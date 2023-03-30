#' @importFrom R6 R6Class
#' @importFrom rlang expr
#' @importFrom cli cli_alert_danger cli_alert_success

#' @title A Git Service API Client superclass
#' @description  A superclass for GitHub and GitLab classes

GitService <- R6::R6Class("GitService",
  public = list(

    #' @field rest_api_url A character, url of REST API.
    rest_api_url = NULL,

    #' @field gql_api_url A character, url of GraphQL API.
    gql_api_url = NULL,

    #' @field gql_query An environment for GraphQL queries.
    gql_query = NULL,

    #' @field orgs A character vector of organizations.
    orgs = NULL,

    #' @field git_service A character specifying whether GitHub or GitLab.
    git_service = NULL,

    #' @field enterprise A character defining whether Git Service is public or
    #'   enterprise version.
    enterprise = NULL,

    #' @field org_limit An integer defining how many org may API pull.
    org_limit = NULL,

    #' @description Create a new `GitService` object
    #' @param rest_api_url A url of rest API.
    #' @param gql_api_url A url of GraphQL API.
    #' @param token A token.
    #' @param orgs A character vector of organisations (owners of repositories
    #'   in case of GitHub and groups of projects in case of GitLab).
    #' @param org_limit An integer to set maximum number of organizations to be
    #'   pulled from Git Service.
    #' @return A new `GitService` object
    initialize = function(rest_api_url = NA,
                          gql_api_url = NA,
                          token = NA,
                          orgs = NA,
                          org_limit = NA) {
      self$rest_api_url <- rest_api_url
      if (is.na(gql_api_url)) {
        private$set_gql_url()
      } else {
        self$gql_api_url <- gql_api_url
      }
      private$token <- token
      self$git_service <- private$check_git_service(self$rest_api_url)
      if (self$git_service == "GitHub") {
        self$gql_query <- GraphQLQueryGitHub$new()
      }
      if (self$git_service == "GitLab") {
        self$gql_query <- GraphQLQueryGitLab$new()
      }
      self$enterprise <- private$check_enterprise(self$rest_api_url)
      self$org_limit <- org_limit
      if (is.null(orgs)) {
        cli::cli_alert_warning("No organizations specified.")
      } else {
        orgs <- private$check_orgs(orgs)
      }
      self$orgs <- orgs
    },

    #' @description  A method to list all repositories for an organization, a
    #'   team or by a keyword.
    #' @param by A character, to choose between: \itemize{\item{org -
    #'   organizations (project groups)} \item{team -
    #'   A team} \item{phrase - A keyword in code blobs.}}
    #' @param team A list of team members.
    #' @param phrase A character to look for in code blobs. Obligatory if
    #'   \code{by} parameter set to \code{"phrase"}.
    #' @param language A character specifying language used in repositories.
    #' @return A data.frame of repositories.
    get_repos = function(by,
                         team,
                         phrase,
                         language = NULL) {

      if (self$git_service == "GitLab") {
        language <- private$language_handler(language)
      }

      repos_dt <- purrr::map(self$orgs, function(org) {
        if (by %in% c("org", "team")) {
          repos_table <- private$pull_repos_from_org(org = org)
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
        }

        if (by == "phrase") {
          repos_list <- private$search_by_keyword(
            phrase,
            org = org,
            language = language
          )
          repos_table <- repos_list %>%
            private$tailor_repos_info() %>%
            private$prepare_repos_table() %>%
            private$add_repos_contributors() %>%
            private$add_repos_issues()
          cli::cli_alert_success(paste0("\n On ", self$git_service,
                                        " [", org, "] found ",
                                        nrow(repos_table), " repositories."))
        }
        return(repos_table)
      }) %>%
        rbindlist(use.names = TRUE)

      return(repos_dt)
    }

  ),
  private = list(

    #' @field token A token authorizing access to API.
    token = NULL,

    #' @description A helper to check if GitHub Client is Public or Enterprise.
    #' @param api_url A character, a url of API.
    #' @return A boolean.
    check_enterprise = function(api_url) {
      if (api_url != "https://api.github.com" &&
        api_url != "https://gitlab.api.com" &&
        (grepl("github", api_url)) || self$git_service == "GitLab") {
        "Enterprise"
      } else {
        "Public"
      }
    },

    #' @description A helper to check if GitService Client is GitHub or GitLab.
    #' @param api_url A character, a url of API.
    #' @return A character.
    check_git_service = function(api_url) {
      if (grepl("github", api_url)) {
        "GitHub"
      } else if (grepl("https://", api_url) && grepl("gitlab|code", api_url)) {
        "GitLab"
      }
    },

    #' @description A method to add information on repository contributors.
    #' @param repos_table A table of repositories.
    #' @return A table of repositories with added information on contributors.
    add_repos_contributors = function(repos_table) {
      if (nrow(repos_table) > 0) {
        if (self$git_service == "GitHub") {
          repo_iterator <- paste0(repos_table$organization, "/", repos_table$name)
          user_name <- rlang::expr(.$login)
        } else if (self$git_service == "GitLab") {
          repo_iterator <- repos_table$id
          user_name <- rlang::expr(.$name)
        }
        repos_table$contributors <- purrr::map(repo_iterator, function(repos_id) {
          if (self$git_service == "GitHub") {
            contributors_endpoint <- paste0(self$rest_api_url, "/repos/", repos_id, "/contributors")
          } else if (self$git_service == "GitLab") {
            id <- gsub("gid://gitlab/Project/", "", repos_id)
            contributors_endpoint <- paste0(self$rest_api_url, "/projects/", id, "/repository/contributors")
          }
          tryCatch(
            {
              private$rest_response(
                endpoint = contributors_endpoint
              ) %>% purrr::map_chr(~eval(user_name)) %>%
                paste0(collapse = ", ")
            },
            error = function(e) {
              NA
            }
          )
        })
      }
      return(repos_table)
    },

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
      repos_table <- repos_table %>%
        dplyr::filter(languages %in% language)
      return(repos_table)
    },

    #' @description Perform get request to find projects by ids.
    #' @param ids A character vector of repositories or projects' ids.
    #' @param objects A character to choose between 'repositories' (GitHub) and
    #'   'projects' (GitLab).
    #' @return A list of repositories.
    find_by_id = function(ids,
                          objects = c("repositories", "projects")) {
      objects <- match.arg(objects)
      projects_list <- purrr::map(ids, function(x) {
        content <- private$rest_response(
          endpoint = paste0(self$rest_api_url, "/", objects, "/", x)
        )
      })

      projects_list
    },

    #' @description GraphQL url handler (if not provided).
    #' @return Nothing, passes proper url to `gql_api_url` field.
    set_gql_url = function() {
      self$gql_api_url <- paste0(gsub("/v+.*", "", self$rest_api_url), "/graphql")
    },

    #' @description A helper to prepare table for repositories content
    #' @param repos_list A repository list.
    #' @return A data.frame.
    prepare_repos_table = function(repos_list) {
      repos_dt <- purrr::map(repos_list, function(repo) {
        repo <- purrr::map(repo, function(attr) {
          attr <- attr %||% ""
        })
        data.frame(repo)
      }) %>%
        data.table::rbindlist()

      if (length(repos_dt) > 0) {
        repos_dt <- dplyr::mutate(repos_dt,
          api_url = self$rest_api_url,
          created_at = as.POSIXct(created_at),
          last_activity_at = difftime(Sys.time(), as.POSIXct(last_activity_at),
            units = "days"
          ) %>% round(2)
        )
      }

      return(repos_dt)
    },

    #' @description A helper to turn list of data.frames into one data.frame
    #' @param commits_list A list
    #' @return A data.frame
    prepare_commits_table = function(commits_list) {
      commits_dt <- purrr::map(commits_list, function(x) {
        purrr::map(x, ~ data.frame(.)) %>%
          rbindlist()
      }) %>% rbindlist()

      if (length(commits_dt) > 0) {
        commits_dt <- dplyr::mutate(
          commits_dt,
          api_url = self$rest_api_url
        )
      }
      return(commits_dt)
    },

    #' @description Check if an organization exists
    #' @param orgs A character vector of organizations
    #' @return orgs or NULL.
    check_orgs = function(orgs) {
      orgs <- purrr::map(orgs, function(org) {
        org_endpoint <- if (self$git_service == "GitHub") {
          "/orgs/"
        } else if (self$git_service == "GitLab") {
          "/groups/"
        }
        withCallingHandlers({
          private$rest_response(endpoint = paste0(self$rest_api_url, org_endpoint, org))
        },
        message = function(m) {
          if (grepl("404", m)) {
            if (grepl(" ", org) & self$git_service == "GitLab") {
              cli::cli_alert_danger("Group name passed in a wrong way: {org}")
              cli::cli_alert_warning("If you are using `GitLab`, please type your group name as you see it in `url`.")
              cli::cli_alert_info("E.g. do not use spaces. Group names as you see on the page may differ from their 'address' name.")
            } else {
              cli::cli_alert_danger("Organization you provided does not exist. Check spelling in: {org}")
            }
            org <<- NULL
          }
        })
        return(org)
      }) %>%
        purrr::keep(~length(.) > 0) %>%
        unlist()

      if (length(orgs) == 0) {
        return(NULL)
      }
      orgs
    },

    #' @description A wrapper for httr2 functions to perform get request to REST API endpoints.
    #' @param endpoint An API endpoint.
    #' @return A content of response formatted to list.
    rest_response = function(endpoint) {

      resp <- perform_request(endpoint, private$token)
      if (!is.null(resp)) {
        result <- resp %>% httr2::resp_body_json(check_type = FALSE)
      } else {
        result <- list()
      }

      return(result)
    },

    #' @description Wrapper of GraphQL API request and response.
    #' @param gql_query A string with GraphQL query.
    #' @return A list.
    gql_response = function(gql_query) {

      request(paste0(self$gql_api_url, "?")) %>%
        httr2::req_headers("Authorization" = paste0("Bearer ", private$token)) %>%
        httr2::req_body_json(list(query=gql_query, variables="null")) %>%
        httr2::req_perform() %>%
        httr2::resp_body_json()

    }

  )
)
