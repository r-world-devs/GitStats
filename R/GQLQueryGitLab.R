#' @noRd
#' @title A GQLQueryGitLab class
#' @description A class with methods to build GraphQL Queries for GitLab.

GQLQueryGitLab <- R6::R6Class("GQLQueryGitLab",
  public = list(

    #' @description Prepare query to list groups from GitLab.
    #' @return A query.
    groups = function() {
      'query GetGroups($groupCursor: String!) {
            groups (after: $groupCursor) {
              pageInfo {
                endCursor
                hasNextPage
              }
              edges {
                node {
                  fullPath
                }
              }
            }
        }'
    },

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
                repo_id: id
                repo_name: name
                repo_path: path
                ... on Project {
                  repository {
                    rootRef
                  }
                }
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
                  path
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
    },

    #' @description Prepare query to get files in a standard filepath from
    #'   GitLab repositories.
    #' @param end_cursor An endCursor.
    #' @return A query.
    files_by_org = function(end_cursor = "") {
      if (nchar(end_cursor) == 0) {
        after_cursor <- end_cursor
      } else {
        after_cursor <- paste0('after: "', end_cursor, '" ')
      }
      paste0(
        'query GetFilesByOrg($org: ID!, $file_paths: [String!]!) {
            group(fullPath: $org) {
              projects(first: 100',
        after_cursor,
        ') {
          count
          pageInfo {
            hasNextPage
            endCursor
          }
          edges {
            node {
              name
              id
              webUrl
              repository {
                blobs(paths: $file_paths) {
                  nodes {
                    name
                    rawBlob
                    size
                  }
                }
              }
            }
          }
        }
      }
    }'
      )
    },

    file_blob_from_repo = function() {
      '
      query GetFilesByRepo($fullPath: ID!, $file_paths: [String!]!) {
        project(fullPath: $fullPath) {
          name
          id
          webUrl
          repository {
            blobs(paths: $file_paths) {
              nodes {
                name
                rawBlob
                size
              }
            }
          }
        }
      }
      '
    },

    files_tree_from_repo = function() {
      '
      query GetFilesTree ($fullPath: ID!, $file_path: String!) {
        project(fullPath: $fullPath) {
          repository {
            tree(path: $file_path) {
              trees (first: 100) {
                pageInfo{
                  endCursor
                  hasNextPage
                }
                nodes {
                  name
                }
              }
              blobs (first: 100) {
                pageInfo{
                  endCursor
                  hasNextPage
                }
                nodes {
                  name
                }
              }
            }
          }
        }
      }
      '
    },

    #' @description Prepare query to get releases from GitHub repositories.
    #' @return A query.
    releases_from_repo = function() {
      'query GetReleasesFromRepo($project_path: ID!) {
              project(fullPath: $project_path) {
                name
                webUrl
    						releases {
                  nodes{
                    name
                    tagName
                    releasedAt
                    links {
                      selfUrl
                    }
                    description
                  }
                }
              }
          }'
    }
  )
)
