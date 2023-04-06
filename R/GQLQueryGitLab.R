#' @title A GQLQueryGitLab class
#' @description A class with methods to build GraphQL Queries for GitLab.

GQLQueryGitLab <- R6::R6Class("GQLQueryGitLab",

  inherit = GQLQuery,

  public = list(

    #' @description Method to build query to pull projects by group.
    #' @param group A group of projects.
    #' @param projects_cursor A cursor.
    #' @return A query.
    projects_by_group = function(group,
                                 projects_cursor){

      paste0('{
        group(fullPath: "', group, '") {
          projects(first: 100',
                   private$add_cursor(projects_cursor),') {
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
      }')

    }
  )
)
