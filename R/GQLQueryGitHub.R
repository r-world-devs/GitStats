#' @noRd
#' @title A GQLQueryGitHub class
#' @description A class with methods to build GraphQL Queries for GitHub.

GQLQueryGitHub <- R6::R6Class("GQLQueryGitHub",
  public = list(

    #' @description Prepare query to list organizations from GitHub.
    #' @param end_cursor An end cursor to paginate.
    #' @return A query.
    orgs = function(end_cursor) {
      if (is.null(end_cursor)) {
        pagination_phrase <- ''
      } else {
        pagination_phrase <- paste0('after: "', end_cursor, '"')
      }
      paste0(
        'query {
          search(first: 100, type: USER, query: "type:org" ', pagination_phrase, ') {
            pageInfo {
               hasNextPage
               endCursor
            }
            edges {
              node{
                ... on Organization {
                  name
                  url
                }
              }
            }
          }
        }'
      )
    },

    #' @description Query to check if a given string is user or organization.
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

    #' @description Prepare query to get repositories from GitHub.
    #' @return A query.
    repos_by_org = function() {
      paste0('
        query GetReposByOrg($login: String! $repoCursor: String!) {
          repositoryOwner(login: $login) {
            ... on Organization {
              ', private$repositories_field(), '
            }
          }
        }')
    },

    #' @description Prepare query to get repositories from GitHub.
    #' @return A query.
    repos_by_user = function() {
      paste0('
        query GetUsersRepos($login: String! $repoCursor: String!){
          user(login: $login) {
            ', private$repositories_field(), '
          }
        }'
      )
    },

    #' @description Prepare query to get info on a GitHub user.
    #' @return A query.
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

    #' @description Prepare query to get commits on GitHub.
    #' @param commits_cursor An endCursor.
    #' @return A query.
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
                          ', private$add_cursor(commits_cursor), ") {
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
        }")
    },

    #' @description Prepare query to get files in a standard filepath from
    #'   GitHub repositories.
    #' @return A query.
    file_blob_from_repo = function() {
      'query GetFileBlobFromRepo($org: String!, $repo: String!, $expression: String!) {
          repository(owner: $org, name: $repo) {
            repo_id: id
            repo_name: name
            repo_url: url
            file: object(expression: $expression) {
              ... on Blob {
                text
                byteSize
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

    #' @description Prepare query to get releases from GitHub repositories.
    #' @return A query.
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
    # @description Helper over defining cursor agument for the query.
    # @param cursor A cursor.
    # @return A string of cursor argument.
    add_cursor = function(cursor) {
      if (nchar(cursor) == 0) {
        cursor_argument <- cursor
      } else {
        cursor_argument <- paste0('after: "', cursor, '"')
      }
      return(cursor_argument)
    },

    # @description Helper to prepare repository query.
    repositories_field = function() {
      '
      repositories(first: 100 after: $repoCursor) {
        totalCount
        pageInfo {
          endCursor
          hasNextPage
        }
        nodes {
          repo_id: id
          repo_name: name
          default_branch: defaultBranchRef {
            name
          }
          stars: stargazerCount
          forks: forkCount
          created_at: createdAt
          last_activity_at: pushedAt
          languages (first: 5) { nodes {name} }
          issues_open: issues (first: 100 states: [OPEN]) {
            totalCount
          }
          issues_closed: issues (first: 100 states: [CLOSED]) {
            totalCount
          }
          organization: owner {
            login
          }
          repo_url: url
        }
      }
      '
    }
  )
)
