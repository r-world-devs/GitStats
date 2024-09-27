#' @noRd
show_message <- function(host,
                         engine,
                         scope = NULL,
                         code = NULL,
                         information) {
  msg_graphql <- cli::col_yellow('GraphQl')
  msg_rest <- cli::col_green('REST')
  engine_msg <- if (engine == "graphql") {
    msg_graphql
  } else if (engine == "rest") {
    msg_rest
  } else if (engine == "both") {
    paste0(msg_rest, "&", msg_graphql)
  }
  message <- if (is.null(scope)) {
    glue::glue("[Host:{host}][Engine:{engine_msg}] {information}...")
  } else {
    glue::glue("[Host:{host}][Engine:{engine_msg}][Scope:{scope}] {information}...")
  }
  cli::cli_alert_info(message)
}
