#' @noRd
#' @description A helper class to cache and mock results.
Mocker <- R6::R6Class("Mocker",
  public = list(

    #' @field storage A list to store objects.
    storage = list(),

    #' @description Method to cache objects.
    cache = function(object = NULL) {
      object_name <- deparse(substitute(object))
      self$storage[[paste0(object_name)]] <- object
    },

    #' @description Method to retrieve objects.
    use = function(object_name) {
      self$storage[[paste0(object_name)]]
    }
  )
)
