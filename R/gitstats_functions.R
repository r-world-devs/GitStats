#' @title Create a `GitStats` object
#' @name create_gitstats
#' @examples
#' my_gitstats <- create_gitstats()
#' @return A `GitStats` object.
#' @export
create_gitstats <- function() {
  GitStats$new()
}

#' @title Add Git host
#' @name add_host
#' @param gitstats_obj A GitStats object.
#' @param api_url A character, url address of API.
#' @param token A token.
#' @param orgs A character vector of organisations (owners of repositories in
#'   case of GitHub and groups of projects in case of GitLab). You do not need
#'   to define `orgs` if you wish to scan whole internal Git platform (such as
#'   enterprise version of GitHub or GitLab). In case of a public one (like
#'   GitHub) you need to define `orgs` as scanning through all organizations
#'   would be an overkill.
#' @return A `GitStats` class object with added information on connection
#'   (`$hosts` field).
#' @examples
#' \dontrun{
#' my_gitstats <- create_gitstats() %>%
#'   add_host(
#'     api_url = "https://api.github.com",
#'     orgs = c("r-world-devs", "openpharma", "pharmaverse")
#'   ) %>%
#'   add_host(
#'     api_url = "https://gitlab.com/api/v4",
#'     token = Sys.getenv("GITLAB_PAT_PUBLIC"),
#'     orgs = "erasmusmc-public-health"
#'   )
#' }
#' @export
add_host <- function(gitstats_obj,
                     api_url,
                     token = NULL,
                     orgs = NULL) {
  gitstats_obj$add_host(
    api_url = api_url,
    token = token,
    orgs = orgs
  )

  return(invisible(gitstats_obj))
}

#' @title Add Git host
#' @name set_connection
#' @inheritParams add_host
#' @export
set_connection <- add_host

#' @title Set up your search settings.
#' @name setup
#' @param gitstats_obj A GitStats object.
#' @param search_param One of three: team, orgs or phrase.
#' @param team_name Name of a team.
#' @param phrase A phrase to look for.
#' @param language A language of programming code.
#' @param print_out A boolean to decide whether to print output
#' @return A `GitStats` object.
#' @examples
#' \dontrun{
#' my_gitstats <- create_gitstats() %>%
#'   setup(
#'     search_param = "team",
#'     team_name = "Avengers",
#'     language = "R"
#'   )
#' }
#' @export
setup <- function(gitstats_obj,
                  search_param = NULL,
                  team_name = NULL,
                  phrase = NULL,
                  language = "All",
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
#' @param add_contributors A logical parameter to decide whether to add
#'   information about repositories' contributors to the repositories output
#'   (table) when pulling them by organizations (`orgs`) or `phrase`. By default
#'   it is set to `FALSE` which makes function run faster as, in the case of
#'   `orgs` search parameter, it reaches only `GraphQL` endpoint with a query on
#'   repositories, and in the case of `phrase` search parameter it reaches only
#'   `repositories REST API` endpoint. However, the pitfall is that the result
#'   does not convey information on contributors. \cr\cr When set to `TRUE`,
#'   `GitStats` iterates additionally over pulled repositories and reaches to
#'   the `contributors APIs`, which makes it slower, but gives additional
#'   information. The same may be achieved with running separately function
#'   `add_repos_contributors()` on the `GitStats` object with the `repositories`
#'   output. \cr\cr When pulling repositories by \bold{`team`} the parameter
#'   always turns to `TRUE` and pulls information on `contributors`.
#' @return A `GitStats` class object with updated `$repos` field.
#' @examples
#' \dontrun{
#' my_gitstats <- create_gitstats() %>%
#'   set_connection(
#'     api_url = "https://api.github.com",
#'     token = Sys.getenv("GITHUB_PAT"),
#'     orgs = c("r-world-devs", "openpharma")
#'   ) %>%
#'   set_connection(
#'     api_url = "https://gitlab.com/api/v4",
#'     token = Sys.getenv("GITLAB_PAT_PUBLIC"),
#'     orgs = "mbtests"
#'   ) %>%
#'   get_repos()
#' }
#' @export
get_repos <- function(gitstats_obj, add_contributors = FALSE) {
  gitstats_obj$get_repos(add_contributors = add_contributors)
  return(invisible(gitstats_obj))
}

#' @title Add information on contributors to your repositories.
#' @name add_repos_contributors
#' @param gitstats_obj A GitStats object.
#' @description A method to add information on repository contributors.
#' @return A table of repositories with added information on contributors.
#' @export
add_repos_contributors <- function(gitstats_obj) {
  gitstats_obj$add_repos_contributors()
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
#'     orgs = c("r-world-devs")
#'   ) %>%
#'   set_connection(
#'     api_url = "https://gitlab.com/api/v4",
#'     token = Sys.getenv("GITLAB_PAT_PUBLIC"),
#'     orgs = "mbtests"
#'   ) %>%
#'   setup(
#'     search_param = "team",
#'     team_name = "rwdevs"
#'   ) %>%
#'   add_team_member("Maciej Banaś", "maciekbanas") %>%
#'   get_commits(date_from = "2018-01-01")
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

#' @title Get users statistics.
#' @name get_users
#' @description Get information on users.
#' @param gitstats_obj A GitStats object.
#' @param users A character vector of users.
#' @examples
#' \dontrun{
#'  my_gitstats <- create_gitstats() %>%
#'   set_connection(
#'     api_url = "https://api.github.com",
#'     token = Sys.getenv("GITHUB_PAT"),
#'     orgs = c("r-world-devs")
#'   ) %>%
#'   set_connection(
#'     api_url = "https://gitlab.com/api/v4",
#'     token = Sys.getenv("GITLAB_PAT_PUBLIC"),
#'     orgs = "mbtests"
#'   ) %>%
#'   get_users(c("maciekabanas", "marcinkowskak"))
#' }
#' @return A table of users.
#' @export
get_users <- function(gitstats_obj,
                      users){
  gitstats_obj$get_users(
    users = users
  )
  return(invisible(gitstats_obj))
}

#' @title Reset GitStats settings
#' @name reset
#' @description Sets all settings to default: search_param to `org`, language to
#'   `All` and other to `NULL`s.
#' @param gitstats_obj A GitStats object.
#' @return A GitStats object.
#' @export
reset <- function(gitstats_obj){
  priv <- environment(gitstats_obj$setup)$private
  priv$settings <- list(
    search_param = "org",
    phrase = NULL,
    team_name = NULL,
    team = list(),
    language = "All",
    print_out = TRUE
  )
  cli::cli_alert_info("Reset settings to default.")
  return(gitstats_obj)
}

#' @title Reset language settings
#' @name reset_language
#' @description Sets language parameter to NULL (switches of filtering by language.)
#' @param gitstats_obj A GitStats object.
#' @return A GitStats object.
#' @export
reset_language <- function(gitstats_obj){
  priv <- environment(gitstats_obj$setup)$private
  priv$settings$language <- "All"
  cli::cli_alert_info("Setting language parameter to 'All'.")
  return(gitstats_obj)
}

#' @title Show organizations
#' @name show_orgs
#' @description Prints organizations downloaded in `GitStats`. Especially
#'   helpful when user is scanning whole git platform and want to have a glimpse
#'   at organizations.
#' @param gitstats_obj A GitStats object.
#' @return A vector of organizations.
#' @export
show_orgs <- function(gitstats_obj){
  return(gitstats_obj$show_orgs())
}
