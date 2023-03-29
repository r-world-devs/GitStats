#' @title A GraphQLQueryGitLab class
#' @description A class with methods to build GraphQL Queries for GitLab.

GraphQLQueryGitLab <- R6::R6Class("GraphQLQueryGitLab",

  inherit = GraphQLQuery,

  public = list(

    #' @description Method to build query to pull GitLab groups by users.
    #' @param team A string of team members.
    #' @return A query.
    groups_by_user = function(team) {
      paste0('{
          users(usernames: ["', team, '"]) {
            pageInfo {
              endCursor
              startCursor
              hasNextPage
            }
            nodes {
              id
              username
              groups {
                edges {
                  node {
                    path
                  }
                }
              }
            }
          }
        }')
    },

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
                createdAt
                stars: starCount
                forks: forksCount
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
