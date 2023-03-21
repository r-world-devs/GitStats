#' @importFrom R6 R6Class
#' @importFrom dplyr mutate rename
#' @importFrom magrittr %>%
#' @importFrom progress progress_bar
#' @importFrom rlang expr %||%
#' @importFrom cli cli_alert cli_alert_success col_green
#'
#' @title A GitHub API Client class
#' @description An object with methods to obtain information form GitHub API.

GitHub <- R6::R6Class("GitHub",
  inherit = GitService,
  cloneable = FALSE,
  public = list(

    #' @description  A method to list all repositories for an organization, a
    #'   team or by a keyword.
    #' @param by A character, to choose between: \itemize{\item{org -
    #'   organizations (owners of repositories or project groups)} \item{team -
    #'   A team} \item{phrase - A keyword in code blobs.}}
    #' @param team A list of team members. Specified by \code{set_team()} method
    #'   of GitStats class object.
    #' @param phrase A character to look for in code blobs. Obligatory if
    #'   \code{by} parameter set to \code{"phrase"}.
    #' @param language A character specifying language used in repositories.
    #' @return A data.frame of repositories.
    get_repos = function(by,
                         team = NULL,
                         phrase = NULL,
                         language = NULL) {

      if (by %in% "org") {
        repos_dt <- purrr::map(self$orgs, ~private$pull_repos_from_org(org = .,
                                                           language = language)) %>%
          rbindlist(use.names = TRUE)
      }
      if (by == "team") {
        repos_dt <- purrr::map(self$orgs, function(org) {
          repos_table <- private$pull_repos_from_org(org = org,
                                      language = language)
          private$filter_repos_by_team(repos_table,
                                       team)}) %>%
          rbindlist(use.names = TRUE)
      }
      if (by == "phrase") {
        repos_list <- private$search_by_keyword(phrase,
                                                org = org,
                                                language = language
        )
        cli::cli_alert_success(paste0("\n On ", self$git_service,
                                      " ('", org, "') found ",
                                      length(repos_list), " repositories."))
      }

      return(repos_dt)

    },

    #' @description A method to get information on commits.
    #' @param orgs A character vector of organisations.
    #' @param date_from A starting date to look commits for.
    #' @param date_until An end date to look commits for.
    #' @param by A character, to choose between: \itemize{\item{org -
    #'   organizations (owners of repositories or project groups)} \item{team -
    #'   A team} \item{phrase - A keyword in code blobs.}}
    #' @param team A list of team members. Specified by \code{set_team()} method
    #'   of GitStats class object.
    #' @return A data.frame of commits
    get_commits = function(orgs = self$orgs,
                           date_from,
                           date_until = Sys.Date(),
                           by,
                           team = NULL) {

      if (is.null(orgs)) {
        cli::cli_alert_warning(paste0("No organizations specified for ", self$git_service, "."))
        orgs <- private$pull_organizations(type = by,
                                           team = team)
      }

      commits_table <- purrr::map(orgs, function(org) {
        private$pull_commits_from_org(org,
                                     date_from = date_from,
                                     date_until = date_until,
                                     team = team)
      }) %>%
        rbindlist()

      return(commits_table)
    },

    #' @description A print method for a GitHub object
    print = function() {
      cat("GitHub API Client", sep = "\n")
      cat(paste0(" url: ", self$rest_api_url), sep = "\n")
      orgs <- paste0(self$orgs, collapse = ", ")
      cat(paste0(" orgs: ", orgs), sep = "\n")
    }
  ),
  private = list(

    #' @description Method to pull all repositories from organization.
    #' @param org An organization.
    #' @param language Language of repositories.
    #' @return A table of repositories
    pull_repos_from_org = function(org,
                                   language) {

      cli::cli_alert_info("[GitHub {self$enterprise}][{org}] Pulling repositories...")
      repos_response <- private$pull_repos_page_from_org(org = org,
                                                         language = language)
      repos_count <- repos_response$data$search$repositoryCount
      cli::cli_alert_info("Number of repositories: {repos_count}")
      if (repos_count > 1000) {
        cli::cli_alert_warning("Repos limit hit. Only 1000 repos will be pulled.")
      }
      full_repos_list <- repos_response$data$search$edges
      next_page <- repos_response$data$search$pageInfo$hasNextPage
      if (is.null(full_repos_list)) full_repos_list <- list()
      if (next_page) {
        repo_cursor <- repos_response$data$search$pageInfo$endCursor
      } else {
        repo_cursor <- ''
      }
      while (next_page) {
        repos_response <- private$pull_repos_page_from_org(org = org,
                                                           language = language,
                                                           repo_cursor = repo_cursor)
        repos_list <- repos_response$data$search$edges
        next_page <- repos_response$data$search$pageInfo$hasNextPage
        if (is.null(next_page)) next_page <- FALSE
        if (is.null(repos_list)) repos_list <- list()
        if (next_page) {
          repo_cursor <- repos_response$data$search$pageInfo$endCursor
        } else {
          repo_cursor <- ''
        }
        full_repos_list <- append(full_repos_list, repos_list)
      }
      repos_table <- private$prepare_repos_table_gql(
        full_repos_list,
        org = org
        )
      return(repos_table)
    },

    #' @description
    #' @param org
    #' @param language
    #' @param repo_cursor
    #' @return
    pull_repos_page_from_org = function(org,
                                        language,
                                        repo_cursor = '') {
      repos_by_org <- self$gql_query$repos_by_org(org,
                                                  language = language,
                                                  cursor = repo_cursor)
      response <- private$gql_response(
        gql_query = repos_by_org
      )
      response
    },

    #' @description Method to pull all commits from organization, optionally
    #'   filtered by team members.
    #' @param org An organization.
    #' @param date_from A starting date to look commits for.
    #' @param date_until An end date to look commits for.
    #' @param team A character vector of team members.
    #' @return A table of commits.
    pull_commits_from_org = function(org,
                                     date_from,
                                     date_until,
                                     team) {

      repos_table <- private$pull_repos_from_org(
        org = org
      )
      repos_names <- repos_table$name

      cli::cli_alert_info("[GitHub {self$enterprise}][{org}] Pulling commits...")

      pb <- progress::progress_bar$new(
        format = paste0("Checking for commits since ", date_from, " in ", length(repos_names), " repos. [:bar] repo: :current/:total"),
        total = length(repos_names)
      )

      if (is.null(team)) {
        repos_list_with_commits <- purrr::map(repos_names, function(repo) {
          pb$tick()
          private$pull_commits_from_repo(org,
                                        repo,
                                        date_from,
                                        date_until)
        })
      }
      if (!is.null(team)) {
        message("Team ON.")
        authors_ids <- private$get_authors_ids(team)
        repos_list_with_commits <- purrr::map(repos_names, function(repo) {
          pb$tick()
          full_commits_list <- list()
          for (author_id in authors_ids) {
            commits_by_author <-
              private$pull_commits_from_repo(org,
                                            repo,
                                            date_from,
                                            date_until,
                                            author_id)
            full_commits_list <-
              append(full_commits_list, commits_by_author)
          }
          return(full_commits_list)
        })
      }
      names(repos_list_with_commits) <- repos_names

      commits_table <- repos_list_with_commits %>%
        purrr::discard(~ length(.) == 0) %>%
        private$prepare_commits_table_gql()

      return(commits_table)
    },

    #' @description A paginating wrapper over GraphQL commit query.
    #' @param org An organization.
    #' @param date_from A starting date to look commits for.
    #' @param date_until An end date to look commits for.
    #' @return A list of commits.
    pull_commits_from_repo = function(org,
                                     repo,
                                     date_from,
                                     date_until,
                                     author_id = '') {
      next_page <- TRUE
      full_commits_list <- list()
      commits_cursor <- ''
      while (next_page) {
        commits_response <- private$pull_commits_page_from_repo(org = org,
                                                              repo = repo,
                                                              date_from = date_from,
                                                              date_until = date_until,
                                                              commits_cursor = commits_cursor,
                                                              author_id = author_id)
        commits_list <- commits_response$data$repository$defaultBranchRef$target$history$edges
        next_page <- commits_response$data$repository$defaultBranchRef$target$history$pageInfo$hasNextPage
        if (is.null(next_page)) next_page <- FALSE
        if (is.null(commits_list)) commits_list <- list()
        if (next_page) {
          commits_cursor <- commits_response$data$repository$defaultBranchRef$target$history$pageInfo$endCursor
        } else {
          commits_cursor <- ''
        }
        full_commits_list <- append(full_commits_list, commits_list)
      }
      full_commits_list
    },

    #' @description
    #' @param
    #' @return
    pull_commits_page_from_repo = function(org,
                                           repo,
                                           date_from,
                                           date_until,
                                           commits_cursor = '',
                                           author_id = '') {
      commits_by_org_query <- self$gql_query$commits_by_repo(
        org = org,
        repo = repo,
        since = date_to_gts(date_from),
        until = date_to_gts(date_until),
        cursor = commits_cursor,
        author_id = author_id
      )
      response <- private$gql_response(
        gql_query = commits_by_org_query
      )
      response
    },

    #' @description Wrapper over GraphQL response.
    #' @param team A character vector of team members.
    #' @return A character vector of GitHub's author's IDs.
    get_authors_ids = function(team) {

      purrr::map_chr(team, ~{
        authors_id_query <- self$gql_query$users_id(.)
        authors_id_response <- private$gql_response(
          gql_query = authors_id_query
        )
        authors_id_response$data$user$id
        })

    },

    #' @description Pull all organisations form API.
    #' @param org_limit An integer defining how many org may API pull.
    #' @return A character vector of organizations names.
    pull_all_organizations = function(org_limit = self$org_limit) {

      total_count <- private$rest_response(
        endpoint = paste0(self$rest_api_url, "/search/users?q=type:org")
      )[["total_count"]]

      if (total_count > org_limit) {
        warning("Number of organizations exceeds limit (", org_limit, "). I will pull only first ", org_limit, " organizations.",
                call. = FALSE,
                immediate. = FALSE
        )
        org_n <- org_limit
      } else {
        cli::cli_alert("Pulling all organizations.")
        org_n <- total_count
      }

      orgs_endpoint <- paste0(self$rest_api_url, "/organizations?per_page=100")

      orgs_list <- private$rest_response(
        endpoint = orgs_endpoint
      )

      while (length(orgs_list) < org_n) {
        last_id <- tail(purrr::map_dbl(orgs_list, ~ .$id), 1)
        endpoint <- paste0(orgs_endpoint, "&since=", last_id)
        orgs_list <- private$rest_response(
          endpoint = endpoint
        ) %>%
          append(orgs_list, .)
      }

      org_names <- purrr::map_chr(orgs_list, ~ .$login)
      org_n <- length(org_names)

      cli::cli_alert_success(cli::col_green(
        "Pulled {org_n} organizations."))

      return(org_names)
    },

    #' @description Pull organisations from API in which are engaged team members.
    #' @param team A character vector of team members.
    #' @return A character vector of organizations names.
    pull_team_organizations = function(team) {
      cli::cli_alert("Pulling organizations by team.")
      orgs_list <- purrr::map(team, function(team_member) {
        suppressMessages({
          private$rest_response(
            endpoint = paste0(self$rest_api_url, "/users/", team_member, "/orgs")
          )
        })
      }) %>%
        purrr::keep(~length(.) > 0) %>%
        unique()

      org_names <- purrr::map(orgs_list, ~purrr::map_chr(., ~ .$login)) %>% unlist()
      org_n <- length(org_names)

      cli::cli_alert_success(cli::col_green(
        "Pulled {org_n} organizations."))

      return(org_names)
    },

    #' @description Method to filter repositories by language used
    #' @param repos_list A repository list to be filtered.
    #' @param language A character specifying language used in repositories.
    #' @return A list of repositories.
    filter_by_language = function(repos_list,
                                  language) {
      purrr::keep(repos_list, ~ length(intersect(.$language, language)) > 0)
    },

    #' @description A helper to retrieve only important info on repos
    #' @param repos_list A list, a formatted content of response returned by GET API request
    #' @return A list of repos with selected information
    tailor_repos_info = function(repos_list) {
      repos_list <- purrr::map(repos_list, function(x) {
        list(
          "organisation" = x$owner$login,
          "name" = x$name,
          "created_at" = x$created_at,
          "last_activity_at" = x$updated_at,
          "forks" = x$forks_count,
          "stars" = x$stargazers_count,
          "contributors" = paste0(x$contributors, collapse = ","),
          "issues" = x$issues,
          "issues_open" = x$issues_open,
          "issues_closed" = x$issues_closed,
          "description" = x$description
        )
      })

      repos_list
    },

    #' @description Search code by phrase
    #' @param phrase A phrase to look for in
    #'   codelines.
    #' @param org A character, an organization of repositories.
    #' @param language A character specifying language used in repositories.
    #' @param byte_max According to GitHub
    #'   documentation only files smaller than 384 KB are searchable. See
    #'   \link{https://docs.github.com/en/rest/search?apiVersion=2022-11-28#search-code}
    #'
    #' @return A list of repositories.
    search_by_keyword = function(phrase,
                                 org,
                                 language,
                                 byte_max = "384000") {
      search_endpoint <- if (!is.null(language)) {
        paste0(self$rest_api_url, "/search/code?q='", phrase, "'+user:", org, "+language:", language)
      } else {
        paste0(self$rest_api_url, "/search/code?q='", phrase, "'+user:", org)
      }

      total_n <- private$rest_response(search_endpoint)[["total_count"]]

      if (length(total_n) > 0) {
        repos_list <- private$search_response(
          search_endpoint = search_endpoint,
          total_n = total_n,
          byte_max = byte_max
        )
        repos_list <- purrr::map_chr(repos_list, ~ as.character(.$repository$id)) %>%
          unique() %>%
          private$find_by_id(objects = "repositories")
      } else {
        repos_list <- list()
      }

      return(repos_list)
    },

    #' @description A wrapper for proper pagination of GitHub search REST API
    #' @param search_endpoint A character, a search endpoint
    #' @param total_n Number of results
    #' @param byte_max Max byte size
    #' @return A list
    search_response = function(search_endpoint,
                               total_n,
                               byte_max) {
      if (total_n > 0 & total_n < 100) {
        resp_list <- private$rest_response(
          paste0(search_endpoint, "+size:0..", byte_max, "&page=1&per_page=100")
        )[["items"]]

        resp_list
      } else if (total_n >= 100 & total_n < 1e3) {
        resp_list <- list()

        for (page in 1:(total_n %/% 100)) {
          resp_list <- private$rest_response(
            paste0(search_endpoint, "+size:0..", byte_max, "&page=", page, "&per_page=100")
          )[["items"]] %>%
            append(resp_list, .)
        }

        resp_list
      } else if (total_n >= 1e3) {
        resp_list <- list()
        index <- c(0, 50)

        pb <- progress::progress_bar$new(
          format = "GitHub search limit (1000 results) exceeded. Results will be divided. :elapsedfull"
        )

        while (index[2] < as.numeric(byte_max)) {
          size_formula <- paste0("+size:", as.character(index[1]), "..", as.character(index[2]))

          pb$tick(0)

          n_count <- tryCatch(
            {
              private$rest_response(paste0(search_endpoint, size_formula)
              )[["total_count"]]
            },
            error = function(e) {
              NULL
            }
          )

          if (is.null(n_count)) {
            NULL
          } else if ((n_count - 1) %/% 100 > 0) {
            for (page in (1:(n_count %/% 100) + 1)) {
              resp_list <- private$rest_response(paste0(search_endpoint, size_formula, "&page=", page, "&per_page=100")
              )[["items"]] %>% append(resp_list, .)
            }
          } else if ((n_count - 1) %/% 100 == 0) {
            resp_list <- private$rest_response(paste0(search_endpoint, size_formula, "&page=1&per_page=100")
            )[["items"]] %>%
              append(resp_list, .)
          }

          index[1] <- index[2]

          if (index[2] < 1e3) {
            index[2] <- index[2] + 50
          }
          if (index[2] >= 1e3 && index[2] < 1e4) {
            index[2] <- index[2] + 100
          }
          if (index[2] >= 1e4 && index[2] < 1e5) {
            index[2] <- index[2] + 1000
          }
          if (index[2] >= 1e5 && index[2] < 1e6) {
            index[2] <- index[2] + 10000
          }
        }

        resp_list
      }
    },

    #' @description Filter repositories by contributors.
    #' @details If at least one member of a team is a contributor than a project
    #'   passes through the filter.
    #' @param repos_table A repository table to be filtered.
    #' @param team A character vector with team member names.
    #' @return A repos table.
    filter_repos_by_team = function(repos_table,
                                    team) {
      cli::cli_alert_info("Filtering by team members.")
      repos_table <- repos_table %>%
        dplyr::filter(contributors %in% team)
      return(repos_table)
    },

    #' @description Parses repositories list into table.
    #' @param repos_list A list of repositories.
    #' @param org An organization of repositories.
    #' @return Table of repositories.
    prepare_repos_table_gql = function(repos_list,
                                       org) {

      repo_table <- purrr::map_dfr(repos_list, function(repo) {
        repo$node$languages <- purrr::map_chr(repo$node$languages$nodes, ~.$name) %>%
          paste0(collapse = ", ")
        repo$node$contributors <- purrr::map_chr(repo$node$contributors$target$history$edges,
                                                     ~{if (!is.null(.$node$committer$user)){
                                                         .$node$committer$user$login
                                                       } else {
                                                         ""
                                                       }
                                                       }) %>%
          purrr::discard(~. == "") %>%
          unique() %>%
          paste0(collapse = ", ")
        repo$node$issues_open <- repo$node$issues_open$totalCount
        repo$node$issues_closed <- repo$node$issues_closed$totalCount
        data.frame(repo$node)

      })
      repo_table <- dplyr::rename(
        repo_table,
        stars = stargazerCount,
        forks = forkCount,
        created_at = createdAt,
        last_push = pushedAt,
        last_activity = updatedAt
      ) %>%
        dplyr::mutate(
          organization = org,
          api_url = self$rest_api_url
        )
    },

    #' @description Parses repositories' list with commits into table of commits.
    #' @param repos_list_with_commits A list of repositories with commits.
    #' @return Table of commits.
    prepare_commits_table_gql = function(repos_list_with_commits) {
      commits_table <- purrr::imap(repos_list_with_commits, function(repo, repo_name) {
        commits_row <- purrr::map_dfr(repo, function(commit) {
          commit$node$author <- commit$node$author$name
          commit$node
        })
        commits_row$repository <- repo_name
        commits_row
      }) %>%
        purrr::discard(~length(.) == 1) %>%
        rbindlist()

      if (nrow(commits_table) > 0) {
        commits_table <- commits_table %>%
          dplyr::rename(committed_date = committedDate)
      }
    }
  )
)
