#' @noRd
#' @description A class for methods wrapping GitLab's REST API responses.
EngineRestGitLab <- R6::R6Class(
  classname = "EngineRestGitLab",
  inherit = EngineRest,
  public = list(

    # Pull repositories with files
    get_files = function(file_paths          = NULL,
                         org                 = NULL,
                         clean_files_content = TRUE,
                         verbose             = TRUE,
                         progress            = TRUE) {
      files_list <- list()
      file_paths <- utils::URLencode(file_paths, reserved = TRUE)
      files_list <- purrr::map(file_paths, function(filename) {
        files_search_result <- private$search_for_code(
          code    = filename,
          in_path = TRUE,
          org     = org,
          verbose = verbose
        ) %>%
          purrr::keep(~ .$path == filename)
        files_content <- private$add_file_info(
          files_search_result = files_search_result,
          clean_file_content  = clean_files_content,
          filename            = filename,
          verbose             = verbose,
          progress            = progress
        )
        return(files_content)
      }, .progress = progress) %>%
        purrr::list_flatten()
      return(files_list)
    },

    # Wrapper for iteration over GitLab search API response
    # @details For the time being there is no possibility to search GitLab with
    #   filtering by language. For more information look here:
    #   https://gitlab.com/gitlab-org/gitlab/-/issues/340333
    get_repos_by_code = function(code,
                                 org = NULL,
                                 filename = NULL,
                                 in_path = FALSE,
                                 raw_output = FALSE,
                                 verbose = TRUE,
                                 progress = TRUE) {
      search_response <- private$search_for_code(
        code = code,
        filename = filename,
        in_path = in_path,
        org = org,
        verbose = verbose
      )
      if (raw_output) {
        search_output <- search_response
      } else {
        search_output <- search_response %>%
          private$map_search_into_repos(
            progress = progress
          ) %>%
          private$pull_repos_languages(
            progress = progress
          )
      }
      return(search_output)
    },

    # Pull all repositories URLs from organization
    get_repos_urls = function(type, org) {
      repos_urls <- self$response(
        endpoint = paste0(private$endpoints[["organizations"]], utils::URLencode(org, reserved = TRUE), "/projects")
      ) %>%
        purrr::map_vec(function(project) {
          if (type == "api") {
            project$`_links`$self
          } else {
            project$web_url
          }
        })
      return(repos_urls)
    },

    # Add information on open and closed issues of a repository.
    get_repos_issues = function(repos_table, progress) {
      if (nrow(repos_table) > 0) {
        issues <- purrr::map(repos_table$repo_id, function(repos_id) {
          id <- gsub("gid://gitlab/Project/", "", repos_id)
          issues_endpoint <- paste0(self$rest_api_url, "/projects/", id, "/issues_statistics")

          self$response(
            endpoint = issues_endpoint
          )[["statistics"]][["counts"]]
        }, .progress = if (progress) {
          "Pulling repositories issues..."
        } else {
          FALSE
        })
        repos_table$issues_open <- purrr::map_dbl(issues, ~ .$opened)
        repos_table$issues_closed <- purrr::map_dbl(issues, ~ .$closed)
      }
      return(repos_table)
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
            private$pull_contributors_from_repo(
              contributors_endpoint = contributors_endpoint,
              user_name = user_name
            )
          },
          error = function(e) {
            NA
          })
          return(contributors_vec)
        }, .progress = if (progress) {
          "[GitHost:GitLab] Pulling contributors..."
        } else {
          FALSE
        })
      }
      return(repos_table)
    },

    # Pull all commits from give repositories.
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

    # A method to get separately GL logins and display names
    get_commits_authors_handles_and_names = function(commits_table,
                                                     verbose = TRUE,
                                                     progress = verbose) {
      if (nrow(commits_table) > 0) {
        if (verbose) {
          cli::cli_alert_info("Looking up for authors' names and logins...")
        }
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

        commits_table <- commits_table %>%
          dplyr::mutate(
            author_login = NA,
            author_name = NA
          ) %>%
          dplyr::relocate(
            any_of(c("author_login", "author_name")),
            .after = author
          )

        empty_dict <- all(is.na(authors_dict[, c("author_login", "author_name")] %>%
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
    },

    # Set search endpoint
    set_search_endpoint = function(org = NULL) {
      groups_search <- if (!private$scan_all) {
        private$set_groups_search_endpoint(org)
      } else {
        ""
      }
      private$endpoints[["search"]] <- paste0(
        self$rest_api_url,
        groups_search,
        "/search?scope=blobs&search="
      )
    },

    # set groups search endpoint
    set_groups_search_endpoint = function(org) {
      paste0("/groups/", private$get_group_id(org))
    },

    # Iterator over pulling pages of repositories.
    get_repos_from_org = function(org, progress) {
      repo_endpoint <- paste0(self$rest_api_url, "/groups/", org, "/projects")
      repos_response <- private$paginate_results(
        endpoint = repo_endpoint
      )
      full_repos_list <- repos_response %>%
        private$pull_repos_languages(
          progress = progress
        )
      return(full_repos_list)
    },

    # Search for code
    search_for_code = function(code,
                               filename = NULL,
                               in_path = FALSE,
                               org = NULL,
                               page_max = 1e6,
                               verbose = TRUE) {
      page <- 1
      still_more_hits <- TRUE
      full_repos_list <- list()
      private$set_search_endpoint(org)
      if (verbose) cli::cli_alert_info("Searching for code [{code}]...")
      if (!in_path) {
        query <- paste0("%22", code, "%22")
      } else {
        query <- paste0("path:", code)
      }
      if (!is.null(filename)) {
        query <- paste0(query, "%20filename:", filename)
      }
      while (still_more_hits | page < page_max) {
        search_result <- self$response(
          paste0(
            private$endpoints[["search"]],
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
    },

    # Parse search response into repositories output
    map_search_into_repos = function(search_response, progress) {
      repos_ids <- purrr::map_chr(search_response, ~ as.character(.$project_id)) %>%
        unique()

      repos_list <- purrr::map(repos_ids, function(repo_id) {
        content <- self$response(
          endpoint = paste0(private$endpoints[["projects"]], repo_id)
        )
      }, .progress = if (progress) {
        "Parsing search response into repositories output..."
      } else {
        FALSE
      })
      return(repos_list)
    },

    # Pull languages of repositories.
    pull_repos_languages = function(repos_list, progress) {
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
        repo_path,
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
    }
  )
)
