#' @noRd
show_message <- function(host,
                         engine,
                         scope = NULL,
                         code = NULL,
                         information) {
  engine_msg <- if (engine == "graphql") {
    cli::col_yellow('GraphQl')
  } else if (engine == "rest") {
    cli::col_green('REST')
  }
  message <- if (is.null(scope)) {
    glue::glue("[Host:{host}][Engine:{engine_msg}] {information}...")
  } else {
    glue::glue("[Host:{host}][Engine:{engine_msg}][Scope:{scope}] {information}...")
  }
  cli::cli_alert_info(message)
}
