#' @noRd
#' @description A class to manage which engine to use for pulling data
GitHost <- R6::R6Class(
  classname = "GitHost",
  public = list(

    #' @description Create a new `GitHost` object.
    #' @param orgs A character vector of organisations (owners of repositories
    #'   in case of GitHub and groups of projects in case of GitLab).
    #' @param repos A character vector of repositories.
    #' @param token A token.
    #' @param host A host.
    #' @param verbose A logical, `TRUE` by default. If `FALSE` messages and printing
    #'   output is switched off.
    #' @return A new `GitHost` object.
    initialize = function(orgs = NA,
                          repos = NA,
                          token = NA,
                          host = NA,
                          verbose = NA,
                          .error = TRUE) {
      private$set_api_url(host)
      private$set_web_url(host)
      private$set_endpoints()
      private$check_if_public(host)
      private$set_token(
        token = token,
        verbose = verbose
      )
      private$set_graphql_url()
      private$set_searching_scope(
        orgs = orgs,
        repos = repos,
        verbose = verbose
      )
      private$setup_engines()
      private$set_orgs_and_repos(
        orgs = orgs,
        repos = repos,
        verbose = verbose,
        .error = .error
      )
    },

    get_orgs = function(output, verbose) {
      if (private$scan_all) {
        orgs <- private$get_orgs_from_host(
          output = output,
          verbose = verbose
        )
      } else {
        orgs <- private$get_orgs_from_orgs_and_repos(
          output = output,
          verbose = verbose
        )
      }
      if (output == "full_table") {
        orgs <- orgs |>
          dplyr::mutate(
            host_url = private$api_url,
            host_name = private$host_name
          )
      }
      return(orgs)
    },

    get_repos = function(add_contributors = TRUE,
                         with_code = NULL,
                         in_files = NULL,
                         with_file = NULL,
                         output = "table",
                         force_orgs = FALSE,
                         verbose = TRUE,
                         progress = TRUE) {
      if (is.null(with_code) && is.null(with_file)) {
        repos_table <- private$get_all_repos(
          verbose  = verbose,
          progress = progress
        )
      }
      if (!is.null(with_code)) {
        repos_table <- private$get_repos_with_code(
          code = with_code,
          in_files = in_files,
          output = output,
          force_orgs = force_orgs,
          verbose = verbose,
          progress = progress
        )
      } else if (!is.null(with_file)) {
        repos_table <- private$get_repos_with_code(
          code = with_file,
          in_path = TRUE,
          output = output,
          force_orgs = force_orgs,
          verbose = verbose,
          progress = progress
        )
      }
      if (output == "table") {
        repos_table <- private$add_repo_api_url(repos_table) %>%
          private$add_platform()
        if (add_contributors) {
          repos_table <- private$get_repos_contributors(
            repos_table = repos_table,
            verbose = verbose,
            progress = progress
          )
        }
      }
      return(repos_table)
    },

    # Get repositories URLS from the Git host
    get_repos_urls = function(type = "web",
                              with_code = NULL,
                              in_files = NULL,
                              with_file = NULL,
                              verbose = TRUE,
                              progress = TRUE) {
      if (!is.null(with_code)) {
        repo_urls <- private$get_repos_urls_with_code(
          type = type,
          code = with_code,
          in_files = in_files,
          verbose = verbose,
          progress = progress
        )
      } else if (!is.null(with_file)) {
        repo_urls <- private$get_repos_urls_with_code(
          type = type,
          code = with_file,
          in_path = TRUE,
          verbose = verbose,
          progress = progress
        )
      } else {
        repo_urls <- private$get_all_repos_urls(
          type = type,
          verbose = verbose,
          progress = progress
        )
      }
      return(repo_urls)
    },

    #' Pull commits method
    get_commits = function(since,
                           until    = Sys.Date(),
                           verbose  = TRUE,
                           progress = TRUE) {
      if (private$scan_all && is.null(private$orgs)) {
        private$orgs <- private$get_orgs_from_host(
          output = "only_names",
          verbose = verbose
        )
      }
      commits_from_orgs <- private$get_commits_from_orgs(
        since = since,
        until = until,
        verbose = verbose,
        progress = progress
      )
      commits_from_repos <- private$get_commits_from_repos(
        since = since,
        until = until,
        verbose = verbose,
        progress = progress
      )
      commits_table <- list(
        commits_from_orgs,
        commits_from_repos
      ) |>
        purrr::list_rbind()
      return(commits_table)
    },

    #' Get issues method
    get_issues = function(since,
                          until = Sys.Date(),
                          state = NULL,
                          verbose = TRUE,
                          progress = TRUE) {
      if (private$scan_all && is.null(private$orgs)) {
        private$orgs <- private$get_orgs_from_host(
          output = "only_names",
          verbose = verbose
        )
      }
      issues_from_orgs <- private$get_issues_from_orgs(
        verbose = verbose,
        progress = progress
      )
      issues_from_repos <- private$get_issues_from_repos(
        verbose = verbose,
        progress = progress
      )
      issues_table <- list(
        issues_from_orgs,
        issues_from_repos
      ) |>
        purrr::list_rbind() |>
        dplyr::distinct()
      if (nrow(issues_table) > 0) {
        issues_table <- issues_table |>
          dplyr::filter(
            created_at >= since & created_at <= until
          )
        if (!is.null(state)) {
          type <- state
          issues_table <- issues_table |>
            dplyr::filter(
              state == type
            )
        }
      }
      return(issues_table)
    },

    #' Pull information about users.
    get_users = function(users) {
      graphql_engine <- private$engines$graphql
      users_table <-  purrr::map(users, function(user) {
        graphql_engine$get_user(user) %>%
          graphql_engine$prepare_user_table()
      }) %>%
        purrr::list_rbind()
      return(users_table)
    },

    #' Retrieve content of given text files from all repositories for a host in
    #' a table format.
    get_files_content = function(file_path,
                                 files_structure = NULL,
                                 verbose = TRUE,
                                 progress = TRUE) {
      if (is.null(files_structure)) {
        if (!private$scan_all) {
          files_content_from_orgs <- private$get_files_content_from_orgs(
            file_path = file_path,
            verbose = verbose,
            progress = progress
          )
          files_content_from_repos <- private$get_files_content_from_repos(
            file_path = file_path,
            verbose = verbose,
            progress = progress
          )
          files_table <- rbind(
            files_content_from_orgs,
            files_content_from_repos
          )
        } else {
          files_table <- private$get_files_content_from_host(
            file_path = file_path,
            verbose = verbose,
            progress = progress
          )
        }
      }
      if (!is.null(files_structure)) {
        files_table <- private$get_files_content_from_files_structure(
          files_structure = files_structure,
          verbose = verbose,
          progress = progress
        )
      }
      return(files_table)
    },

    #' Get files structure
    get_files_structure = function(pattern,
                                   depth,
                                   verbose  = TRUE,
                                   progress = TRUE) {
      if (private$scan_all) {
        cli::cli_abort(c(
          "x" = "This feature is not applicable to scan whole Git Host (time consuming).",
          "i" = "Set `orgs` or `repos` arguments in `set_*_host()` if you wish to run this function."
        ), call = NULL)
      }
      files_structure_from_orgs <- private$get_files_structure_from_orgs(
        pattern = pattern,
        depth = depth,
        verbose = verbose,
        progress = progress
      )
      files_structure_from_repos <- private$get_files_structure_from_repos(
        pattern = pattern,
        depth = depth,
        verbose = verbose,
        progress = progress
      )
      files_structure <- append(
        files_structure_from_orgs %||% list(),
        files_structure_from_repos %||% list()
      )
      return(files_structure)
    },

    #' Iterator over pulling release logs from engines
    get_release_logs = function(since, until, verbose, progress) {
      if (private$scan_all && is.null(private$orgs)) {
        private$orgs <- private$get_orgs_from_host(
          output = "only_names",
          verbose = verbose
        )
      }
      until <- until %||% Sys.time()
      release_logs_from_orgs <- private$get_release_logs_from_orgs(
        since = since,
        until = until,
        verbose = verbose,
        progress = progress
      )
      release_logs_from_repos <- private$get_release_logs_from_repos(
        since = since,
        until = until,
        verbose = verbose,
        progress = progress
      )
      release_logs_table <- list(
        release_logs_from_orgs,
        release_logs_from_repos
      ) |>
        purrr::list_rbind()
      return(release_logs_table)
    }
  ),
  private = list(

    # A REST API URL.
    api_url = NULL,

    # Web URL.
    web_url = NULL,

    # A GraphQL API url.
    graphql_api_url = NULL,

    # Either repos, orgs or whole platform
    searching_scope = NULL,

    # An endpoint for basic checks.
    test_endpoint = NULL,

    # List of endpoints
    endpoints = list(
      tokens = NULL,
      orgs = NULL,
      repositories = NULL
    ),

    # A token.
    token = NULL,

    # Actual token scopes
    token_scopes = NULL,

    # public A boolean.
    is_public = NULL,

    # orgs A character vector of repo organizations.
    orgs = NULL,

    # repos A character vector of repositories.
    repos = NULL,

    # repos_fullnames A character vector of repositories with full names.
    repos_fullnames = NULL,

    # orgs_repos A named list of organizations with repositories.
    orgs_repos = NULL,

    # A boolean.
    scan_all = FALSE,

    # Show messages or not.
    verbose = TRUE,

    # engines A placeholder for REST and GraphQL Engine classes.
    engines = list(),

    # Set API url
    set_custom_api_url = function(host) {
      private$api_url <- if (!grepl("https|http", host)) {
        glue::glue(
          "https://{host}/api/v{private$api_version}"
        )
      } else {
        if (grepl("http(?!s)", host, perl = TRUE)) {
          host <- gsub("http", "https", host)
        }
        glue::glue(
          "{host}/api/v{private$api_version}"
        )
      }
    },

    # Set web url
    set_custom_web_url = function(host) {
      private$web_url <- if (!grepl("https://", host)) {
        glue::glue(
          "https://{host}"
        )
      } else {
        host
      }
    },

    # Set endpoints
    set_endpoints = function() {
      private$set_test_endpoint()
      private$set_tokens_endpoint()
      private$set_orgs_endpoint()
      private$set_repositories_endpoint()
    },

    # Set authorizing token
    set_token = function(token, verbose) {
      if (is.null(token)) {
        token <- private$set_default_token(
          verbose = verbose
        )
      } else {
        token <- private$check_token(token)
      }
      private$token <- token
    },

    # Check whether the token exists.
    check_token = function(token) {
      if (nchar(token) == 0) {
        cli::cli_abort(c(
          "i" = "No token provided."
        ))
      } else {
        if (!private$test_token(token)) {
          cli::cli_abort(c(
            "x" = "Token exists but does not grant access.",
            "i" = "Check if you use correct token.",
            "!" = "Scope that is needed: [{paste0(private$min_access_scopes, collapse = ', ')}]."
          ),
          call = NULL)
        } else {
          return(token)
        }
      }
    },

    # Check if both repos and orgs are defined or not.
    set_searching_scope = function(orgs, repos, verbose) {
      if (is.null(repos) && is.null(orgs)) {
        if (private$is_public) {
          cli::cli_abort(c(
            "You need to specify `orgs` or/and `repos` for public Git Host.",
            "x" = "Host will not be added.",
            "i" = "Add organizations to your `orgs` and/or repositories to
            `repos` parameter."
          ),
          call = NULL)
        } else {
          if (verbose) {
            cli::cli_alert_info(cli::col_grey(
              "No `orgs` nor `repos` specified."
            ))
            cli::cli_alert_info(cli::col_grey(
              "Searching scope set to [all]."
            ))
          }
          private$searching_scope <- "all"
          private$scan_all <- TRUE
        }
      }
      if (!is.null(repos)) {
        private$searching_scope <- c(private$searching_scope, "repo")
      }
      if (!is.null(orgs)) {
        private$searching_scope <- c(private$searching_scope, "org")
      }
    },

    # Set organization or repositories
    set_orgs_and_repos = function(orgs, repos, verbose, .error) {
      if (!private$scan_all) {
        if (!is.null(orgs)) {
          private$orgs <- private$check_organizations(
            orgs = orgs,
            verbose = verbose,
            .error = .error
          )
        }
        if (!is.null(repos)) {
          repos <- private$check_repositories(
            repos = repos,
            verbose = verbose,
            .error = .error
          )
          private$repos_fullnames <- repos
          orgs_repos <- private$extract_repos_and_orgs(private$repos_fullnames)
          private$repos <- unname(unlist(orgs_repos))
          private$orgs_repos <- orgs_repos
        }
      }
    },

    # Check if repositories exist
    check_repositories = function(repos, verbose, .error) {
      if (verbose) {
        cli::cli_alert(cli::col_grey("Checking repositories..."))
      }
      repos <- purrr::map(repos, function(repo) {
        repo_endpoint <- glue::glue("{private$endpoints$repositories}/{repo}")
        check <- private$check_endpoint(
          endpoint = repo_endpoint,
          type = "Repository",
          verbose = verbose,
          .error = .error
        )
        if (!check) {
          repo <- NULL
        }
        return(repo)
      }, .progress = verbose) |>
        purrr::keep(~ length(.) > 0) |>
        unlist()
      if (length(repos) == 0) {
        return(NULL)
      }
      repos
    },

    # Check if organizations or users exist
    check_organizations = function(orgs, verbose, .error) {
      if (verbose) {
        cli::cli_alert(cli::col_grey("Checking owners..."))
      }
      orgs <- private$engines$graphql$set_owner_type(
        owners = utils::URLdecode(orgs)
      ) |>
        purrr::map(function(org) {
          if (attr(org, "type") == "not found") {
            if (.error) {
              cli::cli_abort(
                c(
                  "x" = "Org/user you provided does not exist or its name was passed
                  in a wrong way: {cli::col_red({utils::URLdecode(org)})}",
                  "!" = "Please type your org/user name the way you see it in
                  web URL."
                ),
                call = NULL
              )
            } else {
              if (verbose) {
                cli::cli_alert_warning(
                  cli::col_yellow(
                    "Org/user you provided does not exist: {cli::col_red({org})}"
                  )
                )
              }
              org <- NULL
            }
          }
          return(org)
        }, .progress = verbose) |>
        purrr::keep(~ length(.) > 0)
      if (length(orgs) == 0) {
        return(NULL)
      }
      orgs
    },

    # Check whether the endpoint exists.
    check_endpoint = function(endpoint, type, verbose, .error) {
      check <- TRUE
      tryCatch(
        {
          private$engines$rest$response(endpoint = endpoint)
        },
        error = function(e) {
          if (grepl("404", e)) {
            if (.error) {
              cli::cli_abort(
                c(
                  "x" = "{type} you provided does not exist or its name was passed
                in a wrong way: {cli::col_red({utils::URLdecode(endpoint)})}",
                  "!" = "Please type your {tolower(type)} name as you see it in
                web URL.",
                  "i" = "E.g. do not use spaces. {type} names as you see on the
                page may differ from their web 'address'."
                ),
                call = NULL
              )
            } else {
              if (verbose) {
                cli::cli_alert_warning(
                  cli::col_yellow(
                    "{type} you provided does not exist: {cli::col_red({utils::URLdecode(endpoint)})}"
                  )
                )
              }
              check <<- FALSE
            }

          }
        }
      )
      return(check)
    },

    # Set url of GraphQL API
    set_graphql_url = function() {
      clean_api_url <- gsub("/v+.*", "", private$api_url)
      private$graphql_api_url <- glue::glue("{clean_api_url}/graphql")
    },

    # Set default token if none exists.
    set_default_token = function(verbose) {
      primary_token_name <- private$token_name
      token <- Sys.getenv(primary_token_name)
      if (private$test_token(token)) {
        if (verbose) {
          cli::cli_alert_info("Using PAT from {primary_token_name} envar.")
        }
      } else {
        pat_names <- names(Sys.getenv()[grepl(primary_token_name, names(Sys.getenv()))])
        possible_tokens <- pat_names[pat_names != primary_token_name]
        token_checks <- purrr::map_lgl(possible_tokens, function(token_name) {
          private$test_token(Sys.getenv(token_name))
        })
        if (!any(token_checks)) {
          cli::cli_abort(c(
            "x" = "No sufficient token found among: [{paste0(pat_names, collapse = ', ')}].",
            "i" = "Check if you have correct token.",
            "!" = "Scope that is needed: [{paste0(private$min_access_scopes, collapse = ', ')}]."
          ),
          call = NULL)
        } else {
          token_name <- possible_tokens[token_checks][1]
          if (verbose) {
            cli::cli_alert_info("Using PAT from {token_name} envar.")
          }
          token <- Sys.getenv(token_name)
        }
      }
      return(token)
    },

    # Helper to test if a token works
    test_token = function(token) {
      response <- NULL
      test_endpoint <- private$test_endpoint
      response <- tryCatch({
        httr2::request(test_endpoint) |>
          httr2::req_headers("Authorization" = paste0("Bearer ", token)) |>
          httr2::req_perform()
      },
      error = function(e) {
        if (!is.null(e$parent) && grepl("Could not resolve host", e$parent$message)) {
          cli::cli_abort(e$parent$message, call = NULL)
        } else {
          NULL
        }
      })
      if (!is.null(response)) {
        check <- private$check_token_scopes(response, token)
      } else {
        check <- FALSE
      }
      return(check)
    },

    # Helper to extract organizations and repositories from vector of full names
    # of repositories
    extract_repos_and_orgs = function(repos_fullnames = NULL) {
      repos_fullnames <- URLdecode(repos_fullnames)
      repos_vec <- stringr::str_split(repos_fullnames, "/") %>%
        purrr::map(~ paste0(.[length(.)], collapse = "/")) %>%
        unlist()
      orgs_vec <- stringr::str_split(repos_fullnames, "/") %>%
        purrr::map(~ paste0(.[-length(.)], collapse = "/")) %>%
        unlist()
      names(repos_vec) <- orgs_vec
      orgs_names <- unique(orgs_vec)
      orgs_repo_list <- purrr::map(orgs_names, function(org) {
        unname(repos_vec[which(names(repos_vec) == org)])
      })
      names(orgs_repo_list) <- orgs_names
      return(orgs_repo_list)
    },

    # Filter repositories table by host
    filter_repos_by_host = function(repos_table) {
      dplyr::filter(
        repos_table,
        grepl(gsub("/v+.*", "", private$api_url), api_url)
      )
    },

    get_orgs_from_orgs_and_repos = function(output, verbose) {
      graphql_engine <- private$engines$graphql
      orgs_names <- NULL
      orgs_names_from_repos <- NULL
      if ("org" %in% private$searching_scope) {
        orgs_names <- purrr::keep(private$orgs, function(org) {
          type <- attr(org, "type") %||% "organization"
          type == "organization"
        })
      }
      if ("repo" %in% private$searching_scope) {
        orgs_names_from_repos <- graphql_engine$set_owner_type(
          owners = names(private$orgs_repos)
        ) |>
          purrr::keep(function(org) {
            type <- attr(org, "type") %||% "organization"
            type == "organization"
          })
      }
      total_orgs_names <- c(orgs_names, orgs_names_from_repos)
      orgs_table <- purrr::map(total_orgs_names, function(org) {
        type <- attr(org, "type") %||% "organization"
        org <- utils::URLdecode(org)
        graphql_engine$get_org(
          org = org
        )
      }) |>
        graphql_engine$prepare_orgs_table()
      return(orgs_table)
    },

    get_all_repos = function(verbose = TRUE, progress = TRUE) {
      if (private$scan_all && is.null(private$orgs)) {
        private$orgs <- private$get_orgs_from_host(
          output = "only_names",
          verbose = verbose
        )
      }
      repos_table <- purrr::list_rbind(
        list(
          private$get_repos_from_orgs(verbose, progress),
          private$get_repos_from_repos(verbose, progress)
        )
      )
      return(repos_table)
    },

    get_repos_from_orgs = function(verbose, progress) {
      if (any(c("all", "org") %in% private$searching_scope)) {
        graphql_engine <- private$engines$graphql
        purrr::map(private$orgs, function(org) {
          owner_type <- attr(org, "type") %||% "organization"
          if (!private$scan_all && verbose) {
            show_message(
              host = private$host_name,
              engine = "graphql",
              scope = utils::URLdecode(org),
              information = "Pulling repositories"
            )
          }
          repos_from_org <- graphql_engine$get_repos_from_org(
            org = utils::URLdecode(org),
            owner_type = owner_type,
            verbose = verbose
          )
          if (!inherits(repos_from_org, "graphql_error")) {
            if (length(repos_from_org) > 0) {
              repos_table <- repos_from_org |>
                graphql_engine$prepare_repos_table(
                  org = unclass(utils::URLdecode(org))
                ) |>
                dplyr::filter(organization == unclass(utils::URLdecode(org)))
            } else {
              repos_table <- NULL
            }
          } else {
            if (verbose) {
              cli::cli_alert_info("Switching to REST API")
              show_message(
                host = private$host_name,
                engine = "rest",
                scope = org,
                information = "Pulling repositories"
              )
            }
            rest_engine <- private$engines$rest
            repos_table <- rest_engine$get_repos_from_org(
              org = org,
              output = "full_table",
              verbose = verbose
            ) |>
              rest_engine$prepare_repos_table(
                org = org
              )
          }
          return(repos_table)
        }, .progress = progress) |>
          purrr::list_rbind()
      }
    },

    get_repos_from_repos = function(verbose, progress) {
      if ("repo" %in% private$searching_scope) {
        graphql_engine <- private$engines$graphql
        orgs <- graphql_engine$set_owner_type(
          owners = names(private$orgs_repos)
        )
        purrr::map(orgs, function(org) {
          owner_type <- attr(org, "type") %||% "organization"
          if (!private$scan_all && verbose) {
            show_message(
              host = private$host_name,
              engine = "graphql",
              scope = set_repo_scope(utils::URLdecode(org), private),
              information = "Pulling repositories"
            )
          }
          repos_from_org <- graphql_engine$get_repos_from_org(
            org = utils::URLdecode(org),
            owner_type = owner_type,
            verbose = verbose
          )
          if (!inherits(repos_from_org, "graphql_error")) {
            if (length(repos_from_org) > 0) {
              repos_table <- repos_from_org |>
                graphql_engine$prepare_repos_table() |>
                dplyr::filter(repo_name %in% private$orgs_repos[[utils::URLdecode(org)]])
            } else {
              repos_table <- NULL
            }
          } else {
            if (verbose) {
              cli::cli_alert_info("Switching to REST API")
              show_message(
                host = private$host_name,
                engine = "rest",
                scope = org,
                information = "Pulling repositories"
              )
            }
            rest_engine <- private$engines$rest
            repos_table <- rest_engine$get_repos_from_org(
              org = org,
              repos = private$orgs_repos[[org]],
              output = "full_table",
              verbose = verbose
            ) |>
              rest_engine$prepare_repos_table(
                org = org
              )
          }
          return(repos_table)
        }, .progress = progress) |>
          purrr::list_rbind()
      }
    },

    # Pull repositories with specific code
    get_repos_with_code = function(code,
                                   in_files = NULL,
                                   in_path = FALSE,
                                   output = "table_full",
                                   force_orgs = FALSE,
                                   verbose = TRUE,
                                   progress = TRUE) {
      if (private$scan_all && !force_orgs) {
        repos_table <- private$get_repos_with_code_from_host(
          code = code,
          in_files = in_files,
          in_path = in_path,
          output = output,
          verbose = verbose,
          progress = progress
        )
      }
      if (!private$scan_all || force_orgs) {
        repos_from_org <- private$get_repos_with_code_from_orgs(
          code = code,
          in_files = in_files,
          in_path = in_path,
          output = output,
          verbose = verbose,
          progress = progress
        )
        repos_from_repos <- private$get_repos_with_code_from_repos(
          code = code,
          in_files = in_files,
          in_path = in_path,
          output = output,
          verbose = verbose,
          progress = progress
        )
        repos_table <- rbind(repos_from_org, repos_from_repos)
      }
      return(repos_table)
    },

    # Pull all repositories URLs from organizations
    get_all_repos_urls = function(type, verbose = TRUE, progress = TRUE) {
      if (private$scan_all && is.null(private$orgs)) {
        private$orgs <- private$get_orgs_from_host(
          output = "only_names",
          verbose = verbose
        )
      }
      repos_urls_from_orgs <- private$get_repos_urls_from_orgs(
        type = type,
        verbose = verbose,
        progress = progress
      )
      repos_urls_from_repos <- private$get_repos_urls_from_repos(
        type = type,
        verbose = verbose,
        progress = progress
      )
      repos_vector <- c(
        repos_urls_from_orgs,
        repos_urls_from_repos
      )
      return(repos_vector)
    },

    get_repos_urls_from_orgs = function(type, verbose, progress) {
      if (any(c("all", "org") %in% private$searching_scope)) {
        rest_engine <- private$engines$rest
        repos_vector <- purrr::map(private$orgs, function(org) {
          if (!private$scan_all && verbose) {
            show_message(
              host = private$host_name,
              engine = "rest",
              scope = utils::URLdecode(org),
              information = "Pulling repositories (URLs)"
            )
          }
          repos_urls <- rest_engine$get_repos_urls(
            type = type,
            org = org,
            repos = NULL
          )
          return(repos_urls)
        }, .progress = progress) %>%
          unlist()
      }
    },

    get_repos_urls_from_repos = function(type, verbose, progress) {
      if ("repo" %in% private$searching_scope) {
        rest_engine <- private$engines$rest
        graphql_engine <- private$engines$graphql
        orgs <- graphql_engine$set_owner_type(
          owners = names(private$orgs_repos)
        )
        repos_vector <- purrr::map(orgs, function(org) {
          if (!private$scan_all && verbose) {
            show_message(
              host = private$host_name,
              engine = "rest",
              scope = paste0(org, "/", private$orgs_repos[[org]], collapse = ", "),
              information = "Pulling repositories (URLs)"
            )
          }
          repos_urls <- rest_engine$get_repos_urls(
            type = type,
            org = org,
            repos = private$orgs_repos[[org]]
          )
          return(repos_urls)
        }, .progress = progress) %>%
          unlist()
      }
    },

    get_repos_with_code_from_host = function(code,
                                             in_files = NULL,
                                             in_path = FALSE,
                                             output = "table_full",
                                             verbose = TRUE,
                                             progress = TRUE) {
      if (verbose) {
        show_message(
          host = private$host_name,
          engine = "rest",
          information = "Pulling repositories"
        )
      }
      rest_engine <- private$engines$rest
      if (is.null(in_files)) {
        search_response <- rest_engine$search_for_code(
          code = code,
          in_path = in_path,
          verbose = verbose
        )
      } else {
        search_response <- purrr::map(in_files, function(filename) {
          rest_engine$search_for_code(
            code = code,
            filename = filename,
            in_path = in_path,
            verbose = verbose
          )
        }) |>
          purrr::list_flatten()
      }
      repos_output <- private$parse_search_response(
        search_response = search_response,
        output = output,
        verbose = verbose
      )
      return(repos_output)
    },

    get_repos_with_code_from_orgs = function(code,
                                             in_files = NULL,
                                             in_path = FALSE,
                                             output = "table",
                                             verbose = TRUE,
                                             progress = TRUE) {
      if (any(private$searching_scope %in% c("org", "all"))) {
        repos_list <- purrr::map(private$orgs, function(org) {
          if (verbose) {
            show_message(
              host = private$host_name,
              engine = "rest",
              scope = utils::URLdecode(org),
              code = code,
              information = "Pulling repositories"
            )
          }
          rest_engine <- private$engines$rest
          if (is.null(in_files)) {
            search_response <- rest_engine$search_for_code(
              org = org,
              code = code,
              in_path = in_path,
              verbose = verbose
            )
          } else {
            search_response <- purrr::map(in_files, function(filename) {
              rest_engine$search_for_code(
                org = org,
                code = code,
                filename = filename,
                in_path = in_path,
                verbose = verbose
              )
            }) %>%
              purrr::list_flatten()
          }
          private$parse_search_response(
            search_response = search_response,
            org = org,
            output = output,
            verbose = verbose
          )
        }, .progress = if (progress) {
          "Pulling repositories from organizations..."
        } else {
          FALSE
        })
        if (output != "raw") {
          repos_output <- purrr::list_rbind(repos_list)
        } else {
          repos_output <- purrr::list_flatten(repos_list)
        }
        return(repos_output)
      }
    },

    get_repos_with_code_from_repos = function(code,
                                              in_files = NULL,
                                              in_path  = FALSE,
                                              output   = "table_full",
                                              verbose  = TRUE,
                                              progress = TRUE) {
      orgs <- names(private$orgs_repos)
      if ("repo" %in% private$searching_scope) {
        if (verbose) {
          show_message(
            host = private$host_name,
            engine = "rest",
            scope = utils::URLdecode(paste0(orgs, collapse = "|")),
            code = code,
            information = "Pulling repositories"
          )
        }
        rest_engine <- private$engines$rest
        if (is.null(in_files)) {
          search_response <- rest_engine$search_repos_for_code(
            repos = private$repos_fullnames,
            code = code,
            in_path = in_path,
            verbose = verbose
          )
        } else {
          search_response <- purrr::map(in_files, function(filename) {
            rest_engine$search_repos_for_code(
              repos = private$repos_fullnames,
              code = code,
              filename = filename,
              in_path = in_path,
              verbose = verbose
            )
          }) %>%
            purrr::list_flatten()
        }
        repos_output <- private$parse_search_response(
          search_response = search_response,
          output = output,
          verbose = verbose
        )
        return(repos_output)
      }
    },

    parse_search_response = function(search_response, org = NULL, output, verbose = TRUE) {
      if (length(search_response) > 0) {
        repos_ids <- private$get_repos_ids(search_response)
        graphql_engine <- private$engines$graphql
        if (!is.null(org)) {
          owner_type <- attr(org, "type") %||% "organization"
          repos_from_org <- graphql_engine$get_repos_from_org(
            org = org,
            owner_type = owner_type,
            verbose = verbose
          )
          repos_response <- repos_from_org |>
            purrr::keep(function(repo) {
              if (is.null(repo$node)) {
                repo_node <- repo
              } else {
                repo_node <- repo$node
              }
              any(purrr::map_lgl(repos_ids, ~ grepl(., repo_node$repo_id)))
            })
        } else {
          repos_response <- graphql_engine$get_repos(
            repos_ids = repos_ids,
            verbose = verbose
          )
        }
        if (output != "raw") {
          repos_output <- repos_response |>
            graphql_engine$prepare_repos_table(
              org = org
            )
        } else {
          repos_output <- repos_response
        }
      } else {
        repos_output <- NULL
      }
      return(repos_output)
    },

    get_repos_urls_with_code = function(type,
                                        code,
                                        in_files = NULL,
                                        in_path = FALSE,
                                        verbose,
                                        progress) {
      if (private$scan_all) {
        repos_urls <- private$get_repos_urls_with_code_from_host(
          type = type,
          code = code,
          in_files = in_files,
          in_path = in_path,
          verbose = verbose,
          progress = progress
        )
      } else {
        repos_urls_from_orgs <- private$get_repos_urls_with_code_from_orgs(
          type = type,
          code = code,
          in_files = in_files,
          in_path = in_path,
          verbose = verbose,
          progress = progress
        )
        repos_urls_from_repos <- private$get_repos_urls_with_code_from_repos(
          type = type,
          code = code,
          in_files = in_files,
          in_path = in_path,
          verbose = verbose,
          progress = progress
        )
        repos_urls <- c(repos_urls_from_orgs, repos_urls_from_repos)
      }
      return(repos_urls)
    },

    get_repos_urls_with_code_from_host = function(type, code, in_files, in_path, verbose, progress) {
      private$get_repos_with_code_from_host(
        code = code,
        in_files = in_files,
        in_path = in_path,
        output = "raw",
        verbose = verbose
      ) |>
        private$get_repo_url_from_response(
          type = type,
          progress = progress
        )
    },

    get_repos_urls_with_code_from_orgs = function(type, code, in_files, in_path, verbose, progress) {
      private$get_repos_with_code_from_orgs(
        code = code,
        in_files = in_files,
        in_path = in_path,
        output = "raw",
        verbose = verbose
      ) |>
        purrr::discard(~ is.null(.)) |>
        private$get_repo_url_from_response(
          type = type,
          progress = progress
        )
    },

    get_repos_urls_with_code_from_repos = function(type, code, in_files, in_path, verbose, progress) {
      private$get_repos_with_code_from_repos(
        code = code,
        in_files = in_files,
        in_path = in_path,
        output = "raw",
        verbose = verbose
      ) |>
        purrr::discard(~ is.null(.)) |>
        private$get_repo_url_from_response(
          type = type,
          repos_fullnames = private$repos_fullnames,
          progress = progress
        )
    },

    add_platform = function(repos_table) {
      if (!is.null(repos_table) && nrow(repos_table) > 0) {
        dplyr::mutate(
          repos_table,
          platform = retrieve_platform(api_url)
        )
      }
    },

    #' Add information on repository contributors.
    get_repos_contributors = function(repos_table, verbose, progress) {
      if (!is.null(repos_table) && nrow(repos_table) > 0) {
        if (!private$scan_all && verbose) {
          show_message(
            host = private$host_name,
            engine = "rest",
            information = "Pulling contributors"
          )
        }
        repos_table <- private$filter_repos_by_host(repos_table)
        rest_engine <- private$engines$rest
        repos_table <- rest_engine$get_repos_contributors(
          repos_table = repos_table,
          progress    = progress
        )
        return(repos_table)
      }
    },

    get_issues_from_orgs = function(verbose, progress) {
      if ("org" %in% private$searching_scope) {
        graphql_engine <- private$engines$graphql
        issues_table <- purrr::map(private$orgs, function(org) {
          issues_table_org <- NULL
          if (!private$scan_all && verbose) {
            show_message(
              host = private$host_name,
              engine = "graphql",
              scope = org,
              information = "Pulling issues"
            )
          }
          repos_names <- private$get_repos_names(org)
          issues_table_org <- graphql_engine$get_issues_from_repos(
            org = org,
            repos_names = repos_names,
            progress = progress
          ) |>
            graphql_engine$prepare_issues_table(
              org = org
            )
          return(issues_table_org)
        }, .progress = if (private$scan_all && progress) {
          "[GitHost:GitHub] Pulling issues..."
        } else {
          FALSE
        }) |>
          purrr::list_rbind()
        return(issues_table)
      }
    },

    # Get issues from GitHub
    get_issues_from_repos = function(verbose, progress) {
      if ("repo" %in% private$searching_scope) {
        graphql_engine <- private$engines$graphql
        orgs <- graphql_engine$set_owner_type(
          owners = names(private$orgs_repos)
        )
        issues_table <- purrr::map(orgs, function(org) {
          issues_table_org <- NULL
          if (!private$scan_all && verbose) {
            show_message(
              host = private$host_name,
              engine = "graphql",
              scope = set_repo_scope(org, private),
              information = "Pulling issues"
            )
          }
          issues_table_org <- graphql_engine$get_issues_from_repos(
            org = org,
            repos_names = private$orgs_repos[[org]],
            progress = progress
          ) |>
            graphql_engine$prepare_issues_table(
              org = org
            )
          return(issues_table_org)
        }, .progress = if (private$scan_all && progress) {
          "[GitHost:GitHub] Pulling issues..."
        } else {
          FALSE
        }) %>%
          purrr::list_rbind()
        return(issues_table)
      }
    },

    # Pull files content from organizations
    get_files_content_from_orgs = function(file_path,
                                           verbose = TRUE,
                                           progress = TRUE) {
      if ("org" %in% private$searching_scope) {
        graphql_engine <- private$engines$graphql
        files_table <- purrr::map(private$orgs, function(org) {
          if (verbose) {
            show_message(
              host = private$host_name,
              engine = "graphql",
              scope = org,
              information = glue::glue("Pulling files content: [{paste0(file_path, collapse = ', ')}]")
            )
          }
          owner_type <- attr(org, "type") %||% "organization"
          graphql_engine$get_files_from_org(
            org = org,
            owner_type = owner_type,
            repos = NULL,
            file_paths = file_path,
            verbose = verbose,
            progress = progress
          ) |>
            graphql_engine$prepare_files_table(
              org = org
            )
        }) |>
          purrr::list_rbind() |>
          private$add_repo_api_url()
        return(files_table)
      }
    },

    # Pull files content from organizations
    get_files_content_from_repos = function(file_path,
                                            verbose = TRUE,
                                            progress = TRUE) {
      if ("repo" %in% private$searching_scope) {
        graphql_engine <- private$engines$graphql
        orgs <- graphql_engine$set_owner_type(
          owners = names(private$orgs_repos)
        )
        files_table <- purrr::map(orgs, function(org) {
          if (verbose) {
            show_message(
              host = private$host_name,
              engine = "graphql",
              scope = set_repo_scope(org, private),
              information = glue::glue("Pulling files content: [{paste0(file_path, collapse = ', ')}]")
            )
          }
          owner_type <- attr(org, "type") %||% "organization"
          graphql_engine$get_files_from_org(
            org = org,
            owner_type = owner_type,
            repos = private$orgs_repos[[org]],
            file_paths = file_path,
            verbose = verbose,
            progress = progress
          ) |>
            graphql_engine$prepare_files_table(
              org = org
            )
        }) |>
          purrr::list_rbind() |>
          private$add_repo_api_url()
        return(files_table)
      }
    },

    get_files_content_from_files_structure = function(files_structure,
                                                      verbose = TRUE,
                                                      progress = TRUE) {
      graphql_engine <- private$engines$graphql
      result <- private$get_orgs_and_repos_from_files_structure(
        files_structure = files_structure
      )
      orgs <- result$orgs
      repos <- result$repos
      files_table <- purrr::map(orgs, function(org) {
        if (verbose) {
          show_message(
            host = private$host_name,
            engine = "graphql",
            scope = org,
            information = "Pulling files from files structure"
          )
        }
        owner_type <- attr(org, "type") %||% "organization"
        graphql_engine$get_files_from_org(
          org = org,
          owner_type = owner_type,
          repos = repos,
          host_files_structure = files_structure,
          verbose = verbose,
          progress = progress
        ) |>
          graphql_engine$prepare_files_table(
            org = org
          )
      }) |>
        purrr::list_rbind() |>
        private$add_repo_api_url()
      return(files_table)
    },

    get_orgs_and_repos_from_files_structure = function(files_structure) {
      result <- list(
        "orgs"  = names(files_structure),
        "repos" = purrr::map(files_structure, ~names(.)) %>% unlist() %>% unname()
      )
      return(result)
    },

    get_files_structure_from_orgs = function(pattern,
                                             depth,
                                             verbose  = TRUE,
                                             progress = TRUE) {
      if ("org" %in% private$searching_scope) {
        graphql_engine <- private$engines$graphql
        files_structure_list <- purrr::map(private$orgs, function(org) {
          if (verbose) {
            user_info <- if (!is.null(pattern)) {
              glue::glue(
                "Pulling files \U1F333 structure...[files matching pattern: '{paste0(pattern, collapse = '|')}']"
              )
            } else {
              glue::glue("Pulling files \U1F333 structure...")
            }
            show_message(
              host = private$host_name,
              engine = "graphql",
              scope = org,
              information = user_info
            )
          }
          owner_type <- attr(org, "type") %||% "organization"
          graphql_engine$get_files_structure_from_org(
            org = org,
            owner_type = owner_type,
            pattern = pattern,
            depth = depth,
            verbose = verbose,
            progress = progress
          )
        })
        names(files_structure_list) <- private$orgs
        files_structure_list <- files_structure_list %>%
          purrr::discard(~ length(.) == 0)
        if (length(files_structure_list) == 0 && verbose) {
          cli::cli_alert_warning(
            cli::col_yellow(
              "For {private$host_name} no files structure found."
            )
          )
        }
        return(files_structure_list)
      }
    },

    get_files_structure_from_repos = function(pattern,
                                              depth,
                                              verbose  = TRUE,
                                              progress = TRUE) {
      if ("repo" %in% private$searching_scope) {
        graphql_engine <- private$engines$graphql
        orgs <- graphql_engine$set_owner_type(
          owners = names(private$orgs_repos)
        )
        files_structure_list <- purrr::map(orgs, function(org) {
          if (verbose) {
            user_info <- if (!is.null(pattern)) {
              glue::glue(
                "Pulling files \U1F333 structure...[files matching pattern: '{paste0(pattern, collapse = '|')}']"
              )
            } else {
              glue::glue("Pulling files \U1F333 structure...")
            }
            show_message(
              host = private$host_name,
              engine = "graphql",
              scope = set_repo_scope(org, private),
              information = user_info
            )
          }
          owner_type <- attr(org, "type") %||% "organization"
          graphql_engine$get_files_structure_from_org(
            org = org,
            owner_type = owner_type,
            repos = private$repos,
            pattern = pattern,
            depth = depth,
            verbose = verbose,
            progress = progress
          )
        })
        names(files_structure_list) <- orgs
        files_structure_list <- files_structure_list %>%
          purrr::discard(~ length(.) == 0)
        if (length(files_structure_list) == 0 && verbose) {
          cli::cli_alert_warning(
            cli::col_yellow(
              "For {private$host_name} no files structure found."
            )
          )
        }
        return(files_structure_list)
      }
    },

    # Pull files from host
    get_files_content_from_host = function(file_path,
                                           verbose  = TRUE,
                                           progress = TRUE) {
      rest_engine <- private$engines$rest
      if (verbose) {
        show_message(
          host = private$host_name,
          engine = "rest",
          information = glue::glue("Pulling files: [{paste0(file_path, collapse = ', ')}]")
        )
      }
      files_table <- rest_engine$get_files(
        files = file_path
      ) |>
        rest_engine$prepare_files_table() |>
        private$add_repo_api_url()
      return(files_table)
    },

    get_release_logs_from_orgs = function(since, until, verbose, progress) {
      if ("org" %in% private$searching_scope) {
        release_logs_table <- purrr::map(private$orgs, function(org) {
          org <- utils::URLdecode(org)
          release_logs_table_org <- NULL
          if (!private$scan_all && verbose) {
            show_message(
              host = private$host_name,
              engine = "graphql",
              scope = org,
              information = "Pulling release logs"
            )
          }
          repos_names <- private$get_repos_names(
            org = org
          )
          graphql_engine <- private$engines$graphql
          if (length(repos_names) > 0) {
            release_logs_table_org <- graphql_engine$get_release_logs_from_org(
              repos_names = repos_names,
              org = org
            ) %>%
              graphql_engine$prepare_releases_table(
                org = org,
                since = since,
                until = until
              )
          } else {
            releases_logs_table_org <- NULL
          }
          return(release_logs_table_org)
        }, .progress = if (progress) {
          glue::glue("[GitHost:{private$host_name}] Pulling release logs...")
        } else {
          FALSE
        }) %>%
          purrr::list_rbind()
        return(release_logs_table)
      }
    },

    get_release_logs_from_repos = function(since, until, verbose, progress) {
      if ("repo" %in% private$searching_scope) {
        graphql_engine <- private$engines$graphql
        orgs <- graphql_engine$set_owner_type(
          owners = names(private$orgs_repos)
        )
        release_logs_table <- purrr::map(orgs, function(org) {
          org <- utils::URLdecode(org)
          release_logs_table_org <- NULL
          if (!private$scan_all && verbose) {
            show_message(
              host = private$host_name,
              engine = "graphql",
              scope = set_repo_scope(org, private),
              information = "Pulling release logs"
            )
          }
          release_logs_table_org <- graphql_engine$get_release_logs_from_org(
            repos_names = private$orgs_repos[[org]],
            org = org
          ) %>%
            graphql_engine$prepare_releases_table(
              org = org,
              since = since,
              until = until
            )
          return(release_logs_table_org)
        }, .progress = if (progress) {
          glue::glue("[GitHost:{private$host_name}] Pulling release logs...")
        } else {
          FALSE
        }) %>%
          purrr::list_rbind()
        return(release_logs_table)
      }
    }
  )
)
