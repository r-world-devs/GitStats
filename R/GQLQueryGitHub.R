#' @title A GQLQueryGitHub class
#' @description A class with methods to build GraphQL Queries for GitHub.

GQLQueryGitHub <- R6::R6Class("GQLQueryGitHub",
  public = list(

    #' @description Prepare query to get repositories from GitHub.
    #' @param org An organization of repositories.
    #' @param repo_cursor An end cursor for repositories page.
    #' @return A query.
    repos_by_org = function(org, repo_cursor = "") {
      if (nchar(repo_cursor) == 0) {
        after_cursor <- repo_cursor
      } else {
        after_cursor <- paste0('after: "', repo_cursor, '" ')
      }

      paste0('
        query {
          repositoryOwner(login: "', org, '") {
            ... on Organization {
              repositories(first: 100 ', after_cursor, ') {
              ', private$repository_field(),'
              }
            }
          }
        }')
    },

    #' @description Prepare query to get repositories from GitHub.
    #' @param user A GitHub user.
    #' @param repo_cursor An end cursor for repositories page.
    #' @return A query.
    repos_by_user = function(user, repo_cursor = "") {
      if (nchar(repo_cursor) == 0) {
        after_cursor <- repo_cursor
      } else {
        after_cursor <- paste0('after: "', repo_cursor, '" ')
      }

      paste0('
        query {
          user(login: "', user, '") {
            repositories(
              first: 100
              ownerAffiliations: COLLABORATOR
              ', after_cursor, ') {
              ', private$repository_field(),'
            }
          }
        }')
    },

    #' @description Prepare query to get info on a GitHub user.
    #' @param login A login of a user.
    #' @return A query.
    user = function(login) {
      paste0('{
        user(login: "', login, '") {
          id
          name
          email
          bio
          location
          updatedAt
          repositories(first: 100) {
            edges {
              node {
                name
              }
            }
          }
          followers(first: 100) {
            totalCount
          }
          following(first: 100) {
            totalCount
          }
          status {
            id
          }
        }
      }')
    },

    #' @description Prepare query to get commits on GitHub.
    #' @param org A GitHub organization.
    #' @param repo Name of a repository.
    #' @param since Git Time Stamp of starting date of commits.
    #' @param until Git Time STamp of end date of commits.
    #' @param commits_cursor An endCursor.
    #' @param author_id An Id of an author.
    #' @return A query.
    commits_by_repo = function(org,
                               repo,
                               since,
                               until,
                               commits_cursor = "",
                               author_id = "") {
      if (nchar(author_id) == 0) {
        author_filter <- author_id
      } else {
        author_filter <- paste0('author: { id: "', author_id, '"}')
      }

      paste0('{
          repository(name: "', repo, '", owner: "', org, '") {
            defaultBranchRef {
              target {
                ... on Commit {
                  history(since: "', since, '"
                          until: "', until, '"
                          ', private$add_cursor(commits_cursor), "
                          ", author_filter, ") {
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
                          }
                          additions
                          deletions
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }")
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
    repository_field = function() {
      paste0(
       'totalCount
        pageInfo {
          endCursor
          hasNextPage
        }
        nodes {
          id
          name
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
          contributors: defaultBranchRef {
            target {
              ... on Commit {
                id
                history(since: "2000-01-01T00:00:00Z") {
                  edges {
                    node {
                      committer {
                        user {
                          login
                          id
                        }
                      }
                    }
                  }
                }
              }
            }
          }
          organization: owner {
            login
          }
          repo_url: url
        }'
      )
    }
  )
)
