#' @noRd
#' @importFrom R6 R6Class
#' @importFrom cli cli_alert_info cli_alert_success cli_alert_warning col_yellow
#' @importFrom data.table rbindlist
#' @importFrom dplyr glimpse
#' @importFrom magrittr %>%
#' @importFrom purrr map map_chr
#'
#' @title A statistics platform for Git hosts
#' @description An R6 class object with methods to derive information from multiple Git platforms.
#'
GitStats <- R6::R6Class("GitStats",
  public = list(

    #' @description Set up your search settings.
    #' @param search_param One of four: `team`, `org`, `repo` or `phrase`.
    #' @param team_name A name of a team.
    #' @param phrase A phrase to look for.
    #' @param language A language of programming code.
    #' @param print_out A boolean stating if you want to print output after
    #'   pulling.
    #' @return Nothing.
    set_params = function(search_param,
                          team_name = NULL,
                          phrase = NULL,
                          language = "All",
                          print_out = TRUE) {
      search_param <- match.arg(
        search_param,
        c("org", "repo", "team", "phrase")
      )

      if (search_param == "team") {
        if (is.null(team_name)) {
          cli::cli_abort(
            "You need to define your `team_name`."
          )
        } else {
          private$settings$team_name <- team_name
          cli::cli_alert_success(
            paste0("Your search parameter set to {cli::col_green('team: ", team_name, "')}.")
          )
          if (length(private$settings$team) == 0) {
            cli::cli_alert_warning(
              cli::col_yellow(
                "No team members in the team. Add them with `set_team_member()`."
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
      if (language != "All") {
        private$settings$language <- private$language_handler(language)
        cli::cli_alert_success(
          "Your programming language is set to {cli::col_green({language})}."
        )
      } else {
        private$settings$language <- "All"
      }
      private$settings$print_out <- print_out
    },

    #' @description Method to set connections to Git platforms.
    #' @param api_url A character, url address of API.
    #' @param token A token.
    #' @param orgs An optional character vector of organisations (owners of
    #'   repositories in case of GitHub and groups of projects in case of GitLab).
    #'   If you pass it, `repos` parameter should stay `NULL`.
    #' @param repos An optional character vector of repositories full names
    #'   (organization and repository name, e.g. "r-world-devs/GitStats"). If you
    #'   pass it, `orgs` parameter should stay `NULL`.
    #' @return Nothing, puts connection information into `$hosts` slot.
    set_host = function(api_url,
                        token = NULL,
                        orgs = NULL,
                        repos = NULL) {
      new_host <- NULL

      new_host <- GitHost$new(
        orgs = orgs,
        repos = repos,
        token = token,
        api_url = api_url
      )
      if (grepl("https://", api_url) && grepl("github", api_url)) {
        cli::cli_alert_success("Set connection to GitHub.")
      } else if (grepl("https://", api_url) && grepl("gitlab|code", api_url)) {
        cli::cli_alert_success("Set connection to GitLab.")
      }
      if (!is.null(repos)) {
        private$settings$search_param <- "repo"
        cli::cli_alert_info(cli::col_grey("Your search parameter set to [repo]."))
      }
      if (!is.null(orgs)) {
        private$settings$search_param <- "org"
        cli::cli_alert_info(cli::col_grey("Your search parameter set to [org]."))
      }
      if (!is.null(new_host)) {
        private$hosts <- new_host %>%
          private$check_for_duplicate_hosts() %>%
          append(private$hosts, .)
      }
    },

    #' @description A method to add a team member.
    #' @param member_name Name of a member.
    #' @param ... User names on Git platforms.
    #' @return Nothing, passes information on team member to `GitStats`.
    set_team_member = function(member_name,
                               ...) {
      team_member <- list(
        "name" = member_name,
        "logins" = unlist(list(...))
      )
      private$settings$team[[paste0(member_name)]] <- team_member
      cli::cli_alert_success("{member_name} successfully added to team.")
    },

    #' @description Wrapper over pulling repositories by phrase.
    #' @param package_name A character, name of the package.
    #' @param only_loading A boolean, if `TRUE` function will check only if package
    #'   is loaded in repositories, not used as dependencies. This is much faster
    #'   approach as searching usage only with loading (i.e. library(package)) is
    #'   based on Search APIs (one endpoint), whereas searching usage as a
    #'   dependency pulls text files from all repositories (many endpoints). This is
    #'   a good option to choose when you want to check package usage but guess that
    #'   it may be used mainly by loading in data scripts and not used as a
    #'   dependency of other packages.
    pull_R_package_usage = function(package_name, only_loading = FALSE) {
      repos_using_package <- private$check_R_package_loading(package_name)
      repos_with_package_as_dependency <- if (!only_loading) {
        private$check_R_package_as_dependency(package_name)
      } else {
        NULL
      }
      package_usage_table <- purrr::list_rbind(
        list(
          repos_with_package_as_dependency,
          repos_using_package
        )
      )
      duplicated_repos <- package_usage_table$api_url[duplicated(package_usage_table$api_url)]
      package_usage_table <- package_usage_table[!duplicated(package_usage_table$api_url),]
      package_usage_table <- package_usage_table %>%
        dplyr::mutate(
          package_usage = ifelse(api_url %in% duplicated_repos, "import, library", package_usage)
        )
      private$R_package_usage <- package_usage_table
      return(invisible(self))
    },

    #' @description  A method to list all repositories for an organization,
    #'   a team or by a keyword.
    #' @param add_contributors A boolean to decide whether to add contributors
    #'   information to repositories.
    pull_repos = function(add_contributors = FALSE) {
      if (private$settings$search_param == "repo") {
        cli::cli_abort(
          c(
            "Can not pull repos when search parameter is set to `repo`",
            "i" = "Pass `orgs` to `GitStats` with `set_host()` function.",
            "i" = "Set your search parameter to `org`, `phrase` or `team` with `set_params()` function."
          ),
          call = NULL
        )
      }
      if (private$settings$search_param == "team") {
        if (length(private$settings$team) == 0) {
          cli::cli_abort("You have to specify a team first with 'set_team_member()'.")
        }
      } else if (private$settings$search_param == "phrase") {
        if (is.null(private$settings$phrase)) {
          cli::cli_abort("You have to provide a phrase to look for.")
        }
      }
      repos_table <- purrr::map(private$hosts, ~ .$pull_repos(
        settings = private$settings,
        add_contributors = add_contributors
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

    #' @description A method to add information on repository contributors.
    #' @return A table of repositories with added information on contributors.
    pull_repos_contributors = function() {
      if (length(private$repos) == 0) {
        cli::cli_abort("You need to pull repos first with `pull_repos()`.")
      } else {
        private$repos <- purrr::map_dfr(private$hosts, ~ .$pull_repos_contributors(
          repos_table = private$repos
        ))
      }
    },

    #' @description A method to get information on commits.
    #' @param date_from A starting date for commits.
    #' @param date_until An end date for commits.
    pull_commits = function(date_from,
                            date_until) {
      if (is.null(date_from)) {
        stop("You need to define `date_from`.", call. = FALSE)
      }
      if (private$settings$search_param == "team") {
        if (length(private$settings$team) == 0) {
          cli::cli_abort("You have to specify a team first with 'set_team_member()'.")
        }
      }
      commits_table <- purrr::map(private$hosts, function(host) {
        commits_table_host <- host$pull_commits(
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

    #' @description Get information on users.
    #' @param users Character vector of users.
    #' @return A data.frame of users.
    pull_users = function(users) {
      private$check_for_host()
      users_table <- purrr::map(private$hosts, function(host) {
        host$pull_users(users)
      }) %>%
        unique() %>%
        purrr::list_rbind()
      private$users <- users_table
      if (private$settings$print_out) dplyr::glimpse(users_table)
      return(invisible(self))
    },

    #' @description Pull text content of a file from all repositories.
    #' @param file_path A file path, may be a character vector.
    #' @param .use_pulled_repos A boolean if TRUE `GitStats` will pull files only
    #'   from stored in the output repositories.
    pull_files = function(file_path, .use_pulled_repos = FALSE) {
      private$check_for_host()
      files_table <- purrr::map(private$hosts, function(host) {
        host$pull_files(
          file_path = file_path,
          pulled_repos = if (.use_pulled_repos) {
            self$get_repos()
          } else {
            NULL
          }
        )
      }) %>%
        purrr::list_rbind()
      private$files <- files_table
      if (private$settings$print_out) dplyr::glimpse(files_table)
      return(invisible(self))
    },

    #' @description Return organizations vector from GitStats.
    get_orgs = function() {
      purrr::map(private$hosts, function(host) {
        orgs <- host$.__enclos_env__$private$orgs
        purrr::map_vec(orgs, ~ gsub("%2f", "/", .))
        }) %>% unlist()
    },

    #' @description Return repositories table from GitStats.
    get_repos = function() {
      private$repos
    },

    #' @description Return commits table from GitStats.
    get_commits = function() {
      private$commits
    },

    #' @description Return users table from GitStats.
    get_users = function() {
      private$users
    },

    #' @description Return files table from GitStats.
    get_files = function() {
      private$files
    },

    #' @description Return R_package_usage table from GitStats.
    get_R_package_usage = function() {
      private$R_package_usage
    },

    #' @description A print method for a GitStats object.
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
      })
      repos <- purrr::map(private$hosts, function(host) {
        host_priv <- environment(host$initialize)$private
        repos <- host_priv$repos
      })
      private$print_item("Organisations", orgs)
      private$print_item("Repositories", repos)
      private$print_item("Search parameter", private$settings$search_param)
      private$print_item("Team", private$settings$team_name, paste0(private$settings$team_name, " (", length(private$settings$team), " members)"))
      private$print_item("Phrase", private$settings$phrase)
      private$print_item("Language", private$settings$language)
      private$print_item("Repositories output", private$repos, paste0("Rows number: ", nrow(private$repos)))
      private$print_item("Commits output", private$commits, paste0("Since: ", min(private$commits$committed_date), "; Until: ", max(private$commits$committed_date), "; Rows number: ", nrow(private$commits)))
    }
  ),
  private = list(

    # @field hosts A list of API connections information.
    hosts = list(),

    # @field settings List of search preferences.
    settings = list(
      search_param = NULL,
      phrase = NULL,
      team_name = NULL,
      team = list(),
      language = "All",
      print_out = TRUE
    ),

    # @field repos An output table of repositories.
    repos = NULL,

    # @field commits An output table of commits.
    commits = NULL,

    # @field users An output table of users.
    users = NULL,

    # @field files An output table of files.
    files = NULL,

    # @field R_package_usage.
    R_package_usage = NULL,

    # @description Search repositories with `library(package_name)` in code blobs.
    # @param package_name Name of a package.
    check_R_package_loading = function(package_name) {
      cli::cli_alert_info("Checking where [{package_name}] is loaded from library...")
      package_usage_phrases <- c(
        paste0("library(", package_name, ")"),
        paste0(package_name, "::")
      )
      repos_using_package <- purrr::map(package_usage_phrases, ~ {
        suppressMessages(
          self$set_params(
            search_param = "phrase",
            phrase = .,
            print_out = FALSE
          )
        )
        self$pull_repos()
        repos_using_package <- self$get_repos()
        if (!is.null(repos_using_package)) {
          repos_using_package$package_usage <- "library"
          repos_using_package <- repos_using_package %>%
            dplyr::select(repo_name, repo_url, api_url, package_usage)
        }
        return(repos_using_package)
      }) %>%
        purrr::list_rbind() %>%
        unique()
      return(repos_using_package)
    },

    # @description Search repositories with `package_name` in DESCRIPTION and NAMESPACE files.
    # @param package_name Name of a package.
    check_R_package_as_dependency = function(package_name) {
      cli::cli_alert_info("Checking where [{package_name}] is used as a dependency...")
      if (any(c("DESCRIPTION", "NAMESPACE") %in% private$files$file_path)){
        desc_table <- self$get_files()
      } else {
        self$pull_files(
          file_path = c("DESCRIPTION", "NAMESPACE")
        )
        desc_table <- self$get_files()
      }
      repos_with_package <- desc_table[grepl(package_name, desc_table$file_content), ]
      if (nrow(repos_with_package) > 0) {
        repos_with_package <- repos_with_package[!duplicated(repos_with_package$api_url),]
        repos_with_package$package_usage <- "import"
      }
      repos_with_package <- repos_with_package %>%
        dplyr::select(repo_name, repo_url, api_url, package_usage)
      return(repos_with_package)
    },

    # @description Check whether the urls do not repeat in input.
    # @param host An object of GitPlatform class.
    # @return A GitPlatform object.
    check_for_duplicate_hosts = function(host) {
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

    # @description Helper to check if there are any hosts.
    check_for_host = function() {
      if (length(private$hosts) == 0) {
        cli::cli_abort("Add first your hosts with `set_host()`.")
      }
    },

    # @description Switcher to manage language names.
    # @details E.g. GitLab API will not filter
    #   properly if you provide 'python' language
    #   with small letter.
    # @param language Code programming language.
    # @return A character.
    language_handler = function(language) {
      if (language != "All") {
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
      if (item_name %in% c("Organisations", "Repositories")) {
        item_to_print <- unlist(item_to_print)
        item_to_print <- purrr::map_vec(item_to_print, function(element) {
          gsub("%2f", "/", element)
        })
        if (length(item_to_print) < 10) {
          list_items <- paste0(item_to_print, collapse = ", ")
        } else {
          item_to_print_cut <- item_to_print[1:10]
          list_items <- paste0(item_to_print_cut, collapse = ", ") %>%
            paste0("... and ", length(item_to_print) - 10, " more")
        }
        item_to_print <- paste0("[", cli::col_green(length(item_to_print)), "] ", list_items)
      }
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
