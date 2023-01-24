#' @importFrom R6 R6Class
#' @importFrom data.table rbindlist :=
#' @importFrom plotly plot_ly
#' @importFrom purrr map
#'
#' @title A statistics platform for Git clients
#' @description An R6 class object with methods to derive information from multiple Git platforms.
#'
GitStats <- R6::R6Class("GitStats",
  public = list(

    #' @field clients A list of API connections information.
    clients = list(),

    #' @description Create a new `GitStats` object
    #' @return A new `GitStats` object
    initialize = function() {

    },

    #' @field team A character vector containig team members.
    team = NULL,

    #' @field repos_dt An output table of repositories.
    repos_dt = NULL,

    #' @field commits_dt An output table of commits.
    commits_dt = NULL,

    #' @description Method to set connections to Git platforms
    #' @param api_url A character, url address of API.
    #' @param token A token.
    #' @param orgs A character vector of organisations (owners of repositories
    #'   in case of GitHub and groups of projects in case of GitLab).
    #' @return Nothing, puts connection information into `$clients` slot
    set_connection = function(api_url,
                              token,
                              orgs = NULL) {
      if (is.null(orgs)) {
        stop("You need to specify organisations of the repositories.", call. = FALSE)
      }

      if (grepl("github", api_url)) {
        message("Set connection to GitHub.")
        new_client <- GitHub$new(
          rest_api_url = api_url,
          token = token,
          orgs = orgs
        )
      } else if (grepl("https://", api_url) && grepl("gitlab|code", api_url)) {
        message("Set connection to GitLab.")
        new_client <- GitLab$new(
          rest_api_url = api_url,
          token = token,
          orgs = orgs
        )
      } else {
        stop("This connection is not supported by GitStats class object.")
      }

      self$clients <- new_client %>%
        private$check_client() %>%
        private$check_token() %>%
        append(self$clients, .)
    },

    #' @description A method to set your team.
    #' @param team_name A name of a team.
    #' @param ... A charactger vector of team members (names and logins).
    #' @return Nothing, pass team information into `$team` field.
    set_team = function(team_name, ...) {
      self$team <- list()

      self$team[[paste(team_name)]] <- unlist(list(...))
    },

    #' @description  A method to list all repositories for an organization,
    #'   a team or by a codephrase.
    #' @param by A character, to choose between: \itemize{\item{org - organizations
    #'   (owners of repositories)} \item{team - A team} \item{phrase - A keyword in
    #'   code blobs.}}
    #' @param phrase A character, phrase to look for in codelines.
    #' @param language A character specifying language used in repositories.
    #' @param print_out A boolean stating whether to print an output.
    #' @return A data.frame of repositories
    get_repos = function(by = "org",
                         phrase = NULL,
                         language = NULL,
                         print_out = TRUE) {
      by <- match.arg(
        by,
        c("org", "team", "phrase")
      )

      if (by == "org") {
        repos_dt_list <- purrr::map(self$clients, ~ .$get_repos(by = by,
                                                                language = language))
      } else if (by == "team") {
        if (is.null(self$team)) {
          stop("You have to specify a team first with 'set_team()' method.", call. = FALSE)
        }
        team <- self$team[[1]]
        repos_dt_list <- purrr::map(self$clients, ~ .$get_repos(
          by = "team",
          language = language,
          team = team
        ))
      } else if (by == "phrase") {
        if (is.null(phrase)) {
          stop("You have to provide a phrase to look for.", call. = FALSE)
        }
        repos_dt_list <- purrr::map(self$clients, ~ .$get_repos(
          by = "phrase",
          phrase = phrase,
          language = language))
      }

      if (purrr::map_lgl(repos_dt_list, ~length(.) != 0)){

        self$repos_dt <- repos_dt_list %>%
          rbindlist() %>%
          dplyr::arrange(last_activity_at)

        if (print_out) print(self$repos_dt)

      } else {
        message("Empty object - will not be saved.")
      }

      invisible(self)
    },

    #' @description A method to get information on commits.
    #' @param date_from A starting date to look commits for
    #' @param date_until An end date to look commits for
    #' @param by A character, to choose between: \itemize{\item{org - organizations
    #'   (owners of repositories)} \item{team - A team} \item{phrase - A keyword in
    #'   code blobs.}}
    #' @param print_out A boolean stating whether to print an output.
    #' @return A data.frame of commits
    get_commits = function(date_from = NULL,
                           date_until = Sys.time(),
                           by = "org",
                           print_out = TRUE) {
      if (is.null(date_from)) {
        stop("You need to define `date_from`.", call. = FALSE)
      }

      by <- match.arg(
        by,
        c("org", "team")
      )

      if (by == "org") {
        commits_dt <- purrr::map(self$clients, function(x) {
          x$get_commits(
            date_from = date_from,
            date_until = date_until,
            by = by
          )
        }) %>%
          rbindlist(use.names = TRUE)
      } else if (by == "team") {
        if (is.null(self$team)) {
          stop("You have to specify a team first with 'set_team()' method.", call. = FALSE)
        }

        team <- self$team[[1]]

        commits_dt <- purrr::map(self$clients, function(x) {
          commits <- x$get_commits(
            date_from = date_from,
            date_until = date_until,
            by = by,
            team = team
          )

          message(self$clients$rest_api_url, " (", names(self$team), " team): pulled commits from ", length(unique(commits$repo_project)), " repositories.")

          commits
        }) %>% rbindlist(use.names = TRUE)
      }

      commits_dt$committedDate <- as.Date(commits_dt$committedDate)

      self$commits_dt <- commits_dt

      if (print_out) print(commits_dt)

      invisible(self)
    },

    #' @description A method to plot repositories outcome.
    #' @param repos_dt An output of one of `get_repos` methods.
    #' @param repos_n An integer, a number of repos to show on the plot.
    #' @return A plot.
    plot_repos = function(repos_dt = self$repos_dt,
                          repos_n = 10) {
      if (is.null(self$repos_dt)) {
        stop("You have to first construct your repos data.frame with one of 'get_repos' methods.",
          call. = FALSE
        )
      }

      repos_dt <- head(repos_dt, repos_n)
      # repos_dt$last_activity_at <- -repos_dt$last_activity_at
      repos_dt$name <- factor(repos_dt$name, levels = unique(repos_dt$name)[order(repos_dt$last_activity_at, decreasing = TRUE)])

      plotly::plot_ly(repos_dt,
        y = ~name,
        x = ~last_activity_at,
        color = ~organisation,
        type = "bar",
        orientation = "h"
      ) %>%
        plotly::layout(
          yaxis = list(title = ""),
          xaxis = list(title = "last activity - days ago")
        )
    },

    #' @description A method to plot basic commit stats.
    #' @param commits_dt An output of one of `get_commits` methods.
    #' @return A plot.
    plot_commits = function(commits_dt = self$commits_dt,
                            stats_by = c("day", "week", "month")) {
      if (is.null(self$commits_dt)) {
        stop("You have to first construct your repos data.frame with one of 'get_commits' methods.",
          call. = FALSE
        )
      }

      stats_by <- match.arg(stats_by)

      if (stats_by == "day") {
        commits_dt[, statsDate := committedDate]
      } else if (stats_by == "week") {
        commits_dt[, statsDate := paste(format(committedDate, "%-V"), format(committedDate, "%G"), sep = "-")]
      } else if (stats_by == "month") {
        commits_dt[, statsDate := as.Date(paste0(substring(committedDate, 1, 7), "-01"))]
      }

      commits_n <- commits_dt[, .(commits_n = .N), by = .(statsDate, organisation)]
      commits_n <- commits_n[order(statsDate)]

      plotly::plot_ly(commits_n,
        x = ~statsDate,
        y = ~commits_n,
        color = ~organisation,
        type = "scatter",
        mode = "lines+markers"
      )
    },

    #' @description A method to plot commit additions and deletions.
    #' @param commits_dt An output of one of `get_commits` methods.
    #' @return A plot.
    plot_commit_lines = function(commits_dt = self$commits_dt) {
      if (is.null(self$commits_dt)) {
        stop("You have to first construct your repos data.frame with one of 'get_commits' methods.",
          call. = FALSE
        )
      }

      commits_dt[, deletions := -deletions]

      plotly::plot_ly(commits_dt) %>%
        plotly::add_trace(
          y = ~additions,
          x = ~committedDate,
          color = ~organisation,
          type = "bar"
        ) %>%
        plotly::add_trace(
          y = ~deletions,
          x = ~committedDate,
          color = ~organisation,
          type = "bar"
        ) %>%
        plotly::layout(
          yaxis = list(title = ""),
          xaxis = list(title = "")
        )
    },

    #' @description A print method for a GitStats object
    print = function() {
      cat(paste0("A GitStats object (multi-API client platform) for ", length(self$clients), " clients:"), sep = "\n")
      purrr::walk(self$clients, ~ .$print())
    }
  ),
  private = list(

    #' @description Check whether the urls do not repeat in input.
    #' @param client An object of GitService class
    #' @return A GitService object
    check_client = function(client) {
      if (length(self$clients) > 0) {
        clients_to_check <- append(client, self$clients)

        urls <- purrr::map_chr(clients_to_check, ~ .$rest_api_url)

        if (length(urls) != length(unique(urls))) {
          stop("You can not provide two clients of the same API urls.")
        }
      }

      client
    },

    #' @description Check whether the token exists.
    #' @param client An object of GitService class
    #' @return A GitService object
    check_token = function(client) {
      priv <- environment(client$initialize)$private

      if (nchar(priv$token) == 0) {
        warning(paste0("No token provided for `", client$rest_api_url, "`. Your access to API will be unauthorized."), call. = FALSE)
      }

      client
    }
  )
)

#' @title Create a `GitStats` object
#' @name create_gitstats
#' @examples
#'  my_gitstats <- create_gitstats()
#' @return A `GitStats` object.
#' @export
create_gitstats <- function() {
  GitStats$new()
}

#' @title Setting connections
#' @name set_connection
#' @param gitstats_obj A GitStats object.
#' @examples
#' \dontrun{
#' my_gitstats <- create_gitstats() %>%
#'   set_connection(api_url = "https://api.github.com",
#'                  token = Sys.getenv("GITHUB_PAT"),
#'                  orgs = c("r-world-devs", "openpharma", "pharmaverse")) %>%
#'   set_connection(api_url = "https://gitlab.com/api/v4",
#'                  token = Sys.getenv("GITLAB_PAT"),
#'                  orgs = "erasmusmc-public-health")
#' }
#' @return A `GitStats` class object with added connection information
#'   (`$clients` field).
#' @export
set_connection <- function(gitstats_obj,
                           api_url,
                           token,
                           orgs = NULL) {

  gitstats_obj$set_connection(api_url = api_url,
                              token = token,
                              orgs = orgs)

  return(invisible(gitstats_obj))
}

#' @title Set your team.
#' @name set_team
#' @description Declare your team members (logins, full names) to obtain
#'   statistcis \code{by = "team"}.
#' @details Bear in mind that on different Git platforms, team members may use
#'   different logins. You have to specify all of them, if you want to get team
#'   statitistics from all your Git clients.
#' @param gitstats_obj A GitStats object.
#' @param team_name A name of a team.
#' @param ... A charactger vector of team members (names and logins).
#' @return A `GitStats` class object with added information to `$team` field.
#' @examples
#' \dontrun{
#' my_gitstats <- create_gitstats() %>%
#'   set_connection(api_url = "https://api.github.com",
#'                  token = Sys.getenv("GITHUB_PAT"),
#'                  orgs = c("r-world-devs", "openpharma", "pharmaverse")) %>%
#'   set_team("RWD-IE", "galachad", "kalimu", "Cotau", "krystian8207", "marcinkowskak", "maciekbanas") %>%
#'   get_repos(by = "team")
#' }
#' @export
set_team = function(gitstats_obj, team_name, ...) {

  gitstats_obj$set_team(team_name, ...)

  return(invisible(gitstats_obj))
}

#' @title Get information on repositories
#' @name get_repos
#' @description  List all repositories for an organization, a team or by a
#'   codephrase.
#' @param gitstats_obj A GitStats object.
#' @param by A character, to choose between: \itemize{\item{org - organizations
#'   (owners of repositories)} \item{team - A team} \item{phrase - A keyword in
#'   code blobs.}}
#' @param phrase A character, phrase to look for in codelines.
#' @param language A character specifying language used in repositories.
#' @param print_out A boolean stating whether to print an output.
#' @return A `GitStats` class object with updated `$repos_dt` field.
#' @examples
#' \dontrun{
#' my_gitstats <- create_gitstats() %>%
#'   set_connection(api_url = "https://api.github.com",
#'                  token = Sys.getenv("GITHUB_PAT"),
#'                  orgs = c("r-world-devs", "openpharma", "pharmaverse")) %>%
#'   set_connection(api_url = "https://gitlab.com/api/v4",
#'                  token = Sys.getenv("GITLAB_PAT"),
#'                  orgs = "erasmusmc-public-health") %>%
#'   get_repos(language = "R")
#'
#' my_gitstats$get_repos(by = "phrase",
#'                       phrase = "diabetes",
#'                       language = "R")
#' }
#' @export
get_repos = function(gitstats_obj,
                     by = "org",
                     phrase = NULL,
                     language = NULL,
                     print_out = TRUE) {

  gitstats_obj$get_repos(by = by,
                         phrase = phrase,
                         language = language,
                         print_out = print_out)

  return(invisible(gitstats_obj))
}

#' @title Get information on commits.
#' @get_commits
#' @description List all repositories for an organization, a team.
#' @param gitstats_obj  A GitStats object.
#' @param date_from A starting date to look commits for
#' @param date_until An end date to look commits for
#' @param by A character, to choose between: \itemize{\item{org - organizations
#'   (owners of repositories)} \item{team - A team} \item{phrase - A keyword in
#'   code blobs.}}
#' @param print_out A boolean stating whether to print an output.
#' @return A `GitStats` class object with updated `$commits_dt` field.
#' @examples
#' \dontrun{
#' my_gitstats <- create_gitstats() %>%
#'   set_connection(api_url = "https://api.github.com",
#'                  token = Sys.getenv("GITHUB_PAT"),
#'                  orgs = c("r-world-devs", "openpharma", "pharmaverse")) %>%
#'   set_connection(api_url = "https://gitlab.com/api/v4",
#'                  token = Sys.getenv("GITLAB_PAT"),
#'                  orgs = "erasmusmc-public-health") %>%
#'   get_commits(date_from = '2020-01-01')
#'
#' my_gitstats %>%
#'   set_team("RWD-IE", "galachad", "kalimu", "Cotau", "krystian8207", "marcinkowskak", "maciekbanas") %>%
#'   get_commits(date_from = '2020-01-01',
#'               date_until = '2022-12-31',
#'               by = "team"
#'               )
#' }
#' @export
get_commits = function(gitstats_obj,
                       date_from = NULL,
                       date_until = Sys.time(),
                       by = "org",
                       print_out = TRUE) {

  gitstats_obj$get_commits(date_from = date_from,
                           date_until = date_until,
                           by = by,
                           print_out = print_out)

  return(invisible(gitstats_obj))
}
