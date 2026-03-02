Engine <- R6::R6Class("Engine",
  private = list(
    token = NULL,
    scan_all = FALSE,
    engine = NULL,
    verbose = TRUE,
    set_verbose = function(verbose) {
      private$verbose <- verbose
    }
  )
)
