#' @noRd
#' @description A superclass for API connections.
Engine <- R6::R6Class("Engine",
  private = list(
    # A token authorizing access to API.
    token = NULL,

    # Is scanning whole git platform switched on?
    scan_all = FALSE,

    # Engine type.
    engine = NULL,

    # Print messages or not.
    verbose = TRUE,

    # Set verbose mode
    set_verbose = function(verbose) {
      private$verbose <- verbose
    }
  )
)
