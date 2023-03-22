#' @importFrom R6 R6Class
#' @importFrom dplyr mutate
#' @importFrom magrittr %>%
#' @importFrom rlang expr %||%
#' @importFrom cli cli_alert cli_alert_success col_green
#'
#' @title A GitLab API Client class
#' @description An object with methods to obtain information form GitLab API.

GitLab <- R6::R6Class("GitLab",
  inherit = GitService,
  cloneable = FALSE,
  public = list(

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

      language <- private$language_handler(language)

      if (is.null(orgs)) {
        cli::cli_alert_warning(paste0("No organizations specified for ", self$git_service, "."))
        orgs <- private$pull_organizations(type = by,
                                           team = team)
      }

      repos_dt <- purrr::map(orgs, function(org) {
        if (by %in% c("org", "team")) {
          repos_list <- private$pull_repos_from_org(org = org,
                                                    language = language)
          if (by == "team") {
            repos_list <- private$filter_repos_by_team(
              repos_list = repos_list,
              team = team
            )
          }
          if (!is.null(language)) {
            repos_list <- private$filter_by_language(
              repos_list = repos_list,
              language = language
            )
          }
          return(repos_list)
        }

        if (by == "phrase") {
          repos_list <- private$search_by_keyword(phrase,
                                                  org = org,
                                                  language = language
          )
          cli::cli_alert_success(paste0("\n On ", self$git_service, " ('", org, "') found ", length(repos_list), " repositories."))
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
    },

    #' @description A print method for a GitLab object
    print = function() {
      cat("GitLab API Client", sep = "\n")
      cat(paste0(" url: ", self$rest_api_url), sep = "\n")
      orgs <- paste0(self$orgs, collapse = ", ")
      cat(paste0(" orgs: ", orgs), sep = "\n")
    }
  ),
  private = list(

    #' @description Pull all groups form API.
    #' @param org_limit An integer defining how many org may API pull.
    #' @return A character vector of groups names.
    pull_all_organizations = function(org_limit = self$org_limit) {
      cli::cli_alert("Pulling all organizations...")
      total_pages <- org_limit %/% 100

      pb <- progress::progress_bar$new(
        format = paste0("[:bar] page: :current/:total"),
        total = total_pages
      )
      pb$tick(-1)
      orgs_list <- list()
      o_page <- 1
      still_more_hits <- TRUE
      while (length(orgs_list) < org_limit || !still_more_hits) {
        pb$tick()
        orgs_page <- private$rest_response(
          endpoint = paste0(self$rest_api_url, "/groups?all_available=true&per_page=100&page=", o_page)
        )
        if (length(orgs_page) > 0) {
          orgs_list <- append(orgs_list, orgs_page)
          o_page <- o_page + 1
        } else {
          still_more_hits <- FALSE
        }
      }

      org_names <- purrr::map_chr(orgs_list, ~ .$path)
      org_n <- length(org_names)

      cli::cli_alert_success(cli::col_green(
        "Pulled {org_n} organizations."))

      return(org_names)
    },

    #' @description Pull organisations from API in which are engaged team
    #'   members.
    #' @details Makes use of GraphQL API as there is no reasonable way to do it
    #'   in GitLab's REST API.
    #' @param team A character vector of team members.
    #' @return A character vector of organizations names.
    pull_team_organizations = function(team) {
      cli::cli_alert("Pulling organizations by team.")

      team <- paste0(team, collapse = '", "')

      gql_query <- self$groups_by_user(team)

      json_data <- gql_response(
                     api_url = paste0(self$gql_api_url),
                     gql_query = gql_query,
                     token = private$token
                   )

      org_names <- purrr::map(json_data$data$users$nodes, function(node) {
        if (length(node$groups) > 0) {
          full_id <- purrr::map_chr(node$groups$edges, ~.$node$path)
        }
      }) %>% purrr::discard(~length(.) == 0) %>% unlist()

      org_n <- length(org_names)

      cli::cli_alert_success(cli::col_green(
        "Pulled {org_n} organizations."))

      return(org_names)
    },

    #' @description A method to pull all repositories for an organization.
    #' @param org A character, an organization:\itemize{\item{GitHub - owners o
    #'   repositories} \item{GitLab - group of projects.}}
    #' @param language
    #' @return A list.
    pull_repos_from_org = function(org,
                                   language) {

      cli::cli_alert_info("[GitLab][{org}] Pulling repositories...")
      next_page <- TRUE
      full_repos_list <- list()
      repo_cursor <- ''
      while (next_page) {
        repos_response <- private$pull_repos_page_from_org(org = org,
                                                           language = language,
                                                           repo_cursor = repo_cursor)
        repositories <- repos_response$data$group$projects
        if (length(full_repos_list) == 0) {
          cli::cli_alert_info("Number of repositories: {repositories$count}")
        }
        repos_list <- repositories$edges
        next_page <- repositories$pageInfo$hasNextPage
        repo_cursor <- repositories$pageInfo$endCursor

        full_repos_list <- append(full_repos_list, repos_list)
      }

      repos_table <- repos_list %>%
        private$prepare_repos_table_gql()
        # private$pull_repos_contributors()

      return(repos_table)
    },

    pull_repos_page_from_org = function(org, language, repo_cursor) {
      repos_by_org <- self$gql_query$projects_by_group(group = org)
      response <- private$gql_response(
        gql_query = repos_by_org
      )
      response
    },

    #' @description Method to pull repositories' issues.
    #' @param repos_list A list of repositories.
    #' @return A list of repositories.
    pull_repos_issues = function(repos_list) {
      projects_ids <- unique(purrr::map_chr(repos_list, ~ as.character(.$id)))

      repos_list <- purrr::map(projects_ids, function(project_id) {
        issues_stats <- private$rest_response(
          endpoint = paste0(self$rest_api_url, "/projects/", project_id, "/issues_statistics")
        )

        issues_stats
      }) %>%
        purrr::map2(repos_list, function(issue, repository) {
          purrr::list_modify(repository,
            issues = issue$statistics$counts$all,
            issues_open = issue$statistics$counts$opened,
            issues_closed = issue$statistics$counts$closed
          )
        })

      repos_list
    },

    #' @description Filter projects by programming
    #'   language
    #' @param repos_list A list of repositories to be
    #'   filtered.
    #' @param language A character, name of a
    #'   programming language.
    #' @details This method is specific for GitLab
    #'   Client class as there is no possibility
    #'   currently to add language filter to search
    #'   endpoint. As for now, an epic is in progress
    #'   on GitLab to add this feature. For more
    #'   details you can visit:
    #'   \link{https://gitlab.com/gitlab-org/gitlab/-/issues/342648}
    #' @return A list of projects where speicfied
    #'   language is used.
    filter_by_language = function(repos_list,
                                  language) {
      projects_id <- unique(purrr::map_chr(repos_list, ~ as.character(.$id)))

      projects_language_list <- purrr::map(projects_id, function(x) {
        private$rest_response(
          endpoint = paste0(self$rest_api_url, "/projects/", x, "/languages")
        )
      })

      names(projects_language_list) <- projects_id

      filtered_projects <- purrr::map(projects_language_list, function(x) {
        purrr::map_chr(x, ~.)
      }) %>%
        purrr::keep(~ language %in% names(.))

      if (length(filtered_projects) > 0) {
        purrr::keep(repos_list, ~ .$id %in% names(filtered_projects))
      } else {
        list()
      }
    },

    #' @description A helper to retrieve only important info on repos
    #' @param projects_list A list, a formatted content of response returned by GET API request
    #' @return A list of repos with selected information
    tailor_repos_info = function(projects_list) {
      projects_list <- purrr::map(projects_list, function(x) {
        list(
          "organization" = x$namespace$path,
          "name" = x$name,
          "created_at" = x$created_at,
          "last_activity_at" = x$last_activity_at,
          "forks" = x$fork_count,
          "stars" = x$star_count,
          "contributors" = paste0(x$contributors, collapse = ","),
          "issues_open" = x$issues_open,
          "issues_closed" = x$issues_closed
        )
      })

      projects_list
    },

    #' @description Perform get request to search API.
    #' @param phrase A phrase to look for in codelines.
    #' @param org A character, a group of projects.
    #' @param language A character specifying language used in repositories.
    #' @param page_max An integer, maximum number of pages.
    #' @return A list of repositories.
    search_by_keyword = function(phrase,
                                 org,
                                 language,
                                 page_max = 1e6) {
      page <- 1
      still_more_hits <- TRUE
      resp_list <- list()
      groups_id <- private$get_group_id(org)

      while (still_more_hits | page < page_max) {
        resp <- private$rest_response(
          paste0(self$rest_api_url, "/groups/", groups_id,
                 "/search?scope=blobs&search=", phrase, "&per_page=100&page=", page)
        )

        if (length(resp) == 0) {
          still_more_hits <- FALSE
          break()
        } else {
          resp_list <- append(resp_list, resp)
          page <- page + 1
        }
      }

      repos_list <- purrr::map_chr(resp_list, ~ as.character(.$project_id)) %>%
        unique() %>%
        private$find_by_id(objects = "projects")

      return(repos_list)
    },

    #' @description GitLab private method to derive
    #'   commits from repo with REST API.
    #' @param org A character, a group of projects.
    #' @param date_from A starting date to look commits for.
    #' @param date_until An end date to look commits for.
    #' @return A list of commits
    pull_commits_from_org = function(org,
                                       date_from,
                                       date_until = Sys.date()) {
      repos_list <- private$pull_repos_from_org(
        org = org
      )

      repos_names <- purrr::map_chr(repos_list, ~ .$name)
      projects_ids <- purrr::map_chr(repos_list, ~ as.character(.$id))

      pb <- progress::progress_bar$new(
        format = paste0("GitLab (", org, "). Checking for commits since ", date_from, " in ", length(repos_names), " repos. [:bar] repo: :current/:total"),
        total = length(repos_names)
      )

      commits_list <- purrr::map(projects_ids, function(x) {
        pb$tick()

        private$rest_response(
          endpoint = paste0(
            self$rest_api_url,
            "/projects/",
            x,
            "/repository/commits?since='",
            date_to_gts(date_from),
            "'&until='",
            date_to_gts(date_until),
            "'&with_stats=true"
          )
        )
      })

      names(commits_list) <- repos_names

      commits_list <- commits_list %>%
        purrr::discard(~ length(.) == 0)

      return(commits_list)
    },

    #' @description Filter by contributors.
    #' @param commits_list A commits list to be filtered.
    #' @param team A character vector with team member names.
    #' @return A list.
    filter_commits_by_team = function(commits_list,
                                      team) {
      commits_list <- purrr::map(commits_list, function(repo) {
        purrr::keep(repo, function(commit) {
          if (length(commit$author_name > 0)) {
            commit$author_name %in% team
          } else {
            FALSE
          }
        })
      }) %>% purrr::discard(~ length(.) == 0)

      commits_list
    },

    #' @description A helper to retrieve only important info on commits
    #' @param commits_list A list, a formatted content of response returned by
    #'   GET API request
    #' @param org A character, name of a group
    #' @return A list of commits with selected information
    tailor_commits_info = function(commits_list,
                                   org) {
      commits_list <- purrr::map(commits_list, function(x) {
        purrr::map(x, function(y) {
          list(
            "id" = y$id,
            "organisation" = org,
            "repository" = gsub(
              pattern = paste0("/-/commit/", y$id),
              replacement = "",
              x = gsub(paste0("(.*)", org, "/"), "", y$web_url)
            ),
            "additions" = y$stats$additions,
            "deletions" = y$stats$deletions,
            "committed_date" = y$committed_date
          )
        })
      })

      commits_list
    },

    prepare_repos_table_gql = function(repos_list) {

      repos_table <- purrr::map_dfr(repos_list, function(repo) {
        data.frame(
          "id" = repo$node$id,
          "name" = repo$node$name,
          "created_at" = repo$node$createdAt,
          "last_activity_at" = repo$node$last_activity_at,
          "stars" = repo$node$stars,
          "forks" = repo$node$forks,
          "languages" = if (length(repo$node$languages) > 0) {
            purrr::map_chr(repo$node$languages, ~.$name)
          } else {
            ''
          },
          "issues_open" = repo$node$issueStatusCounts$opened,
          "issues_closed" = repo$node$issueStatusCounts$closed
        )
      })
      return(repos_table)
    },

    #' @description Switcher to manage language names
    #' @details E.g. GitLab API will not filter
    #'   properly if you provide 'python' language
    #'   with small letter.
    #' @param language A character, language name
    #' @return A character
    language_handler = function(language) {
      if (!is.null(language)) {
        substr(language, 1, 1) <- toupper(substr(language, 1, 1))
      }

      language
    },

    #' @description A helper to get group's id
    #' @param project_group A character, a group of projects.
    #' @return An integer, id of group.
    get_group_id = function(project_group) {
      private$rest_response(paste0(self$rest_api_url, "/groups/", project_group)
      )[["id"]]
    }
  )
)
