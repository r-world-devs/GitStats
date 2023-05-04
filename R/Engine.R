#' @importFrom dplyr filter
#' @importFrom purrr keep
#'
#' @title An Engine class
#' @description A super class for methods wrapping API responses.
#'
Engine <- R6::R6Class("Engine",

  public = list(

    #' @description Create new `Engine` object.
    initialize = function(){

    }
  ),

  private = list(
    # @field token A token authorizing access to API.
    token = NULL,

    # @description Filter repositories by contributors.
    # @details If at least one member of a team is a contributor than a project
    #   passes through the filter.
    # @param repos_table A repository table to be filtered.
    # @param language A language used in repository.
    # @return A repos table.
    filter_repos_by_language = function(repos_table,
                                        language) {
      cli::cli_alert_info("Filtering by language.")
      filtered_langs <- purrr::keep(repos_table$languages, function(row) {
        grepl(language, row)
      })
      repos_table <- repos_table %>%
        dplyr::filter(languages %in% filtered_langs)
      return(repos_table)
    }
  )
)
