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

    #' @field repo_contributors_endpoint An expression for repositories'
    #'   contributors endpoint.
    repo_contributors_endpoint = NULL,

    #' @description Create a new `GitService` object
    #' @param rest_api_url A url of rest API.
    #' @param gql_api_url A url of GraphQL API.
    #' @param token A token.
    #' @param orgs A character vector of organisations (owners of repositories
    #'   in case of GitHub and groups of projects in case of GitLab).
    #' @param org_limit An integer to set maximum number of organizations to be
    #'   pulled from Git Service.
    #' @param repo_contributors_endpoint An expression for repositories'
    #'   contributors endpoint.
    #' @return A new `GitService` object
    initialize = function(rest_api_url = NA,
                          gql_api_url = NA,
                          token = NA,
                          orgs = NA,
                          org_limit = NA,
                          repo_contributors_endpoint = self$repo_contributors_endpoint) {
      self$rest_api_url <- rest_api_url
      if (is.na(gql_api_url)) {
        private$set_gql_url()
      } else {
        self$gql_api_url <- gql_api_url
      }
      self$gql_query <- GraphQLQuery$new()
      private$token <- token
      self$git_service <- private$check_git_service(self$rest_api_url)
      self$enterprise <- private$check_enterprise(self$rest_api_url)
      self$org_limit <- org_limit
      if (is.null(orgs)) {
        cli::cli_alert_warning("No organizations specified.")
      } else {
        orgs <- private$check_orgs(orgs)
      }
      self$orgs <- orgs

      self$repo_contributors_endpoint <- repo_contributors_endpoint
    },

    #' @description  A method to list all repositories for an organization, a
    #'   team or by a keyword.
    #' @param orgs A character vector of organizations (owners of repositories).
    #' @param by A character, to choose between: \itemize{\item{org -
    #'   organizations (owners of repositories or project groups)} \item{team -
    #'   A team} \item{phrase - A keyword in code blobs.}}
    #' @param team A list of team members. Specified by \code{set_team()} method
    #'   of GitStats class object.
    #' @param phrase A character to look for in code blobs. Obligatory if
    #'   \code{by} parameter set to \code{"phrase"}.
    #' @param language A character specifying language used in repositories.
    #' @return A data.frame of repositories.
    get_repos = function(orgs = self$orgs,
                         by,
                         team,
                         phrase,
                         language = NULL) {

      if (self$git_service == "GitLab") {
        language <- private$language_handler(language)
      }

      if (is.null(orgs)) {
        cli::cli_alert_warning(paste0("No organizations specified for ", self$git_service, "."))
        orgs <- private$pull_organizations(type = by,
                                           team = team)
      }
      cli::cli_alert(paste0("[", self$git_service, "] Pulling repositories..."))

      pb <- progress::progress_bar$new(
        format = paste0("...from {:what}: [:bar] :current/:total"),
        total = length(orgs)
      )

      repos_dt <- purrr::map(orgs, function(org) {
        pb$tick(tokens = list(what = org))
        if (by == "phrase") {
          repos_list <- private$search_by_keyword(phrase,
                                                  org = org,
                                                  language = language
          )
          cli::cli_alert_success(paste0("\n On ", self$git_service, " ('", org, "') found ", length(repos_list), " repositories."))
        } else {
          repos_list <- private$pull_repos_from_org(org = org) %>%
            {
              if (by == "team") {
                private$filter_repos_by_team(
                  repos_list = .,
                  team = team
                )
              } else {
                .
              }
            } %>%
            {
              if (!is.null(language)) {
                private$filter_by_language(
                  repos_list = .,
                  language = language
                )
              } else {
                .
              }
            }
        }

        repos_dt <- repos_list %>%
          private$tailor_repos_info() %>%
          private$prepare_repos_table()
      }) %>%
        rbindlist()

      repos_dt
    },

    #' @description A method to get information on commits.
    #' @param orgs A character vector of organisations.
    #' @param date_from A starting date to look commits for
    #' @param date_until An end date to look commits for
    #' @param by A character, to choose between: \itemize{\item{org -
    #'   organizations (owners of repositories or project groups)} \item{team -
    #'   A team} \item{phrase - A keyword in code blobs.}}
    #' @param team A list of team members. Specified by \code{set_team()} method
    #'   of GitStats class object.
    #' @return A data.frame of commits
    get_commits = function(orgs = self$orgs,
                           date_from,
                           date_until = Sys.time(),
                           by,
                           team) {

      if (is.null(orgs)) {
        cli::cli_alert_warning(paste0("No organizations specified for ", self$git_service, "."))
        orgs <- private$pull_organizations(type = by,
                                           team = team)
      }

      commits_dt <- purrr::map(orgs, function(x) {
        private$pull_commits_from_org(
          x,
          date_from,
          date_until
        ) %>%
          {
            if (by == "team") {
              private$filter_commits_by_team(
                commits_list = .,
                team = team
              )
            } else {
              .
            }
          } %>%
          private$tailor_commits_info(org = x)  %>%
          private$prepare_commits_table()
      }) %>% rbindlist()

      commits_dt
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

    #' @description Pull organisations form API.
    #' @param type A character.
    #' @param team A character vector of team members.
    #' @return A character vector of organizations names.
    pull_organizations = function(type,
                                  team) {

      if (type %in% c("org", "phrase")) {

        pull_all_orgs <- menu(c("Yes (this may take a while)",
                                "No (I want to specify orgs by myself)"),
                              title = "I need organizations specified to pull repos. Do you want me to pull all orgs from the API?")

        if (pull_all_orgs == 1) {
          org_names <- private$pull_all_organizations()
        } else {
          message("Specify your organizations with `set_orgnizations()` or set your preferences to look by `team`.")
          return(NULL)
        }

      } else if (type == "team") {
        org_names <- private$pull_team_organizations(team)
      }

      return(org_names)
    },

    #' @description A method to add information on repository contributors.
    #' @param repos_list A list of repositories.
    #' @param repo_contributors_endpoint An expression for repositories' contributors endpoint.
    #' @return A list of repositories with added information on contributors.
    pull_repos_contributors = function(repos_list,
                                       repo_contributors_endpoint = self$repo_contributors_endpoint) {
      repos_list <- purrr::map(repos_list, function(repo) {
        if (self$git_service == "GitHub") {
          user_name <- rlang::expr(.$login)
        } else if (self$git_service == "GitLab") {
          user_name <- rlang::expr(.$name)
        }

        contributors <- tryCatch(
          {
            private$rest_response(
              endpoint = eval(repo_contributors_endpoint)
            ) %>% purrr::map_chr(~ eval(user_name))
          },
          error = function(e) {
            NA
          }
        )

        contributors
      }) %>%
        purrr::map2(repos_list, function(contributor, repository) {
          purrr::list_modify(repository,
            contributors = contributor
          )
        })

      repos_list
    },

    #' @description Filter repositories by contributors.
    #' @details If at least one member of a team is a contributor than a project
    #'   passes through the filter.
    #' @param repos_list A repository list to be filtered.
    #' @param team A character vector with team member names.
    #' @return A list.
    filter_repos_by_team = function(repos_list,
                                    team) {
      repos_list <- purrr::map(repos_list, function(x) {
        if (length(intersect(team, x$contributors)) > 0) {
          return(x)
        } else {
          return(NULL)
        }
      }) %>% purrr::keep(~ length(.) > 0)
      return(repos_list)
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
