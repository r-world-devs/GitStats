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
    #' @param files Define files to scan.
    #' @param language A language of programming code.
    #' @param verbose A boolean stating if you want to print output after
    #'   pulling.
    #' @param use_storage A boolean. If set to `TRUE` it will pull data from the
    #'   storage when it is there, e.g. `repositories`, when user runs
    #'   `get_repos()`. If set to `FALSE` `get_repos()` will always pull data from
    #'   the API.
    #' @return Nothing.
    set_params = function(search_param,
                          team_name = NULL,
                          phrase = NULL,
                          files = NULL,
                          language = "All",
                          verbose = TRUE,
                          use_storage = TRUE) {
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
      if (!is.null(files)) {
        private$settings$files <- files
        cli::cli_alert_info("Set files {files} to scan.")
      } else {
        private$settings$files <- NULL
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
      private$settings$verbose <- verbose
      private$settings$use_storage <- use_storage
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

    #' @description Get release logs of repositories.
    #' @param since A starting date for release logs.
    #' @param until An end date for release logs.
    get_release_logs = function(since, until) {
      private$check_for_host()
      if (private$trigger_pulling("release_logs", dates = list(since, until))) {
        release_logs <- private$pull_release_logs(
          date_from = since,
          date_until = until
        ) %>%
          private$set_dates_as_attr(since, until)
        private$save_to_storage(release_logs)
      } else {
        release_logs <- private$get_from_storage("release_logs")
      }
      if (private$settings$verbose) dplyr::glimpse(release_logs)
      return(invisible(release_logs))
    },

    #' @description Wrapper over pulling repositories by phrase.
    #' @param package_name A character, name of the package.
    #' @param only_loading A boolean, if `TRUE` function will check only if
    #'   package is loaded in repositories, not used as dependencies.
    get_R_package_usage = function(package_name, only_loading = FALSE) {
      private$check_for_host()
      if (is.null(package_name)) {
        cli::cli_abort("You need to define `package_name`.", call = NULL)
      }
      if (private$trigger_pulling_package(package_name)) {
        R_package_usage <- private$pull_R_package_usage(
          package_name = package_name,
          only_loading = only_loading
        ) %>%
          private$set_as_attr("package_name", package_name)
        private$save_to_storage(R_package_usage)
      } else {
        R_package_usage <- private$get_from_storage("R_package_usage")
      }
      if (private$settings$verbose) dplyr::glimpse(R_package_usage)
      return(invisible(R_package_usage))
    },

    #' @description  A method to list all repositories for an organization, a
    #'   team or by a keyword.
    #' @param add_contributors A boolean to decide whether to add contributors
    #'   information to repositories.
    get_repos = function(add_contributors = FALSE) {
      private$check_for_host()
      private$check_search_param_for_repos()
      if (private$trigger_pulling("repositories")) {
        repositories <- private$pull_repos(
          add_contributors = add_contributors,
          settings = private$settings
        )
        private$save_to_storage(repositories)
      } else {
        repositories <- private$get_from_storage("repositories")
      }
      if (private$settings$verbose) dplyr::glimpse(repositories)
      return(invisible(repositories))
    },

    #' @description A method to get information on commits.
    #' @param since A starting date for commits.
    #' @param until An end date for commits.
    get_commits = function(since, until) {
      private$check_for_host()
      private$check_search_param_for_commits()
      if (private$trigger_pulling("commits", dates = list(since, until))) {
        commits <- private$pull_commits(
          date_from = since,
          date_until = until
        ) %>%
          private$set_dates_as_attr(since, until)
        private$save_to_storage(commits)
      } else {
        commits <- private$get_from_storage('commits')
      }
      if (private$settings$verbose) {
        private$commits_success_info(commits = commits)
        dplyr::glimpse(commits)
      }
      return(invisible(commits))
    },

    #' @title Get statistics on commits
    #' @name get_commits_stats
    #' @description Prepare statistics from the pulled commits data.
    #' @param time_interval A character, specifying time interval to show statistics.
    #' @return A table of `commits_stats` class.
    get_commits_stats = function(time_interval = c("month", "day", "week")){
      commits <- private$storage[["commits"]]
      if (is.null(commits)) {
        cli::cli_abort(c(
          "x" = "No commits found in GitStats storage.",
          "i" = "Run first `get_commits()`."
        ),
        call = NULL)
      }
      time_interval <- match.arg(time_interval)

      commits_stats <- private$prepare_commits_stats(
        commits = commits,
        time_interval = time_interval
      )
      return(commits_stats)
    },

    #' @description Get information on users.
    #' @param logins Character vector of logins.
    get_users = function(logins) {
      private$check_for_host()
      if (private$trigger_pulling_users(logins)) {
        users <- private$pull_users(logins) %>%
          private$set_as_attr("logins", logins)
        private$save_to_storage(users)
      } else {
        users <- private$get_from_storage("users")
      }
      if (private$settings$verbose) dplyr::glimpse(users)
      return(invisible(users))
    },

    #' @description Pull text content of a file from all repositories.
    #' @param file_path A file path, may be a character vector.
    get_files = function(file_path) {
      private$check_for_host()
      if (private$trigger_pulling_files(file_path)) {
        files <- private$pull_files(file_path) %>%
          private$set_as_attr("file_path", file_path)
        private$save_to_storage(files)
      } else {
        files <- private$get_from_storage("files")
      }
      if (private$settings$verbose) dplyr::glimpse(files)
      return(invisible(files))
    },

    #' @description Return organizations vector from GitStats.
    show_orgs = function() {
      purrr::map(private$hosts, function(host) {
        orgs <- host$.__enclos_env__$private$orgs
        purrr::map_vec(orgs, ~ gsub("%2f", "/", .))
        }) %>% unlist()
    },

    #' @description Retrieves table stored in `GitStats` object.
    #' @param storage Table of `repositories`, `commits`, `users`, `files` or
    #'   `R_package_usage`.
    #' @return A table.
    show_data = function(storage) {
      storage <- match.arg(
        arg = storage,
        choices = c("repos", "repositories", "commits", "files", "users",
                    "R_package_usage", "package_usage", "releases", "release_logs")
      )
      if (storage == "repos") {
        storage <- "repositories"
      }
      if (storage == "package_usage") {
        storage <- "R_package_usage"
      }
      if (storage == "releases") {
        storage <- "release_logs"
      }
      storage <- private$get_from_storage(storage)
      return(storage)
    },

    #' @description A print method for a GitStats object.
    print = function() {
      cat(paste0("A ", cli::col_blue('GitStats'), " object for ", length(private$hosts)," hosts: \n"))
      private$print_hosts()
      cat(cli::col_blue("Scanning scope: \n"))
      private$print_orgs_and_repos()
      private$print_files()
      cat(cli::col_blue("Search settings: \n"))
      private$print_search_parameters()
      private$print_team()
      private$print_verbose()
      private$print_use_storage()
      private$print_storage()
    }
  ),
  private = list(

    # @field hosts A list of API connections information.
    hosts = list(),

    # @field settings List of search preferences.
    settings = list(
      search_param = NULL,
      phrase = NULL,
      files = NULL,
      team_name = NULL,
      team = list(),
      language = "All",
      verbose = TRUE,
      use_storage = TRUE
    ),

    # temporary settings used when calling some methods for custom purposes
    temp_settings = list(
      search_param = NULL,
      phrase = NULL,
      files = NULL,
      team_name = NULL,
      team = list(),
      language = "All",
      verbose = TRUE,
      use_storage = TRUE
    ),

    # @field storage for results
    storage = list(
      repositories = NULL,
      commits = NULL,
      users = NULL,
      files = NULL,
      R_package_usage = NULL,
      release_logs = NULL
    ),

    # Check if table exists in storage
    storage_is_empty = function(table) {
      is.null(private$storage[[table]])
    },

    # Save table to storage
    save_to_storage = function(table) {
      table_name <- deparse(substitute(table))
      private$storage[[paste0(table_name)]] <- table
    },

    # Retrieve table form storage
    get_from_storage = function(table) {
      cli::cli_alert_warning(cli::col_yellow(glue::glue("Retrieving {table} from the GitStats storage.")))
      cli::cli_alert_info(cli::col_cyan("If you wish to pull the data from API once more, set `use_storage` to `FALSE` in `set_params()` function."))
      private$storage[[table]]
    },

    # Boolean
    do_not_use_storage = function() {
      private$settings[["use_storage"]] == FALSE
    },

    # Decide if data needs to be pulled from API
    trigger_pulling = function(storage, dates = NULL) {
      private$storage_is_empty(storage) || private$do_not_use_storage() ||
        private$dates_do_not_comply(storage, dates)
    },

    # Decide if data needs to be pulled from API
    trigger_pulling_package = function(package_name) {
      !private$is_package_usage_in_storage(package_name)
    },

    # Check if package is already in GitStats storage
    is_package_usage_in_storage = function(package_name) {
      package_usage_in_storage <- private$storage[["R_package_usage"]]
      if (!is.null(package_usage_in_storage)) {
        package_name == attr(package_usage_in_storage, "package_name")
      } else {
        FALSE
      }
    },

    # Decide if data needs to be pulled from API
    trigger_pulling_files = function(file_path) {
      !private$are_files_in_storage(file_path)
    },

    # Check if data on files is already in GitStats storage
    are_files_in_storage = function(file_path) {
      files_in_storage <- private$storage[["files"]]
      if (!is.null(files_in_storage)) {
        setequal(file_path, attr(files_in_storage, "file_path"))
      } else {
        FALSE
      }
    },

    # Decide if data needs to be pulled from API
    trigger_pulling_users = function(logins) {
      !private$are_users_in_storage(logins)
    },

    # Check if data on users is already in GitStats storage
    are_users_in_storage = function(logins) {
      users_in_storage <- private$storage[["users"]]
      if (!is.null(users_in_storage)) {
        setequal(logins, attr(users_in_storage, "logins"))
      } else {
        FALSE
      }
    },

    # Check if dates in function call are the same as in storage
    dates_do_not_comply = function(storage, dates) {
      do_not_comply <- FALSE
      if (!is.null(dates)) {
        dates <- standardize_dates(dates)
        dates_storage <- private$get_dates_from_storage(storage)
        do_not_comply <- !dplyr::setequal(dates, dates_storage)
      }
      return(do_not_comply)
    },

    # Get date from and date until from storage
    get_dates_from_storage = function(storage) {
      attr(private$storage[[storage]], "dates_range")
    },

    # Save dates parameters as attributes of the object
    set_dates_as_attr = function(object, date_from, date_until) {
      attr(object, "dates_range") <- list(date_from, date_until) %>%
        standardize_dates()
      return(object)
    },

    # Save meta data as an attribute of the object
    set_as_attr = function(object, attribute_name, attribute) {
      attr(object, attribute_name) <- attribute
      return(object)
    },

    # Handle search parameter when pulling repositories
    check_search_param_for_repos = function() {
      search_param <- private$settings$search_param
      if (search_param == "repo") {
        cli::cli_abort(
          c(
            "Can not pull repos when search parameter is set to `repo`",
            "i" = "Pass `orgs` to `GitStats` with `set_host()` function.",
            "i" = "Set your search parameter to `org`, `phrase` or `team` with `set_params()` function."
          ),
          call = NULL
        )
      }
      if (search_param == "team") {
        if (length(private$settings$team) == 0) {
          cli::cli_abort("You have to specify a team first with 'set_team_member()'.", call = NULL)
        }
      } else if (search_param == "phrase") {
        if (is.null(private$settings$phrase)) {
          cli::cli_abort("You have to provide a phrase to look for.", call = NULL)
        }
      }
    },

    # Handle search parameter when pulling commits
    check_search_param_for_commits = function() {
      search_param <- private$settings$search_param
      if (search_param == "team") {
        if (length(private$settings$team) == 0) {
          cli::cli_abort("You have to specify a team first with 'set_team_member()'.", call = NULL)
        }
      }
    },

    # Pull repositories tables from hosts and bind them into one
    pull_repos = function(add_contributors = FALSE, settings) {
      repos_table <- purrr::map(private$hosts, ~ .$pull_repos(
        settings = settings,
        add_contributors = add_contributors
      )) %>%
        purrr::list_rbind() %>%
        private$add_stats_to_repos()
      return(repos_table)
    },

    # Pull commits tables from hosts and bind them into one
    pull_commits = function(date_from, date_until) {
      commits_table <- purrr::map(private$hosts, function(host) {
        host$pull_commits(
          date_from = date_from,
          date_until = date_until,
          settings = private$settings,
          .storage = private$storage
        )
      }) %>%
        purrr::list_rbind()
      return(commits_table)
    },

    # Pull information on unique users in a table form
    pull_users = function(logins) {
      purrr::map(private$hosts, function(host) {
        host$pull_users(logins)
      }) %>%
        unique() %>%
        purrr::list_rbind()
    },

    # Pull content of a text file in a table form
    pull_files = function(file_path) {
      purrr::map(private$hosts, function(host) {
        host$pull_files(
          file_path = file_path,
          pulled_repos = private$storage[["repositories"]]
        )
      }) %>%
        purrr::list_rbind()
    },

    # Pull release logs tables from hosts and bind them into one
    pull_release_logs = function(date_from, date_until) {
      purrr::map(private$hosts, ~ .$pull_release_logs(
        date_from = date_from,
        date_until = date_until,
        settings = private$settings,
        .storage = private$storage
      )) %>%
        purrr::list_rbind()
    },

    # Pull information on package usage in a table form
    pull_R_package_usage = function(package_name, only_loading) {
      if (!only_loading) {
        repos_with_package_as_dependency <- private$check_R_package_as_dependency(package_name)
      } else {
        repos_with_package_as_dependency <- NULL
      }
      repos_using_package <- private$check_R_package_loading(package_name)
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
      rownames(package_usage_table) <- c(1:nrow(package_usage_table))
      return(package_usage_table)
    },

    # Search repositories with `library(package_name)` in code blobs.
    check_R_package_loading = function(package_name) {
      cli::cli_alert_info("Checking where [{package_name}] is loaded from library...")
      package_usage_phrases <- c(
        paste0("library(", package_name, ")"),
        paste0("require(", package_name, ")")
      )
      private$temp_settings$search_param <- "phrase"
      private$temp_settings$files <- NULL
      repos_using_package <- purrr::map(package_usage_phrases, ~ {
        private$temp_settings$phrase <- .
        repos_using_package <- private$pull_repos(
          settings = private$temp_settings
        )
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
      private$temp_settings$search_param <- "phrase"
      private$temp_settings$phrase <- package_name
      private$temp_settings$files <- c("DESCRIPTION", "NAMESPACE")
      repos_with_package <- private$pull_repos(
        settings = private$temp_settings
      )
      if (nrow(repos_with_package) > 0) {
        repos_with_package <- repos_with_package[!duplicated(repos_with_package$api_url),]
        repos_with_package$package_usage <- "import"
      }
      repos_with_package <- repos_with_package %>%
        dplyr::select(repo_name, repo_url, api_url, package_usage)
      return(repos_with_package)
    },

    # Add some user-friendly columns to repositories table
    add_stats_to_repos = function(repos_table) {
      if (nrow(repos_table > 0)) {
        repos_table <- repos_table %>%
          dplyr::mutate(
            fullname = paste0(organization, "/", repo_name)
          ) %>%
          dplyr::mutate(
            last_activity = difftime(
              Sys.time(),
              last_activity_at,
              units = "days"
            ) %>% round(2),
            platform = retrieve_platform(api_url)
          ) %>%
          dplyr::relocate(
            organization, fullname, platform, repo_url, api_url, created_at,
            last_activity_at, last_activity,
            .after = repo_name
          )
        if ("contributors" %in% colnames(repos_table)) {
          repos_table <- dplyr::mutate(
            repos_table,
            contributors_n = purrr::map_vec(contributors, function(contributors_string) {
              length(stringr::str_split(contributors_string[1], ", ")[[1]])
            })
          )
        }
      } else {
        repos_table <- NULL
      }
      return(repos_table)
    },

    # Handler for message when team is set
    commits_success_info = function(commits) {
      if (private$settings$search_param == "team" && !is.null(private$settings$team)) {
        cli::cli_alert_success(
          paste0(
            "For '", private$settings$team_name, "' team: pulled ",
            nrow(commits), " commits from ",
            length(unique(commits$repository)), " repositories."
          )
        )
      }
    },

    # Prepare stats out of commits table
    prepare_commits_stats = function(commits, time_interval) {
      commits_stats <- commits %>%
        dplyr::mutate(
          stats_date = lubridate::floor_date(
            committed_date,
            unit = time_interval
          ),
          platform = retrieve_platform(api_url)
        ) %>%
        dplyr::group_by(stats_date, platform, organization) %>%
        dplyr::summarise(
          commits_n = dplyr::n()
        ) %>%
        dplyr::arrange(
          stats_date
        )
      commits_stats <- commits_stats(
        object = commits_stats,
        time_interval = time_interval
      )
      return(commits_stats)
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
          cli::cli_abort(c(
            "x" = "You can not provide two hosts of the same API urls.",
            "i" = "If you wish to change/add more organizations you can do it with `set_organizations()` function."
          ),
          call = NULL
          )
        }
      }

      host
    },

    # @description Helper to check if there are any hosts.
    check_for_host = function() {
      if (length(private$hosts) == 0) {
        cli::cli_abort("Add first your hosts with `set_host()`.", call = NULL)
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
      if (item_name %in% c(" Organizations", " Repositories", " Files")) {
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
    },

    # print hosts passed to GitStats
    print_hosts = function() {
      hosts <- purrr::map_chr(private$hosts, function(host) {
        host_priv <- environment(host$initialize)$private
        host_priv$engines$rest$rest_api_url
      })
      private$print_item("Hosts", hosts, paste0(hosts, collapse = ", "))
    },

    # print organizations and repositories set in GitStats
    print_orgs_and_repos = function() {
      orgs <- purrr::map(private$hosts, function(host) {
        host_priv <- environment(host$initialize)$private
        orgs <- host_priv$orgs
      })
      repos <- purrr::map(private$hosts, function(host) {
        host_priv <- environment(host$initialize)$private
        repos <- host_priv$repos
      })
      private$print_item(" Organizations", orgs)
      private$print_item(" Repositories", repos)
    },

    # print files set to be scanned to GitStats
    print_files = function() {
      private$print_item(
        " Files",
        private$settings$files
      )
    },

    # print team name and number of team members
    print_team = function() {
      members_n <- length(private$settings$team)
      private$print_item(
        " Team",
        item_to_check = private$settings$team_name,
        item_to_print = glue::glue("{private$settings$team_name} ({members_n} members)")
      )
    },

    # print search parameters: organization, team, phrase, language
    print_search_parameters = function() {
      item_names <- list(
        " Search parameter", " Phrase", " Language"
      )
      items <- list(
        private$settings$search_param,
        private$settings$phrase,
        private$settings$language
      )
      purrr::walk2(item_names, items, ~ private$print_item(.x, .y))
    },

    # print verbose mode
    print_verbose = function() {
      private$print_item("Verbose", private$settings$verbose)
    },

    # print if storage is used
    print_use_storage = function() {
      private$print_item("Use storage", private$settings$use_storage)
    },

    # print storage
    print_storage = function() {
      gitstats_storage <- purrr::imap(private$storage, function(storage_table, storage_name) {
        if (!is.null(storage_table)) {
          glue::glue(
            "{stringr::str_to_title(storage_name)}: {nrow(storage_table)} {private$print_storage_attribute(storage_table, storage_name)}"
          )
        }
      }) %>%
        purrr::discard(~is.null(.))
      if (length(gitstats_storage) == 0) {
        private$print_item(
          "Storage",
          cli::col_grey("<no tables in storage>")
        )
      } else {
        cat(paste0(
          cli::col_blue("Storage: \n"),
          paste0(" ", gitstats_storage, collapse = "\n")
        ))
      }
    },

    # print storage attribute
    print_storage_attribute = function(storage_table, storage_name) {
       if (storage_name != "repositories") {
        storage_attr <- switch(storage_name,
                               "files" = "file_path",
                               "commits" = "dates_range",
                               "release_logs" = "dates_range",
                               "users" = "logins",
                               "R_package_usage" = "package_name")
        attr_data <- attr(storage_table, storage_attr)
        attr_name <- switch(storage_attr,
                            "file_path" = "files",
                            "dates_range" = "date range",
                            "package_name" = "package",
                            "logins" = "logins")
        if (length(attr_data) > 1) {
          separator <- if (storage_attr == "dates_range") {
            " - "
          } else {
            ", "
          }
          attr_data <- attr_data %>% paste0(collapse = separator)
        }
        return(cli::col_grey(glue::glue("[{attr_name}: {attr_data}]")))
      } else {
        return("")
      }
    }
  )
)
