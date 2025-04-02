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
  information <- cli::col_br_blue(information)
  message <- if (is.null(scope)) {
    glue::glue("[Host:{host}][Engine:{engine_msg}] {information}...")
  } else {
    glue::glue("[Host:{host}][Engine:{engine_msg}][Scope:{scope}] {information}...")
  }
  cli::cli_alert(message)
}

set_repo_scope <- function(org, private) {
  paste0(org, ": ", length(private$orgs_repos[[org]]), " repos")
}

cut_item_to_print <- function(item_to_print) {
  if (length(item_to_print) < 10) {
    list_items <- paste0(item_to_print, collapse = ", ")
  } else {
    item_to_print_cut <- item_to_print[1:10]
    list_items <- paste0(item_to_print_cut, collapse = ", ") %>%
      paste0("... and ", length(item_to_print) - 10, " more")
  }
  return(list_items)
}
