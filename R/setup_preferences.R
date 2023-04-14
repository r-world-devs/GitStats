#' @title Set up your search parameters.
#' @name setup_preferences
#' @param gitstats_obj A GitStats object.
#' @param search_param One of three: team, orgs or phrase.
#' @param team_name Name of a team.
#' @param phrase A phrase to look for.
#' @param language A language of programming code.
#' @return A `GitStats` object.
#' @export
setup_preferences <- function(gitstats_obj,
                              search_param = NULL,
                              team_name = NULL,
                              phrase = NULL,
                              language = NULL) {
  gitstats_obj$setup_preferences(
    search_param = search_param,
    team_name = team_name,
    phrase = phrase,
    language = language
  )

  return(gitstats_obj)
}
