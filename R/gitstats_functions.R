#' @title Create a `GitStats` object
#' @name create_gitstats
#' @examples
#' my_gitstats <- create_gitstats()
#' @return A `GitStats` object.
#' @export
create_gitstats <- function() {
  GitStats$new()
}

#' @title Set GitHub host
#' @name set_github_host
#' @param gitstats_obj A GitStats object.
#' @param host A character, optional, URL name of the host. If not passed, a
#'   public host will be used.
#' @param token A token.
#' @param orgs An optional character vector of organisations. If you pass it,
#'   `repos` parameter should stay `NULL`.
#' @param repos An optional character vector of repositories full names
#'   (organization and repository name, e.g. "r-world-devs/GitStats"). If you
#'   pass it, `orgs` parameter should stay `NULL`.
#' @details If you do not define `orgs` and `repos`, `GitStats` will be set to
#'   scan whole Git platform (such as enterprise version of GitHub or GitLab),
#'   unless it is a public platform. In case of a public one (like GitHub) you
#'   need to define `orgs` or `repos` as scanning through all organizations may
#'   take large amount of time.
#' @return A `GitStats` object with added information on host.
#' @examples
#' \dontrun{
#' my_gitstats <- create_gitstats() %>%
#'   set_github_host(
#'     orgs = c("r-world-devs", "openpharma", "pharmaverse")
#'   )
#' }
#' @export
set_github_host <- function(gitstats_obj,
                            host = NULL,
                            token = NULL,
                            orgs = NULL,
                            repos = NULL) {
  gitstats_obj$set_github_host(
    host = host,
    token = token,
    orgs = orgs,
    repos = repos
  )

  return(invisible(gitstats_obj))
}

#' @title Set GitLab host
#' @name set_gitlab_host
#' @inheritParams set_github_host
#' @details If you do not define `orgs` and `repos`, `GitStats` will be set to
#'   scan whole Git platform (such as enterprise version of GitHub or GitLab),
#'   unless it is a public platform. In case of a public one (like GitHub) you
#'   need to define `orgs` or `repos` as scanning through all organizations may
#'   take large amount of time.
#' @return A `GitStats` object with added information on host.
#' @examples
#' \dontrun{
#' my_gitstats <- create_gitstats() %>%
#'   set_gitlab_host(
#'     token = Sys.getenv("GITLAB_PAT_PUBLIC"),
#'     orgs = "mbtests"
#'   )
#' }
#' @export
set_gitlab_host <- function(gitstats_obj,
                            host = NULL,
                            token = NULL,
                            orgs = NULL,
                            repos = NULL) {
  gitstats_obj$set_gitlab_host(
    host = host,
    token = token,
    orgs = orgs,
    repos = repos
  )

  return(invisible(gitstats_obj))
}

#' @title Set up your search settings
#' @name set_params
#' @param gitstats_obj A GitStats object.
#' @param search_mode One of four: `org`, `repo` or `code`.
#' @param files Define files to scan.
#' @param verbose A boolean to decide whether to print output.
#' @param use_storage A boolean. If set to `TRUE` it will pull data from the
#'   storage when it is there, e.g. `repositories`, when user runs
#'   `get_repos()`. If set to `FALSE` `get_repos()` will always pull data from
#'   the API.
#' @return A `GitStats` object.
#' @examples
#' \dontrun{
#' my_gitstats <- create_gitstats() %>%
#'   set_params(
#'     search_mode = "code",
#'     files = "DESCRIPTION"
#'   )
#' }
#' @export
set_params <- function(gitstats_obj,
                       search_mode = NULL,
                       files = NULL,
                       verbose = NULL,
                       use_storage = NULL) {
  gitstats_obj$set_params(
    search_mode = search_mode,
    files = files,
    verbose = verbose,
    use_storage = use_storage
  )

  return(gitstats_obj)
}

#' @title Reset GitStats settings
#' @name reset
#' @description Sets all settings to default.
#' @param gitstats_obj A GitStats object.
#' @return A `GitStats` object.
#' @export
reset <- function(gitstats_obj){
  priv <- environment(gitstats_obj$set_params)$private
  priv$settings <- list(
    search_mode = "org",
    files = NULL,
    verbose = TRUE,
    use_storage = TRUE
  )
  cli::cli_alert_info("Reset settings to default.")
  return(gitstats_obj)
}

#' @title Get information on repositories
#' @name get_repos
#' @description  List all repositories for an organization or by a keyword.
#' @param gitstats_obj A GitStats object.
#' @param add_contributors A logical parameter to decide whether to add
#'   information about repositories' contributors to the repositories output
#'   (table). If set to `FALSE` it makes function run faster as, in the case of
#'   `org` search mode, it reaches only `GraphQL` endpoint with a query on
#'   repositories, and in the case of `code` search mode it reaches only
#'   `repositories REST API` endpoint. However, the pitfall is that the result
#'   does not convey information on contributors. \cr\cr When set to `TRUE` (by
#'   default), `GitStats` iterates additionally over pulled repositories and
#'   reaches to the `contributors APIs`, which makes it slower, but gives
#'   additional information.
#' @param code A character, should be defined is GitStats is set to get repos by
#'   code with `set_params()` function.
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
#'   )
#'   get_repos(my_gitstats)
#' }
#' @export
get_repos <- function(gitstats_obj, add_contributors = TRUE, code = NULL) {
  gitstats_obj$get_repos(
    add_contributors = add_contributors,
    code = code
  )
}

#' @title Get information on commits
#' @name get_commits
#' @description List all commits from all repositories for an organization or a
#'   vector of repositories.
#' @param gitstats_obj  A GitStats object.
#' @param since A starting date of commits.
#' @param until An end date of commits.
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
#'   get_commits(since = "2018-01-01")
#' }
#' @export
get_commits <- function(gitstats_obj,
                        since = NULL,
                        until = NULL) {
  if (is.null(since)) {
    cli::cli_abort(cli::col_red("You need to pass date to `since` parameter."), call = NULL)
  }
  gitstats_obj$get_commits(
    since = since,
    until = until
  )
}

#' @title Get statistics on commits
#' @name get_commits_stats
#' @description Prepare statistics from the pulled commits data.
#' @param gitstats_obj A GitStats class object.
#' @param time_interval A character, specifying time interval to show statistics.
#' @return A table of `commits_stats` class.
#' @export
get_commits_stats = function(gitstats_obj,
                             time_interval = c("month", "day", "week")) {
  gitstats_obj$get_commits_stats(
    time_interval = time_interval
  )
}

#' @title Get users data
#' @name get_users
#' @description Pull users data from Git Host.
#' @param gitstats_obj A GitStats object.
#' @param logins A character vector of logins.
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
#'   )
#'   get_users(my_gitstats, c("maciekabanas", "marcinkowskak"))
#' }
#' @return A `GitStats` object with table of users.
#' @export
get_users <- function(gitstats_obj,
                      logins){
  gitstats_obj$get_users(logins = logins)
}

#' @title Get files content
#' @name get_files
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
#'   )
#'   get_files(my_gitstats, "meta_data.yaml")
#' }
#' @return A `GitStats` object with table of files.
#' @export
get_files <- function(gitstats_obj,
                      file_path){
  gitstats_obj$get_files(file_path = file_path)
}

#' @title Get information on package usage across repositories
#' @name get_R_package_usage
#' @description Wrapper over searching repositories by code blobs related to
#'   loading package (`library(package)` and `require(package)` in all files) or
#'   using it as a dependency (`package` in `DESCRIPTION` and `NAMESPACE` files).
#' @param gitstats_obj A GitStats object.
#' @param package_name A character, name of the package.
#' @param only_loading A boolean, if `TRUE` function will check only if package
#'   is loaded in repositories, not used as dependencies.
#' @return A table of repositories content.
#' @examples
#' \dontrun{
#'  my_gitstats <- create_gitstats() %>%
#'   set_host(
#'     api_url = "https://api.github.com",
#'     token = Sys.getenv("GITHUB_PAT"),
#'     orgs = c("r-world-devs", "openpharma")
#'   ) %>%
#'   get_R_package_usage("shiny")
#' }
#' @export
get_R_package_usage <- function(
    gitstats_obj,
    package_name,
    only_loading = FALSE
  ) {
  gitstats_obj$get_R_package_usage(
    package_name = package_name,
    only_loading = only_loading
  )
}

#' @title Get release logs
#' @name get_release_logs
#' @description Pull release logs from repositories.
#' @param gitstats_obj A GitStats object.
#' @param since A starting date for release logs.
#' @param until An end date for release logs.
#' @return A table with release logs.
#' @examples
#' \dontrun{
#'  my_gitstats <- create_gitstats() %>%
#'   set_host(
#'     api_url = "https://api.github.com",
#'     token = Sys.getenv("GITHUB_PAT"),
#'     orgs = c("r-world-devs", "openpharma")
#'   )
#'   get_release_logs(my_gistats, since = "2024-01-01")
#' }
#' @export
get_release_logs <- function(
    gitstats_obj,
    since = NULL,
    until = NULL
) {
  if (is.null(since)) {
    cli::cli_abort(cli::col_red("You need to pass date to `since` parameter."), call = NULL)
  }
  gitstats_obj$get_release_logs(
    since = since,
    until = until
  )
}

#' @title Show organizations set in `GitStats`
#' @name show_orgs
#' @description Retrieves organizations set or pulled by `GitStats`. Especially
#'   helpful when user is scanning whole git platform and wants to have a
#'   glimpse at organizations.
#' @param gitstats_obj A GitStats object.
#' @return A vector of organizations.
#' @export
show_orgs <- function(gitstats_obj){
  gitstats_obj$show_orgs()
}

#' @title Show data stored in GitStats
#' @name show_data
#' @description Retrieves table stored in `GitStats` object.
#' @param gitstats_obj A GitStats object.
#' @param storage Table of `repositories`, `commits`, `users`, `files`,
#'   `release_logs` or `R_package_usage`.
#' @examples
#' \dontrun{
#'  my_gitstats <- create_gitstats() %>%
#'   set_host(
#'     api_url = "https://api.github.com",
#'     token = Sys.getenv("GITHUB_PAT"),
#'     orgs = c("r-world-devs")
#'   ) %>%
#'   get_repos()
#'   show_data(my_gistats, "repositories")
#' }
#' @return A table.
#' @export
show_data <- function(gitstats_obj, storage) {
  gitstats_obj$show_data(
    storage = storage
  )
}

#' @title Switch on verbose mode
#' @name verbose_on
#' @description Print all messages and output.
#' @param gitstats_obj A GitStats object.
#' @return A GitStats object.
#' @export
verbose_on <- function(gitstats_obj) {
  gitstats_obj$verbose_on()
  return(invisible(gitstats_obj))
}

#' @title Switch off verbose mode
#' @name verbose_off
#' @description Stop printing messages and output.
#' @param gitstats_obj A GitStats object.
#' @return A GitStats object.
#' @export
verbose_off <- function(gitstats_obj) {
  gitstats_obj$verbose_off()
  return(invisible(gitstats_obj))
}
