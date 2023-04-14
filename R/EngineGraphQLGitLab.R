#' @title A EngineGraphQLGitLab class
#' @description A class for methods wraping GitLab's GraphQL API responses.
EngineGraphQLGitLab <- R6::R6Class("EngineGraphQLGitLab",
  inherit = EngineGraphQL,
  public = list(
    #' @description Create `EngineGraphQLGitLab` object.
    #' @param gql_api_url A GraphQL API url
    #' @param token A token.
    initialize = function(gql_api_url,
                          token) {
      super$initialize(
        gql_api_url = gql_api_url,
        token = token
      )
      self$gql_query <- GQLQueryGitLab$new()
    },

    #' @description A method to pull all repositories for an organization.
    #' @param org A character, an organization:\itemize{\item{GitHub - owners o
    #'   repositories} \item{GitLab - group of projects.}}
    #' @return A list.
    get_repos_from_org = function(org) {
      cli::cli_alert_info("[GitLab][{org}][Engine:{cli::col_yellow('GraphQL')}] Pulling repositories...")
      full_repos_list <- list()
      next_page <- TRUE
      repo_cursor <- ""
      while (next_page) {
        repos_response <- private$pull_repos_page_from_org(
          org = org,
          repo_cursor = repo_cursor
        )
        repositories <- repos_response$data$group$projects
        repos_list <- repositories$edges
        next_page <- repositories$pageInfo$hasNextPage
        repo_cursor <- repositories$pageInfo$endCursor

        full_repos_list <- append(full_repos_list, repos_list)
      }

      repos_table <- repos_list %>%
        private$prepare_repos_table(org = org)

      return(repos_table)
    }
  ),
  private = list(

    #' @description Wrapper over building GraphQL query and response.
    #' @param org An organization
    #' @param repo_cursor An end cursor for repos page.
    #' @return A list.
    pull_repos_page_from_org = function(org, repo_cursor) {
      repos_by_org_query <- self$gql_query$projects_by_group(
        group = org,
        projects_cursor = repo_cursor
      )
      response <- self$gql_response(
        gql_query = repos_by_org_query
      )
      response
    },

    #' @description Parses repositories list into table.
    #' @param repos_list A list of repositories.
    #' @param org An organization of repositories.
    #' @return Table of repositories.
    prepare_repos_table = function(repos_list,
                                   org) {
      repos_table <- purrr::map_dfr(repos_list, function(repo) {
        issues_counts <- repo$node$issueStatusCounts
        repo_row <- data.frame(
          "id" = repo$node$id,
          "name" = repo$node$name,
          "stars" = repo$node$stars,
          "forks" = repo$node$forks,
          "created_at" = gts_to_posixt(repo$node$createdAt),
          "last_push" = NA,
          "last_activity_at" = difftime(Sys.time(),
            as.POSIXct(repo$node$last_activity_at),
            units = "days"
          ) %>% round(2),
          "languages" = if (length(repo$node$languages) > 0) {
            purrr::map_chr(repo$node$languages, ~ .$name) %>%
              paste0(collapse = ", ")
          } else {
            ""
          },
          "issues_open" = if (!is.null(issues_counts)) {
            issues_counts$opened
          } else {
            NA
          },
          "issues_closed" = if (!is.null(issues_counts)) {
            issues_counts$closed
          } else {
            NA
          },
          "contributors" = NA,
          "organization" = org,
          "api_url" = gsub("/graphql", "", self$gql_api_url),
          "repo_url" = paste0(
            gsub("/graphql", "", self$gql_api_url),
            "/projects/",
            gsub("gid://gitlab/Project/", "", repo$node$id)
          )
        )
        repo_row
      })
      return(repos_table)
    }
  )
)
