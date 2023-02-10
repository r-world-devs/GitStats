#' @title A GraphQLQuery class
#' @description An object with methods to build GraphQL Queries.

GraphQLQuery <- R6::R6Class("GraphQLQuery",
                       public = list(

                         #' @description Method to build query to pull groups by users.
                         #' @param team A string of team members.
                         #' @return A character.
                         groups_by_user = function(team) {
                           paste0('{ users(usernames: ["', team, '"]) { pageInfo { endCursor startCursor hasNextPage } nodes { id username, groups { edges { node { name } } } } } }')
                         }
                       )
)
