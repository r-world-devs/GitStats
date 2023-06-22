#' @title A GQLQueryGitLab class
#' @description A class with methods to build GraphQL Queries for GitLab.

GQLQueryGitLab <- R6::R6Class("GQLQueryGitLab",
  public = list(

    #' @description Prepare query to get repositories from GitLab.
    #' @param repo_cursor An end cursor for repositories page.
    #' @return A query.
    repos_by_org = function(repo_cursor = "") {
      if (nchar(repo_cursor) == 0) {
        after_cursor <- repo_cursor
      } else {
        after_cursor <- paste0('after: "', repo_cursor, '" ')
      }
      paste0('query GetReposByOrg($org: ID!) {
        group(fullPath: $org) {
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
                stars: starCount
                forks: forksCount
                created_at: createdAt
                last_activity_at: lastActivityAt
                languages {
                  name
                }
                issues: issueStatusCounts {
                  all
                  closed
                  opened
                }
                group {
                  name
                }
                repo_url: webUrl
              }
            }
          }
        }
      }')
    },

    #' @description Prepare query to get info on a GitLab user.
    #' @return A query.
    user = function() {
      paste0('
        query GetUser($user: String!) {
          user(username: $user) {
            id
            name
            login: username
            email: publicEmail
            location
            starred_repos: starredProjects {
              count
            }
            pull_requests: authoredMergeRequests {
              count
            }
            reviews: reviewRequestedMergeRequests {
              count
            }
            avatar_url: avatarUrl
            web_url: webUrl
          }
        }
      ')
    }
  )
)
