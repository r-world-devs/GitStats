#' @noRd
#' @description A helper class to cache and mock results.
TestMock <- R6::R6Class("TestMock",
   public = list(

     mocker = list(),

     mock = function(object = NULL) {
       object_name <- deparse(substitute(object))
       self$mocker[[paste0(object_name)]] <- object
     }
   )
)

