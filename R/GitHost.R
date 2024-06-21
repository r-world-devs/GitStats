#' @noRd
#' @description A class to manage which engine to use for pulling data
GitHost <- R6::R6Class("GitHost",
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
                          verbose = NA) {
      private$set_verbose(verbose)
      private$set_api_url(host)
      private$set_endpoints()
      private$check_if_public(host)
      private$set_token(token)
      private$set_graphql_url()
      private$set_searching_scope(orgs, repos)
      private$setup_engines()
      private$set_orgs_and_repos(orgs, repos)
    },

    # Pull repositories method
    pull_repos = function(add_contributors = TRUE,
                          with_code = NULL,
                          with_file = NULL,
                          verbose = TRUE,
                          settings) {
      private$set_verbose(verbose)
      if (is.null(with_code) && is.null(with_file)) {
        repos_table <- private$pull_all_repos(
          settings = settings
        )
      }
      if (!is.null(with_code)) {
        repos_table <- private$pull_repos_with_code(
          code = with_code,
          settings = settings
        )
      } else if (!is.null(with_file)) {
        repos_table <- private$pull_repos_with_code(
          code = with_file,
          in_path = TRUE,
          settings = settings
        )
      }
      repos_table <- private$add_repo_api_url(repos_table)
      if (add_contributors) {
        repos_table <- private$pull_repos_contributors(
          repos_table = repos_table,
          settings = settings
        )
      }
      return(repos_table)
    },

    #' Pull commits method
    pull_commits = function(since,
                            until = Sys.Date(),
                            verbose = TRUE,
                            settings) {
      private$set_verbose(verbose)
      if (private$scan_all && is.null(private$orgs)) {
        cli::cli_alert_info("[{private$host_name}][Engine:{cli::col_yellow('GraphQL')}] Pulling all organizations...")
        private$orgs <- private$engines$graphql$pull_orgs()
      }
      if (is.null(until)) {
        until <- Sys.time()
      }
      commits_table <- private$pull_commits_from_host(
        since = since,
        until = until,
        settings = settings
      )
      return(commits_table)
    },

    #' Pull information about users.
    pull_users = function(users) {
      graphql_engine <- private$engines$graphql
      users_table <-  purrr::map(users, function(user) {
        graphql_engine$pull_user(user) %>%
          private$prepare_user_table()
      }) %>%
        purrr::list_rbind()
      return(users_table)
    },

    #' Retrieve content of given text files from all repositories for a host in
    #' a table format.
    pull_files = function(file_path, verbose = TRUE) {
      files_table <- if (!private$scan_all) {
        private$pull_files_from_orgs(
          file_path = file_path,
          verbose = verbose
        )
      } else {
        private$pull_files_from_host(
          file_path = file_path,
          verbose = verbose
        )
      }
      return(files_table)
    },

    #' Iterator over pulling release logs from engines
    pull_release_logs = function(since, until, verbose, settings) {
      if (private$scan_all && is.null(private$orgs)) {
        cli::cli_alert_info("[{private$host_name}][Engine:{cli::col_yellow('GraphQL')}] Pulling all organizations...")
        private$orgs <- private$engines$graphql$pull_orgs()
      }
      until <- until %||% Sys.time()
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
        repos_names <- private$set_repositories(
          org = org,
          settings = settings
        )
        gql_engine <- private$engines$graphql
        if (length(repos_names) > 0) {
          release_logs_table_org <- gql_engine$pull_release_logs_from_org(
            org = org,
            repos_names = repos_names
          ) %>%
            private$prepare_releases_table(org, since, until)
        } else {
          releases_logs_table_org <- NULL
        }
        return(release_logs_table_org)
      }, .progress = if (private$scan_all && verbose) {
        glue::glue("[GitHost:{private$host_name}] Pulling release logs...")
      } else {
        FALSE
      }) %>%
        purrr::list_rbind()
      return(release_logs_table)
    }
  ),
  private = list(

    # A REST API URL.
    api_url = NULL,

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

    # Set verbose mode
    set_verbose = function(verbose) {
      private$verbose <- verbose
    },

    # engines A placeholder for REST and GraphQL Engine classes.
    engines = list(),

    # Set API url
    set_custom_api_url = function(host) {
      private$api_url <- if (!grepl("https://", host)) {
        glue::glue(
          "https://{host}/api/v{private$api_version}"
        )
      } else {
        glue::glue(
          "{host}/api/v{private$api_version}"
        )
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
    set_token = function(token) {
      if (is.null(token)){
        token <- private$set_default_token()
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
            "i" = "Check if you use correct token. Check scopes your token is using."
          ))
        } else {
          return(token)
        }
      }
    },

    # Check if both repos and orgs are defined or not.
    set_searching_scope = function(orgs, repos) {
      if (is.null(repos) && is.null(orgs)) {
        if (private$is_public) {
          cli::cli_abort(c(
            "You need to specify `orgs` for public Git Host.",
            "x" = "Host will not be added.",
            "i" = "Add organizations to your `orgs` parameter."
          ),
          call = NULL)
        } else {
          if (private$verbose) {
            cli::cli_alert_warning(cli::col_yellow(
              "No `orgs` specified."
            ))
            cli::cli_alert_info(cli::col_grey(
              "Searching scope set to [all]."
            ))
          }
          private$searching_scope <- "all"
          private$scan_all <- TRUE
        }
      }
      if (!is.null(repos) && is.null(orgs)) {
        if (private$verbose) {
          cli::cli_alert_info(cli::col_grey("Searching scope set to [repo]."))
        }
        private$searching_scope <- "repo"
      }
      if (is.null(repos) && !is.null(orgs)) {
        if (private$verbose) {
          cli::cli_alert_info(cli::col_grey("Searching scope set to [org]."))
        }
        private$searching_scope <- "org"
      }
      if (!is.null(repos) && !is.null(orgs)) {
        cli::cli_abort(c(
          "Do not specify `orgs` while specifing `repos`.",
          "x" = "Host will not be added.",
          "i" = "Specify `orgs` or `repos`."
        ),
        call = NULL)
      }
    },

    # Set organization or repositories
    set_orgs_and_repos = function(orgs, repos) {
      if (!private$scan_all) {
        if (!is.null(orgs)) {
          private$orgs <- private$check_organizations(orgs)
        }
        if (!is.null(repos)) {
          repos <- private$check_repositories(repos)
          private$repos_fullnames <- repos
          orgs_repos <- private$extract_repos_and_orgs(repos)
          private$orgs <- names(orgs_repos)
          private$repos <- unname(unlist(orgs_repos))
          private$orgs_repos <- orgs_repos
        }
      }
    },

    # Check if repositories exist
    check_repositories = function(repos) {
      if (private$verbose) {
        cli::cli_alert_info(cli::col_grey("Checking host data..."))
      }
      repos <- purrr::map(repos, function(repo) {
        repo_endpoint = glue::glue("{private$endpoints$repositories}/{repo}")
        check <- private$check_endpoint(
          endpoint = repo_endpoint,
          type = "Repository"
        )
        if (!check) {
          repo <- NULL
        }
        return(repo)
      }) %>%
        purrr::keep(~ length(.) > 0) %>%
        unlist()
      if (length(repos) == 0) {
        return(NULL)
      }
      repos
    },

    # Check if organizations exist
    check_organizations = function(orgs) {
      if (private$verbose) {
        cli::cli_alert_info(cli::col_grey("Checking host data..."))
      }
      orgs <- purrr::map(orgs, function(org) {
        org_endpoint = glue::glue("{private$endpoints$orgs}/{org}")
        check <- private$check_endpoint(
          endpoint = org_endpoint,
          type = "Organization"
        )
        if (!check) {
          org <- NULL
        }
        return(org)
      }) %>%
        purrr::keep(~ length(.) > 0) %>%
        unlist()
      if (length(orgs) == 0) {
        return(NULL)
      }
      orgs
    },

    # Check whether the endpoint exists.
    check_endpoint = function(endpoint, type) {
      check <- TRUE
      tryCatch(
        {
          private$engines$rest$response(endpoint = endpoint)
        },
        error = function(e) {
          if (!is.null(e$parent$message) && grepl("Could not resolve host", e$parent$message)) {
            cli::cli_abort(
              cli::col_red(e$parent$message),
              call = NULL
            )
          }
          if (grepl("404", e)) {
            cli::cli_abort(
              c(
                "x" = "{type} you provided does not exist or its name was passed in a wrong way: {cli::col_red({endpoint})}",
                "!" = "Please type your {tolower(type)} name as you see it in web URL.",
                "i" = "E.g. do not use spaces. {type} names as you see on the page may differ from their web 'address'."
              ),
              call = NULL
            )
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
    set_default_token = function() {
      primary_token_name <- private$token_name
      token <- Sys.getenv(primary_token_name)
      if (private$test_token(token) && private$verbose) {
        cli::cli_alert_info("Using PAT from {primary_token_name} envar.")
      } else {
        pat_names <- names(Sys.getenv()[grepl(primary_token_name, names(Sys.getenv()))])
        possible_tokens <- pat_names[pat_names != primary_token_name]
        for (token_name in possible_tokens) {
          if (private$test_token(Sys.getenv(token_name))) {
            token <- Sys.getenv(token_name)
            if (private$verbose) {
              cli::cli_alert_info("Using PAT from {token_name} envar.")
            }
            break
          }
        }
      }
      return(token)
    },

    # Helper to test if a token works
    test_token = function(token) {
      response <- NULL
      test_endpoint <- private$test_endpoint
      try(response <- httr2::request(test_endpoint) %>%
        httr2::req_headers("Authorization" = paste0("Bearer ", token)) %>%
        httr2::req_perform(), silent = TRUE)
      if (!is.null(response)) {
        private$check_token_scopes(response, token)
        TRUE
      } else {
        FALSE
      }
    },

    # Helper to extract organizations and repositories from vector of full names
    # of repositories
    extract_repos_and_orgs = function(repos_fullnames = NULL) {
      repos_fullnames <-URLdecode(repos_fullnames)
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

    # Set repositories
    set_repos = function(settings, org) {
      if (private$searching_scope == "repo") {
        repos <- private$orgs_repos[[org]]
      } else {
        repos <- NULL
      }
      return(repos)
    },

    # Filter repositories table by host
    filter_repos_by_host = function(repos_table) {
      dplyr::filter(
        repos_table,
        grepl(gsub("/v+.*", "", private$api_url), api_url)
      )
    },

    #' Retrieve all repositories for an organization in a table format.
    pull_all_repos = function(settings, verbose = private$verbose) {
      if (private$scan_all && is.null(private$orgs)) {
        if (verbose) {
          show_message(
            host = private$host_name,
            engine = "graphql",
            information = "Pulling all organizations"
          )
        }
        private$orgs <- private$engines$graphql$pull_orgs()
      }
      graphql_engine <- private$engines$graphql
      repos_table <- purrr::map(private$orgs, function(org) {
        org <- utils::URLdecode(org)
        if (!private$scan_all && verbose) {
          show_message(
            host = private$host_name,
            engine = "graphql",
            scope = org,
            information = "Pulling repositories"
          )
        }
        repos <- private$set_repos(settings, org)
        repos_table <- graphql_engine$pull_repos_from_org(
          org = org
        ) %>%
          private$prepare_repos_table_from_graphql()
        if (!is.null(repos)) {
          repos_table <- repos_table %>%
            dplyr::filter(repo_name %in% repos)
        }
        return(repos_table)
      }, .progress = private$scan_all) %>%
        purrr::list_rbind()
      return(repos_table)
    },

    # Pull repositories with specific code
    pull_repos_with_code = function(code, in_path = FALSE, raw_output = FALSE, settings) {
      if (private$scan_all) {
        repos_table <- private$pull_repos_with_code_from_host(
          code = code,
          in_path = in_path,
          raw_output = raw_output,
          settings = settings
        )
      }
      if (!private$scan_all) {
        repos_table <- private$pull_repos_with_code_from_orgs(
          code = code,
          in_path = in_path,
          raw_output = raw_output,
          settings = settings
        )
      }
      return(repos_table)
    },

    # Pull repositories with code from whole Git Host
    pull_repos_with_code_from_host = function(code, in_path = FALSE, raw_output = FALSE, settings) {
      rest_engine <- private$engines$rest
      if (private$verbose) {
        show_message(
          host = private$host_name,
          engine = "rest",
          information = "Pulling repositories"
        )
      }
      repos_response <- rest_engine$pull_repos_by_code(
        code = code,
        in_path = in_path,
        raw_output = raw_output,
        verbose = private$verbose,
        settings = settings
      )
      if (!raw_output) {
        repos_table <- repos_response %>%
          private$tailor_repos_response() %>%
          private$prepare_repos_table_from_rest() %>%
          rest_engine$pull_repos_issues()
        return(repos_table)
      } else {
        return(repos_response)
      }
    },

    # Pull repositories with code from given organizations
    pull_repos_with_code_from_orgs = function(code, in_path = FALSE, raw_output = FALSE, settings) {
      rest_engine <- private$engines$rest
      repos_list <- purrr::map(private$orgs, function(org) {
        if (private$verbose) {
          show_message(
            host = private$host_name,
            engine = "rest",
            scope = org,
            code = code,
            information = "Pulling repositories"
          )
        }
        repos_response <- rest_engine$pull_repos_by_code(
          org = org,
          code = code,
          in_path = in_path,
          raw_output = raw_output,
          verbose = private$verbose,
          settings = settings
        )
        if (!raw_output) {
          repos_table <- repos_response %>%
            private$tailor_repos_response() %>%
          private$prepare_repos_table_from_rest() %>%
          rest_engine$pull_repos_issues()
          return(repos_table)
        } else {
          return(repos_response)
        }
      }, .progress = private$scan_all)
      if (!raw_output) {
        repos_output <- purrr::list_rbind(repos_list)
      } else {
        repos_output <- purrr::list_flatten(repos_list)
      }
      return(repos_output)
    },

    #' Add information on repository contributors.
    pull_repos_contributors = function(repos_table, settings) {
      if (!is.null(repos_table) && nrow(repos_table) > 0) {
        if (!private$scan_all && private$verbose) {
          show_message(
            host = private$host_name,
            engine = "rest",
            information = "Pulling contributors"
          )
        }
        repos_table <- private$filter_repos_by_host(repos_table)
        rest_engine <- private$engines$rest
        repos_table <- rest_engine$pull_repos_contributors(
          repos_table = repos_table,
          settings = settings
        )
        return(repos_table)
      }
    },

    # Prepare table for repositories content
    prepare_repos_table_from_rest = function(repos_list) {
      repos_dt <- purrr::map(repos_list, function(repo) {
        repo <- purrr::map(repo, function(attr) {
          attr <- attr %||% ""
        })
        data.frame(repo)
      }) %>%
        purrr::list_rbind()
      if (private$verbose) {
        cli::cli_alert_info("Preparing repositories table...")
      }
      if (length(repos_dt) > 0) {
        repos_dt <- dplyr::mutate(repos_dt,
                                  repo_id = as.character(repo_id),
                                  created_at = as.POSIXct(created_at),
                                  last_activity_at = as.POSIXct(last_activity_at),
                                  forks = as.integer(forks),
                                  issues_open = as.integer(issues_open),
                                  issues_closed = as.integer(issues_closed)
        )
      }
      return(repos_dt)
    },

    # Pull files content from organizations
    pull_files_from_orgs = function(file_path, verbose) {
      graphql_engine <- private$engines$graphql
      files_table <- purrr::map(private$orgs, function(org) {
        if (verbose) {
          show_message(
            host = private$host_name,
            engine = "graphql",
            scope = org,
            information = glue::glue("Pulling files: [{paste0(file_path, collapse = ', ')}]")
          )
        }
        graphql_engine$pull_files_from_org(
          org = org,
          file_path = file_path
        ) %>%
          private$prepare_files_table(
            org = org,
            file_path = file_path
          )
      }) %>%
        purrr::list_rbind() %>%
        private$add_repo_api_url()
      return(files_table)
    },

    # Pull files from host
    pull_files_from_host = function(file_path, verbose) {
      rest_engine <- private$engines$rest
      if (verbose) {
        show_message(
          host = private$host_name,
          engine = "rest",
          information = glue::glue("Pulling files: [{paste0(file_path, collapse = ', ')}]")
        )
      }
      files_table <- rest_engine$pull_files(
        files = file_path
      ) %>%
        private$prepare_files_table_from_rest() %>%
        private$add_repo_api_url()
      return(files_table)
    }
  )
)
