#' @title Add your team member
#' @name add_team_member
#' @description Passes information on team member to your `team` field.
#' @param gitstats_obj `GitStats` object.
#' @param member_name Name of a member.
#' @param ... All user logins.
#' @return `GitStats` object with new information on team member.
#' @examples
#' \dontrun{
#' my_gitstats <- create_gitstats() %>%
#'   add_team_member("Peter Parker", "spider_man", "spidey") %>%
#'   add_team_member("Tony Stark", "ironMan", "tony_s")
#' }
#' @export
add_team_member <- function(gitstats_obj,
                            member_name,
                            ...) {
  gitstats_obj$add_team_member(
    member_name = member_name,
    ... = ...
  )

  return(invisible(gitstats_obj))
}
