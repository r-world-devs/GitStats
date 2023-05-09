#' @title Create a `GitStats` object
#' @name create_gitstats
#' @examples
#' my_gitstats <- create_gitstats()
#' @return A `GitStats` object.
#' @export
create_gitstats <- function() {
  GitStats$new()
}

#' @title Setting connections
#' @name set_connection
#' @param gitstats_obj A GitStats object.
#' @param api_url A character, url address of API.
#' @param token A token.
#' @param orgs A character vector of organisations (owners of repositories
#'   in case of GitHub and groups of projects in case of GitLab).
#' @return A `GitStats` class object with added information on connection
#'   (`$hosts` field).
#' @examples
#' \dontrun{
#' my_gitstats <- create_gitstats() %>%
#'   set_connection(
#'     api_url = "https://api.github.com",
#'     token = Sys.getenv("GITHUB_PAT"),
#'     orgs = c("r-world-devs", "openpharma", "pharmaverse")
#'   ) %>%
#'   set_connection(
#'     api_url = "https://gitlab.com/api/v4",
#'     token = Sys.getenv("GITLAB_PAT_PUBLIC"),
#'     orgs = "erasmusmc-public-health"
#'   )
#' }
#' @export
set_connection <- function(gitstats_obj,
                           api_url,
                           token,
                           orgs) {
  gitstats_obj$add_host(
    api_url = api_url,
    token = token,
    orgs = orgs
  )

  return(invisible(gitstats_obj))
}

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
setup <- function(gitstats_obj,
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

#' @title Get information on repositories.
#' @name get_repos
#' @description  List all repositories for an organization, a team or by a
#'   keyword.
#' @param gitstats_obj A GitStats object.
#' @return A `GitStats` class object with updated `$repos` field.
#' @examples
#' \dontrun{
#' my_gitstats <- create_gitstats() %>%
#'   set_connection(
#'     api_url = "https://api.github.com",
#'     token = Sys.getenv("GITHUB_PAT"),
#'     orgs = c("r-world-devs", "openpharma", "pharmaverse")
#'   ) %>%
#'   set_connection(
#'     api_url = "https://gitlab.com/api/v4",
#'     token = Sys.getenv("GITLAB_PAT_PUBLIC"),
#'     orgs = "erasmusmc-public-health"
#'   ) %>%
#'   get_repos()
#'
#' }
#' @export
get_repos <- function(gitstats_obj) {
  gitstats_obj$get_repos()
  return(invisible(gitstats_obj))
}

#' @title Get information on commits.
#' @name get_commits
#' @description List all repositories for an organization, a team.
#' @param gitstats_obj  A GitStats object.
#' @param date_from A starting date to look commits for
#' @param date_until An end date to look commits for
#' @return A `GitStats` class object with updated `$commits` field.
#' @examples
#' \dontrun{
#' my_gitstats <- create_gitstats() %>%
#'   set_connection(
#'     api_url = "https://api.github.com",
#'     token = Sys.getenv("GITHUB_PAT"),
#'     orgs = c("r-world-devs", "openpharma", "pharmaverse")
#'   ) %>%
#'   set_connection(
#'     api_url = "https://gitlab.com/api/v4",
#'     token = Sys.getenv("GITLAB_PAT_PUBLIC"),
#'     orgs = "erasmusmc-public-health"
#'   ) %>%
#'   get_commits(date_from = "2020-01-01")
#' }
#' @export
get_commits <- function(gitstats_obj,
                        date_from = NULL,
                        date_until = Sys.time()) {
  gitstats_obj$get_commits(
    date_from = date_from,
    date_until = date_until
  )

  return(invisible(gitstats_obj))
}
