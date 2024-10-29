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
    initialize = function(orgs    = NA,
                          repos   = NA,
                          token   = NA,
                          host    = NA,
                          verbose = NA) {
      private$set_api_url(host)
      private$set_web_url(host)
      private$set_endpoints()
      private$check_if_public(host)
      private$set_token(
        token   = token,
        verbose = verbose
      )
      private$set_graphql_url()
      private$set_searching_scope(
        orgs    = orgs,
        repos   = repos,
        verbose = verbose
      )
      private$setup_engines()
      private$set_orgs_and_repos(
        orgs    = orgs,
        repos   = repos,
        verbose = verbose
      )
    },

    # Pull repositories method
    get_repos = function(add_contributors = TRUE,
                         with_code        = NULL,
                         in_files         = NULL,
                         with_file        = NULL,
                         output           = "table_full",
                         verbose          = TRUE,
                         progress         = TRUE) {
      if (is.null(with_code) && is.null(with_file)) {
        repos_table <- private$get_all_repos(
          verbose  = verbose,
          progress = progress
        )
      }
      if (!is.null(with_code)) {
        repos_table <- private$get_repos_with_code(
          code     = with_code,
          in_files = in_files,
          output   = output,
          verbose  = verbose,
          progress = progress
        )
      } else if (!is.null(with_file)) {
        repos_table <- private$get_repos_with_code(
          code     = with_file,
          in_path  = TRUE,
          output   = output,
          verbose  = verbose,
          progress = progress
        )
      }
      if (output == "table_full" || output == "table_min") {
        repos_table <- private$add_repo_api_url(repos_table) %>%
          private$add_platform()
        if (add_contributors) {
          repos_table <- private$get_repos_contributors(
            repos_table = repos_table,
            verbose     = verbose,
            progress    = progress
          )
        }
      }
      return(repos_table)
    },

    # Get repositories URLS from the Git host
    get_repos_urls = function(type      = "web",
                              with_code = NULL,
                              in_files  = NULL,
                              with_file = NULL,
                              verbose   = TRUE,
                              progress  = TRUE) {
      if (!is.null(with_code)) {
        repo_urls <- private$get_repos_with_code(
          code     = with_code,
          in_files = in_files,
          output   = "raw",
          verbose  = verbose
        ) %>%
          private$get_repo_url_from_response(
            type     = type,
            progress = progress
          )
      } else if (!is.null(with_file)) {
        repo_urls <- private$get_repos_with_code(
          code    = with_file,
          in_path = TRUE,
          output  = "raw",
          verbose = verbose
        ) %>%
          private$get_repo_url_from_response(
            type     = type,
            progress = progress
          )
      } else {
        repo_urls <- private$get_all_repos_urls(
          type     = type,
          verbose  = verbose,
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
      if (private$scan_all && is.null(private$orgs) && verbose) {
        cli::cli_alert_info("[{private$host_name}][Engine:{cli::col_yellow('GraphQL')}] Pulling all organizations...")
        private$orgs <- private$engines$graphql$get_orgs()
      }
      commits_table <- private$get_commits_from_orgs(
        since    = since,
        until    = until,
        verbose  = verbose,
        progress = progress
      )
      return(commits_table)
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
                                 host_files_structure = NULL,
                                 only_text_files      = TRUE,
                                 verbose              = TRUE,
                                 progress             = TRUE) {
      files_table <- if (!private$scan_all) {
        private$get_files_content_from_orgs(
          file_path            = file_path,
          host_files_structure = host_files_structure,
          only_text_files      = only_text_files,
          verbose              = verbose,
          progress             = progress
        )
      } else {
        private$get_files_content_from_host(
          file_path = file_path,
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
      files_structure <- private$get_files_structure_from_orgs(
        pattern  = pattern,
        depth    = depth,
        verbose  = verbose,
        progress = progress
      )
      return(files_structure)
    },

    #' Iterator over pulling release logs from engines
    get_release_logs = function(since, until, verbose, progress) {
      if (private$scan_all && is.null(private$orgs)) {
        if (verbose) {
          cli::cli_alert_info("[{private$host_name}][Engine:{cli::col_yellow('GraphQL')}] Pulling all organizations...")
        }
        private$orgs <- private$engines$graphql$get_orgs()
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
          org = org
        )
        graphql_engine <- private$engines$graphql
        if (length(repos_names) > 0) {
          release_logs_table_org <- graphql_engine$get_release_logs_from_org(
            org = org,
            repos_names = repos_names
          ) %>%
            graphql_engine$prepare_releases_table(org, since, until)
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
            "You need to specify `orgs` for public Git Host.",
            "x" = "Host will not be added.",
            "i" = "Add organizations to your `orgs` parameter."
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
      if (!is.null(repos) && is.null(orgs)) {
        if (verbose) {
          cli::cli_alert_info(cli::col_grey("Searching scope set to [repo]."))
        }
        private$searching_scope <- "repo"
      }
      if (is.null(repos) && !is.null(orgs)) {
        if (verbose) {
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
    set_orgs_and_repos = function(orgs, repos, verbose) {
      if (!private$scan_all) {
        if (!is.null(orgs)) {
          private$orgs <- private$check_organizations(
            orgs    = orgs,
            verbose = verbose
          )
        }
        if (!is.null(repos)) {
          repos <- private$check_repositories(
            repos   = repos,
            verbose = verbose
          )
          private$repos_fullnames <- repos
          orgs_repos <- private$extract_repos_and_orgs(repos)
          private$orgs <- private$set_owner_type(
            owners = names(orgs_repos)
          )
          private$repos <- unname(unlist(orgs_repos))
          private$orgs_repos <- orgs_repos
        }
      }
    },

    # Check if repositories exist
    check_repositories = function(repos, verbose) {
      if (verbose) {
        cli::cli_alert_info(cli::col_grey("Checking repositories..."))
      }
      repos <- purrr::map(repos, function(repo) {
        repo_endpoint <- glue::glue("{private$endpoints$repositories}/{repo}")
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
    check_organizations = function(orgs, verbose) {
      if (verbose) {
        cli::cli_alert_info(cli::col_grey("Checking organizations..."))
      }
      orgs <- purrr::map(orgs, function(org) {
        org_endpoint <- glue::glue("{private$endpoints$orgs}/{org}")
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
          if (grepl("404", e)) {
            cli::cli_abort(
              c(
                "x" = "{type} you provided does not exist or its name was passed
                in a wrong way: {cli::col_red({endpoint})}",
                "!" = "Please type your {tolower(type)} name as you see it in
                web URL.",
                "i" = "E.g. do not use spaces. {type} names as you see on the
                page may differ from their web 'address'."
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
    set_default_token = function(verbose) {
      primary_token_name <- private$token_name
      token <- Sys.getenv(primary_token_name)
      if (private$test_token(token) && verbose) {
        cli::cli_alert_info("Using PAT from {primary_token_name} envar.")
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

    # Set repositories
    set_repos = function(org) {
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
    get_all_repos = function(verbose = TRUE, progress = TRUE) {
      if (private$scan_all && is.null(private$orgs)) {
        if (verbose) {
          show_message(
            host        = private$host_name,
            engine      = "graphql",
            information = "Pulling all organizations"
          )
        }
        private$orgs <- private$engines$graphql$get_orgs()
      }
      graphql_engine <- private$engines$graphql
      repos_table <- purrr::map(private$orgs, function(org) {
        type <- attr(org, "type") %||% "organization"
        org <- utils::URLdecode(org)
        if (!private$scan_all && verbose) {
          show_message(
            host        = private$host_name,
            engine      = "graphql",
            scope       = org,
            information = "Pulling repositories"
          )
        }
        repos <- private$set_repos(org)
        repos_table <- graphql_engine$get_repos_from_org(
          org  = org,
          type = type
        ) %>%
          graphql_engine$prepare_repos_table()
        if (!is.null(repos)) {
          repos_table <- repos_table %>%
            dplyr::filter(repo_name %in% repos)
        }
        return(repos_table)
      }, .progress = progress) %>%
        purrr::list_rbind()
      return(repos_table)
    },

    # Pull repositories with specific code
    get_repos_with_code = function(code,
                                   in_files   = NULL,
                                   in_path    = FALSE,
                                   output     = "table_full",
                                   verbose    = TRUE,
                                   progress   = TRUE) {
      if (private$scan_all) {
        repos_table <- private$get_repos_with_code_from_host(
          code     = code,
          in_files = in_files,
          in_path  = in_path,
          output   = output,
          verbose  = verbose,
          progress = progress
        )
      }
      if (!private$scan_all) {
        repos_table <- private$get_repos_with_code_from_orgs(
          code     = code,
          in_files = in_files,
          in_path  = in_path,
          output   = output,
          verbose  = verbose,
          progress = progress
        )
      }
      return(repos_table)
    },

    # Pull all repositories URLs from organizations
    get_all_repos_urls = function(type, verbose = TRUE, progress = TRUE) {
      if (private$scan_all && is.null(private$orgs)) {
        if (verbose) {
          show_message(
            host        = private$host_name,
            engine      = "graphql",
            information = "Pulling all organizations"
          )
        }
        private$orgs <- private$engines$graphql$get_orgs()
      }
      rest_engine <- private$engines$rest
      repos_vector <- purrr::map(private$orgs, function(org) {
        org <- utils::URLdecode(org)
        if (!private$scan_all && verbose) {
          show_message(
            host        = private$host_name,
            engine      = "rest",
            scope       = org,
            information = "Pulling repositories (URLS)"
          )
        }
        repos_urls <- rest_engine$get_repos_urls(
          type = type,
          org  = org
        )
        return(repos_urls)
      }, .progress = progress) %>%
        unlist()
      return(repos_vector)
    },

    # Pull repositories with code from whole Git Host
    get_repos_with_code_from_host = function(code,
                                             in_files = NULL,
                                             in_path  = FALSE,
                                             output   = "table_full",
                                             verbose  = TRUE,
                                             progress = TRUE) {
      if (verbose) {
        show_message(
          host        = private$host_name,
          engine      = "rest",
          information = "Pulling repositories"
        )
      }
      rest_engine <- private$engines$rest
      if (is.null(in_files)) {
        repos_response <- rest_engine$get_repos_by_code(
          code     = code,
          in_path  = in_path,
          output   = output,
          verbose  = verbose,
          progress = progress
        )
      } else {
        repos_response <- purrr::map(in_files, function(filename) {
          rest_engine$get_repos_by_code(
            code     = code,
            filename = filename,
            in_path  = in_path,
            output   = output,
            verbose  = verbose,
            progress = progress
          )
        }) %>%
          purrr::list_flatten()
      }
      if (output != "raw") {
        repos_table <- repos_response %>%
          rest_engine$tailor_repos_response(
            output = output
          ) %>%
          rest_engine$prepare_repos_table(
            output  = output,
            verbose = verbose
          )
        if (output == "table_full") {
          repos_table <- repos_table %>%
            rest_engine$get_repos_issues(
              progress = progress
            )
        }
        return(repos_table)
      } else {
        return(repos_response)
      }
    },

    # Pull repositories with code from given organizations
    get_repos_with_code_from_orgs = function(code,
                                             in_files = NULL,
                                             in_path  = FALSE,
                                             output   = "table_full",
                                             verbose  = TRUE,
                                             progress = TRUE) {
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
          repos_response <- rest_engine$get_repos_by_code(
            org      = org,
            code     = code,
            in_path  = in_path,
            output   = output,
            verbose  = verbose,
            progress = progress
          )
        } else {
          repos_response <- purrr::map(in_files, function(filename) {
            rest_engine$get_repos_by_code(
              org      = org,
              code     = code,
              filename = filename,
              in_path  = in_path,
              output   = output,
              verbose  = verbose,
              progress = progress
            )
          }) %>%
            purrr::list_flatten()
        }
        if (output != "raw") {
          repos_table <- repos_response %>%
            rest_engine$tailor_repos_response(
              output = output
            ) %>%
            rest_engine$prepare_repos_table(
              output  = output,
              verbose = verbose
            )
          if (output == "table_full") {
            repos_table <- repos_table %>%
              rest_engine$get_repos_issues(
                progress = progress
              )
          }
          return(repos_table)
        } else {
          return(repos_response)
        }
      }, .progress = progress)
      if (output != "raw") {
        repos_output <- purrr::list_rbind(repos_list)
      } else {
        repos_output <- purrr::list_flatten(repos_list)
      }
      return(repos_output)
    },

    add_platform = function(repos_table) {
      if (nrow(repos_table) > 0) {
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

    # Pull files content from organizations
    get_files_content_from_orgs = function(file_path,
                                           host_files_structure = NULL,
                                           only_text_files      = TRUE,
                                           verbose              = TRUE,
                                           progress             = TRUE) {
      graphql_engine <- private$engines$graphql
      if (!is.null(host_files_structure)) {
        if (verbose) {
          cli::cli_alert_info(cli::col_green("I will make use of files structure stored in GitStats."))
        }
        result <- private$get_orgs_and_repos_from_files_structure(
          host_files_structure = host_files_structure
        )
        orgs <- result$orgs
        repos <- result$repos
      } else {
        orgs <- private$orgs
        repos <- private$repos
      }
      files_table <- purrr::map(orgs, function(org) {
        if (verbose) {
          user_msg <- if (!is.null(host_files_structure)) {
            "Pulling files from files structure"
          } else {
            glue::glue("Pulling files content: [{paste0(file_path, collapse = ', ')}]")
          }
          show_message(
            host        = private$host_name,
            engine      = "graphql",
            scope       = org,
            information = user_msg
          )
        }
        type <- attr(org, "type") %||% "organization"
        graphql_engine$get_files_from_org(
          org                  = org,
          type                 = type,
          repos                = repos,
          file_paths           = file_path,
          host_files_structure = host_files_structure,
          only_text_files      = only_text_files,
          verbose              = verbose,
          progress             = progress
        ) %>%
          graphql_engine$prepare_files_table(
            org       = org,
            file_path = file_path
          )
      }) %>%
        purrr::list_rbind() %>%
        private$add_repo_api_url()
      return(files_table)
    },

    get_orgs_and_repos_from_files_structure = function(host_files_structure) {
      result <- list(
        "orgs"  = names(host_files_structure),
        "repos" = purrr::map(host_files_structure, ~names(.)) %>% unlist() %>% unname()
      )
      return(result)
    },

    get_files_structure_from_orgs = function(pattern,
                                             depth,
                                             verbose  = TRUE,
                                             progress = TRUE) {
      graphql_engine <- private$engines$graphql
      files_structure_list <- purrr::map(private$orgs, function(org) {
        if (verbose) {
          user_info <- if (!is.null(pattern)) {
            glue::glue("Pulling files structure...[files matching pattern: '{pattern}']")
          } else {
            glue::glue("Pulling files structure...")
          }
          show_message(
            host = private$host_name,
            engine = "graphql",
            scope = org,
            information = user_info
          )
        }
        type <- attr(org, "type") %||% "organization"
        graphql_engine$get_files_structure_from_org(
          org      = org,
          type     = type,
          repos    = private$repos,
          pattern  = pattern,
          depth    = depth,
          verbose  = verbose,
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
        file_paths = file_path,
        verbose    = verbose,
        progress   = progress
      ) %>%
        private$prepare_files_table_from_rest() %>%
        private$add_repo_api_url()
      return(files_table)
    }
  )
)
