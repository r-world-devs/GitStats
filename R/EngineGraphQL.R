#' @title A EngineGraphQL class
#' @description A superclass for methods wraping GraphQL API responses.

EngineGraphQL <- R6::R6Class("EngineGraphQL",
  inherit = Engine,
  public = list(

    #' @field git_service A character specifying whether GitHub or GitLab.
    git_service = NULL,

    #' @field gql_api_url A character, url of GraphQL API.
    gql_api_url = NULL,

    #' @field gql_query An environment for GraphQL queries.
    gql_query = NULL,

    #' @description Create a new `GraphQL` object
    #' @param token A token.
    #' @param gql_api_url A character, url of GraphQL API.
    #' @return A `GraphQL` object.
    initialize = function(token = NA,
                          gql_api_url = NA) {
      super$initialize(token = token)
      self$gql_api_url <- gql_api_url
    },

    #' @description Wrapper of GraphQL API request and response.
    #' @param gql_query A string with GraphQL query.
    #' @return A list.
    gql_response = function(gql_query) {
      httr2::request(paste0(self$gql_api_url, "?")) %>%
        httr2::req_headers("Authorization" = paste0("Bearer ", private$token)) %>%
        httr2::req_body_json(list(query=gql_query, variables="null")) %>%
        httr2::req_perform() %>%
        httr2::resp_body_json()

    },

    #' @description Method to pull all repositories from organization.
    #' @param org An organization.
    #' @param by A character, to choose between: \itemize{\item{org -
    #'   organizations (project groups)} \item{team -
    #'   A team}}
    #' @param team A list of team members.
    #' @param language A character specifying language used in repositories.
    #' @return A table of repositories
    get_repos_by_org = function(org,
                                by,
                                team,
                                language) {

      repos_table <- self$get_repos_from_org(
        org = org
      )
      if (by == "team") {
        repos_table <- private$filter_repos_by_team(
          repos_table = repos_table,
          team = team
        )
      }
      if (!is.null(language)) {
        repos_table <- private$filter_repos_by_language(
          repos_table = repos_table,
          language = language
        )
      }
      return(repos_table)
    }
  ),

  private = list(
    #' @description Filter repositories by contributors.
    #' @details If at least one member of a team is a contributor than a project
    #'   passes through the filter.
    #' @param repos_table A repository table to be filtered.
    #' @param team A list with team members.
    #' @return A repos table.
    filter_repos_by_team = function(repos_table,
                                    team) {
      cli::cli_alert_info("Filtering by team members.")
      team_logins <- purrr::map(team, ~.$logins) %>%
        unlist()
      if (nrow(repos_table) > 0) {
        repos_table <- repos_table %>%
          dplyr::filter(contributors %in% team_logins)
      } else {
        repos_table
      }
      return(repos_table)
    },

    #' @description Filter repositories by contributors.
    #' @details If at least one member of a team is a contributor than a project
    #'   passes through the filter.
    #' @param repos_table A repository table to be filtered.
    #' @param language A language used in repository.
    #' @return A repos table.
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
