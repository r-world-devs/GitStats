#' @title A GraphQL class
#' @description An object with methods to build GraphQL Queries.

GraphQL <- R6::R6Class("GraphQL",
                       public = list(

                         commits_by_org = function(org, repo, since, until) {
                           paste0('{
                                    repository(name: "', repo, '", owner: "', org, '") {
                                      defaultBranchRef {
                                        target {
                                          ... on Commit {
                                            history(since: "', since, '" until: "', until, '") {
                                              edges {
                                                node {
                                                  ... on Commit {
                                                    id
                                                    committedDate
                                                    author {
                                                      email
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

                         #' @description Method to build query to pull groups by users.
                         #' @param team A string of team members.
                         #' @return A character.
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
                         }
                       )
)
