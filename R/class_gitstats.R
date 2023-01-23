#' @export
#'
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
    clients = list(),

    #' @description Create a new `GitStats` object
    #' @return A new `GitStats` object
    initialize = function() {

    },
    team = NULL,
    repos_dt = NULL,
    commits_dt = NULL,

    #' @description  A method to list all repositories for an organization,
    #'   a team or by a codephrase.
    #' @param by A character, to choose between: \itemize{
    #'   \item{org}{Organizations - owners of repositories} \item(team){A team}
    #'   \item(phrase){A keyword in code blobs.}}
    #' @param phrase A phrase to look for in codelines.
    #' @param language A character specifying language used in repositories.
    #' @param print_out A boolean stating whether to print an output.
    #' @return A data.frame of repositories
    get_repos = function(by = "org",
                         phrase = NULL,
                         language = "R",
                         print_out = TRUE) {
      by <- match.arg(
        by,
        c("org", "team", "phrase")
      )

      if (by == "org") {
        repos_dt_list <- purrr::map(self$clients, ~ .$get_repos(by = by))
      } else if (by == "team") {
        if (is.null(self$team)) {
          stop("You have to specify a team first with 'set_team()' method.", call. = FALSE)
        }
        team <- self$team[[1]]
        repos_dt_list <- purrr::map(self$clients, ~ .$get_repos(
          by = "team",
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

      }

      invisible(self)
    },

    #' @description A method to get information on commits.
    #' @param date_from A starting date to look commits for
    #' @param date_until An end date to look commits for
    #' @param by A chararacter, to choose between: \itemize{
    #'   \item{org}{Organizations} \item(team){Team}}
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
    #' @return Nothing, puts team information into `$team` slot.
    set_team = function(team_name, ...) {
      self$team <- list()

      self$team[[paste(team_name)]] <- unlist(list(...))
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
