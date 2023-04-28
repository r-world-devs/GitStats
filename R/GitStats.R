#' @importFrom R6 R6Class
#' @importFrom cli cli_alert_info cli_alert_success cli_alert_warning col_yellow
#' @importFrom data.table rbindlist :=
#' @importFrom dplyr glimpse
#' @importFrom magrittr %>%
#' @importFrom purrr map
#' @importFrom tibble tibble
#' @importFrom DBI dbConnect dbWriteTable dbAppendTable dbReadTable dbListTables Id
#' @importFrom RPostgres Postgres
#' @importFrom RSQLite SQLite
#'
#' @title A statistics platform for Git hosts
#' @description An R6 class object with methods to derive information from multiple Git platforms.
#'
GitStats <- R6::R6Class("GitStats",
  public = list(

    #' @description Set up your search settings.
    #' @param search_param One of three: `team`, `org` or `phrase`.
    #' @param team_name A name of a team.
    #' @param phrase A phrase to look for.
    #' @param language A language of programming code.
    #' @param print_out A boolean stating if you want to print output after
    #'   pulling.
    #' @return Nothing.
    setup = function(search_param,
                     team_name,
                     phrase,
                     language,
                     print_out) {
      search_param <- match.arg(
        search_param,
        c("org", "team", "phrase")
      )

      if (search_param == "team") {
        if (is.null(team_name)) {
          cli::cli_abort(
            "You need to define your `team_name`."
          )
        } else {
          private$settings$team_name <- team_name
          cli::cli_alert_success(
            paste0("Your search preferences set to {cli::col_green('team: ", team_name, "')}.")
          )
          if (length(private$settings$team) == 0) {
            cli::cli_alert_warning(
              cli::col_yellow(
                "No team members in the team. Add them with `add_team_member()`."
              )
            )
          }
        }
      }
      if (search_param == "phrase") {
        if (is.null(phrase)) {
          cli::cli_abort(
            "You need to define your phrase."
          )
        } else {
          private$settings$phrase <- phrase
          cli::cli_alert_success(
            paste0("Your search preferences set to {cli::col_green('phrase: ", phrase, "')}.")
          )
        }
      }
      private$settings$search_param <- search_param
      if (!is.null(language)) {
        private$settings$language <- private$language_handler(language)
        cli::cli_alert_success(
          paste0("Your programming language is set to <", language, ">.")
        )
      }
      private$settings$print_out <- print_out
    },

    #' @description Method to set connections to Git platforms
    #' @param api_url A character, url address of API.
    #' @param token A token.
    #' @param orgs A character vector of organisations (owners of repositories
    #'   in case of GitHub and groups of projects in case of GitLab).
    #' @return Nothing, puts connection information into `$hosts` slot
    add_host = function(api_url,
                        token,
                        orgs) {

      new_host <- GitHost$new(
        orgs = orgs,
        token = token,
        api_url = api_url
      )

      private$hosts <- new_host %>%
        private$check_host() %>%
        append(private$hosts, .)
    },

    #' @description A method to add a team member.
    #' @param member_name Name of a member.
    #' @param ... User names on Git platforms.
    #' @return Nothing, pass information on team member to `GitStats`.
    add_team_member = function(member_name,
                               ...) {
      team_member <- list(
        "name" = member_name,
        "logins" = unlist(list(...))
      )
      private$settings$team[[paste0(member_name)]] <- team_member
      cli::cli_alert_success("{member_name} successfully added to team.")
    },

    #' @description  A method to list all repositories for an organization,
    #'   a team or by a keyword.
    #' @return A data.frame of repositories
    get_repos = function() {

      if (private$settings$search_param == "team") {
        if (length(private$settings$team) == 0) {
          cli::cli_abort("You have to specify a team first with 'add_team_member()'.")
        }
      } else if (private$settings$search_param == "phrase") {
        if (is.null(private$settings$phrase)) {
          cli::cli_abort("You have to provide a phrase to look for.")
        }
      }

      repos_table <- purrr::map(private$hosts, ~ .$get_repos(
        settings = private$settings
      )) %>%
        purrr::list_rbind()

      if (nrow(repos_table) == 0) {
        message("Empty object - will not be saved.")
      } else {
        if (private$settings$print_out) dplyr::glimpse(repos_table)
        private$repos <- repos_table
      }
      return(invisible(self))
    },

    #' @description A method to get information on commits.
    #' @param date_from A starting date to look commits for
    #' @param date_until An end date to look commits for
    #' @return A data.frame of commits
    get_commits = function(date_from,
                           date_until) {
      if (is.null(date_from)) {
        stop("You need to define `date_from`.", call. = FALSE)
      }

      if (private$settings$search_param == "team") {
        if (length(private$settings$team) == 0) {
          cli::cli_abort("You have to specify a team first with 'add_team_member()'.")
        }
      }

      commits_table <- purrr::map(private$hosts, function(host) {
        commits_table_host <- host$get_commits(
          date_from = date_from,
          date_until = date_until,
          settings = private$settings
        )
        return(commits_table_host)
      }) %>% purrr::list_rbind()

      private$commits <- commits_table

      if (private$settings$search_param == "team" && !is.null(private$settings$team)) {
        cli::cli_alert_success(
          paste0(
            "For '", private$settings$team_name, "' team: pulled ",
            nrow(commits_table), " commits from ",
            length(unique(commits_table$repository)), " repositories."
          )
        )
      }
      if (private$settings$print_out) dplyr::glimpse(commits_table)
      return(invisible(self))
    },

    #' @description Print repositories output.
    show_repos = function() {
      private$repos
    },

    #' @description Print commits output.
    show_commits = function() {
      private$commits
    },

    #' @description A print method for a GitStats object
    print = function() {
      cat(paste0("A <GitStats> object for ", length(private$hosts), " hosts:"), sep = "\n")
      hosts <- purrr::map_chr(private$hosts, function(host) {
        host_priv <- environment(host$initialize)$private
        host_priv$engines$rest$rest_api_url
      })
      private$print_item("Hosts", hosts, paste0(hosts, collapse = ", "))
      orgs <- purrr::map(private$hosts, function(host) {
        host_priv <- environment(host$initialize)$private
        orgs <- host_priv$orgs
        paste0(orgs, collapse = ", ")
      }) %>% paste0(collapse = ", ")
      private$print_item("Organisations", orgs)
      private$print_item("Search preference", private$settings$search_param)
      private$print_item("Team", private$settings$team_name, paste0(private$settings$team_name, " (", length(private$settings$team), " members)"))
      private$print_item("Phrase", private$settings$phrase)
      private$print_item("Language", private$settings$language)
      private$print_item("Repositories output", private$repos, paste0("Rows number: ", nrow(private$repos)))
      private$print_item("Commits output", private$commits, paste0("Since: ", min(private$commits$committed_date), "Until: ", max(private$commits$committed_date), "; Rows number: ", nrow(private$commits)))
    }
  ),
  private = list(

    # @field hosts A list of API connections information.
    hosts = list(),

    # @field settings List of search preferences.
    settings = list(
      search_param = "org",
      phrase = NULL,
      team_name = NULL,
      team = list(),
      language = NULL,
      print_out = TRUE
    ),

    # @field repos An output table of repositories.
    repos = NULL,

    # @field commits An output table of commits.
    commits = NULL,

    # @description Check whether the urls do not repeat in input.
    # @param host An object of GitPlatform class
    # @return A GitPlatform object
    check_host = function(host) {
      if (length(private$hosts) > 0) {
        hosts_to_check <- append(host, private$hosts)

        urls <- purrr::map_chr(hosts_to_check, function(host) {
          host_priv <- environment(host$initialize)$private
          host_priv$engines$rest$rest_api_url
        })

        if (length(urls) != length(unique(urls))) {
          stop("You can not provide two hosts of the same API urls.
               If you wish to change/add more organizations you can do it with `set_organizations()` function.",
            call. = FALSE
          )
        }
      }

      host
    },

    # @description Switcher to manage language names
    # @details E.g. GitLab API will not filter
    #   properly if you provide 'python' language
    #   with small letter.
    # @param language A character, language name
    # @return A character
    language_handler = function(language) {
      if (!is.null(language)) {
        substr(language, 1, 1) <- toupper(substr(language, 1, 1))
      } else if (language %in% c("javascript", "Javascript", "js", "JS", "Js")) {
        language <- "JavaScript"
      }
      language
    },

    # @description A helper to manage printing `GitStats` object.
    # @param name Name of item to print.
    # @param item_to_check Item to check for emptiness.
    # @param item_to_print Item to print, if not defined it is item that is checked.
    # @return Nothing, prints object.
    print_item = function(item_name,
                          item_to_check,
                          item_to_print = item_to_check) {
      cat(paste0(
        cli::col_blue(paste0(item_name, ": ")),
        ifelse(is.null(item_to_check),
          cli::col_grey("<not defined>"),
          item_to_print
        ), "\n"
      ))
    }
  )
)
