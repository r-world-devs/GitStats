#' @title A GraphQL class
#' @description An object with methods to build GraphQL Queries.

GraphQL <- R6::R6Class("GraphQL",
                       public = list(

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

                         #' @description GitHub
                         gh_commits_by_org = function(org, repo, since, until, cursor = '') {

                           if (nchar(cursor) == 0) {
                             after_cursor <- cursor
                           } else {
                             after_cursor <- paste0('after: "', cursor, '"')
                           }

                           paste0('{
                                    repository(name: "', repo, '", owner: "', org, '") {
                                      defaultBranchRef {
                                        target {
                                          ... on Commit {
                                            history(since: "', since, '" until: "', until, '"', after_cursor, ') {
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
                                                    changedFilesIfAvailable
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
                         #' @return A character.
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
