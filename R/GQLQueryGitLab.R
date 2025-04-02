#' @noRd
#' @title A GQLQueryGitLab class
#' @description A class with methods to build GraphQL Queries for GitLab.

GQLQueryGitLab <- R6::R6Class("GQLQueryGitLab",
  public = list(

    groups = function() {
      paste0(
        'query GetGroups($groupCursor: String!) {
            groups (after: $groupCursor) {
              pageInfo {
                endCursor
                hasNextPage
              }
              edges {
                node {', private$group_fields, '}
              }
            }
        }'
      )
    },

    group = function() {
      paste0('
      query GetGroup($org: ID!) {
        group(fullPath: $org) {',
             private$group_fields
             , '}
      }
    ')
    },

    user_or_org_query =
      '
      query ($username: String! $grouppath: ID!) {
        user(username: $username) {
          __typename
          username
        }
        group(fullPath: $grouppath) {
          __typename
          fullPath
        }
      }'
    ,

    repos = function(repo_cursor) {
      paste0('
        query GetRepo($projects_ids: [ID!]!) {
          projects(ids: $projects_ids first:100', private$add_cursor(repo_cursor), ') {
          ', private$projects_field_content, '
          }
        }')
    },

    repos_by_org = function() {
      paste0('
        query GetReposByOrg($org: ID! $repo_cursor: String!) {
          group(fullPath: $org) {
            projects(first: 100 after: $repo_cursor) {
            ', private$projects_field_content, '
            }
          }
        }')
    },

    repos_by_user = function() {
      paste0('
        query GetUserRepos ($username: String! $repo_cursor: String!) {
          projects(search: $username searchNamespaces: true after: $repo_cursor first: 100) {
            ', private$projects_field_content, '
          }
        }')
    },

    issues_from_repo = function(issues_cursor = "") {
      paste0('
      query getIssuesFromRepo ($fullPath: ID!) {
          project(fullPath: $fullPath) {
            issues(first: 100
                   ', private$add_cursor(issues_cursor), ') {
              pageInfo {
                hasNextPage
      				  endCursor
      				}
              edges {
                node {
                  number: iid
                  title
                  description
                  created_at: createdAt
                  closed_at: closedAt
                  state
                  url: webUrl
                  author {
                    login: username
                  }
                }
              }
            }
          }
        }
      ')
    },

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

    files_by_org = function(end_cursor = "") {
      paste0(
        'query GetFilesByOrg($org: ID!, $file_paths: [String!]!) {
            group(fullPath: $org) {
              projects(first: 100',
        private$add_cursor(end_cursor),
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
                    path
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
                path
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
  ),
  private = list(
    add_cursor = function(cursor) {
      if (nchar(cursor) == 0) {
        cursor_argument <- cursor
      } else {
        cursor_argument <- paste0('after: "', cursor, '"')
      }
      return(cursor_argument)
    },

    group_fields =
      '
      name
      description
      fullPath
      webUrl
      projectsCount
      groupMembersCount
      avatarUrl
    ',

    projects_field_content =
      '
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
          namespace {
            path: fullPath
          }
          repo_url: webUrl
        }
      }'
  )
)
