#' @noRd
#' @description A class for methods wrapping GitLab's REST API responses.
EngineRestGitLab <- R6::R6Class(
  classname = "EngineRestGitLab",
  inherit = EngineRest,
  public = list(

    get_orgs_count = function(verbose) {
      if (verbose) {
        cli::cli_alert("[Host:GitLab][Engine:{cli::col_green('REST')}] Pulling number of all organizations...")
      }
      orgs_response <- self$perform_request(paste0(private$endpoints$organizations, "?all_available=True"),
                                            token = private$token)
      return(orgs_response$headers$`x-total`)
    },

    get_orgs = function(orgs_count, verbose, progress = verbose) {
      if (verbose) {
        cli::cli_alert("[Host:GitLab][Engine:{cli::col_green('REST')}] Pulling organizations...")
      }
      iterations_number <- ceiling(orgs_count / 100)
      orgs_list <- purrr::map(1:iterations_number, function(page) {
        self$response(
          paste0(
            private$endpoints[["organizations"]],
            "?all_available=true",
            "&pagination=keyset",
            "&per_page=100&page=",
            page
          )
        )
      }, .progress = progress) |>
        purrr::list_flatten()
      return(orgs_list)
    },

    get_org = function(org, verbose) {
      if (verbose) {
        cli::cli_alert("[Host:GitLab][Engine:{cli::col_green('REST')}] Pulling {utils::URLdecode(org)} organization...")
      }
      self$response(
        paste0(
          private$endpoints[["organizations"]],
          org
        )
      )
    },

    prepare_orgs_table = function(orgs_list) {
      purrr::map(orgs_list, function(org) {
        data.frame(
          name = org$name,
          description = org$description,
          path = org$path,
          url = org$web_url,
          avatar_url = org$avatar_url %||% NA_character_,
          repos_count = NA_integer_,
          members_count = NA_integer_
        )
      }) |>
        purrr::list_rbind()
    },

    # Pull repositories with files
    get_files = function(file_paths = NULL,
                         org = NULL,
                         clean_files_content = TRUE,
                         verbose = TRUE,
                         progress = TRUE) {
      files_list <- list()
      file_paths <- utils::URLencode(file_paths, reserved = TRUE)
      files_list <- purrr::map(file_paths, function(filename) {
        files_search_result <- private$search_for_code(
          code = filename,
          in_path = TRUE,
          org = org,
          verbose = verbose
        ) %>%
          purrr::keep(~ .$path == filename)
        files_content <- private$add_file_info(
          files_search_result = files_search_result,
          clean_file_content = clean_files_content,
          filename = filename,
          verbose = verbose,
          progress = progress
        )
        return(files_content)
      }, .progress = progress) %>%
        purrr::list_flatten()
      return(files_list)
    },

    get_repos_from_org = function(org, repos = NULL, output = "full_table", verbose = FALSE) {
      owner_type <- attr(org, "type") %||% "organization"
      owner_endpoint <- if (owner_type == "organization") {
        private$endpoints[["organizations"]]
      } else {
        private$endpoints[["users"]]
      }
      repos_response <- private$paginate_results(
        endpoint = paste0(owner_endpoint,
                          utils::URLencode(org, reserved = TRUE),
                          "/projects")
      )
      if (!is.null(repos)) {
        repos_response <- repos_response %>%
          purrr::keep(~ .$path %in% repos)
      }
      if (output == "full_table") {
        repos_response <- repos_response |>
          private$get_repos_languages(
            progress = verbose
          )
      }
      return(repos_response)
    },

    # Pull all repositories URLs from organization
    get_repos_urls = function(type, org, repos) {
      repos_response <- self$get_repos_from_org(
        org = org,
        repos = repos,
        output = "raw"
      )
      repos_urls <- repos_response %>%
        purrr::map_vec(function(project) {
          if (type == "api") {
            project$`_links`$self
          } else {
            project$web_url
          }
        })
      return(repos_urls)
    },

    prepare_repos_table = function(repos_list, org) {
      if (length(repos_list) > 0) {
        purrr::map(repos_list, function(repo) {
          if (length(repo$languages) == 0) {
            repo_languages <- ""
          } else {
            repo_languages <- paste0(repo$languages, collapse = ", ")
          }
          data.frame(
            repo_id = repo$id,
            repo_name = repo$name,
            default_branch = repo$default_branch %||% "",
            stars = repo$star_count,
            forks = repo$forks_count %||% NA_integer_,
            created_at = gts_to_posixt(repo$created_at),
            last_activity_at = as.POSIXct(repo$last_activity_at),
            languages = repo_languages,
            issues_open = repo$open_issues_count %||% 0,
            issues_closed = NA_integer_,
            organization = org,
            repo_url = repo$web_url
          )
        }) |>
          purrr::list_rbind()
      } else {
        NULL
      }
    },

    #' Add information on repository contributors.
    get_repos_contributors = function(repos_table, progress) {
      if (nrow(repos_table) > 0) {
        repo_urls <- repos_table$api_url
        user_name <- rlang::expr(.$name)
        repos_table$contributors <- purrr::map_chr(repo_urls, function(repo_url) {
          contributors_endpoint <- paste0(
            repo_url,
            "/repository/contributors"
          )
          contributors_vec <- tryCatch({
            private$get_contributors_from_repo(
              contributors_endpoint = contributors_endpoint,
              user_name = user_name
            )
          },
          error = function(e) {
            NA
          })
          return(contributors_vec)
        }, .progress = progress)
      }
      return(repos_table)
    },

    # Prepare files table from REST API.
    prepare_files_table = function(files_list) {
      files_table <- NULL
      if (!is.null(files_list)) {
        files_table <- purrr::map(files_list, function(file_data) {
          org_repo <- stringr::str_split_1(file_data$repo_fullname, "/")
          org <- paste0(org_repo[1:(length(org_repo) - 1)], collapse = "/")
          data.frame(
            "repo_id" = as.character(file_data$repo_id),
            "repo_name" = file_data$repo_name,
            "organization" = org,
            "file_path" = file_data$file_path,
            "file_content" = file_data$content,
            "file_size" = file_data$size,
            "repo_url" = file_data$repo_url
          )
        }) %>%
          purrr::list_rbind() %>%
          unique()
      }
      return(files_table)
    },

    # Search for code
    search_for_code = function(code,
                               filename = NULL,
                               in_path = FALSE,
                               org = NULL,
                               page_max = 1e6,
                               verbose = TRUE) {
      if (!is.null(org)) {
        org <- utils::URLencode(org, reserved = TRUE)
      }
      page <- 1
      still_more_hits <- TRUE
      full_repos_list <- list()
      search_endpoint <- private$set_search_endpoint(org)
      if (verbose) cli::cli_alert("Searching for code [{code}]...")
      if (!in_path) {
        query <- paste0("%22", code, "%22")
      } else {
        query <- paste0("path:", code)
      }
      if (!is.null(filename)) {
        query <- paste0(query, "%20filename:", filename)
      }
      while (still_more_hits | page < page_max) {
        search_result <- tryCatch({
          self$response(
            paste0(
              search_endpoint,
              query,
              "&per_page=100&page=",
              page
            )
          )
        }, error = function(e) {
          if (length(full_repos_list) == 1e4) {
            if (verbose) {
              cli::cli_alert_warning("Reached 10 thousand response limit.")
            }
            class(full_repos_list) <<- c(class(full_repos_list), "rest_error", "rest_error_response_limit")
            return(NULL)
          } else {
            cli::cli_alert_danger(e$message)
            return(NULL)
          }
        })
        if (length(search_result) == 0 || inherits(full_repos_list, "rest_error")) {
          still_more_hits <- FALSE
          break()
        } else {
          full_repos_list <- append(full_repos_list, search_result)
          page <- page + 1
        }
      }
      return(full_repos_list)
    },

    search_repos_for_code = function(code,
                                     repos,
                                     filename = NULL,
                                     in_path = FALSE,
                                     page_max = 1e6,
                                     verbose = TRUE) {
      if (verbose) cli::cli_alert("Searching for code [{code}]...")
      if (!in_path) {
        query <- paste0("%22", code, "%22")
      } else {
        query <- paste0("path:", code)
      }
      if (!is.null(filename)) {
        query <- paste0(query, "%20filename:", filename)
      }
      search_response <- purrr::map(repos, function(repo) {
        page <- 1
        still_more_hits <- TRUE
        full_repos_list <- list()
        search_endpoint <- private$set_projects_search_endpoint(repo)
        while (still_more_hits | page < page_max) {
          search_result <- self$response(
            paste0(
              search_endpoint,
              query,
              "&per_page=100&page=",
              page
            )
          )
          if (length(search_result) == 0) {
            still_more_hits <- FALSE
            break()
          } else {
            full_repos_list <- append(full_repos_list, search_result)
            page <- page + 1
          }
        }
        return(full_repos_list)
      }) |>
        purrr::list_flatten()
      return(search_response)
    },

    # Pull all commits from given repositories.
    get_commits_from_repos = function(repos_names,
                                      since,
                                      until,
                                      progress) {
      repos_list_with_commits <- purrr::map(repos_names, function(repo_path) {
        commits_from_repo <- private$get_commits_from_one_repo(
          repo_path = repo_path,
          since = since,
          until = until
        )
        return(commits_from_repo)
      }, .progress = !private$scan_all && progress)
      names(repos_list_with_commits) <- repos_names
      repos_list_with_commits <- repos_list_with_commits %>%
        purrr::discard(~ length(.) == 0)
      return(repos_list_with_commits)
    },

    # Get only important info on commits.
    tailor_commits_info = function(repos_list_with_commits,
                                   org) {
      repos_list_with_commits_cut <- purrr::map(repos_list_with_commits, function(repo) {
        purrr::map(repo, function(commit) {
          list(
            "repo_name" = gsub(
              pattern = paste0("/-/commit/", commit$id),
              replacement = "",
              x = gsub(paste0("(.*)", org, "/"), "", commit$web_url)
            ),
            "id" = commit$id,
            "committed_date" = gts_to_posixt(commit$committed_date),
            "author" = commit$author_name,
            "additions" = commit$stats$additions,
            "deletions" = commit$stats$deletions,
            "organization" = org,
            "repo_url" = stringr::str_match(commit$web_url, "(.*)/-/commit/.*")[2]
          )
        })
      })
      return(repos_list_with_commits_cut)
    },

    # A helper to turn list of data.frames into one data.frame
    prepare_commits_table = function(commits_list) {
      commits_dt <- purrr::map(commits_list, function(commit) {
        purrr::map(commit, ~ data.frame(.)) %>%
          purrr::list_rbind()
      }) %>%
        purrr::list_rbind()
      if (length(commits_dt) > 0) {
        commits_dt <- dplyr::mutate(
          commits_dt,
          api_url = self$rest_api_url
        )
      }
      return(commits_dt)
    },

    # A method to get separately GL logins and display names
    get_commits_authors_handles_and_names = function(commits_table,
                                                     verbose = TRUE,
                                                     progress = verbose) {
      if (nrow(commits_table) > 0) {
        if (verbose) {
          cli::cli_alert("Looking up for authors' names and logins...")
        }
        authors_dict <- private$get_authors_dict(
          commits_table = commits_table,
          progress = progress
        )
        commits_table <- commits_table %>%
          dplyr::mutate(
            author_login = NA,
            author_name = NA
          ) %>%
          dplyr::relocate(
            any_of(c("author_login", "author_name")),
            .after = author
          )

        empty_dict <- all(is.na(authors_dict[, c("author_login", "author_name")] |>
                                  unlist()))
        if (!empty_dict) {
          commits_table <- dplyr::mutate(
            commits_table,
            author_login = purrr::map_vec(author, ~ authors_dict$author_login[. == authors_dict$author]),
            author_name = purrr::map_vec(author, ~ authors_dict$author_name[. == authors_dict$author])
          )
        }
        return(commits_table)
      }
    }
  ),
  private = list(

    # Endpoints list
    endpoints = list(
      organizations = NULL,
      projects = NULL,
      search = NULL
    ),

    # Set endpoints for the API
    set_endpoints = function() {
      private$set_projects_endpoint()
    },

    # Set projects endpoint
    set_projects_endpoint = function() {
      private$endpoints[["projects"]] <- paste0(
        self$rest_api_url,
        "/projects/"
      )
      private$endpoints[["organizations"]] <- paste0(
        self$rest_api_url,
        "/groups/"
      )
      private$endpoints[["users"]] <- paste0(
        self$rest_api_url,
        "/users/"
      )
    },

    # Set search endpoint
    set_search_endpoint = function(org = NULL) {
      scope_endpoint <- if (!is.null(org)) {
        paste0("/groups/", private$get_group_id(org))
      } else {
        ""
      }
      paste0(
        self$rest_api_url,
        scope_endpoint,
        "/search?scope=blobs&search="
      )
    },

    set_projects_search_endpoint = function(repo) {
      paste0(
        self$rest_api_url,
        "/projects/",
        utils::URLencode(repo, reserved = TRUE),
        "/search?scope=blobs&search="
      )
    },

    # Pull languages of repositories.
    get_repos_languages = function(repos_list, progress) {
      repos_list_with_languages <- purrr::map(repos_list, function(repo) {
        id <- repo$id
        repo$languages <- names(self$response(paste0(private$endpoints[["projects"]], id, "/languages")))
        repo
      }, .progress = if (progress) {
        "Pulling repositories languages..."
      } else {
        FALSE
      })
      return(repos_list_with_languages)
    },

    # Iterator over pages of commits response.
    get_commits_from_one_repo = function(repo_path,
                                         since,
                                         until) {
      commits_endpoint <- paste0(
        private$endpoints$projects,
        utils::URLencode(repo_path, reserved = TRUE),
        "/repository/commits?since='",
        as.Date(since),
        "'&until='",
        as.Date(until),
        "'&with_stats=true"
      )
      all_commits_in_repo <- tryCatch({
        private$paginate_results(
          endpoint = commits_endpoint,
          joining_sign = "&"
        )
      }, error = function(e) {
        list()
      })
      return(all_commits_in_repo)
    },

    # A helper to get group's id
    get_group_id = function(project_group) {
      self$response(paste0(self$rest_api_url, "/groups/", project_group))[["id"]]
    },

    # Add file content to files search result
    add_file_info = function(files_search_result,
                             filename,
                             clean_file_content = FALSE,
                             verbose            = FALSE,
                             progress           = FALSE) {
      purrr::map(files_search_result, function(file_data) {
        repo_data <- self$response(
          paste0(
            private$endpoints$projects,
            file_data$project_id
          )
        )
        def_branch <- repo_data[["default_branch"]]
        file_data <- tryCatch({
          self$response(
            paste0(
              private$endpoints$projects,
              file_data$project_id,
              "/repository/files/",
              filename,
              "?ref=",
              def_branch
            )
          )
        }, error = function(e) {
          NULL
        })
        if (!is.null(file_data)) {
          file_data$repo_name <- repo_data$path
          file_data$repo_fullname <- repo_data$path_with_namespace
          file_data$repo_id <- repo_data$id
          file_data$repo_url <- repo_data$web_url
          if (clean_file_content) {
            file_data$content <- NA
          }
        }
        return(file_data)
      }, .progress = if (progress) {
        glue::glue("Adding file [{filename}] info...")
      } else {
        FALSE
      }) |>
        purrr::discard(is.null)
    },

    get_authors_dict = function(commits_table, progress) {
      authors_dict <- purrr::map(unique(commits_table$author), function(author) {
        author <- url_encode(author)
        search_endpoint <- paste0(
          self$rest_api_url,
          "/search?scope=users&search=%22", author, "%22"
        )
        user_response <- list()
        try({
          user_response <- self$response(endpoint = search_endpoint)
        }, silent = TRUE)
        if (length(user_response) == 0) {
          author <- stringi::stri_trans_general(author, "Latin-ASCII")
          search_endpoint <- paste0(
            self$rest_api_url,
            "/search?scope=users&search=%22", author, "%22"
          )
          try({
            user_response <- self$response(endpoint = search_endpoint)
          }, silent = TRUE)
        }
        if (!is.null(user_response) && length(user_response) > 1) {
          user_response <- purrr::keep(user_response, ~ grepl(author, .$name))
        }
        if (is.null(user_response) || length(user_response) == 0) {
          user_tbl <- tibble::tibble(
            author = URLdecode(author),
            author_login = NA,
            author_name = NA
          )
        } else {
          user_tbl <- tibble::tibble(
            author = URLdecode(author),
            author_login = user_response[[1]]$username,
            author_name = user_response[[1]]$name
          )
        }
        return(user_tbl)
      }, .progress = progress) %>%
        purrr::list_rbind()
      authors_dict <- private$clean_authors_dict(authors_dict)
      return(authors_dict)
    },

    clean_authors_dict = function(authors_dict) {
      authors_dict <- private$clean_authors_with_comma(
        authors_dict = authors_dict
      )
      authors_dict <- private$fill_empty_authors(
        authors_dict = authors_dict
      )
      return(authors_dict)
    },

    clean_authors_with_comma = function(authors_dict) {
      authors_to_clean <- authors_dict$author[is.na(authors_dict$author_name)]
      if (any(grepl(",", authors_to_clean))) {
        authors_with_comma <- authors_to_clean[grepl(",", authors_to_clean)]
        clean_authors <- purrr::map(authors_with_comma, function(author) {
          split_author <- stringr::str_split_1(author, ",")
          split_author <- purrr::map(split_author, function(x) {
            stringr::str_replace(x, "\\{.*?\\}", "") |>
              stringr::str_replace_all(" ", "")
          })
          source_author <- unlist(split_author)
          clean_author <- paste(source_author[2], source_author[1])
          dplyr::tibble(
            author = author,
            author_login = NA_character_,
            author_name = clean_author
          )
        }) |>
          purrr::list_rbind()
        authors_dict <- authors_dict |>
          dplyr::filter(!author %in% authors_with_comma)
        authors_dict <- rbind(authors_dict, clean_authors)
      }
      return(authors_dict)
    },

    fill_empty_authors = function(authors_dict) {
      authors_to_clean <- authors_dict$author[is.na(authors_dict$author_name)]
      authors_to_clean <- authors_to_clean[!grepl(",", authors_to_clean)]
      author_names <- purrr::keep(authors_to_clean, function(author) {
        length(stringr::str_split_1(author, " ")) > 1
      })
      author_logins <- purrr::keep(authors_to_clean, function(author) {
        length(stringr::str_split_1(author, " ")) == 1
      })
      authors_dict <- authors_dict |>
        dplyr::mutate(
          author_name = ifelse(author %in% author_names,
                               author,
                               author_name),
          author_login = ifelse(author %in% author_logins,
                                author,
                                author_login)
        )
      return(authors_dict)
    }
  )
)
