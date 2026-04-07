GitHostBitBucket <- R6::R6Class(
  classname = "GitHostBitBucket",
  inherit = GitHost,
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
      if (verbose) {
        cli::cli_alert_success("Set connection to BitBucket.")
      }
    },

    # BitBucket has no GraphQL, so users endpoint is not supported yet
    get_users = function(users) {
      cli::cli_abort(
        "{.fun get_users} is not yet supported for BitBucket.",
        call = NULL
      )
    }
  ),
  private = list(

    host_name = "BitBucket",
    api_version = "2.0",
    token_name = "BITBUCKET_PAT",
    min_access_scopes = c("repository"),

    access_scopes = list(
      repo = c("repository", "repository:write"),
      workspace = c("workspace")
    ),

    engine_methods = list(
      "rest" = list(
        "repos",
        "commits",
        "code",
        "contributors"
      )
    ),

    set_api_url = function(host) {
      if (is.null(host) ||
            host == "https://bitbucket.org" ||
            host == "http://bitbucket.org" ||
            host == "bitbucket.org") {
        private$api_url <- "https://api.bitbucket.org/2.0"
      } else {
        private$set_custom_api_url(host)
      }
    },

    set_web_url = function(host) {
      if (is.null(host)) {
        private$web_url <- "https://bitbucket.org"
      } else {
        private$set_custom_web_url(host)
      }
    },

    check_if_public = function(host) {
      private$is_public <- is.null(host) || grepl("bitbucket.org", host)
    },

    set_test_endpoint = function() {
      private$test_endpoint <- paste0(private$api_url, "/user")
    },

    set_tokens_endpoint = function() {
      private$endpoints$tokens <- NULL
    },

    set_orgs_endpoint = function() {
      private$endpoints$orgs <- paste0(private$api_url, "/workspaces")
    },

    set_repositories_endpoint = function() {
      private$endpoints$repositories <- paste0(private$api_url, "/repositories")
    },

    # No GraphQL for BitBucket
    set_graphql_url = function() {
      private$graphql_api_url <- NULL
    },

    setup_engines = function() {
      private$engines$rest <- EngineRestBitBucket$new(
        rest_api_url = private$api_url,
        token = private$token,
        scan_all = private$scan_all
      )
      # No GraphQL engine for BitBucket
      private$engines$graphql <- NULL
    },

    check_token_scopes = function(response, token = NULL) {
      # BitBucket Cloud does not return scope headers in the same way.
      # If the request succeeded (200), the token is valid.
      response$status_code == 200
    },

    add_repo_api_url = function(repos_table) {
      if (!is.null(repos_table) && nrow(repos_table) > 0) {
        repos_table <- dplyr::mutate(
          repos_table,
          api_url = paste0(private$endpoints$repositories, "/", organization, "/", repo_name)
        )
      }
      return(repos_table)
    },

    # BitBucket workspaces as orgs
    get_orgs_from_host = function(output, verbose) {
      if (private$is_public) {
        cli::cli_abort("This feature is not applicable for public hosts.",
                       call = NULL)
      }
      rest_engine <- private$engines$rest
      workspaces <- private$get_workspaces(verbose = verbose)
      if (output == "only_names") {
        return(purrr::map_chr(workspaces, ~ .$slug))
      }
      orgs_table <- purrr::map(workspaces, function(ws) {
        data.frame(
          name = ws$name %||% NA_character_,
          description = NA_character_,
          path = ws$slug,
          url = ws$links$html$href %||% NA_character_,
          avatar_url = ws$links$avatar$href %||% NA_character_,
          repos_count = NA_integer_,
          members_count = NA_integer_
        )
      }) |>
        purrr::list_rbind()
      private$orgs <- purrr::map_chr(workspaces, ~ .$slug)
      return(orgs_table)
    },

    get_workspaces = function(verbose) {
      rest_engine <- private$engines$rest
      endpoint <- paste0(private$api_url, "/workspaces?pagelen=100")
      all_workspaces <- list()
      repeat {
        response <- rest_engine$response(
          endpoint = endpoint,
          verbose = verbose
        )
        if (inherits(response, "rest_error")) break
        values <- response$values %||% list()
        all_workspaces <- append(all_workspaces, values)
        next_url <- response$`next`
        if (is.null(next_url)) break
        endpoint <- next_url
      }
      return(all_workspaces)
    },

    # Override to check orgs/repos via REST (no GraphQL)
    check_organizations = function(orgs, verbose, .error) {
      if (verbose) {
        cli::cli_alert(cli::col_grey("Checking owners..."))
      }
      rest_engine <- private$engines$rest
      orgs <- purrr::map(orgs, function(org) {
        endpoint <- paste0(private$api_url, "/workspaces/", org)
        response <- rest_engine$perform_request(
          endpoint = endpoint,
          token = private$token,
          verbose = FALSE
        )
        if (response$status_code == 404) {
          if (.error) {
            cli::cli_abort(
              c(
                "x" = "Workspace you provided does not exist or its name was passed
                in a wrong way: {cli::col_red({org})}",
                "!" = "Please type your workspace name as you see it in the web URL."
              ),
              call = NULL
            )
          } else {
            if (verbose) {
              cli::cli_alert_warning(
                cli::col_yellow(
                  "Workspace you provided does not exist: {cli::col_red({org})}"
                )
              )
            }
            org <- NULL
          }
        } else {
          # Tag as organization type for consistency with the base class
          attr(org, "type") <- "organization"
        }
        return(org)
      }) |>
        purrr::keep(~ length(.) > 0)
      if (length(orgs) == 0) {
        return(NULL)
      }
      orgs
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

    # Override repos retrieval to use REST only
    get_repos_from_orgs = function(add_languages, verbose, progress) {
      if (any(c("all", "org") %in% private$searching_scope)) {
        rest_engine <- private$engines$rest
        gitstats_map(private$orgs, function(org) {
          org_name <- if (is.character(org)) org else unclass(org)
          if (!private$scan_all && verbose) {
            show_message(
              host = private$host_name,
              engine = "rest",
              scope = org_name,
              information = paste0("Pulling repositories ", cli_icons$repo)
            )
          }
          repos_from_org <- rest_engine$get_repos_from_org(
            org = org_name,
            verbose = verbose
          )
          if (length(repos_from_org) > 0) {
            repos_table <- rest_engine$prepare_repos_table(
              repos_list = repos_from_org,
              org = org_name
            )
          } else {
            repos_table <- NULL
          }
          return(repos_table)
        }, .progress = set_progress_bar(progress, private)) |>
          purrr::list_rbind()
      }
    },

    get_repos_from_repos = function(add_languages, verbose, progress) {
      if ("repo" %in% private$searching_scope) {
        rest_engine <- private$engines$rest
        orgs <- names(private$orgs_repos)
        gitstats_map(orgs, function(org) {
          if (!private$scan_all && verbose) {
            show_message(
              host = private$host_name,
              engine = "rest",
              scope = set_repo_scope(org, private),
              information = paste0("Pulling repositories ", cli_icons$repo)
            )
          }
          repos_from_org <- rest_engine$get_repos_from_org(
            org = org,
            repos = private$orgs_repos[[org]],
            verbose = verbose
          )
          if (length(repos_from_org) > 0) {
            repos_table <- rest_engine$prepare_repos_table(
              repos_list = repos_from_org,
              org = org
            )
          } else {
            repos_table <- NULL
          }
          return(repos_table)
        }, .progress = set_progress_bar(progress, private)) |>
          purrr::list_rbind()
      }
    },

    get_repos_ids = function(search_response) {
      purrr::map_vec(search_response, ~ .$uuid) |> unique()
    },

    get_repo_url_from_response = function(search_response,
                                          repos_fullnames = NULL,
                                          type,
                                          verbose = TRUE,
                                          progress = TRUE) {
      if (!is.null(repos_fullnames)) {
        search_response <- search_response |>
          purrr::keep(~ .$full_name %in% repos_fullnames)
      }
      purrr::map_vec(search_response, function(project) {
        if (type == "api") {
          project$links$self$href
        } else {
          project$links$html$href
        }
      })
    },

    # Override commits retrieval to use REST
    get_commits_from_orgs = function(since, until, verbose, progress) {
      if ("org" %in% private$searching_scope) {
        rest_engine <- private$engines$rest
        commits_table <- gitstats_map(private$orgs, function(org) {
          org_name <- if (is.character(org)) org else unclass(org)
          repos_data <- private$get_repos_data(
            org = org_name,
            verbose = verbose
          )
          if (!private$scan_all && verbose) {
            show_message(
              host = private$host_name,
              engine = "rest",
              scope = org_name,
              information = paste0("Pulling commits ", cli_icons$commit)
            )
          }
          repos_fullnames <- purrr::map_chr(
            repos_data[["paths"]], ~ paste0(org_name, "/", .)
          )
          commits_from_repos <- rest_engine$get_commits_from_repos(
            repos_fullnames = repos_fullnames,
            since = since,
            until = until,
            verbose = verbose
          )
          if (length(commits_from_repos) > 0) {
            commits_from_repos |>
              rest_engine$tailor_commits_info(org = org_name) |>
              rest_engine$prepare_commits_table()
          } else {
            NULL
          }
        }, .progress = set_progress_bar(progress, private)) |>
          purrr::list_rbind()
        return(commits_table)
      }
    },

    get_commits_from_repos = function(since, until, verbose, progress) {
      if ("repo" %in% private$searching_scope) {
        rest_engine <- private$engines$rest
        orgs <- names(private$orgs_repos)
        commits_table <- gitstats_map(orgs, function(org) {
          if (!private$scan_all && verbose) {
            show_message(
              host = private$host_name,
              engine = "rest",
              scope = set_repo_scope(org, private),
              information = paste0("Pulling commits ", cli_icons$commit)
            )
          }
          repos_fullnames <- paste0(org, "/", private$orgs_repos[[org]])
          commits_from_repos <- rest_engine$get_commits_from_repos(
            repos_fullnames = repos_fullnames,
            since = since,
            until = until,
            verbose = verbose
          )
          if (length(commits_from_repos) > 0) {
            commits_from_repos |>
              rest_engine$tailor_commits_info(org = org) |>
              rest_engine$prepare_commits_table()
          } else {
            NULL
          }
        }, .progress = set_progress_bar(progress, private)) |>
          purrr::list_rbind()
        return(commits_table)
      }
    },

    # Repos data cache — REST-only version (no GraphQL)
    get_repos_data = function(org, repos = NULL, verbose) {
      cached_repos <- private$get_cached_repos(org)
      if (is.null(cached_repos)) {
        if (verbose) cli::cli_alert("[{org}] Pulling repositories {cli_icons$repo} data...")
        rest_engine <- private$engines$rest
        repos_from_org <- rest_engine$get_repos_from_org(
          org = org,
          verbose = verbose
        )
        private$set_cached_repos(repos_from_org, org, verbose)
      } else {
        if (verbose) cli::cli_alert("[{org}] Using cached repositories data...")
        repos_from_org <- cached_repos
      }
      if (!is.null(repos)) {
        repos_from_org <- repos_from_org |>
          purrr::keep(~ .$slug %in% repos)
      }
      repos_data <- list(
        "paths" = purrr::map_chr(repos_from_org, ~ .$slug),
        "def_branches" = purrr::map_chr(repos_from_org, ~ .$mainbranch$name %||% ""),
        "repo_ids" = purrr::map_chr(repos_from_org, ~ .$uuid %||% NA_character_)
      )
      return(repos_data)
    },

    # Override repos URL retrieval to avoid GraphQL
    get_repos_urls_from_repos = function(type, verbose, progress) {
      if ("repo" %in% private$searching_scope) {
        rest_engine <- private$engines$rest
        orgs <- names(private$orgs_repos)
        repos_vector <- gitstats_map(orgs, function(org) {
          if (!private$scan_all && verbose) {
            show_message(
              host = private$host_name,
              engine = "rest",
              scope = paste0(org, "/", private$orgs_repos[[org]], collapse = ", "),
              information = paste0("Pulling repositories ", cli_icons$repo, " (URLs)")
            )
          }
          rest_engine$get_repos_urls(
            type = type,
            org = org,
            repos = private$orgs_repos[[org]]
          )
        }, .progress = set_progress_bar(progress, private)) |>
          unlist()
      }
    },

    # Override file structure retrieval for repos scope (no GraphQL)
    get_files_structure_from_repos = function(pattern,
                                              depth,
                                              verbose  = TRUE,
                                              progress = TRUE) {
      if ("repo" %in% private$searching_scope) {
        rest_engine <- private$engines$rest
        orgs <- names(private$orgs_repos)
        files_structure_list <- gitstats_map(orgs, function(org) {
          repos_data <- private$get_repos_data(
            org = org,
            repos = private$orgs_repos[[org]],
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
              scope = set_repo_scope(org, private),
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
        names(files_structure_list) <- orgs
        files_structure_list <- files_structure_list |>
          purrr::discard(~ length(.) == 0)
        if (length(files_structure_list) == 0 && verbose) {
          cli::cli_alert_warning(
            cli::col_yellow(
              "For {private$host_name} no files {cli_icons$tree} structure found."
            )
          )
        }
        return(files_structure_list)
      }
    },

    # Not yet supported methods — raise informative errors
    get_issues_from_orgs = function(verbose, progress) {
      cli::cli_abort(
        "{.fun get_issues} is not yet supported for BitBucket.",
        call = NULL
      )
    },

    get_issues_from_repos = function(verbose, progress) {
      cli::cli_abort(
        "{.fun get_issues} is not yet supported for BitBucket.",
        call = NULL
      )
    },

    get_pr_from_orgs = function(verbose, progress) {
      cli::cli_abort(
        "{.fun get_pull_requests} is not yet supported for BitBucket.",
        call = NULL
      )
    },

    get_pr_from_repos = function(verbose, progress) {
      cli::cli_abort(
        "{.fun get_pull_requests} is not yet supported for BitBucket.",
        call = NULL
      )
    },

    get_release_logs_from_orgs = function(verbose, progress) {
      cli::cli_abort(
        "{.fun get_release_logs} is not yet supported for BitBucket.",
        call = NULL
      )
    },

    get_release_logs_from_repos = function(verbose, progress) {
      cli::cli_abort(
        "{.fun get_release_logs} is not yet supported for BitBucket.",
        call = NULL
      )
    },

    get_files_content_from_orgs = function(file_path, verbose, progress) {
      cli::cli_abort(
        "{.fun get_files} content retrieval is not yet supported for BitBucket.",
        call = NULL
      )
    },

    get_files_content_from_repos = function(file_path, verbose, progress) {
      cli::cli_abort(
        "{.fun get_files} content retrieval is not yet supported for BitBucket.",
        call = NULL
      )
    },

    get_files_content_from_files_structure = function(files_structure, verbose, progress) {
      cli::cli_abort(
        "{.fun get_files} content retrieval is not yet supported for BitBucket.",
        call = NULL
      )
    },

    # Code search is not supported on BitBucket Cloud REST API in the same way
    parse_search_response = function(search_response, org = NULL, output, verbose = TRUE) {
      cli::cli_abort(
        "Code search via {.arg with_code} is not yet supported for BitBucket.",
        call = NULL
      )
    },

    set_repo_url = function(repo_fullname) {
      paste0(private$endpoints$repositories, "/", repo_fullname)
    }
  )
)
