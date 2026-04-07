EngineRestBitBucket <- R6::R6Class(
  classname = "EngineRestBitBucket",
  inherit = EngineRest,
  public = list(

    # BitBucket uses cursor-based pagination with `next` URLs
    perform_request = function(endpoint, token, verbose) {
      resp <- httr2::request(endpoint) |>
        httr2::req_headers("Authorization" = paste0("Bearer ", token)) |>
        httr2::req_error(is_error = function(resp) FALSE) |>
        httr2::req_perform()
      if (resp$status_code == 401 && verbose) {
        cli::cli_alert_danger("HTTP 401 Unauthorized.")
      }
      if (resp$status_code == 404 && verbose) {
        cli::cli_alert_danger("HTTP 404 Not Found.")
      }
      if (resp$status_code %in% c(400, 500, 403)) {
        resp <- httr2::request(endpoint) |>
          httr2::req_headers("Authorization" = paste0("Bearer ", token)) |>
          httr2::req_retry(
            is_transient = ~ httr2::resp_status(.x) %in% c(400, 500, 403),
            max_seconds = 60
          ) |>
          httr2::req_perform()
      }
      return(resp)
    },

    get_repos_from_org = function(org, repos = NULL, verbose = FALSE) {
      endpoint <- paste0(
        private$endpoints[["repositories"]],
        org
      )
      repos_response <- private$paginate_bitbucket_results(
        endpoint = endpoint,
        verbose = verbose
      )
      if (!is.null(repos)) {
        repos_response <- repos_response |>
          purrr::keep(~ .$slug %in% repos)
      }
      return(repos_response)
    },

    prepare_repos_table = function(repos_list, org) {
      if (length(repos_list) > 0) {
        purrr::map(repos_list, function(repo) {
          repo_languages <- repo$language %||% ""
          created_at <- if (!is.null(repo$created_on)) {
            gts_to_posixt(repo$created_on)
          } else {
            as.POSIXct(NA)
          }
          last_activity_at <- if (!is.null(repo$updated_on)) {
            gts_to_posixt(repo$updated_on)
          } else {
            created_at
          }
          default_branch <- repo$mainbranch$name %||% ""
          data.frame(
            repo_id = repo$uuid %||% NA_character_,
            repo_name = repo$slug,
            repo_fullpath = repo$full_name,
            default_branch = default_branch,
            stars = NA_integer_,
            forks = NA_integer_,
            created_at = created_at,
            last_activity_at = last_activity_at,
            languages = repo_languages,
            issues_open = NA_integer_,
            issues_closed = NA_integer_,
            organization = org,
            repo_url = repo$links$html$href %||% NA_character_,
            commit_sha = repo$mainbranch$target$hash %||% NA_character_
          )
        }) |>
          purrr::list_rbind()
      } else {
        NULL
      }
    },

    get_repos_urls = function(type, org, repos, verbose = TRUE) {
      repos_response <- self$get_repos_from_org(
        org = org,
        repos = repos,
        verbose = verbose
      )
      repos_urls <- repos_response |>
        purrr::map_vec(function(repo) {
          if (type == "api") {
            repo$links$self$href
          } else {
            repo$links$html$href
          }
        })
      return(repos_urls)
    },

    get_commits_from_repos = function(repos_fullnames,
                                      since,
                                      until,
                                      verbose) {
      repos_list_with_commits <- gitstats_map(repos_fullnames, function(repo_fullname) {
        private$get_commits_from_one_repo(
          repo_fullname = repo_fullname,
          since = since,
          until = until,
          verbose = verbose
        )
      })
      names(repos_list_with_commits) <- repos_fullnames
      repos_list_with_commits <- repos_list_with_commits |>
        purrr::discard(~ length(.) == 0)
      return(repos_list_with_commits)
    },

    tailor_commits_info = function(repos_list_with_commits,
                                   org) {
      purrr::map(repos_list_with_commits, function(repo) {
        purrr::map(repo, function(commit) {
          author_raw <- commit$author$raw %||% ""
          author_name <- if (nchar(author_raw) > 0) {
            sub("\\s*<.*>$", "", author_raw)
          } else {
            NA_character_
          }
          repo_slug <- sub(paste0("^", org, "/"), "", commit$repository$full_name %||% "")
          list(
            "repo_name" = repo_slug,
            "id" = commit$hash,
            "committed_date" = gts_to_posixt(commit$date),
            "author" = author_name,
            "additions" = NA_integer_,
            "deletions" = NA_integer_,
            "organization" = org,
            "repo_url" = commit$repository$links$html$href %||%
              paste0("https://bitbucket.org/", commit$repository$full_name %||% "")
          )
        })
      })
    },

    prepare_commits_table = function(commits_list) {
      commits_dt <- purrr::map(commits_list, function(commit) {
        purrr::map(commit, ~ data.frame(.)) |>
          purrr::list_rbind()
      }) |>
        purrr::list_rbind()
      if (length(commits_dt) > 0) {
        commits_dt <- dplyr::mutate(
          commits_dt,
          api_url = self$rest_api_url
        )
      }
      return(commits_dt)
    },

    get_repos_contributors = function(repos_table, verbose = TRUE, progress) {
      if (nrow(repos_table) > 0) {
        repo_iterator <- paste0(repos_table$organization, "/", repos_table$repo_name)
        repos_table$contributors <- gitstats_map_chr(repo_iterator, function(repo_fullname) {
          tryCatch({
            # BitBucket has no direct contributors endpoint; approximate from
            # recent commits.
            commits_endpoint <- paste0(
              self$rest_api_url,
              "/repositories/",
              repo_fullname,
              "/commits?pagelen=100"
            )
            commits_response <- self$response(
              endpoint = commits_endpoint,
              verbose = verbose
            )
            values <- commits_response$values %||% list()
            authors <- purrr::map_chr(values, function(commit) {
              user <- commit$author$user
              if (!is.null(user)) {
                user$display_name %||% user$nickname %||% ""
              } else {
                sub("\\s*<.*>$", "", commit$author$raw %||% "")
              }
            }) |>
              unique() |>
              purrr::discard(~ nchar(.) == 0)
            paste0(authors, collapse = ", ")
          },
          error = function(e) {
            NA
          })
        }, .progress = progress)
      }
      return(repos_table)
    },

    get_files_tree = function(org, repo, def_branch, pattern, depth, verbose) {
      if (is.null(def_branch) || nchar(def_branch) == 0) {
        def_branch <- "main"
      }
      endpoint <- paste0(
        self$rest_api_url,
        "/repositories/",
        org, "/", repo,
        "/src/", def_branch, "/?pagelen=100&max_depth=100"
      )
      all_files <- list()
      repeat {
        response <- tryCatch(
          self$response(endpoint = endpoint, verbose = verbose),
          error = function(e) NULL
        )
        if (is.null(response) || inherits(response, "rest_error")) {
          break
        }
        values <- response$values %||% list()
        files <- purrr::keep(values, ~ .$type == "commit_file") |>
          purrr::map_chr(~ .$path)
        all_files <- c(all_files, files)
        next_url <- response$`next`
        if (is.null(next_url)) break
        endpoint <- next_url
      }
      files <- unlist(all_files)
      if (length(files) == 0) return(NULL)
      if (!is.null(depth) && depth < Inf) {
        files <- purrr::keep(files, function(path) {
          stringr::str_count(path, "/") < depth
        })
      }
      if (!is.null(pattern)) {
        files <- purrr::keep(files, function(path) {
          any(stringr::str_detect(path, pattern))
        })
      }
      if (length(files) == 0) return(NULL)
      return(files)
    }
  ),
  private = list(

    endpoints = list(
      repositories = NULL,
      workspaces = NULL
    ),

    set_endpoints = function() {
      private$endpoints[["repositories"]] <- paste0(
        self$rest_api_url,
        "/repositories/"
      )
      private$endpoints[["workspaces"]] <- paste0(
        self$rest_api_url,
        "/workspaces/"
      )
    },

    # BitBucket uses cursor-based pagination with a `next` URL field
    paginate_bitbucket_results = function(endpoint, verbose = TRUE) {
      full_response <- list()
      url <- paste0(endpoint, "?pagelen=100")
      repeat {
        response <- self$response(
          endpoint = url,
          verbose = verbose
        )
        if (inherits(response, "rest_error")) {
          break
        }
        values <- response$values %||% list()
        if (length(values) > 0) {
          full_response <- append(full_response, values)
        }
        next_url <- response$`next`
        if (is.null(next_url)) {
          break
        }
        url <- next_url
      }
      return(full_response)
    },

    get_commits_from_one_repo = function(repo_fullname,
                                         since,
                                         until,
                                         verbose) {
      # BitBucket Cloud does not support `since` as a date filter on the
      # commits endpoint directly.  We paginate and stop when commits fall
      # outside the requested window.
      until_dt <- parse_until_param(until)
      since_dt <- lubridate::as_datetime(since)
      all_commits <- list()
      url <- paste0(
        self$rest_api_url,
        "/repositories/",
        repo_fullname,
        "/commits?pagelen=100"
      )
      repeat {
        response <- tryCatch(
          self$response(endpoint = url, verbose = verbose),
          error = function(e) NULL
        )
        if (is.null(response) || inherits(response, "rest_error")) {
          break
        }
        values <- response$values %||% list()
        if (length(values) == 0) break
        for (commit in values) {
          commit_date <- gts_to_posixt(commit$date)
          if (commit_date < since_dt) {
            return(all_commits)
          }
          if (commit_date <= until_dt) {
            all_commits <- append(all_commits, list(commit))
          }
        }
        next_url <- response$`next`
        if (is.null(next_url)) break
        url <- next_url
      }
      return(all_commits)
    }
  )
)
