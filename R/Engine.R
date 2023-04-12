Engine <- R6::R6Class("Engine",
  public = list(
    initialize = function(token) {
      private$token <- token
    }
  ),
  private = list(
    token = NULL,

    #' @description Check whether the token exists.
    #' @param token A token.
    #' @return A token.
    check_token = function(token) {
      if (nchar(token) == 0) {
        cli::cli_abort(c(
          "i" = "No token provided.",
          "x" = "Host will not be passed to `GitStats` object."
        ))
      } # else if (nchar(token) > 0) {
        # withCallingHandlers({
        #   check_endpoint <- if (client$git_service == "GitLab") {
        #     paste0(client$rest_api_url, "/projects")
        #   } else if (client$git_service == "GitHub") {
        #     client$rest_api_url
        #   }
        #   client$rest_engine$response(endpoint = check_endpoint)
        # },
        # message = function(m) {
        #   if (grepl("401", m)) {
        #     cli::cli_abort(c(
        #       "i" = "Token provided for ... is invalid.",
        #       "x" = "Host will not be passed to `GitStats` object."
        #     ))
        #   }
        # })
      # }
      return(token)
    }
  )
)
