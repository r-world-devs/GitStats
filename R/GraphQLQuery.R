#' @title A GraphQLQuery class
#' @description A superclass for GraphQL Queries.

GraphQLQuery <- R6::R6Class("GraphQLQuery",

   private = list(

     #' @description Helper over defining cursor agument for the query.
     #' @param cursor A cursor.
     #' @return A string of cursor argument.
     add_cursor = function(cursor) {
       if (nchar(cursor) == 0) {
         cursor_argument <- cursor
       } else {
         cursor_argument <- paste0('after: "', cursor, '"')
       }
       return(cursor_argument)
     }

   )
)
