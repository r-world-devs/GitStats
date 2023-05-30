#' @title A GQLQueryGitLab class
#' @description A class with methods to build GraphQL Queries for GitLab.

GQLQueryGitLab <- R6::R6Class("GQLQueryGitLab",
  public = list(

    #' @description Prepare query to get repositories from GitLab.
    #' @param org An group of projects.
    #' @param repo_cursor An end cursor for repositories page.
    #' @return A query.
    repos_by_org = function(org, repo_cursor = "") {
      if (nchar(repo_cursor) == 0) {
        after_cursor <- repo_cursor
      } else {
        after_cursor <- paste0('after: "', repo_cursor, '" ')
      }
      paste0('{
        group(fullPath: "', org, '") {
          projects(first: 100 ', after_cursor, ') {
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
                starCount
                forksCount
                lastActivityAt
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
