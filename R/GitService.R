#' @importFrom R6 R6Class
#' @importFrom rlang expr

#' @title A Git Service API Client superclass
#' @description  A superclass for GitHub and GitLab classes

GitService <- R6::R6Class("GitService",
  public = list(

    #' @field rest_api_url A character, url of REST API.
    rest_api_url = NULL,

    #' @field gql_api_url A character, url of GraphQL API.
    gql_api_url = NULL,

    #' @field orgs A character vector of organizations.
    orgs = NULL,

    #' @field git_service A character specifying whether GitHub or GitLab.
    git_service = NULL,

    #' @field enterprise A boolean defining whether Git Service is public or
    #'   enterprise version.
    enterprise = NULL,

    #' @field org_limit An integer defining how many org may API pull.
    org_limit = NULL,

    #' @field repos_endpoint An expression for repositories endpoint.
    repos_endpoint = NULL,

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
    #' @param repos_endpoint An expression for repositories endpoint.
    #' @param repo_contributors_endpoint An expression for repositories'
    #'   contributors endpoint.
    #' @return A new `GitService` object
    initialize = function(rest_api_url = NA,
                          gql_api_url = NA,
                          token = NA,
                          orgs = NA,
                          org_limit = NA,
                          repos_endpoint = self$repos_endpoint,
                          repo_contributors_endpoint = self$repo_contributors_endpoint) {
      self$rest_api_url <- rest_api_url
      if (is.na(gql_api_url)) {
        private$set_gql_url()
      } else {
        self$gql_api_url <- gql_api_url
      }
      private$token <- token
      self$git_service <- private$check_git_service(self$rest_api_url)
      self$enterprise <- private$check_enterprise(self$rest_api_url)
      self$org_limit <- org_limit
      if (is.null(orgs)) {
        if (self$enterprise) {
          warning("No organizations specified.",
            call. = FALSE,
            immediate. = TRUE
          )
          pull_all_orgs <- menu(c("Yes", "No"), title = "Do you want to pull all orgs from the API?")

          if (pull_all_orgs == 1) {
            orgs <- private$pull_organizations()
            message("Pulled ", length(orgs), " organizations.")
          } else {
            stop("No organizations specified for ", self$git_service, ". Pass your organizations to `orgs` parameter.",
              call. = FALSE
            )
          }
        } else {
          stop("No organizations specified for public ", self$git_service, ". Pass your organizations to `orgs` parameter.",
            call. = FALSE
          )
        }
      }
      self$orgs <- orgs

      self$repos_endpoint <- repos_endpoint
      self$repo_contributors_endpoint <- repo_contributors_endpoint
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
        TRUE
      } else {
        FALSE
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

    #' @description A method to pull all repositories for an organization.
    #' @param org A character, an organization:\itemize{\item{GitHub - owners o
    #'   repositories} \item{GitLab - group of projects.}}
    #' @param repos_endpoint An expression for repositories endpoint.
    #' @return A list.
    pull_repos_from_org = function(org,
                                   repos_endpoint = self$repos_endpoint) {
      repos_list <- list()
      r_page <- 1
      repeat {
        repos_page <- get_response(
          endpoint = paste0(eval(repos_endpoint), "?per_page=100&page=", r_page),
          token = private$token
        )
        if (length(repos_page) > 0) {
          repos_list <- append(repos_list, repos_page)
          r_page <- r_page + 1
        } else {
          break
        }
      }

      repos_list <- repos_list %>%
        private$pull_repos_contributors() %>%
        private$pull_repos_issues()

      repos_list
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
            get_response(
              endpoint = eval(repo_contributors_endpoint),
              token = private$token
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
      purrr::map(repos_list, function(x) {
        if (length(intersect(team, x$contributors)) > 0) {
          return(x)
        } else {
          return(NULL)
        }
      }) %>% purrr::keep(~ length(.) > 0)
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
        content <- get_response(
          endpoint = paste0(self$rest_api_url, "/", objects, "/", x),
          token = private$token
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
    }
  )
)
