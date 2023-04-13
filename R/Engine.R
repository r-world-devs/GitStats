Engine <- R6::R6Class("Engine",
  public = list(
    initialize = function(token) {
      private$token <- token
    }
  ),
  private = list(
    token = NULL
  )
)
