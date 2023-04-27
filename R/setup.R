#' @title Set up your search settings.
#' @name setup
#' @param gitstats_obj A GitStats object.
#' @param search_param One of three: team, orgs or phrase.
#' @param team_name Name of a team.
#' @param phrase A phrase to look for.
#' @param language A language of programming code.
#' @param print_out A boolean to decide whether to print output
#' @return A `GitStats` object.
#' @export
setup<- function(gitstats_obj,
                 search_param = NULL,
                 team_name = NULL,
                 phrase = NULL,
                 language = NULL,
                 print_out = TRUE) {
  gitstats_obj$setup(
    search_param = search_param,
    team_name = team_name,
    phrase = phrase,
    language = language,
    print_out = print_out
  )

  return(gitstats_obj)
}
