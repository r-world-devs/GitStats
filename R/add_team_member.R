#' @title Add your team member
#' @name add_team_member
#' @description Passes information on team member to your `team` field.
#' @param gitstats_obj `GitStats` object.
#' @param member_name Name of a member.
#' @param gh_login A GitHub login.
#' @param gl_login A GitLab login.
#' @return `GitStats` object with new information on team member.
#' @example \dontrun{ my_gitstats <- create_gitstats() %>%
#'   add_team_member("Peter Parker", gh_login = "spider_man", gl_login =
#'   "spidey") %>% add_team_member("Tony Stark", gh_login = "ironMan", gl_login
#'   = "i_man") }
#' @export
add_team_member <- function(gitstats_obj,
                            member_name,
                            gh_login = NULL,
                            gl_login = NULL) {

  gitstats_obj$add_team_member(member_name = member_name,
                               gh_login = gh_login,
                               gl_login = gl_login)

  return(invisible(gitstats_obj))
}
