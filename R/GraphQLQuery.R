#' @title A GraphQL class
#' @description An object with methods to build GraphQL Queries.

GraphQLQuery <- R6::R6Class("GraphQLQuery",

                       public = list(

                         #' @description Prepare query to pull repositories for GitHub organization.
                         #' @param org An organization.
                         #' @param language Language of a repository.
                         #' @param cursor An endCursor.
                         #' @return A query.
                         repos_by_org = function(org, language, cursor) {



                           if (!is.null(language)) {
                             search_query <-
                               paste0('query: "org:', org, ' language:', language, '"')
                           } else {
                             search_query <- paste0('query: "org:', org, '"')
                           }

                           if (nchar(cursor) == 0) {
                             after_cursor <- cursor
                           } else {
                             after_cursor <- paste0('after: "', cursor, '"')
                           }

                           paste0('{
                              search(', search_query, '
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
                                      id
                                      name
                                      createdAt
                                      pushedAt
                                      updatedAt
                                      stargazerCount
                                      forkCount
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
                                            history(since: "2020-01-01T00:00:00Z") {
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
                         commits_by_repo = function(org, repo, since, until, cursor = '', author_id = '') {

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
                          },

                         #' @description description
                         #' @param group
                         #' @return return
                         projects_by_group = function(group){

                           paste0('{
                            group(fullPath: "', group, '") {
                              projects(first: 100) {
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
                                    stars: starCount
                                    forks: forksCount
                                    last_activity_at: lastActivityAt
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
