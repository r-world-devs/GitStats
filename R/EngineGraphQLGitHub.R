#' @title A EngineGraphQLGitHub class
#' @description A class for methods wraping GitHub's GraphQL API responses.
EngineGraphQLGitHub <- R6::R6Class("EngineGraphQLGitHub",
  inherit = EngineGraphQL,
  public = list(
    #' @description Create `EngineGraphQLGitHub` object.
    #' @param gql_api_url GraphQL API url.
    #' @param token A token.
    initialize = function(gql_api_url,
                          token) {
      super$initialize(
        gql_api_url = gql_api_url,
        token = token
      )
      self$gql_query <- GQLQueryGitHub$new()
    },

    #' @description A method to retrieve all repositories for an organization in
    #'   a table format.
    #' @param org A character, an organization:\itemize{\item{GitHub - owners o
    #'   repositories} \item{GitLab - group of projects.}}
    #' @return A table.
    get_repos_from_org = function(org) {
      cli::cli_alert_info("[GitHub][{org}][Engine:{cli::col_yellow('GraphQL')}] Pulling repositories...")
      repos_table <- private$pull_repos_from_org(org = org) %>%
        private$prepare_repos_table(org = org)
      return(repos_table)
    },

    #' @description Method to pull all commits from organization, optionally
    #'   filtered by team members.
    #' @param org An organization.
    #' @param repos_table A table of repositories.
    #' @param date_from A starting date to look commits for.
    #' @param date_until An end date to look commits for.
    #' @param by A character, 'org' or 'team'.
    #' @param team A list of team members.
    #' @return A table of commits.
    get_commits_from_org = function(org,
                                    repos_table,
                                    date_from,
                                    date_until,
                                    by,
                                    team) {
      repos_names <- repos_table$name

      if (by == "org") {
        cli::cli_alert_info("[GitHub][{org}][Engine:{cli::col_yellow('GraphQL')}] Pulling commits...")
        repos_list_with_commits <- private$pull_commits_from_repos(
          org = org,
          repos = repos_names,
          date_from = date_from,
          date_until = date_until
        )
      }
      if (by == "team") {
        cli::cli_alert_info("[GitHub][{org}][Engine:{cli::col_yellow('GraphQL')}] Pulling commits by team...")
        repos_list_with_commits <- private$pull_commits_from_repos(
          org = org,
          repos = repos_names,
          date_from = date_from,
          date_until = date_until,
          team_filter = TRUE,
          team = team
        )
      }
      names(repos_list_with_commits) <- repos_names

      commits_table <- repos_list_with_commits %>%
        purrr::discard(~ length(.) == 0) %>%
        private$prepare_commits_table(org)

      return(commits_table)
    }
  ),
  private = list(

    #' @description Iterator over pulling pages of repositories.
    #' @param org An organization.
    #' @return A list of repositories from organization.
    pull_repos_from_org = function(org) {
      full_repos_list <- list()
      next_page <- TRUE
      repo_cursor <- ""
      while (next_page) {
        repos_response <- private$pull_repos_page_from_org(
          org = org,
          repo_cursor = repo_cursor
        )
        repositories <- repos_response$data$repositoryOwner$repositories
        repos_list <- repositories$nodes
        next_page <- repositories$pageInfo$hasNextPage
        if (is.null(next_page)) next_page <- FALSE
        if (is.null(repos_list)) repos_list <- list()
        if (next_page) {
          repo_cursor <- repositories$pageInfo$endCursor
        } else {
          repo_cursor <- ""
        }
        full_repos_list <- append(full_repos_list, repos_list)
      }
      return(full_repos_list)
    },

    #' @description Parses repositories list into table.
    #' @param repos_list A list of repositories.
    #' @param org An organization of repositories.
    #' @return Table of repositories.
    prepare_repos_table = function(repos_list,
                                   org) {
      repos_table <- purrr::map_dfr(repos_list, function(repo) {
        repo$languages <- purrr::map_chr(repo$languages$nodes, ~ .$name) %>%
          paste0(collapse = ", ")
        repo$contributors <- purrr::map_chr(
          repo$contributors$target$history$edges,
          ~ {
            if (!is.null(.$node$committer$user)) {
              .$node$committer$user$login
            } else {
              ""
            }
          }
        ) %>%
          purrr::discard(~ . == "") %>%
          unique() %>%
          paste0(collapse = ", ")
        repo$created_at <- gts_to_posixt(repo$created_at)
        repo$issues_open <- repo$issues_open$totalCount
        repo$issues_closed <- repo$issues_closed$totalCount
        repo$last_activity_at <- difftime(Sys.time(), as.POSIXct(repo$last_activity_at),
          units = "days"
        ) %>% round(2)
        data.frame(repo)
      })
      repos_table <- dplyr::mutate(
        repos_table,
        organization = org,
        api_url = gsub("/graphql", "", self$gql_api_url)
      ) %>%
        dplyr::relocate(
          repo_url,
          .after = organization
        )
      return(repos_table)
    },

    #' @description Iterator over pulling commits from all repositories.
    #' @param org An organization.
    #' @param repos A character vector of repository names.
    #' @param date_from A starting date to look commits for.
    #' @param date_until An end date to look commits for.
    #' @param team_filter A boolean.
    #' @param team A list of team members.
    #' @return A list of repositories with commits.
    pull_commits_from_repos = function(org,
                                       repos,
                                       date_from,
                                       date_until,
                                       team_filter = FALSE,
                                       team = NULL) {
      pb <- progress::progress_bar$new(
        format = paste0("Checking for commits since ", date_from, " in ", length(repos), " repos. [:bar] repo: :current/:total"),
        total = length(repos)
      )
      if (team_filter) {
        authors_ids <- private$get_authors_ids(team) %>%
          purrr::discard(~ . == "")
      }
      repos_list_with_commits <- purrr::map(repos, function(repo) {
        if (interactive()) pb$tick()
        if (!team_filter) {
          private$pull_commits_from_one_repo(
            org,
            repo,
            date_from,
            date_until
          )
        } else {
          full_commits_list <- list()
          for (author_id in authors_ids) {
            commits_by_author <-
              private$pull_commits_from_one_repo(
                org,
                repo,
                date_from,
                date_until,
                author_id
              )
            full_commits_list <-
              append(full_commits_list, commits_by_author)
          }
          return(full_commits_list)
        }
      })
      return(repos_list_with_commits)
    },

    #' @description An iterator over pulling commit pages from one repository.
    #' @param org An organization.
    #' @param repo A repository name.
    #' @param date_from A starting date to look commits for.
    #' @param date_until An end date to look commits for.
    #' @param author_id Id of an author.
    #' @return A list of commits.
    pull_commits_from_one_repo = function(org,
                                          repo,
                                          date_from,
                                          date_until,
                                          author_id = "") {
      next_page <- TRUE
      full_commits_list <- list()
      commits_cursor <- ""
      while (next_page) {
        commits_response <- private$pull_commits_page_from_repo(
          org = org,
          repo = repo,
          date_from = date_from,
          date_until = date_until,
          commits_cursor = commits_cursor,
          author_id = author_id
        )
        commits_list <- commits_response$data$repository$defaultBranchRef$target$history$edges
        next_page <- commits_response$data$repository$defaultBranchRef$target$history$pageInfo$hasNextPage
        if (is.null(next_page)) next_page <- FALSE
        if (is.null(commits_list)) commits_list <- list()
        if (next_page) {
          commits_cursor <- commits_response$data$repository$defaultBranchRef$target$history$pageInfo$endCursor
        } else {
          commits_cursor <- ""
        }
        full_commits_list <- append(full_commits_list, commits_list)
      }
      return(full_commits_list)
    },

    #' @description Wrapper over building GraphQL query and response.
    #' @param org An organization
    #' @param repo A repository.
    #' @param date_from A starting date to look commits for.
    #' @param date_until An end date to look commits for.
    #' @param commits_cursor An end cursor for commits page.
    #' @param author_id Id of an author.
    #' @return A list.
    pull_commits_page_from_repo = function(org,
                                           repo,
                                           date_from,
                                           date_until,
                                           commits_cursor = "",
                                           author_id = "") {
      commits_by_org_query <- self$gql_query$commits_by_repo(
        org = org,
        repo = repo,
        since = date_to_gts(date_from),
        until = date_to_gts(date_until),
        commits_cursor = commits_cursor,
        author_id = author_id
      )
      response <- self$gql_response(
        gql_query = commits_by_org_query
      )
      return(response)
    },

    #' @description Parses repositories' list with commits into table of commits.
    #' @param repos_list_with_commits A list of repositories with commits.
    #' @param org An organization of repositories.
    #' @return Table of commits.
    prepare_commits_table = function(repos_list_with_commits,
                                     org) {
      commits_table <- purrr::imap(repos_list_with_commits, function(repo, repo_name) {
        commits_row <- purrr::map_dfr(repo, function(commit) {
          commit$node$author <- commit$node$author$name
          commit$node$committed_date <- gts_to_posixt(commit$node$committed_date)
          commit$node
        })
        commits_row$repository <- repo_name
        commits_row
      }) %>%
        purrr::discard(~ length(.) == 1) %>%
        rbindlist()

      if (nrow(commits_table) > 0) {
        commits_table <- commits_table %>%
          dplyr::mutate(
            organization = org,
            api_url = gsub("/graphql", "", self$gql_api_url)
          )
      }
      return(commits_table)
    },

    #' @description Wrapper over GraphQL response.
    #' @param team A character vector of team members.
    #' @return A character vector of GitHub's author's IDs.
    get_authors_ids = function(team) {
      logins <- purrr::map(team, ~ .$logins) %>%
        unlist()
      ids <- purrr::map_chr(logins, ~ {
        authors_id_query <- self$gql_query$users_id(.)
        authors_id_response <- self$gql_response(
          gql_query = authors_id_query
        )
        result <- authors_id_response$data$user$id
        if (is.null(result)) {
          result <- ""
        }
        return(result)
      })
      return(unname(ids))
    }
  )
)
