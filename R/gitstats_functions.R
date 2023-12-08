#' @title Create a `GitStats` object
#' @name create_gitstats
#' @examples
#' my_gitstats <- create_gitstats()
#' @return A `GitStats` object.
#' @export
create_gitstats <- function() {
  GitStats$new()
}

#' @title Set Git host
#' @name set_host
#' @param gitstats_obj A GitStats object.
#' @param api_url A character, URL address of API.
#' @param token A token.
#' @param orgs A character vector of organisations (owners of repositories in
#'   case of GitHub and groups of projects in case of GitLab). You do not need
#'   to define `orgs` if you wish to scan whole internal Git platform (such as
#'   enterprise version of GitHub or GitLab). In case of a public one (like
#'   GitHub) you need to define `orgs` as scanning through all organizations
#'   may take large amount of time.
#' @return A `GitStats` object with added information on host.
#' @examples
#' \dontrun{
#' my_gitstats <- create_gitstats() %>%
#'   set_host(
#'     api_url = "https://api.github.com",
#'     orgs = c("r-world-devs", "openpharma", "pharmaverse")
#'   ) %>%
#'   set_host(
#'     api_url = "https://gitlab.com/api/v4",
#'     token = Sys.getenv("GITLAB_PAT_PUBLIC"),
#'     orgs = "erasmusmc-public-health"
#'   )
#' }
#' @export
set_host <- function(gitstats_obj,
                     api_url,
                     token = NULL,
                     orgs = NULL) {
  gitstats_obj$set_host(
    api_url = api_url,
    token = token,
    orgs = orgs
  )

  return(invisible(gitstats_obj))
}

#' @title Set up your search settings
#' @name set_params
#' @param gitstats_obj A GitStats object.
#' @param search_param One of three: team, orgs or phrase.
#' @param team_name Name of a team.
#' @param phrase A phrase to look for.
#' @param language Code programming language.
#' @param print_out A boolean to decide whether to print output.
#' @return A `GitStats` object.
#' @examples
#' \dontrun{
#' my_gitstats <- create_gitstats() %>%
#'   set_params(
#'     search_param = "team",
#'     team_name = "Avengers",
#'     language = "R"
#'   )
#' }
#' @export
set_params <- function(gitstats_obj,
                       search_param = NULL,
                       team_name = NULL,
                       phrase = NULL,
                       language = "All",
                       print_out = TRUE) {
  gitstats_obj$set_params(
    search_param = search_param,
    team_name = team_name,
    phrase = phrase,
    language = language,
    print_out = print_out
  )

  return(gitstats_obj)
}

#' @title Set your team member
#' @name set_team_member
#' @description Passes information on team member to your `team` field.
#' @param gitstats_obj A GitStats object.
#' @param member_name Name of a member.
#' @param ... All user logins.
#' @return `GitStats` object with new information on team member.
#' @examples
#' \dontrun{
#' my_gitstats <- create_gitstats() %>%
#'   set_team_member("Peter Parker", "spider_man", "spidey") %>%
#'   set_team_member("Tony Stark", "ironMan", "tony_s")
#' }
#' @export
set_team_member <- function(gitstats_obj,
                            member_name,
                            ...) {
  gitstats_obj$set_team_member(
    member_name = member_name,
    ... = ...
  )

  return(invisible(gitstats_obj))
}

#' @title Pull information on repositories
#' @name pull_repos
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
#'   `pull_repos_contributors()` on the `GitStats` object with the `repositories`
#'   output. \cr\cr When pulling repositories by \bold{`team`} the parameter
#'   always turns to `TRUE` and pulls information on `contributors`.
#' @return A `GitStats` class object with repositories table.
#' @examples
#' \dontrun{
#' my_gitstats <- create_gitstats() %>%
#'   set_host(
#'     api_url = "https://api.github.com",
#'     token = Sys.getenv("GITHUB_PAT"),
#'     orgs = c("r-world-devs", "openpharma")
#'   ) %>%
#'   set_host(
#'     api_url = "https://gitlab.com/api/v4",
#'     token = Sys.getenv("GITLAB_PAT_PUBLIC"),
#'     orgs = "mbtests"
#'   ) %>%
#'   pull_repos()
#' }
#' @export
pull_repos <- function(gitstats_obj, add_contributors = FALSE) {
  gitstats_obj$pull_repos(add_contributors = add_contributors)
  return(invisible(gitstats_obj))
}

#' @title Pull information on contributors
#' @name pull_repos_contributors
#' @param gitstats_obj A GitStats object.
#' @description Adds information on contributors to already pulled repositories
#'   table.
#' @return  A `GitStats` class object with repositories table with added
#'   information on contributors.
#' @export
pull_repos_contributors <- function(gitstats_obj) {
  gitstats_obj$pull_repos_contributors()
  return(invisible(gitstats_obj))
}

#' @title Pull information on commits
#' @name pull_commits
#' @description List all commits from all repositories for an organization or a
#'   team.
#' @param gitstats_obj  A GitStats object.
#' @param date_from A starting date of commits.
#' @param date_until An end date of commits.
#' @return A `GitStats` class object with commits table.
#' @examples
#' \dontrun{
#' my_gitstats <- create_gitstats() %>%
#'   set_host(
#'     api_url = "https://api.github.com",
#'     token = Sys.getenv("GITHUB_PAT"),
#'     orgs = c("r-world-devs")
#'   ) %>%
#'   set_host(
#'     api_url = "https://gitlab.com/api/v4",
#'     token = Sys.getenv("GITLAB_PAT_PUBLIC"),
#'     orgs = "mbtests"
#'   ) %>%
#'   set_params(
#'     search_param = "team",
#'     team_name = "rwdevs"
#'   ) %>%
#'   set_team_member("Maciej Banaś", "maciekbanas") %>%
#'   pull_commits(date_from = "2018-01-01")
#' }
#' @export
pull_commits <- function(gitstats_obj,
                         date_from = NULL,
                         date_until = Sys.time()) {
  gitstats_obj$pull_commits(
    date_from = date_from,
    date_until = date_until
  )

  return(invisible(gitstats_obj))
}

#' @title Pull users data
#' @name pull_users
#' @description Pull users data from Git Host.
#' @param gitstats_obj A GitStats object.
#' @param users A character vector of users.
#' @examples
#' \dontrun{
#'  my_gitstats <- create_gitstats() %>%
#'   set_host(
#'     api_url = "https://api.github.com",
#'     token = Sys.getenv("GITHUB_PAT"),
#'     orgs = c("r-world-devs")
#'   ) %>%
#'   set_host(
#'     api_url = "https://gitlab.com/api/v4",
#'     token = Sys.getenv("GITLAB_PAT_PUBLIC"),
#'     orgs = "mbtests"
#'   ) %>%
#'   pull_users(c("maciekabanas", "marcinkowskak"))
#' }
#' @return A `GitStats` object with table of users.
#' @export
pull_users <- function(gitstats_obj,
                       users){
  gitstats_obj$pull_users(
    users = users
  )
  return(invisible(gitstats_obj))
}

#' @title Pull files content
#' @name pull_files
#' @description Pull files content from Git Hosts.
#' @param gitstats_obj A GitStats object.
#' @param file_path A standardized path to file(s) in repositories. May be a
#'   character vector if multiple files are to be pulled.
#' @examples
#' \dontrun{
#'  my_gitstats <- create_gitstats() %>%
#'   set_host(
#'     api_url = "https://api.github.com",
#'     token = Sys.getenv("GITHUB_PAT"),
#'     orgs = c("r-world-devs")
#'   ) %>%
#'   set_host(
#'     api_url = "https://gitlab.com/api/v4",
#'     token = Sys.getenv("GITLAB_PAT_PUBLIC"),
#'     orgs = "mbtests"
#'   ) %>%
#'   pull_files("meta_data.yaml")
#' }
#' @return A `GitStats` object with table of files.
#' @export
pull_files <- function(gitstats_obj,
                       file_path){
  gitstats_obj$pull_files(
    file_path = file_path
  )
  return(invisible(gitstats_obj))
}

#' @title Reset GitStats settings
#' @name reset
#' @description Sets all settings to default: search_param to `org`, language to
#'   `All` and other to `NULL`s.
#' @param gitstats_obj A GitStats object.
#' @return A `GitStats` object.
#' @export
reset <- function(gitstats_obj){
  priv <- environment(gitstats_obj$set_params)$private
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
#' @description Sets language parameter to \code{NULL} (switches of filtering by
#'   language.).
#' @param gitstats_obj A GitStats object.
#' @return A `GitStats` object.
#' @export
reset_language <- function(gitstats_obj){
  priv <- environment(gitstats_obj$set_params)$private
  priv$settings$language <- "All"
  cli::cli_alert_info("Setting language parameter to 'All'.")
  return(gitstats_obj)
}

#' @title Get organizations
#' @name get_orgs
#' @description Retrieves organizations set or pulled by `GitStats`. Especially
#'   helpful when user is scanning whole git platform and wants to have a
#'   glimpse at organizations.
#' @param gitstats_obj A GitStats object.
#' @return A vector of organizations.
#' @export
get_orgs <- function(gitstats_obj){
  return(gitstats_obj$get_orgs())
}

#' @title Get repositories
#' @name get_repos
#' @description Retrieves repositories table pulled by `GitStats`.
#' @param gitstats_obj A GitStats object.
#' @return A table of repositories.
#' @export
get_repos <- function(gitstats_obj){
  return(gitstats_obj$get_repos())
}

#' @title Get commits
#' @name get_commits
#' @description Retrieves commits table pulled by `GitStats`.
#' @param gitstats_obj A GitStats object.
#' @return A table of commits.
#' @export
get_commits <- function(gitstats_obj){
  return(gitstats_obj$get_commits())
}

#' @title Get users
#' @name get_users
#' @description Retrieves users table pulled by `GitStats`.
#' @param gitstats_obj A GitStats object.
#' @return A table of users.
#' @export
get_users <- function(gitstats_obj){
  return(gitstats_obj$get_users())
}

#' @title Get files
#' @name get_files
#' @description Retrieves files table pulled by `GitStats`.
#' @param gitstats_obj A GitStats object.
#' @return A table of files content.
#' @export
get_files <- function(gitstats_obj){
  return(gitstats_obj$get_files())
}

#' @title Check package usage across repositories
#' @name pull_R_package_usage
#' @description Wrapper over searching repositories by code blobs related to
#'   using package (`library(package)`, `require(package)` and `package::`).
#' @param gitstats_obj A GitStats object.
#' @param package_name A character, name of the package.
#' @param only_loading A boolean, if `TRUE` function will check only if package
#'   is loaded in repositories, not used as dependencies. This is much faster
#'   approach as searching usage only with loading (i.e. library(package)) is
#'   based on Search APIs (one endpoint), whereas searching usage as a
#'   dependency pulls text files from all repositories (many endpoints). This is
#'   a good option to choose when you want to check package usage but guess that
#'   it may be used mainly by loading in data scripts and not used as a
#'   dependency of other packages.
#' @return A table of repositories content.
#' @examples
#' \dontrun{
#'  my_gitstats <- create_gitstats() %>%
#'   set_host(
#'     api_url = "https://api.github.com",
#'     token = Sys.getenv("GITHUB_PAT"),
#'     orgs = c("r-world-devs", "openpharma")
#'   ) %>%
#'   pull_R_package_usage("Shiny")
#' }
#' @export
pull_R_package_usage <- function(
    gitstats_obj,
    package_name,
    only_loading = FALSE
  ) {
  gitstats_obj$pull_R_package_usage(
    package_name = package_name,
    only_loading = only_loading
  )
  return(invisible(gitstats_obj))
}

#' @title Get R package usage
#' @name get_files
#' @description Retrieves list of repositories that make use of a package.
#' @param gitstats_obj A GitStats object.
#' @return A table with repo urls.
#' @export
get_R_package_usage <- function(gitstats_obj) {
  return(gitstats_obj$get_R_package_usage())
}
