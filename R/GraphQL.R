#' @title A GraphQL class
#' @description An object with methods to build GraphQL Queries.

GraphQL <- R6::R6Class("GraphQL",
                       public = list(

                         #' @description Prepare query to pull repositories for GitHub organization.
                         #' @param org An organization.
                         #' @param cursor An endCursor.
                         #' @return A query.
                         gh_repos_by_org = function(org, cursor) {

                           if (nchar(cursor) == 0) {
                             after_cursor <- cursor
                           } else {
                             after_cursor <- paste0('after: "', cursor, '"')
                           }

                           paste0('{
                              search(query: "org:', org, '"
                                     type: REPOSITORY
                                     first: 100
                                     ', after_cursor, '
                                     ) {
                                repositoryCount
                                pageInfo{
                                  hasNextPage
                                  endCursor
                                }
                                edges {
                                  node {
                                    ... on Repository {
                                      name
                                      stargazerCount
                                      forkCount
                                    }
                                  }
                                }
                              }
                            }')
                         },

                         #' @description Prepare query to pull repositories for GitHub user.
                         #' @param user A user login.
                         #' @param cursor An endCursor.
                         #' @return A query.
                         gh_repos_by_user = function(user) {

                           paste0('{
                            user(login: "', user, '"){
                              repositories (first:100) {
                                pageInfo {
                                   hasNextPage
                                   endCursor
                                }
                                edges {
                                  node {
                                    name
                                    stargazerCount
                                    forkCount
                                  }
                                }
                              }
                            }
                          }')

                         },

                         #' @description Prepare query to get ID of a GitHub user
                         #' @param login A login of a user.
                         #' @return A query.
                         users_id = function(login) {
                            paste0('{
                              user(login: "', login, '") {
                                id
                              }
                            }')
                         },

                         #' @description Prepare query to get commits on GitHub
                         #' @param org A GitHub organization
                         #' @param repo Name of a repository
                         #' @param since Git Time Stamp of starting date of commits.
                         #' @param until Git Time STamp of end date of commits.
                         #' @param cursor An endCursor.
                         #' @param author_id An Id of an author.
                         #' @return A query.
                         gh_commits = function(org, repo, since, until, cursor = '', author_id = '') {

                           if (nchar(cursor) == 0) {
                             after_cursor <- cursor
                           } else {
                             after_cursor <- paste0('after: "', cursor, '"')
                           }

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
                                                    ', after_cursor, '
                                                    ', author_filter, ') {
                                              pageInfo {
                                                hasNextPage
                                                endCursor
                                              }
                                              edges {
                                                node {
                                                  ... on Commit {
                                                    id
                                                    committedDate
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
                                  }')
                         },

                         #' @description GitLab. Method to build query to pull groups by users.
                         #' @param team A string of team members.
                         #' @return A query.
                         gl_groups_by_user = function(team) {
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
                         }
                       )
)
