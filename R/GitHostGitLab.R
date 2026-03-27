GitHostGitLab <- R6::R6Class("GitHostGitLab",
  inherit = GitHost,
  public = list(
    initialize = function(orgs = NA,
                          repos = NA,
                          token = NA,
                          host = NA,
                          verbose = NA,
                          .error = TRUE) {
      repos <- if (!is.null(repos)) {
        url_encode(repos)
      }
      orgs <- if (!is.null(orgs)) {
        url_encode(orgs)
      }
      super$initialize(orgs = orgs,
                       repos = repos,
                       token = token,
                       host = host,
                       verbose = verbose,
                       .error = .error)
      if (verbose) {
        cli::cli_alert_success("Set connection to GitLab.")
      }
    }
  ),
  private = list(

    host_name = "GitLab",
    api_version = 4,
    token_name = "GITLAB_PAT",
    min_access_scopes = c("read_api"),
    access_scopes = c("api", "read_api"),

    engine_methods = list(
      "graphql" = list(
        "repos",
        "release_logs"
      ),
      "rest" = list(
        "code",
        "commits",
        "contributors"
      )
    ),

    set_api_url = function(host) {
      if (is.null(host)) {
        private$api_url <- glue::glue(
          "https://gitlab.com/api/v{private$api_version}"
        )
      } else {
        private$set_custom_api_url(host)
      }
    },

    set_web_url = function(host) {
      if (is.null(host)) {
        private$web_url <- glue::glue(
          "https://gitlab.com"
        )
      } else {
        private$set_custom_web_url(host)
      }
    },

    check_if_public = function(host) {
      private$is_public <- is.null(host) || grepl("gitlab.com", host)
    },

    set_test_endpoint = function() {
      private$test_endpoint <- glue::glue("{private$api_url}/projects")
    },

    set_tokens_endpoint = function() {
      private$endpoints$tokens <- glue::glue("{private$api_url}/personal_access_tokens")
    },

    set_orgs_endpoint = function() {
      private$endpoints$orgs <- glue::glue("{private$api_url}/groups")
      private$endpoints$users <- glue::glue("{private$api_url}/users?username=")
    },

    set_repositories_endpoint = function() {
      private$endpoints$repositories <- glue::glue("{private$api_url}/projects")
    },

    setup_engines = function() {
      private$engines$rest <- EngineRestGitLab$new(
        rest_api_url = private$api_url,
        token = private$token,
        scan_all = private$scan_all
      )
      private$engines$graphql <- EngineGraphQLGitLab$new(
        gql_api_url = private$graphql_api_url,
        token = private$token,
        scan_all = private$scan_all
      )
    },

    check_token_scopes = function(response = NULL, token) {
      TRUE
    },

    add_repo_api_url = function(repos_table) {
      if (!is.null(repos_table) && nrow(repos_table) > 0) {
        repos_table <- dplyr::mutate(
          repos_table,
          api_url = paste0(private$endpoints$repositories,
                           "/",
                           stringr::str_match(repo_id, "[0-9].*"))
        )
      }
      return(repos_table)
    },

    get_orgs_from_host = function(output, verbose) {
      if (private$is_public) {
        cli::cli_abort("This feature is not applicable for public hosts.",
                       call = NULL)
      }
      rest_engine <- private$engines$rest
      orgs_count <- rest_engine$get_orgs_count(verbose)
      if (verbose) {
        cli::cli_alert_info("{orgs_count} organizations found.")
      }
      graphql_engine <- private$engines$graphql
      orgs <- graphql_engine$get_orgs(
        orgs_count = as.integer(orgs_count),
        output = output,
        verbose = verbose
      )
      if (inherits(orgs, "graphql_error")) {
        if (verbose) {
          cli::cli_alert_info("Switching to REST API")
        }
        orgs <- rest_engine$get_orgs(
          orgs_count = as.integer(orgs_count),
          verbose = verbose
        )
        if (output == "full_table") {
          orgs <- orgs |>
            rest_engine$prepare_orgs_table()
          private$orgs <- dplyr::pull(orgs, path)
        } else {
          orgs <- purrr::map_vec(orgs, ~.$full_path)
          private$orgs <- orgs
        }
      } else {
        if (output == "full_table") {
          orgs <- orgs |>
            graphql_engine$prepare_orgs_table()
          private$orgs <- dplyr::pull(orgs, path)
        } else {
          private$orgs <- orgs
        }
      }
      return(orgs)
    },

    get_orgs_from_orgs_and_repos = function(output, verbose) {
      graphql_engine <- private$engines$graphql
      default_engine <- graphql_engine
      rest_engine <- private$engines$rest
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
      orgs_list <- purrr::map(total_orgs_names, function(org) {
        type <- attr(org, "type") %||% "organization"
        org_response <- graphql_engine$get_org(
          org = url_decode(org),
          verbose = verbose
        )
        if (inherits(org_response, "graphql_error")) {
          if (verbose) {
            cli::cli_alert_info("Switching to REST API")
          }
          org_response <- rest_engine$get_org(
            org = url_encode(org),
            verbose = verbose
          )
          default_engine <<- rest_engine
        }
        return(org_response)
      })
      orgs_table <- default_engine$prepare_orgs_table(orgs_list)
      return(orgs_table)
    },

    get_repos_ids = function(search_response) {
      purrr::map_vec(search_response, ~.$project_id) |> unique()
    },

    get_repo_url_from_response = function(search_response,
                                          type,
                                          repos_fullnames = NULL,
                                          verbose = TRUE,
                                          progress = TRUE) {
      repo_urls <- purrr::map_vec(search_response, function(response) {
        api_url <- paste0(private$api_url, "/projects/", gsub("gid://gitlab/Project/", "", response$node$repo_id))
        if (type == "api") {
          return(api_url)
        } else {
          rest_engine <- private$engines$rest
          project_response <- rest_engine$response(
            endpoint = api_url,
            verbose = verbose
          )
          web_url <- project_response$web_url
          return(web_url)
        }
      }, .progress = if (progress && type != "api") {
        "Mapping api URL to web URL..."
      } else {
        FALSE
      })
      return(repo_urls)
    },

    get_commits_from_orgs = function(since,
                                     until,
                                     verbose,
                                     progress) {
      if ("org" %in% private$searching_scope) {
        rest_engine <- private$engines$rest
        commits_table <- gitstats_map(private$orgs, function(org) {
          commits_table_org <- NULL
          repos_data <- private$get_repos_data(
            org = org,
            verbose = verbose
          )
          if (!private$scan_all && verbose) {
            show_message(
              host = private$host_name,
              engine = "rest",
              scope = url_decode(org),
              information = paste0("Pulling commits ", cli_icons$commit)
            )
          }
          full_repos_encoded <- paste0(
            url_encode(org),
            "%2f",
            repos_data[["paths"]]
          )
          commits_table_org <- rest_engine$get_commits_from_repos(
            full_repos_names = full_repos_encoded,
            since = since,
            until = until,
            verbose = verbose
          ) |>
            rest_engine$tailor_commits_info(org = org) |>
            rest_engine$prepare_commits_table() |>
            rest_engine$get_commits_authors_handles_and_names(
              verbose = verbose
            )
          return(commits_table_org)
        }, .progress = set_progress_bar(progress, private)) |>
          purrr::list_rbind()
        return(commits_table)
      }
    },

    get_commits_from_repos = function(since,
                                      until,
                                      verbose,
                                      progress) {
      if ("repo" %in% private$searching_scope) {
        rest_engine <- private$engines$rest
        graphql_engine <- private$engines$graphql
        orgs <- graphql_engine$set_owner_type(
          owners = names(private$orgs_repos),
          verbose = verbose
        )
        commits_table <- gitstats_map(orgs, function(org) {
          commits_table_org <- NULL
          repos <- private$orgs_repos[[org]]
          full_repos_names <- paste0(url_encode(org), "%2f", repos)
          if (!private$scan_all && verbose) {
            show_message(
              host = private$host_name,
              engine = "rest",
              scope = set_repo_scope(org, private),
              information = paste0("Pulling commits ", cli_icons$commit)
            )
          }
          commits_table_org <- rest_engine$get_commits_from_repos(
            full_repos_names = full_repos_names,
            since = since,
            until = until,
            verbose = verbose
          ) |>
            rest_engine$tailor_commits_info(org = org) |>
            rest_engine$prepare_commits_table() |>
            rest_engine$get_commits_authors_handles_and_names(
              verbose = verbose
            )
          return(commits_table_org)
        }, .progress = set_progress_bar(progress, private)) |>
          purrr::list_rbind()
        return(commits_table)
      }
    },

    get_repos_data = function(org, repos = NULL, verbose) {
      cached_repos <- private$get_cached_repos(org)
      if (is.null(cached_repos)) {
        if (verbose) cli::cli_alert("[{org}] Pulling repositories {cli_icons$repo} data...")
        graphql_engine <- private$engines$graphql
        owner_type <- attr(org, "type") %||% "organization"
        repos_from_org <- graphql_engine$get_repos_from_org(
          org = url_decode(org),
          owner_type = owner_type,
          verbose = verbose
        )
        engine_used <- graphql_engine
        if (inherits(repos_from_org, "graphql_error")) {
          if (verbose) {
            cli::cli_alert_info("Switching to REST API...")
          }
          rest_engine <- private$engines$rest
          repos_from_org <- rest_engine$get_repos_from_org(
            org = url_encode(org),
            output = "raw",
            verbose = verbose
          )
          engine_used <- rest_engine
        } else {
          repos_from_org <- purrr::map(repos_from_org, function(repos_data) {
            repos_data$path <- repos_data$node$repo_path
            repos_data
          })
        }
        private$set_cached_repos(repos_from_org, org, verbose)
        tryCatch(
          private$save_repos_to_storage(
            repos_from_org, org, engine_used
          ),
          error = function(e) NULL
        )
      } else {
        if (verbose) cli::cli_alert("Using cached repositories data...")
        repos_from_org <- cached_repos
      }
      if (!is.null(repos)) {
        repos_from_org <- purrr::keep(repos_from_org, ~ .$path %in% repos)
      }
      repos_names <- repos_from_org |>
        purrr::map_vec(~ .$path)
      repo_ids <- purrr::map_chr(repos_from_org, function(repo) {
        if (!is.null(repo$node$repo_id)) {
          get_gitlab_repo_id(repo$node$repo_id)
        } else {
          as.character(repo$id)
        }
      })
      repos_data <- list(
        "paths" = repos_names,
        "repo_ids" = repo_ids
      )
      return(repos_data)
    },

    save_repos_to_storage = function(repos_from_org, org, engine) {
      storage <- private$storage_backend
      if (!is.null(storage) && storage$is_db()) {
        repos_table <- engine$prepare_repos_table(repos_from_org, org)
        if (!is.null(repos_table) && nrow(repos_table) > 0) {
          repos_table <- dplyr::as_tibble(repos_table)
          existing <- storage$load("repositories")
          if (!is.null(existing)) {
            repos_table <- dplyr::bind_rows(existing, repos_table) |>
              dplyr::distinct(repo_id, .keep_all = TRUE)
          }
          class(repos_table) <- c("gitstats_repos", class(repos_table))
          storage$save("repositories", repos_table)
        }
      }
    },

    are_non_text_files = function(file_path, host_files_structure) {
      if (!is.null(file_path)) {
        any(grepl(non_text_files_pattern, file_path))
      } else if (!is.null(host_files_structure)) {
        any(grepl(non_text_files_pattern, unlist(host_files_structure, use.names = FALSE)))
      } else {
        FALSE
      }
    },

    get_files_structure_from_repos = function(pattern,
                                              depth,
                                              verbose  = TRUE,
                                              progress = TRUE) {
      if ("repo" %in% private$searching_scope) {
        rest_engine <- private$engines$rest
        graphql_engine <- private$engines$graphql
        orgs <- graphql_engine$set_owner_type(
          owners = names(private$orgs_repos),
          verbose = verbose
        )
        files_structure_list <- gitstats_map(orgs, function(org) {
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
            repos_data = list("paths" = private$orgs_repos[[org]]),
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

    get_files_content_from_repos = function(file_path,
                                            verbose = TRUE,
                                            progress = TRUE) {
      if ("repo" %in% private$searching_scope) {
        graphql_engine <- private$engines$graphql
        orgs <- graphql_engine$set_owner_type(
          owners = names(private$orgs_repos),
          verbose = verbose
        )
        files_table <- gitstats_map(orgs, function(org) {
          if (verbose) {
            show_message(
              host = private$host_name,
              engine = "graphql",
              scope = set_repo_scope(org, private),
              information = glue::glue("Pulling files {cli_icons$file} content: [{paste0(file_path, collapse = ', ')}]")
            )
          }
          owner_type <- attr(org, "type") %||% "organization"
          graphql_engine$get_files_from_org_per_repo(
            org = org,
            owner_type = owner_type,
            repos_data = list("paths" = private$orgs_repos[[org]]),
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

    get_files_content_from_files_structure = function(files_structure,
                                                      verbose = TRUE,
                                                      progress = TRUE) {
      if (length(files_structure) > 0) {
        graphql_engine <- private$engines$graphql
        result <- private$get_orgs_and_repos_from_files_structure(
          files_structure = files_structure
        )
        orgs <- result$orgs
        repos <- result$repos
        files_table <- gitstats_map(orgs, function(org) {
          if (verbose) {
            show_message(
              host = private$host_name,
              engine = "graphql",
              scope = org,
              information = paste0("Pulling files ", cli_icons$file, " from files structure")
            )
          }
          owner_type <- attr(org, "type") %||% "organization"
          graphql_engine$get_files_from_org_per_repo(
            org = org,
            owner_type = owner_type,
            repos_data = list("paths" = repos),
            host_files_structure = files_structure,
            verbose = verbose
          ) |>
            graphql_engine$prepare_files_table(
              org = org
            )
        }, .progress = set_progress_bar(progress, private)) |>
          purrr::list_rbind() |>
          private$add_repo_api_url()
        return(files_table)
      } else {
        cli::cli_alert_warning("[GitLab] No files {cli_icons$file} found. Skipping pulling files content.")
        return(NULL)
      }
    }
  )
)
