#' @importFrom R6 R6Class

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

    #' @description Create a new `GitService` object
    #' @param rest_api_url A url of rest API.
    #' @param gql_api_url A url of GraphQL API.
    #' @param token A token.
    #' @param orgs A character vector of organisations (owners of repositories
    #'   in case of GitHub and groups of projects in case of GitLab).
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
      self$enterprise <- private$check_enterprise(self$rest_api_url)
      self$org_limit <- org_limit
      if (is.null(orgs)) {

        if (self$enterprise) {
          warning("No organizations specified.",
                  call. = FALSE,
                  immediate. = TRUE)
          pull_all_orgs <- menu(c("Yes", "No"), title="Do you want to pull all orgs from the API?")

          if (pull_all_orgs == 1) {
            orgs <- private$pull_organizations()
            message("Pulled ", length(orgs), " organizations.")
          } else {
            stop("No organizations specified for ", self$git_service, ". Pass your organizations to `orgs` parameter.",
                 call. = FALSE)
          }

        } else {
          stop("No organizations specified for public ", self$git_service, ". Pass your organizations to `orgs` parameter.",
               call. = FALSE)
        }

      }
      self$orgs <- orgs
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

    #' @description Pull all organisations/groups form API.
    #' @param api_url An url of an API.
    #' @param git_service A character specifying whether Git Client is GitHub or
    #'   GitLab.
    #' @param token A token.
    #' @param org_limit An integer defining how many org may API pull.
    #' @return A character vector of organizations/groups names.
    pull_organizations = function(api_url = self$rest_api_url,
                                  git_service = self$git_service,
                                  token = private$token,
                                  org_limit = self$org_limit) {

      if (git_service == "GitHub") {

        total_count <- get_response(endpoint = paste0(api_url, "/search/users?q=type%3Aorg"),
                                           token = token)[["total_count"]]

        if (total_count > org_limit) {
          warning("Number of organizations exceeds limit (", org_limit, "). I will pull only first ", org_limit, " organizations.",
                  call. = FALSE,
                  immediate. = FALSE)
          org_n <- org_limit
        } else {
          org_n <- total_count
        }

        endpoint <- paste0(api_url,"/organizations?per_page=100")

        orgs_list <- get_response(endpoint = endpoint,
                                  token = token)

        if (org_n > 100) {
          while (length(orgs_list) < org_n) {
            last_id <- tail(purrr::map_dbl(orgs_list, ~.$id), 1)
            endpoint <- paste0(api_url,"/organizations?per_page=100&since=", last_id)
            orgs_list <- get_response(endpoint = endpoint,
                                      token = token) %>%
              append(orgs_list, .)
          }
        }

      } else if (git_service == "GitLab") {

        resp <- perform_request(endpoint = paste0(api_url, "/groups?all_available=true&per_page=50&page=1"),
                                token = token)

        if (length(resp$headers$`x-total-pages`) > 0){
          total_pages <- resp$headers$`x-total-pages`
        } else {
          total_pages <- org_limit %/% 50
        }

        orgs_list <- list()
        o_page <- 1
        still_more_hits <- TRUE
        while(length(orgs_list) < total_pages || !still_more_hits){
          orgs_page <- get_response(endpoint = paste0(api_url, "/groups?all_available=true&per_page=50&page=", o_page),
                                    token = token)
          if (length(orgs_page) > 0) {
            orgs_list <- append(orgs_list, orgs_page)
            o_page <- o_page + 1
          } else {
            still_more_hits <- FALSE
          }
        }

      }
      org_names <- purrr::map_chr(orgs_list, ~{
        if (git_service == "GitHub") {
          .$login
        } else if (git_service == "GitLab") {
          .$path
        }

      })

      return(org_names)

    },

    #' @description A method to pull all repositories for an organization.
    #' @param org A character, an organization:\itemize{\item{GitHub - owners o
    #'   repositories} \item{GitLab - group of projects.}}
    #' @param rest_api_url A url of a REST API.
    #' @param token A token.
    #' @param git_service A character, to choose from "GitHub" or "GitLab".
    #' @return A list.
    pull_repos_from_org = function(org,
                                   rest_api_url = self$rest_api_url,
                                   token = private$token,
                                   git_service = self$git_service) {

      repos_list <- list()
      r_page <- 1
      repeat {
        repos_endpoint <- if (git_service == "GitHub") {
          paste0("/orgs/", org, "/repos")
        } else if (git_service == "GitLab") {
          paste0("/groups/", org, "/projects")
        }
        endpoint <- paste0(rest_api_url, repos_endpoint,"?per_page=100&page=", r_page)

        repos_page <- get_response(
          endpoint = endpoint,
          token = token
        )
        if (length(repos_page) > 0) {
          repos_list <- append(repos_list, repos_page)
          r_page <- r_page + 1
        } else {
          break
        }
      }

      repos_list
    },

    #' @description Perform get request to find projects by ids.
    #' @param ids A character vector of repositories or projects' ids.
    #' @param objects A character to choose between 'repositories' (GitHub) and
    #'   'projects' (GitLab).
    #' @return A list of repositories.
    find_by_id = function(ids,
                          objects = c("repositories", "projects"),
                          api_url = self$rest_api_url,
                          token = private$token) {
      objects <- match.arg(objects)
      projects_list <- purrr::map(ids, function(x) {
        content <- get_response(
          paste0(api_url, "/", objects, "/", x),
          token
        )
      })

      projects_list
    },

    #' @description GraphQL url handler (if not provided)
    #' @param gql_api_url A url of GraphQL API.
    #' @param rest_api_url A url of REST API.
    #' @return Nothing, passes proper url to `gql_api_url` field.
    set_gql_url = function(gql_api_url = self$gql_api_url,
                           rest_api_url = self$rest_api_url) {
      self$gql_api_url <- paste0(gsub("/v+.*", "", rest_api_url), "/graphql")
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
          )
        )
      }

      return(repos_dt)
    },

    #' @description A helper to turn list of data.frames into one data.frame
    #' @param commits_list A list
    #' @return A data.frame
    prepare_commits_table = function(commits_list) {
      purrr::map(commits_list, function(x) {
        purrr::map(x, ~ data.frame(.)) %>%
          rbindlist()
      }) %>% rbindlist()
    }
  )
)
