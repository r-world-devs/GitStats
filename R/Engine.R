#' @title An Engine class
#' @description A super class for methods wrapping API responses.
#'
Engine <- R6::R6Class("Engine",
  public = list(
    #' @description Create `Engine` class.
    initialize = function(token) {
      private$token <- token
    }
  ),
  private = list(
    #' @field token A token authorizing access to API.
    token = NULL
  )
)
