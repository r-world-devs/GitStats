#' @noRd
#' @title A GQLQueryGitHub class
#' @description A class with methods to build GraphQL Queries for GitHub.

GQLQueryGitHub <- R6::R6Class("GQLQueryGitHub",
  public = list(

    orgs = function(end_cursor) {
      paste0(
        'query {
          search(first: 100, type: USER, query: "type:org" ', private$add_cursor(end_cursor), ') {
            pageInfo {
               hasNextPage
               endCursor
            }
            edges {
              node{
                ... on Organization {', private$org_fields, '}
              }
            }
          }
        }'
      )
    },

    org = function() {
      paste0(
        '
        query GetOrg($org: String!) {
          organization(login: $org) {', private$org_fields, '}
        }'
      )
    },

    user_or_org_query =
      '
      query ($login: String!) {
        user(login: $login) {
          __typename
          login
        }
        organization(login: $login) {
          __typename
          login
        }
      }'
    ,

    repos_by_ids = function() {
      paste0(
        '
        query GetReposByIds($ids: [ID!]!) {
          nodes(ids: $ids) {
            ... on Repository {', private$repo_node_data, '
            }
          }
        }
        '
      )
    },

    repos_by_org = function(repo_cursor) {
      paste0('
        query GetReposByOrg($login: String!) {
          repositoryOwner(login: $login) {
            ... on Organization {
              ', private$repositories_field(repo_cursor), '
            }
          }
        }')
    },

    repos_by_user = function(repo_cursor) {
      paste0('
        query GetUsersRepos($login: String!){
          user(login: $login) {
            ', private$repositories_field(repo_cursor), '
          }
        }'
      )
    },

    user = function() {
      paste0('
        query GetUser($user: String!) {
          user(login: $user) {
            id
            name
            login
            email
            location
            starred_repos: starredRepositories {
              totalCount
            }
            contributions: contributionsCollection {
              totalIssueContributions
              totalCommitContributions
              totalPullRequestContributions
              totalPullRequestReviewContributions
            }
            avatar_url: avatarUrl
            web_url: websiteUrl
          }
        }')
    },

    commits_from_repo = function(commits_cursor = "") {
      paste0('
      query GetCommitsFromRepo($repo: String!
                               $org: String!
                               $since: GitTimestamp
                               $until: GitTimestamp){
          repository(name: $repo, owner: $org) {
            defaultBranchRef {
              target {
                ... on Commit {
                  history(since: $since
                          until: $until
                          ', private$add_cursor(commits_cursor), ') {
                    pageInfo {
                      hasNextPage
                      endCursor
                    }
                    edges {
                      node {
                        ... on Commit {
                          id
                          committed_date: committedDate
                          author {
                            name
                            user {
                              name
                              login
                            }
                          }
                          additions
                          deletions
                          repository {
                            url
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }')
    },

    issues_from_repo = function(issues_cursor = "") {
      paste0('
      query getIssuesFromRepo ($repo: String!
                               $org: String!) {
          repository(name: $repo, owner: $org) {
            issues(first: 100
                   ', private$add_cursor(issues_cursor), ') {
              pageInfo {
                hasNextPage
      				  endCursor
      				}
              edges {
                node {
                  number
                  title
                  description: body
                  created_at: createdAt
                  closed_at: closedAt
                  state
                  url
                  author {
                    login
                  }
                }
              }
            }
          }
        }
      ')
    },

    file_blob_from_repo = function() {
      'query GetFileBlobFromRepo($org: String!, $repo: String!, $expression: String!) {
          repository(owner: $org, name: $repo) {
            repo_id: id
            repo_name: name
            repo_url: url
            defaultBranchRef {
              target {
                ... on Commit {
                  oid
                }
              }
            }
            file: object(expression: $expression) {
              ... on Blob {
                text
                byteSize
                oid
              }
            }
          }
      }'
    },

    files_tree_from_repo = function() {
      'query GetFilesFromRepo($org: String!, $repo: String!, $expression: String!) {
          repository(owner: $org, name: $repo) {
            id
            name
            url
            object(expression: $expression) {
              ... on Tree {
                entries {
                  name
                  type
                }
              }
            }
          }
      }'
    },

    releases_from_repo = function() {
      'query GetReleasesFromRepo ($org: String!, $repo: String!) {
          repository(owner:$org, name:$repo){
            name
            url
            releases (last: 100) {
              nodes {
                name
                tagName
                publishedAt
                url
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

    org_fields = '
      name
      description
      login
      url
      repositories (first: 100) {
        totalCount
      }
      membersWithRole(first: 100) {
        totalCount
      }
      avatarUrl
    ',

    # @description Helper to prepare repository query.
    repositories_field = function(repo_cursor) {
      paste0('
      repositories(first: 100', private$add_cursor(repo_cursor), ') {
        totalCount
        pageInfo {
          endCursor
          hasNextPage
        }
        nodes {', private$repo_node_data, '}
      }')
    },

    repo_node_data = '
      repo_id: id
      repo_name: name
      repo_path: name
      repo_fullpath: nameWithOwner
      default_branch: defaultBranchRef {
        name
      }
      stars: stargazerCount
      forks: forkCount
      created_at: createdAt
      last_activity_at: pushedAt
      languages(first: 5) {
        nodes {
          name
        }
      }
      issues_open: issues(first: 100, states: [OPEN]) {
        totalCount
      }
      issues_closed: issues(first: 100, states: [CLOSED]) {
        totalCount
      }
      organization: owner {
        login
      }
      repo_url: url
      defaultBranchRef {
        target {
          ... on Commit {
            oid
          }
        }
      }
    '
  )
)
