#' @importFrom R6 R6Class
#' @importFrom rlang expr
#' @importFrom cli cli_alert_danger cli_alert_success
#' @importFrom purrr keep

#' @title A GitHost superclass

GitHost <- R6::R6Class("GitHost",
  public = list(

    #' @description Create a new `GitHost` object
    #' @param orgs A character vector of organisations (owners of repositories
    #'   in case of GitHub and groups of projects in case of GitLab).
    #' @param token A token.
    #' @param api_url An API url.
    #' @return A new `GitHost` object
    initialize = function(orgs = NA,
                          token = NA,
                          api_url = NA) {
      private$api_url <- api_url
      if (grepl("https://", api_url) && grepl("github", api_url)) {
        private$engines$rest <- EngineRestGitHub$new(
          token = token,
          rest_api_url = api_url
        )
        private$engines$graphql <- EngineGraphQLGitHub$new(
          token = token,
          gql_api_url = private$set_gql_url(api_url)
        )
        cli::cli_alert_success("Set connection to GitHub.")
      } else if (grepl("https://", api_url) && grepl("gitlab|code", api_url)) {
        private$engines$rest <- EngineRestGitLab$new(
          token = token,
          rest_api_url = api_url
        )
        private$engines$graphql <- EngineGraphQLGitLab$new(
          token = token,
          gql_api_url = private$set_gql_url(api_url)
        )
        cli::cli_alert_success("Set connection to GitLab.")
      } else {
        stop("This connection is not supported by GitStats class object.")
      }
      private$orgs <- private$engines$rest$check_organizations(orgs)
    },

    #' @description  A method to list all repositories for an organization, a
    #'   team or by a keyword.
    #' @param settings A list of `GitStats` settings.
    #' @param add_contributors A boolean to decide wether to add contributors
    #'   column to repositories table.
    #' @return A data.frame of repositories.
    get_repos = function(settings, add_contributors = FALSE) {
      repos_table <- purrr::map(private$orgs, function(org) {
        tryCatch({
          repos_list <- purrr::map(private$engines, function (engine) {
            engine$get_repos(
                org = org,
                settings = settings
              )
          })
        },
        error = function(e) {
          if (grepl("502", e)) {
            cli::cli_alert_warning(cli::col_yellow("HTTP 502 Bad Gateway Error. Switch to another Engine."))
            repos_list <<- purrr::map(private$engines, function (engine) {
              engine$get_repos_supportive(
                org = org,
                settings = settings
              )
            })
          } else {
            e
          }
        })
        repos_table_org <- purrr::list_rbind(repos_list)
        return(repos_table_org)
      }) %>%
        purrr::list_rbind()

      if (add_contributors) {
        repos_table <- self$add_repos_contributors(repos_table)
      }

      if (nrow(repos_table) > 0 && !is.null(settings$language)) {
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
    add_repos_contributors = function(repos_table) {
      repos_table <- repos_table %>%
        dplyr::filter(api_url == gsub("/v+.*", "", private$api_url))
      repos_table <- purrr::map_dfr(private$engines, function (engine) {
        if (inherits(engine, "EngineRest")) {
          engine$add_repos_contributors(
            repos_table
          )
        } else {
          NULL
        }
      })
    },

    #' @description A method to get information on commits.
    #' @param date_from A starting date to look commits for.
    #' @param date_until An end date to look commits for.
    #' @param settings A list of `GitStats` settings.
    #' @return A data.frame of commits
    get_commits = function(date_from,
                           date_until = Sys.Date(),
                           settings) {
      if (settings$search_param == "phrase") {
        cli::cli_abort(c(
          "x" = "Pulling commits by phrase in code blobs is not supported.",
          "i" = "Please change your `search_param` either to 'org' or 'team' with `setup()`."
        ))
      }

      commits_table <- purrr::map(private$orgs, function(org) {
        commits_table_org <- purrr::map(private$engines, ~ .$get_commits(
          org = org,
          date_from = date_from,
          date_until = date_until,
          settings = settings
        )) %>%
          purrr::list_rbind()

        return(commits_table_org)
      }) %>%
        purrr::list_rbind()

      return(commits_table)
    },

    #' @description Get information about users
    #' @param users A character vector of users
    #' @return Table of users
    get_users = function(users) {
      users_table <- purrr::map(private$engines, function(engine) {
        if (inherits(engine, "EngineGraphQL")) {
          engine$get_users(users)
        } else {
          NULL
        }
      }) %>%
        purrr::list_rbind()
      return(users_table)
    }
  ),
  private = list(

    # @field A REST API url.
    api_url = NULL,

    # @field orgs A character vector of repo organizations.
    orgs = NULL,

    # @field engines A placeholder for REST and GraphQL Engine classes.
    engines = list(),

    # @description GraphQL url handler (if not provided).
    # @param rest_api_url REST API url.
    # @return GraphQL API url.
    set_gql_url = function(rest_api_url) {
      paste0(gsub("/v+.*", "", rest_api_url), "/graphql")
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
    }
  )
)
