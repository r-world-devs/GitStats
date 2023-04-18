#' @title A GQLQueryGitLab class
#' @description A class with methods to build GraphQL Queries for GitLab.

GQLQueryGitLab <- R6::R6Class("GQLQueryGitLab",
  inherit = GQLQuery,
  public = list(

    #' @description Method to build query to pull projects by group.
    #' @param org A group of projects.
    #' @param repo_cursor A cursor.
    #' @return A query.
    repos_by_org = function(org,
                            repo_cursor = "") {
      paste0(
        '{
        group(fullPath: "', org, '") {
          projects(first: 100',
        private$add_cursor(repo_cursor), ") {
            count
            pageInfo {
              hasNextPage
              endCursor
            }
            edges {
              node {
                id
                name
                stars: starCount
                forks: forksCount
                createdAt
                last_activity_at: lastActivityAt
                languages {
                  name
                }
                issueStatusCounts {
                  all
                  closed
                  opened
                }
              }
            }
          }
        }
      }"
      )
    }
  )
)
