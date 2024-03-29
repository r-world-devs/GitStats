#' @noRd
#' @importFrom R6 R6Class
#' @importFrom rlang expr
#' @importFrom cli cli_alert_danger cli_alert_success
#' @importFrom purrr keep

#' @title A GitHost superclass

GitHost <- R6::R6Class("GitHost",
  public = list(

    #' @description Create a new `GitHost` object.
    #' @param orgs A character vector of organisations (owners of repositories
    #'   in case of GitHub and groups of projects in case of GitLab).
    #' @param repos A character vector of repositories.
    #' @param token A token.
    #' @param api_url An API URL.
    #' @return A new `GitHost` object.
    initialize = function(orgs = NA,
                          repos = NA,
                          token = NA,
                          api_url = NA) {
      private$api_url <- api_url
      private$is_public <- private$check_if_public()
      private$host <- private$set_host_name()
      if (is.null(token)){
        private$token <- private$set_default_token()
      } else {
        private$token <- token
      }
      private$check_orgs_and_repos(orgs, repos)
      if (private$host == "GitLab") {
        repos <- gsub("/", "%2f", repos)
        orgs <- gsub("/", "%2f", orgs)
      }
      rest_engine <- private$engines$rest <- private$setup_engine(type = "rest")
      gql_engine <- private$engines$graphql <- private$setup_engine(type = "graphql")
      if (private$scan_all) {
        cli::cli_alert_info("[{private$host}][Engine:{cli::col_yellow('GraphQL')}] Pulling all organizations...")
        private$orgs <- gql_engine$pull_orgs()
      } else {
        if (!is.null(orgs)) {
          private$orgs <- rest_engine$check_organizations(orgs)
        }
        if (!is.null(repos)) {
          private$repos <- rest_engine$check_repositories(repos)
        }
      }
    },

    #' @description  A method to list all repositories for an organization, a
    #'   team or by a keyword.
    #' @param settings A list of `GitStats` settings.
    #' @param add_contributors A boolean to decide whether to add contributors
    #'   column to repositories table.
    #' @return A data.frame of repositories.
    pull_repos = function(settings, add_contributors = FALSE) {
      repos_table <- private$pull_repos_from_orgs(
        settings = settings
      )
      if (settings$search_param == "team") {
        add_contributors <- TRUE
      }
      repos_table <- private$add_repo_api_url(repos_table)
      if (add_contributors) {
        repos_table <- self$pull_repos_contributors(repos_table)
      }
      if (nrow(repos_table) > 0 && settings$language != "All") {
        repos_table <- private$filter_repos_by_language(
          repos_table = repos_table,
          language = settings$language
        )
      }
      return(repos_table)
    },

    #' @description A method to add information on repository contributors.
    #' @param repos_table A table of repositories.
    #' @return A table of repositories with added information on contributors.
    pull_repos_contributors = function(repos_table) {
      if (!is.null(repos_table) && nrow(repos_table) > 0) {
        repos_table <- repos_table %>%
          dplyr::filter(grepl(gsub("/v+.*", "", private$api_url), api_url))
        repos_table <- purrr::map_dfr(private$engines, function (engine) {
          if (inherits(engine, "EngineRest")) {
            engine$pull_repos_contributors(
              repos_table
            )
          } else {
            NULL
          }
        })
      }
    },

    #' @description A method to get information on commits.
    #' @param date_from A starting date to look commits for.
    #' @param date_until An end date to look commits for.
    #' @param settings A list of `GitStats` settings.
    #' @return A data.frame of commits.
    pull_commits = function(date_from,
                            date_until = Sys.Date(),
                            settings) {
      if (settings$search_param == "phrase") {
        cli::cli_abort(c(
          "x" = "Pulling commits by phrase in code blobs is not supported.",
          "i" = "Please change your `search_param` either to 'org' or 'team' with `set_params()`."
        ))
      }
      if (private$scan_all) {
        cli::cli_alert_info("[Host:{private$host}] {cli::col_yellow('Pulling commits from all organizations...')}")
      }
      if (settings$search_param == "repo") {
        orgs_repos <- private$extract_repos_and_orgs(private$repos)
        orgs <- names(orgs_repos)
      } else {
        orgs <- private$orgs
      }
      commits_table <- purrr::map(orgs, function(org) {
        commits_table_org <- NULL
        if (settings$search_param == "repo") {
          repos <- orgs_repos[[org]]
        } else {
          repos <- NULL
        }
        commits_table_org <- purrr::map(private$engines, ~ .$pull_commits(
          org = org,
          repos = repos,
          date_from = date_from,
          date_until = date_until,
          settings = settings
        )) %>%
          purrr::list_rbind()
        return(commits_table_org)
      }, .progress = private$scan_all) %>%
        purrr::list_rbind()
      return(commits_table)
    },

    #' @description Pull information about users.
    #' @param users A character vector of users.
    #' @return Table of users.
    pull_users = function(users) {
      users_table <- purrr::map(private$engines, function(engine) {
        if (inherits(engine, "EngineGraphQL")) {
          engine$pull_users(users)
        } else {
          NULL
        }
      }) %>%
        purrr::list_rbind()
      return(users_table)
    },

    #' @description A method to retrieve given files from all repositories for
    #'   a host in a table format.
    #' @param file_path A file path.
    #' @param pulled_repos Optional parameter to pass repository output object.
    #' @return A table.
    pull_files = function(file_path, pulled_repos = NULL) {
      if (!is.null(pulled_repos)) {
        orgs <- pulled_repos %>%
          dplyr::filter(grepl(private$api_url, api_url)) %>%
          dplyr::select(organization) %>%
          unique() %>%
          unlist() %>%
          unname()
      } else {
        orgs <- private$orgs
      }
      files_table <- purrr::map(orgs, function(org) {
        repos_table <- purrr::map(private$engines, function(engine) {
          if (inherits(engine, "EngineGraphQL")) {
            files_table <- engine$pull_files(
              org = org,
              file_path = file_path,
              pulled_repos = pulled_repos
            )
            return(files_table)
          } else {
            NULL
          }
        }) %>%
          purrr::list_rbind()
      }, .progress = if (private$scan_all) {
            cli::cli_alert_info("[{private$host}][Engine:{cli::col_yellow('GraphQL')}] Pulling {file_path} files...")
          } else {
            FALSE
          }
      ) %>%
        purrr::list_rbind() %>%
        private$add_repo_api_url()
      return(files_table)
    }
  ),
  private = list(

    # @field A REST API URL.
    api_url = NULL,

    # @field A token.
    token = NULL,

    # @field public A boolean.
    is_public = NULL,

    # @field Host name.
    host = NULL,

    # @field orgs A character vector of repo organizations.
    orgs = NULL,

    # @field repos A character vector of repositories.
    repos = NULL,

    # @field A boolean.
    scan_all = FALSE,

    # @field engines A placeholder for REST and GraphQL Engine classes.
    engines = list(),

    # @description Check whether Git platform is public or internal.
    check_if_public = function() {
      if (grepl("api.github.com|gitlab.com/api", private$api_url)) {
        TRUE
      } else {
        FALSE
      }
    },

    # @description Check if both repos and orgs are defined or not.
    check_orgs_and_repos = function(orgs, repos) {
      if (is.null(repos) && is.null(orgs)) {
        if (private$is_public) {
          cli::cli_abort(c(
            "You need to specify `orgs` for public Git Host.",
            "x" = "Host will not be added.",
            "i" = "Add organizations to your `orgs` parameter."
          ),
          call = NULL)
        } else {
          cli::cli_alert_warning(cli::col_yellow(
            "No `orgs` specified. I will pull all organizations from the Git Host."
          ))
          private$scan_all <- TRUE
        }
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

    # @description Set name of a Git Host.
    set_host_name = function() {
      if (grepl("https://", private$api_url) && grepl("github", private$api_url)) {
        "GitHub"
      } else if (grepl("https://", private$api_url) && grepl("gitlab|code", private$api_url)) {
        "GitLab"
      } else {
        cli::cli_abort(c(
          "This connection is not supported by GitStats class object.",
          "x" = "Host will not be added."
          ),
          call = NULL
        )
      }
    },

    # @description Set default token if none exists.
    set_default_token = function() {
      if (grepl("github", private$api_url)) {
        primary_token_name <- "GITHUB_PAT"
      } else {
        primary_token_name <- "GITLAB_PAT"
      }
      token <- Sys.getenv(primary_token_name)
      if (private$test_token(token)) {
        cli::cli_alert_info("Using PAT from {primary_token_name} envar.")
      } else {
        pat_names <- names(Sys.getenv()[grepl(primary_token_name, names(Sys.getenv()))])
        possible_tokens <- pat_names[pat_names != primary_token_name]
        for (token_name in possible_tokens) {
          if (private$test_token(Sys.getenv(token_name))) {
            token <- Sys.getenv(token_name)
            cli::cli_alert_info("Using PAT from {token_name} envar.")
            break
          }
        }
      }
      return(token)
    },

    # Setup REST and GraphQL engines
    setup_engine = function(type) {
      engine <- if (private$host == "GitHub") {
        if (type == "rest") {
          EngineRestGitHub$new(
            rest_api_url = private$api_url,
            token = private$token,
            scan_all = private$scan_all
          )
        } else {
          EngineGraphQLGitHub$new(
            gql_api_url = private$set_gql_url(private$api_url),
            token = private$token,
            scan_all = private$scan_all
          )
        }
      } else {
        if (type == "rest") {
          EngineRestGitLab$new(
            rest_api_url = private$api_url,
            token = private$token,
            scan_all = private$scan_all
          )
        } else {
          EngineGraphQLGitLab$new(
            gql_api_url = private$set_gql_url(private$api_url),
            token = private$token,
            scan_all = private$scan_all
          )
        }
      }
      return(engine)
    },

    # @description Helper to test if a token works
    test_token = function(token) {
      response <- NULL
      test_endpoint <- if (grepl("github", private$api_url)) {
        private$api_url
      } else {
        paste0(private$api_url, "/projects")
      }
      try(response <- httr2::request(test_endpoint) %>%
        httr2::req_headers("Authorization" = paste0("Bearer ", token)) %>%
        httr2::req_perform(), silent = TRUE)
      if (!is.null(response)) {
        TRUE
      } else {
        FALSE
      }
    },

    # @description GraphQL url handler (if not provided).
    # @param rest_api_url REST API url.
    # @return GraphQL API url.
    set_gql_url = function(rest_api_url) {
      paste0(gsub("/v+.*", "", rest_api_url), "/graphql")
    },

    # @description Pull repositories from organisations.
    pull_repos_from_orgs = function(settings) {
      orgs <- private$orgs
      if (private$scan_all) {
        if (settings$search_param == "phrase") {
          orgs <- "no_orgs"
        } else {
          cli::cli_alert_info("[Host:{private$host}] {cli::col_yellow('Pulling repositories from all organizations...')}")
        }
      }
      repos_table <- purrr::map(orgs, function(org) {
        repos_list <- list()
        tryCatch({
          repos_list <- purrr::map(private$engines, function (engine) {
            engine$pull_repos(
              org = org,
              settings = settings
            )
          })
        },
        error = function(e) {
          if (!private$scan_all) {
            if (grepl("502|400", e)) {
              if (grepl("502", e)) {
                cli::cli_alert_warning(cli::col_yellow("HTTP 502 Bad Gateway Error."))
              } else if (grepl("400", e)) {
                cli::cli_alert_warning(cli::col_yellow("HTTP 400 Bad Request."))
              }
              cli::cli_alert_info("Switching to REST engine.")
              repos_list <<- purrr::map(private$engines, function (engine) {
                engine$pull_repos_supportive(
                  org = org,
                  settings = settings
                )
              })
            } else if (grepl("Empty", e)) {
              cli::cli_abort(
                c(
                  "x" = "Empty response.",
                  "!" = "Your token probably does not cover scope to pull repositories.",
                  "i" = "Set `read_api` scope when creating GitLab token."
                )
              )
            }
          } else {
            e
          }
        })
        repos_table_org <- purrr::list_rbind(repos_list)
        return(repos_table_org)
      }, .progress = private$scan_all) %>%
        purrr::list_rbind()
    },

    # @description Add `api_url` column to table.
    add_repo_api_url = function(repos_table){
      if (!is.null(repos_table) && nrow(repos_table) > 0) {
        repos_table <- if (private$host == "GitHub") {
          dplyr::mutate(
            repos_table,
            api_url = paste0(private$api_url, "/repos/", organization, "/", repo_name),
          )
        } else if (private$host == "GitLab") {
          dplyr::mutate(
            repos_table,
            api_url = paste0(private$api_url, "/projects/", stringr::str_match(repo_id, "[0-9].*"))
          )
        }
      }
      return(repos_table)
    },

    # @description Filter repositories by contributors.
    # @details If at least one member of a team is a contributor than a project
    #   passes through the filter.
    # @param repos_table A repository table to be filtered.
    # @param language A language used in repository.
    # @return A repos table.
    filter_repos_by_language = function(repos_table,
                                        language) {
      cli::cli_alert_info("Filtering by language.")
      filtered_langs <- purrr::keep(repos_table$languages, function(row) {
        grepl(language, row)
      })
      repos_table <- repos_table %>%
        dplyr::filter(languages %in% filtered_langs)
      return(repos_table)
    },

    # Helper to extract organizations and repositories from vector of full names
    # of repositories
    extract_repos_and_orgs = function(repos_fullnames) {
      if (any(grepl("%2f", repos_fullnames))) {
        repos_fullnames <- gsub("%2f", "/", repos_fullnames)
      }
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
    }
  )
)
