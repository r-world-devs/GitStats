handle_graphql_error <- function(responses_list, verbose) {
  if (inherits(responses_list, "graphql_error")) {
    if (verbose) cli::cli_alert_danger("GraphQL returned errors.")
    if (inherits(responses_list, "graphql_no_fields_error")) {
      if (verbose) {
        error_fields <- purrr::map_vec(responses_list$errors, ~.$extensions$fieldName)
        cli::cli_alert_info("Your GraphQL does not recognize [{error_fields}] field{?s}.")
        cli::cli_alert_warning("Check version of your GitLab.")
      }
    }
  } else if (any(purrr::map_lgl(responses_list, ~ inherits(., "graphql_error")))) {
    class(responses_list) <- c("graphql_error", class(responses_list))
    if (verbose) cli::cli_alert_danger("GraphQL returned errors.")
    check <- any(purrr::map_lgl(responses_list, ~ inherits(., "graphql_no_fields_error")))
    if (check && verbose) {
      error_fields <- purrr::map_vec(responses_list, ~ purrr::map(.$errors, ~.$extensions$fieldName) |> purrr::discard(is.null)) |> unique()
      cli::cli_alert_info("Your GraphQL does not recognize [{error_fields}] field{?s}.")
      cli::cli_alert_warning("Check version of your GitLab.")
    }
  }
  return(responses_list)
}
