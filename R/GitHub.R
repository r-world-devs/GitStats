#' @importFrom R6 R6Class
#' @importFrom dplyr mutate
#' @importFrom magrittr %>%
#' @importFrom rlang expr %||%
#' @importFrom cli cli_alert cli_alert_success col_green
#'
#' @title A GitHub API Client class
#' @description An object with methods to obtain information form GitHub API.

GitHub <- R6::R6Class("GitHub",
  inherit = GitService,
  cloneable = FALSE,
  public = list(

    #' @field repos_endpoint An expression for repositories endpoint.
    repos_endpoint = rlang::expr(paste0(self$rest_api_url, "/orgs/", org, "/repos")),

    #' @field repo_contributors_endpoint An expression for repositories contributors endpoint.
    repo_contributors_endpoint = rlang::expr(paste0(self$rest_api_url, "/repos/", repo$full_name, "/contributors")),

    #' @description A print method for a GitHub object
    print = function() {
      cat("GitHub API Client", sep = "\n")
      cat(paste0(" url: ", self$rest_api_url), sep = "\n")
      orgs <- paste0(self$orgs, collapse = ", ")
      cat(paste0(" orgs: ", orgs), sep = "\n")
    }
  ),
  private = list(

    #' @description Pull all organisations form API.
    #' @param org_limit An integer defining how many org may API pull.
    #' @return A character vector of organizations names.
    pull_all_organizations = function(org_limit = self$org_limit) {

      total_count <- get_response(
        endpoint = paste0(self$rest_api_url, "/search/users?q=type:org"),
        token = private$token
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

      orgs_list <- get_response(
        endpoint = orgs_endpoint,
        token = private$token
      )

      while (length(orgs_list) < org_n) {
        last_id <- tail(purrr::map_dbl(orgs_list, ~ .$id), 1)
        endpoint <- paste0(orgs_endpoint, "&since=", last_id)
        orgs_list <- get_response(
          endpoint = endpoint,
          token = private$token
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
        get_response(
          endpoint = paste0(self$rest_api_url, "/users/", team_member, "/orgs"),
          token = private$token
        )
      }) %>%
        purrr::keep(~length(.) > 0) %>%
        unique()

      org_names <- purrr::map(orgs_list, ~purrr::map_chr(., ~ .$login)) %>% unlist()
      org_n <- length(org_names)

      cli::cli_alert_success(cli::col_green(
        "Pulled {org_n} organizations."))

      return(org_names)
    },

    #' @description Method to pull repositories' issues.
    #' @param repos_list A list of repositories.
    #' @return A list of repositories.
    pull_repos_issues = function(repos_list) {
      repos_list <- purrr::map(repos_list, function(repo) {
        issues <- get_response(
          endpoint = paste0(self$rest_api_url, "/repos/", repo$full_name, "/issues"),
          token = private$token
        )

        issues_stats <- list()
        issues_stats[["issues"]] <- length(issues)
        issues_stats[["issues_open"]] <- length(purrr::keep(issues, ~ .$state == "open"))
        issues_stats[["issues_closed"]] <- length(purrr::keep(issues, ~ .$state == "closed"))

        return(issues_stats)
      }) %>%
        purrr::map2(repos_list, function(issue, repository) {
          purrr::list_modify(repository,
            issues = issue$issues,
            issues_open = issue$issues_open,
            issues_closed = issue$issues_closed
          )
        })

      repos_list
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

      total_n <- get_response(search_endpoint,
        token = private$token
      )[["total_count"]]

      if (length(total_n) > 0) {
        repos_list <- search_request(
          search_endpoint = search_endpoint,
          total_n = total_n,
          byte_max = byte_max,
          token = private$token
        )
        repos_list <- purrr::map_chr(repos_list, ~ .$repository$id) %>%
          unique() %>%
          private$find_by_id(objects = "repositories")
      } else {
        repos_list <- list()
      }

      return(repos_list)
    },

    #' @description GitHub private method to pull
    #'   commits from repo with REST API.
    #' @param org A character, an owner of repository.
    #' @param date_from A starting date to look commits for.
    #' @param date_until An end date to look commits for.
    #' @return A list of commits.
    pull_commits_from_org = function(org,
                                     date_from,
                                     date_until = Sys.date()) {
      repos_list <- private$pull_repos_from_org(
        org = org
      )

      enterprise_public <- if (self$enterprise) {
        "Enterprise"
      } else {
        "Public"
      }

      repos_names <- purrr::map_chr(repos_list, ~ .$full_name)

      pb <- progress::progress_bar$new(
        format = paste0("GitHub (", enterprise_public, ") Client (", org, "). Checking for commits since ", date_from, " in ", length(repos_names), " repos. [:bar] repo: :current/:total"),
        total = length(repos_names)
      )

      commits_list <- purrr::map(repos_names, function(x) {
        pb$tick()
        tryCatch(
          {
            get_response(
              endpoint = paste0(
                self$rest_api_url,
                "/repos/",
                x,
                "/commits?since=",
                date_to_gts(date_from),
                "&until=",
                date_to_gts(date_until)
              ),
              token = private$token
            )
          },
          error = function(e) {
            NULL
          }
        )
      })
      names(commits_list) <- repos_names

      commits_list <- commits_list %>% purrr::discard(~ length(.) == 0)

      # message("GitHub (", enterprise_public, ") (", org, "): pulled commits from ", length(commits_list), " repositories.")

      commits_list
    },

    #' @description Filter by contributors.
    #' @param commits_list A commits list to be filtered.
    #' @param team A character vector with team member names.
    #' @return A list.
    filter_commits_by_team = function(commits_list,
                                      team) {
      commits_list <- purrr::map(commits_list, function(repo) {
        purrr::keep(repo, function(commit) {
          if (length(commit$author$login > 0)) {
            commit$author$login %in% team
          } else {
            FALSE
          }
        })
      }) %>% purrr::discard(~ length(.) == 0)

      commits_list
    },

    #' @description A helper to retrieve
    #'   only important info on commits
    #' @details In case of GitHub REST API
    #'   there is no possibility to retrieve
    #'   stats from basic get commits API
    #'   endpoint. It is necessary to reach
    #'   to the API endpoint of single
    #'   commit, which is done in
    #'   \code{attach_commit_stats()}
    #'   method. Therefore
    #'   \code{tailor_commits_info()} is
    #'   'poorer" than the same method for
    #'   GitLab Client class, where you can
    #'   derive stats directly from commits
    #'   API endpoint with \code{with_stats}
    #'   attribute.
    #' @param commits_list A list, a
    #'   formatted content of response
    #'   returned by GET API request
    #' @param org A character, name
    #'   of an organisation
    #' @return A list of commits with
    #'   selected information
    tailor_commits_info = function(commits_list,
                                   org) {
      commits_list <- purrr::imap(commits_list, function(repo, repo_name) {
        purrr::map(repo, function(commit) {
          list(
            "id" = commit$sha,
            "organisation" = org,
            "repository" = gsub(
              pattern = paste0(org, "/"),
              replacement = "",
              x = repo_name
            ),
            "committed_date" = commit$commit$committer$date
          )
        })
      })

      commits_list
    },

    #' @description A method to retrieve statistics for commits.
    #' @param commits_list A list of commits.
    #' @return A list.
    attach_commits_stats = function(commits_list) {
      pb <- progress::progress_bar$new(
        format = paste0("Attaching commits stats: [:bar] repo: :current/:total"),
        total = length(commits_list)
      )
      purrr::imap(commits_list, function(repo, repo_name) {
        pb$tick()
        commit_stats <- purrr::map_chr(repo, ~ .$id) %>%
          purrr::map(function(commit_id) {
            commit_info <- get_response(
              endpoint = paste0(self$rest_api_url, "/repos/", repo_name, "/commits/", commit_id),
              token = private$token
            )

            list(
              additions = commit_info$stats$additions,
              deletions = commit_info$stats$deletions,
              files_changes = length(commit_info$files),
              files_added = length(grep("added", purrr::map_chr(commit_info$files, ~ .$status))),
              files_modified = length(grep("modified", purrr::map_chr(commit_info$files, ~ .$status)))
            )
          })

        purrr::map2(repo, commit_stats, function(repo_commit, repo_stats) {
          purrr::list_modify(repo_commit,
            additions = repo_stats$additions,
            deletions = repo_stats$deletions
          )
        })
      })
    }
  )
)
