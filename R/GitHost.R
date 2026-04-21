GitHost <- R6::R6Class(
  classname = "GitHost",
  public = list(

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
                         add_languages = TRUE,
                         with_code = NULL,
                         in_files = NULL,
                         with_file = NULL,
                         language = NULL,
                         output = "table",
                         verbose = TRUE,
                         progress = TRUE,
                         fill_empty_sha = FALSE) {
      if (is.null(with_code) && is.null(with_file)) {
        repos_table <- private$get_all_repos(
          add_languages = add_languages,
          verbose  = verbose,
          progress = progress,
          fill_empty_sha = fill_empty_sha
        )
      }
      if (!is.null(with_code)) {
        repos_table <- private$get_repos_with_code(
          code = with_code,
          in_files = in_files,
          language = language,
          output = output,
          verbose = verbose,
          progress = progress
        )
      } else if (!is.null(with_file)) {
        repos_table <- private$get_repos_with_code(
          code = with_file,
          in_path = TRUE,
          language = language,
          output = output,
          verbose = verbose,
          progress = progress
        )
      }
      if (output == "table") {
        repos_table <- private$add_repo_api_url(repos_table) |>
          private$add_githost_info()
        if (!is.null(language)) {
          repos_table <- private$filter_repos_table_by_language(
            repos_table = repos_table,
            language_filter = language
          )
        }
        if (!add_languages && "languages" %in% colnames(repos_table)) {
          repos_table <- repos_table |>
            dplyr::select(-languages)
        }
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

    get_commits = function(since,
                           until,
                           verbose = TRUE,
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

    get_issues = function(since,
                          until,
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
            created_at >= since & created_at <= parse_until_param(until)
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

    get_pull_requests = function(since,
                                 until,
                                 state = NULL,
                                 verbose = TRUE,
                                 progress = TRUE) {
      if (private$scan_all && is.null(private$orgs)) {
        private$orgs <- private$get_orgs_from_host(
          output = "only_names",
          verbose = verbose
        )
      }
      pr_from_orgs <- private$get_pr_from_orgs(
        verbose = verbose,
        progress = progress
      )
      pr_from_repos <- private$get_pr_from_repos(
        verbose = verbose,
        progress = progress
      )
      pr_table <- list(
        pr_from_orgs,
        pr_from_repos
      ) |>
        purrr::list_rbind() |>
        dplyr::distinct()
      if (nrow(pr_table) > 0) {
        pr_table <- pr_table |>
          dplyr::filter(
            created_at >= since & created_at <= parse_until_param(until)
          )
        if (!is.null(state)) {
          type <- state
          pr_table <- pr_table |>
            dplyr::filter(
              state == type
            )
        }
      }
      return(pr_table)
    },

    get_users = function(users) {
      graphql_engine <- private$engines$graphql
      users_table <-  gitstats_map(users, function(user) {
        graphql_engine$get_user(user) |>
          graphql_engine$prepare_user_table()
      }) |>
        purrr::list_rbind()
      return(users_table)
    },

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

    get_files_structure = function(pattern,
                                   depth,
                                   verbose  = TRUE,
                                   progress = TRUE) {
      if (private$scan_all && is.null(private$orgs)) {
        private$orgs <- private$get_orgs_from_host(
          output = "only_names",
          verbose = verbose
        )
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

    get_release_logs = function(since, until, verbose, progress) {
      if (private$scan_all && is.null(private$orgs)) {
        private$orgs <- private$get_orgs_from_host(
          output = "only_names",
          verbose = verbose
        )
      }
      release_logs_from_orgs <- private$get_release_logs_from_orgs(
        verbose = verbose,
        progress = progress
      )
      release_logs_from_repos <- private$get_release_logs_from_repos(
        verbose = verbose,
        progress = progress
      )
      release_logs_table <- list(
        release_logs_from_orgs,
        release_logs_from_repos
      ) |>
        purrr::list_rbind()
      if (nrow(release_logs_table) > 0) {
        release_logs_table <- release_logs_table |>
          dplyr::filter(
            published_at >= since & published_at <= parse_until_param(until)
          )
      }
      return(release_logs_table)
    },

    set_storage_backend = function(backend) {
      private$storage_backend <- backend
    }
  ),
  private = list(

    api_url = NULL,
    web_url = NULL,
    graphql_api_url = NULL,
    searching_scope = NULL,
    test_endpoint = NULL,
    endpoints = list(tokens = NULL, orgs = NULL, repositories = NULL),
    token = NULL,
    token_scopes = NULL,
    is_public = NULL,
    orgs = NULL,
    repos = NULL,
    repos_fullnames = NULL,
    orgs_repos = NULL,
    scan_all = FALSE,
    verbose = TRUE,
    engines = list(),
    cached_repos = list(),
    storage_backend = NULL,

    get_cached_repos = function(org) {
      private$cached_repos[[org]]
    },

    set_cached_repos = function(repos, org, verbose) {
      if (verbose) {
        cli::cli_alert("Caching repositories for [{org}]...")
      }
      private$cached_repos[[org]] <- repos
    },

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

    set_custom_web_url = function(host) {
      private$web_url <- if (!grepl("https://", host)) {
        glue::glue(
          "https://{host}"
        )
      } else {
        host
      }
    },

    set_endpoints = function() {
      private$set_test_endpoint()
      private$set_tokens_endpoint()
      private$set_orgs_endpoint()
      private$set_repositories_endpoint()
    },

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

    set_searching_scope = function(orgs, repos, verbose) {
      if (is.null(repos) && is.null(orgs)) {
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
      if (!is.null(repos)) {
        private$searching_scope <- c(private$searching_scope, "repo")
      }
      if (!is.null(orgs)) {
        private$searching_scope <- c(private$searching_scope, "org")
      }
    },

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

    check_repositories = function(repos, verbose, .error) {
      repos_without_org <- repos[!grepl("/", url_decode(repos))]
      if (length(repos_without_org) > 0) {
        cli::cli_abort(
          c(
            "x" = "Repository name must be provided as a full path: {.val org/repo_name}.",
            "i" = "Got: {.val {url_decode(repos_without_org)}}",
            "!" = "Pass the full path as seen in the web URL, e.g. {.val r-world-devs/GitStats}."
          ),
          call = NULL
        )
      }
      if (verbose) {
        cli::cli_alert(cli::col_grey("Checking repositories..."))
      }
      repos <- gitstats_map(repos, function(repo) {
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

    check_organizations = function(orgs, verbose, .error) {
      if (verbose) {
        cli::cli_alert(cli::col_grey("Checking owners..."))
      }
      orgs <- private$engines$graphql$set_owner_type(
        owners = url_decode(orgs),
        verbose = verbose
      ) |>
        purrr::map(function(org) {
          if (attr(org, "type") == "not found") {
            if (.error) {
              cli::cli_abort(
                c(
                  "x" = "Org/user you provided does not exist or its name was passed
                  in a wrong way: {cli::col_red({url_decode(org)})}",
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

    check_endpoint = function(endpoint, type, verbose, .error) {
      check <- TRUE
      endpoint_response <- private$engines$rest$perform_request(
        endpoint = endpoint,
        token = private$token,
        verbose = verbose
      )
      if (endpoint_response$status_code == 404) {
        if (.error) {
          cli::cli_abort(
            c(
              "x" = "{type} you provided does not exist or its name was passed
                in a wrong way: {cli::col_red({url_decode(endpoint)})}",
              "!" = "Please type your {tolower(type)} name as you see it in
                web URL.",
              "i" = "E.g. do not use spaces. {type} names as you see on the
                page may differ from their web 'address'.",
              "i" = "Repository names should be provided as full paths: {.val org/repo_name}."
            ),
            call = NULL
          )
        } else {
          if (verbose) {
            cli::cli_alert_warning(
              cli::col_yellow(
                "{type} you provided does not exist: {cli::col_red({url_decode(endpoint)})}"
              )
            )
          }
          check <- FALSE
        }
      }
      return(check)
    },

    set_graphql_url = function() {
      clean_api_url <- gsub("/v+.*", "", private$api_url)
      private$graphql_api_url <- glue::glue("{clean_api_url}/graphql")
    },

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

    extract_repos_and_orgs = function(repos_fullnames = NULL) {
      repos_fullnames <- url_decode(repos_fullnames)
      repos_vec <- stringr::str_split(repos_fullnames, "/") |>
        purrr::map(~ paste0(.[length(.)], collapse = "/")) |>
        unlist()
      orgs_vec <- stringr::str_split(repos_fullnames, "/") |>
        purrr::map(~ paste0(.[-length(.)], collapse = "/")) |>
        unlist()
      names(repos_vec) <- orgs_vec
      orgs_names <- unique(orgs_vec)
      orgs_repo_list <- purrr::map(orgs_names, function(org) {
        unname(repos_vec[which(names(repos_vec) == org)])
      })
      names(orgs_repo_list) <- orgs_names
      return(orgs_repo_list)
    },

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
          owners = names(private$orgs_repos),
          verbose = verbose
        ) |>
          purrr::keep(function(org) {
            type <- attr(org, "type") %||% "organization"
            type == "organization"
          })
      }
      total_orgs_names <- c(orgs_names, orgs_names_from_repos)
      orgs_table <- gitstats_map(total_orgs_names, function(org) {
        type <- attr(org, "type") %||% "organization"
        org <- url_decode(org)
        graphql_engine$get_org(
          org = org,
          verbose = verbose
        )
      }) |>
        graphql_engine$prepare_orgs_table()
      return(orgs_table)
    },

    get_all_repos = function(add_languages = TRUE, verbose = TRUE, progress = TRUE, fill_empty_sha = FALSE) {
      if (private$scan_all && is.null(private$orgs)) {
        private$orgs <- private$get_orgs_from_host(
          output = "only_names",
          verbose = verbose
        )
      }
      repos_table <- purrr::list_rbind(
        list(
          private$get_repos_from_orgs(add_languages, verbose, progress),
          private$get_repos_from_repos(add_languages, verbose, progress)
        )
      )
      return(repos_table)
    },

    get_repos_from_orgs = function(add_languages, verbose, progress) {
      if (any(c("all", "org") %in% private$searching_scope)) {
        graphql_engine <- private$engines$graphql
        gitstats_map(private$orgs, function(org) {
          owner_type <- attr(org, "type") %||% "organization"
          if (!private$scan_all && verbose) {
            show_message(
              host = private$host_name,
              engine = "graphql",
              scope = url_decode(org),
              information = paste0("Pulling repositories ", cli_icons$repo)
            )
          }
          repos_from_org <- graphql_engine$get_repos_from_org(
            org = url_decode(org),
            owner_type = owner_type,
            verbose = verbose
          )
          if (!inherits(repos_from_org, "graphql_error")) {
            if (length(repos_from_org) > 0) {
              repos_table <- repos_from_org |>
                graphql_engine$prepare_repos_table(
                  org = unclass(url_decode(org))
                ) |>
                dplyr::filter(organization == unclass(url_decode(org)))
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
                information = paste0("Pulling repositories ", cli_icons$repo)
              )
            }
            rest_engine <- private$engines$rest
            repos_table <- rest_engine$get_repos_from_org(
              org = org,
              add_languages = add_languages,
              output = "full_table",
              verbose = verbose
            ) |>
              rest_engine$prepare_repos_table(
                org = org
              )
          }
          return(repos_table)
        }, .progress = set_progress_bar(progress, private)) |>
          purrr::list_rbind()
      }
    },

    get_repos_from_repos = function(add_languages, verbose, progress) {
      if ("repo" %in% private$searching_scope) {
        graphql_engine <- private$engines$graphql
        orgs <- graphql_engine$set_owner_type(
          owners = names(private$orgs_repos),
          verbose = verbose
        )
        gitstats_map(orgs, function(org) {
          owner_type <- attr(org, "type") %||% "organization"
          if (!private$scan_all && verbose) {
            show_message(
              host = private$host_name,
              engine = "graphql",
              scope = set_repo_scope(url_decode(org), private),
              information = paste0("Pulling repositories ", cli_icons$repo)
            )
          }
          repos_from_org <- graphql_engine$get_repos_from_org(
            org = url_decode(org),
            owner_type = owner_type,
            verbose = verbose
          )
          if (!inherits(repos_from_org, "graphql_error")) {
            if (length(repos_from_org) > 0) {
              repos_table <- repos_from_org |>
                graphql_engine$prepare_repos_table() |>
                dplyr::filter(repo_name %in% private$orgs_repos[[url_decode(org)]])
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
                information = paste0("Pulling repositories ", cli_icons$repo)
              )
            }
            rest_engine <- private$engines$rest
            repos_table <- rest_engine$get_repos_from_org(
              org = org,
              repos = private$orgs_repos[[org]],
              add_languages = add_languages,
              output = "full_table",
              verbose = verbose
            ) |>
              rest_engine$prepare_repos_table(
                org = org
              )
          }
          return(repos_table)
        }, .progress = set_progress_bar(progress, private)) |>
          purrr::list_rbind()
      }
    },

    get_repos_with_code = function(code,
                                   in_files = NULL,
                                   in_path = FALSE,
                                   language = NULL,
                                   output = "table_full",
                                   verbose = TRUE,
                                   progress = TRUE) {
      if (private$scan_all) {
        repos_table <- private$get_repos_with_code_from_host(
          code = code,
          in_files = in_files,
          in_path = in_path,
          language = language,
          output = output,
          verbose = verbose
        )
      } else {
        repos_from_org <- private$get_repos_with_code_from_orgs(
          code = code,
          in_files = in_files,
          in_path = in_path,
          language = language,
          output = output,
          verbose = verbose,
          progress = progress
        )
        repos_from_repos <- private$get_repos_with_code_from_repos(
          code = code,
          in_files = in_files,
          in_path = in_path,
          language = language,
          output = output,
          verbose = verbose
        )
        repos_table <- rbind(repos_from_org, repos_from_repos)
      }
      return(repos_table)
    },

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
        repos_vector <- gitstats_map(private$orgs, function(org) {
          if (!private$scan_all && verbose) {
            show_message(
              host = private$host_name,
              engine = "rest",
              scope = url_decode(org),
              information = paste0("Pulling repositories ", cli_icons$repo, " (URLs)")
            )
          }
          repos_urls <- rest_engine$get_repos_urls(
            type = type,
            org = org,
            repos = NULL
          )
          return(repos_urls)
        }, .progress = set_progress_bar(progress, private)) |>
          unlist()
      }
    },

    get_repos_urls_from_repos = function(type, verbose, progress) {
      if ("repo" %in% private$searching_scope) {
        rest_engine <- private$engines$rest
        graphql_engine <- private$engines$graphql
        orgs <- graphql_engine$set_owner_type(
          owners = names(private$orgs_repos),
          verbose = verbose
        )
        repos_vector <- gitstats_map(orgs, function(org) {
          if (!private$scan_all && verbose) {
            show_message(
              host = private$host_name,
              engine = "rest",
              scope = paste0(org, "/", private$orgs_repos[[org]], collapse = ", "),
              information = paste0("Pulling repositories ", cli_icons$repo, " (URLs)")
            )
          }
          repos_urls <- rest_engine$get_repos_urls(
            type = type,
            org = org,
            repos = private$orgs_repos[[org]]
          )
          return(repos_urls)
        }, .progress = set_progress_bar(progress, private)) |>
          unlist()
      }
    },

    # Run a search function with optional in_files iteration, then parse the response.
    search_and_parse = function(search_fn, code, in_files, in_path, language,
                                output, verbose, org = NULL) {
      if (is.null(in_files)) {
        search_response <- search_fn(
          code = code,
          in_path = in_path,
          language = language,
          verbose = verbose
        )
      } else {
        search_response <- purrr::map(in_files, function(filename) {
          search_fn(
            code = code,
            filename = filename,
            in_path = in_path,
            language = language,
            verbose = verbose
          )
        }) |>
          purrr::list_flatten()
      }
      private$parse_search_response(
        search_response = search_response,
        org = org,
        output = output,
        verbose = verbose
      )
    },

    get_repos_with_code_from_host = function(code,
                                             in_files = NULL,
                                             in_path = FALSE,
                                             language = NULL,
                                             output = "table_full",
                                             verbose = TRUE) {
      if (verbose) {
        show_message(
          host = private$host_name,
          engine = "rest",
          information = paste0("Pulling repositories ", cli_icons$repo)
        )
      }
      rest_engine <- private$engines$rest
      search_fn <- function(...) rest_engine$search_for_code(...)
      repos_output <- private$search_and_parse(
        search_fn = search_fn,
        code = code, in_files = in_files, in_path = in_path,
        language = language, output = output, verbose = verbose
      )
      return(repos_output)
    },

    get_repos_with_code_from_orgs = function(code,
                                             in_files = NULL,
                                             in_path = FALSE,
                                             language = NULL,
                                             output = "table",
                                             verbose = TRUE,
                                             progress = TRUE) {
      if (any(private$searching_scope %in% c("org", "all"))) {
        repos_list <- gitstats_map(private$orgs, function(org) {
          if (verbose) {
            show_message(
              host = private$host_name,
              engine = "rest",
              scope = url_decode(org),
              code = code,
              information = paste0("Pulling repositories ", cli_icons$repo)
            )
          }
          rest_engine <- private$engines$rest
          search_fn <- function(...) rest_engine$search_for_code(org = org, ...)
          private$search_and_parse(
            search_fn = search_fn,
            code = code, in_files = in_files, in_path = in_path,
            language = language, output = output, verbose = verbose,
            org = org
          )
        }, .progress = set_progress_bar(progress, private))
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
                                              in_path = FALSE,
                                              language = NULL,
                                              output = "table_full",
                                              verbose = TRUE) {
      orgs <- names(private$orgs_repos)
      if ("repo" %in% private$searching_scope) {
        if (verbose) {
          show_message(
            host = private$host_name,
            engine = "rest",
            scope = url_decode(paste0(orgs, collapse = "|")),
            code = code,
            information = paste0("Pulling repositories ", cli_icons$repo)
          )
        }
        rest_engine <- private$engines$rest
        search_fn <- function(...) {
          rest_engine$search_repos_for_code(repos = private$repos_fullnames, ...)
        }
        repos_output <- private$search_and_parse(
          search_fn = search_fn,
          code = code, in_files = in_files, in_path = in_path,
          language = language, output = output, verbose = verbose
        )
        return(repos_output)
      }
    },

    parse_search_response = function(search_response, org = NULL, output, verbose = TRUE) {
      if (length(search_response) > 0) {
        repos_ids <- private$get_repos_ids(search_response)
        api_engine <- private$engines$graphql
        if (verbose) cli::cli_alert("Parsing search response with GraphQL...")
        repos_response <- api_engine$get_repos(
          repos_ids = repos_ids,
          verbose = verbose
        )
        if (output != "raw") {
          repos_output <- repos_response |>
            api_engine$prepare_repos_table(
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
          verbose = verbose,
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
          verbose = verbose,
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
          verbose = verbose,
          progress = progress
        )
    },

    add_githost_info = function(repos_table) {
      if (!is.null(repos_table) && nrow(repos_table) > 0) {
        dplyr::mutate(
          repos_table,
          githost = retrieve_githost(api_url)
        )
      }
    },

    get_repos_contributors = function(repos_table, verbose, progress) {
      if (!is.null(repos_table) && nrow(repos_table) > 0) {
        if (!private$scan_all && verbose) {
          show_message(
            host = private$host_name,
            engine = "rest",
            information = paste0("Pulling contributors ", cli_icons$user)
          )
        }
        repos_table <- private$filter_repos_by_host(repos_table)
        rest_engine <- private$engines$rest
        repos_table <- rest_engine$get_repos_contributors(
          repos_table = repos_table,
          verbose = verbose,
          progress = progress
        )
        return(repos_table)
      }
    },

    get_issues_from_orgs = function(verbose, progress) {
      if ("org" %in% private$searching_scope) {
        graphql_engine <- private$engines$graphql
        issues_table <- gitstats_map(private$orgs, function(org) {
          issues_table_org <- NULL
          repos_data <- private$get_repos_data(
            org = org,
            verbose = verbose
          )
          if (!private$scan_all && verbose) {
            show_message(
              host = private$host_name,
              engine = "graphql",
              scope = org,
              information = paste0("Getting issues ", cli_icons$issue)
            )
          }
          issues_table_org <- graphql_engine$get_issues_from_repos(
            org = org,
            repos_names = repos_data[["paths"]],
            verbose = verbose
          ) |>
            graphql_engine$prepare_issues_table(
              org = org
            )
          return(issues_table_org)
        }, .progress = set_progress_bar(progress, private)) |>
          purrr::list_rbind()
        return(issues_table)
      }
    },

    get_issues_from_repos = function(verbose, progress) {
      if ("repo" %in% private$searching_scope) {
        graphql_engine <- private$engines$graphql
        orgs <- graphql_engine$set_owner_type(
          owners = names(private$orgs_repos),
          verbose = verbose
        )
        issues_table <- gitstats_map(orgs, function(org) {
          issues_table_org <- NULL
          if (!private$scan_all && verbose) {
            show_message(
              host = private$host_name,
              engine = "graphql",
              scope = set_repo_scope(org, private),
              information = paste0("Getting issues ", cli_icons$issue)
            )
          }
          issues_table_org <- graphql_engine$get_issues_from_repos(
            org = org,
            repos_names = private$orgs_repos[[org]],
            verbose = verbose
          ) |>
            graphql_engine$prepare_issues_table(
              org = org
            )
          return(issues_table_org)
        }, .progress = set_progress_bar(progress, private)) |>
          purrr::list_rbind()
        return(issues_table)
      }
    },

    get_pr_from_orgs = function(verbose, progress) {
      if ("org" %in% private$searching_scope) {
        graphql_engine <- private$engines$graphql
        pr_table <- gitstats_map(private$orgs, function(org) {
          pr_table_org <- NULL
          repos_data <- private$get_repos_data(
            org = org,
            verbose = verbose
          )
          if (!private$scan_all && verbose) {
            show_message(
              host = private$host_name,
              engine = "graphql",
              scope = org,
              information = paste0("Pulling pull requests ", cli_icons$pull_request)
            )
          }
          pr_table_org <- graphql_engine$get_pr_from_repos(
            org = org,
            repos_names = repos_data[["paths"]],
            verbose = verbose
          ) |>
            graphql_engine$prepare_pr_table(
              org = org
            )
          return(pr_table_org)
        }, .progress = set_progress_bar(progress, private)) |>
          purrr::list_rbind()
        return(pr_table)
      }
    },

    get_pr_from_repos = function(verbose, progress) {
      if ("repo" %in% private$searching_scope) {
        graphql_engine <- private$engines$graphql
        orgs <- graphql_engine$set_owner_type(
          owners = names(private$orgs_repos),
          verbose = verbose
        )
        pr_table <- gitstats_map(orgs, function(org) {
          pr_table_org <- NULL
          if (!private$scan_all && verbose) {
            show_message(
              host = private$host_name,
              engine = "graphql",
              scope = set_repo_scope(org, private),
              information = paste0("Getting pull requests ", cli_icons$pull_request)
            )
          }
          pr_table_org <- graphql_engine$get_pr_from_repos(
            org = org,
            repos_names = private$orgs_repos[[org]],
            verbose = verbose
          ) |>
            graphql_engine$prepare_pr_table(
              org = org
            )
          return(pr_table_org)
        }, .progress = set_progress_bar(progress, private)) |>
          purrr::list_rbind()
        return(pr_table)
      }
    },

    get_files_content_from_orgs = function(file_path,
                                           verbose = TRUE,
                                           progress = TRUE) {
      if ("org" %in% private$searching_scope) {
        graphql_engine <- private$engines$graphql
        files_table <- gitstats_map(private$orgs, function(org) {
          owner_type <- attr(org, "type") %||% "organization"
          repos_data <- private$get_repos_data(
            org = org,
            verbose = verbose
          )
          if (verbose) {
            show_message(
              host = private$host_name,
              engine = "graphql",
              scope = org,
              information = glue::glue("Pulling files {cli_icons$file} content: [{paste0(file_path, collapse = ', ')}]")
            )
          }
          graphql_engine$get_files_from_org(
            org = org,
            owner_type = owner_type,
            repos_data = repos_data,
            file_paths = file_path,
            verbose = verbose
          ) |>
            graphql_engine$prepare_files_table(
              org = org
            )
        }, .progress = set_progress_bar(progress, private)) |>
          purrr::list_rbind() |>
          private$add_repo_api_url()
        return(files_table)
      }
    },

    get_files_structure_from_orgs = function(pattern,
                                             depth,
                                             verbose  = TRUE,
                                             progress = TRUE) {
      if (any(c("all", "org") %in% private$searching_scope)) {
        rest_engine <- private$engines$rest
        files_structure_list <- gitstats_map(private$orgs, function(org) {
          repos_data <- private$get_repos_data(
            org = org,
            verbose = verbose
          )
          if (verbose) {
            user_info <- if (!is.null(pattern)) {
              glue::glue(
                "Pulling repos {cli_icons$tree} [files matching pattern: '{paste0(pattern, collapse = '|')}']"
              )
            } else {
              glue::glue("Pulling repos {cli_icons$tree}")
            }
            show_message(
              host = private$host_name,
              engine = "rest",
              scope = org,
              information = user_info
            )
          }
          private$get_files_structure_from_repos_data(
            rest_engine = rest_engine,
            org = org,
            repos_data = repos_data,
            pattern = pattern,
            depth = depth,
            verbose = verbose
          )
        }, .progress = set_progress_bar(progress, private))
        names(files_structure_list) <- private$orgs
        files_structure_list <- files_structure_list |>
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

    get_files_structure_from_repos_data = function(rest_engine,
                                                   org,
                                                   repos_data,
                                                   pattern,
                                                   depth,
                                                   verbose) {
      repositories <- repos_data[["paths"]]
      def_branches <- repos_data[["def_branches"]]
      repo_ids <- repos_data[["repo_ids"]]
      if (!is.null(def_branches)) {
        files_structure <- gitstats_map2(repositories, def_branches,
          function(repo, def_branch) {
            rest_engine$get_files_tree(
              org = org,
              repo = repo,
              def_branch = def_branch,
              pattern = pattern,
              depth = depth,
              verbose = verbose
            )
          }
        )
      } else {
        files_structure <- gitstats_map(repositories,
          function(repo) {
            rest_engine$get_files_tree(
              org = org,
              repo = repo,
              pattern = pattern,
              depth = depth,
              verbose = verbose
            )
          }
        )
      }
      names(files_structure) <- repositories
      if (!is.null(repo_ids)) {
        for (i in seq_along(files_structure)) {
          if (!is.null(files_structure[[i]])) {
            attr(files_structure[[i]], "repo_id") <- repo_ids[[i]]
          }
        }
      }
      files_structure <- purrr::discard(files_structure, ~ length(.) == 0)
      return(files_structure)
    },

    get_files_content_from_host = function(file_path,
                                           verbose  = TRUE,
                                           progress = TRUE) {
      rest_engine <- private$engines$rest
      if (verbose) {
        show_message(
          host = private$host_name,
          engine = "rest",
          information = glue::glue("Pulling files {cli_icons$file}: [{paste0(file_path, collapse = ', ')}]")
        )
      }
      files_table <- rest_engine$get_files(
        file_paths = file_path,
        verbose = verbose
      ) |>
        rest_engine$prepare_files_table() |>
        private$add_repo_api_url()
      return(files_table)
    },

    get_release_logs_from_orgs = function(verbose, progress) {
      if ("org" %in% private$searching_scope) {
        release_logs_table <- gitstats_map(private$orgs, function(org) {
          org <- url_decode(org)
          release_logs_table_org <- NULL
          repos_data <- private$get_repos_data(
            org = org,
            verbose = verbose
          )
          if (!private$scan_all && verbose) {
            show_message(
              host = private$host_name,
              engine = "graphql",
              scope = org,
              information = paste0("Pulling release logs ", cli_icons$release)
            )
          }
          graphql_engine <- private$engines$graphql
          if (length(repos_data[["paths"]]) > 0) {
            release_logs_table_org <- graphql_engine$get_release_logs_from_org(
              repos_names = repos_data[["paths"]],
              org = org,
              verbose = verbose
            ) |>
              graphql_engine$prepare_releases_table(
                org = org
              )
          } else {
            releases_logs_table_org <- NULL
          }
          return(release_logs_table_org)
        }, .progress = set_progress_bar(progress, private)) |>
          purrr::list_rbind()
        return(release_logs_table)
      }
    },

    get_release_logs_from_repos = function(verbose, progress) {
      if ("repo" %in% private$searching_scope) {
        graphql_engine <- private$engines$graphql
        orgs <- graphql_engine$set_owner_type(
          owners = names(private$orgs_repos),
          verbose = verbose
        )
        release_logs_table <- gitstats_map(orgs, function(org) {
          org <- url_decode(org)
          release_logs_table_org <- NULL
          if (!private$scan_all && verbose) {
            show_message(
              host = private$host_name,
              engine = "graphql",
              scope = set_repo_scope(org, private),
              information = paste0("Pulling release logs ", cli_icons$release)
            )
          }
          release_logs_table_org <- graphql_engine$get_release_logs_from_org(
            repos_names = private$orgs_repos[[org]],
            org = org,
            verbose = verbose
          ) |>
            graphql_engine$prepare_releases_table(
              org = org
            )
          return(release_logs_table_org)
        }, .progress = set_progress_bar(progress, private)) |>
          purrr::list_rbind()
        return(release_logs_table)
      }
    },

    filter_repos_table_by_language = function(repos_table, language_filter) {
      if (!is.null(repos_table)) {
        repos_table |>
          dplyr::filter(grepl(paste0("\\b", language_filter, "\\b"), languages))
      }
    }
  )
)
