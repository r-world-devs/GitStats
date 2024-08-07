#' @noRd
#' @description A highest-level class to manage data pulled from different hosts.
GitStats <- R6::R6Class("GitStats",
  public = list(

    #' @description Method to set connections to Git platforms.
    #' @param host A character, optional, URL name of the host. If not passed, a
    #'   public host will be used (api.github.com).
    #' @param token A token.
    #' @param orgs An optional character vector of organisations (owners of
    #'   repositories in case of GitHub). If you pass it, `repos` parameter
    #'   should stay `NULL`.
    #' @param repos An optional character vector of repositories full names
    #'   (organization and repository name, e.g. "r-world-devs/GitStats"). If
    #'   you pass it, `orgs` parameter should stay `NULL`.
    #' @param verbose A logical, `TRUE` by default. If `FALSE` messages and printing
    #'   output is switched off.
    #' @return Nothing, puts connection information into `$hosts` slot.
    set_github_host = function(host,
                               token = NULL,
                               orgs = NULL,
                               repos = NULL,
                               verbose = TRUE) {
      new_host <- NULL
      new_host <- GitHostGitHub$new(
        orgs = orgs,
        repos = repos,
        token = token,
        host = host,
        verbose = verbose
      )
      private$add_new_host(new_host)
    },

    #' @description Method to set connections to Git platforms.
    #' @param host A character, optional, URL name of the host. If not passed, a
    #'   public host will be used (gitlab.com/api/v4).
    #' @param token A token.
    #' @param orgs An optional character vector of organisations (groups of
    #'   projects in case of GitLab). If you pass it, `repos` parameter should
    #'   stay `NULL`.
    #' @param repos An optional character vector of repositories full names
    #'   (organization and repository name, e.g. "r-world-devs/GitStats"). If
    #'   you pass it, `orgs` parameter should stay `NULL`.
    #' @param verbose A logical, `TRUE` by default. If `FALSE` messages and printing
    #'   output is switched off.
    #' @return Nothing, puts connection information into `$hosts` slot.
    set_gitlab_host = function(host,
                               token = NULL,
                               orgs = NULL,
                               repos = NULL,
                               verbose = TRUE) {
      new_host <- NULL
      new_host <- GitHostGitLab$new(
        orgs = orgs,
        repos = repos,
        token = token,
        host = host,
        verbose = verbose
      )
      private$add_new_host(new_host)
    },

    #' @description  A method to list all repositories for an organization or by
    #'   a keyword.
    #' @param add_contributors A boolean to decide whether to add contributors
    #'   information to repositories.
    #' @param with_code A character vector, if defined, GitStats will pull
    #'   repositories with specified code phrases in code blobs.
    #' @param in_files A character vector of file names. Works when `with_code` is
    #'   set - then it searches code blobs only in files passed to `in_files`
    #'   parameter.
    #' @param with_files A character vector, if defined, GitStats will pull
    #'   repositories with specified files.
    #' @param cache A logical, if set to `TRUE` GitStats will retrieve the last
    #'   result from its storage.
    #' @param verbose A logical, `TRUE` by default. If `FALSE` messages and
    #'   printing output is switched off.
    get_repos = function(add_contributors = FALSE,
                         with_code = NULL,
                         in_files = NULL,
                         with_files = NULL,
                         cache = TRUE,
                         verbose = TRUE) {
      private$check_for_host()
      private$check_params_conflict(
        with_code = with_code,
        in_files = in_files,
        with_files = with_files
      )
      args_list <- list("with_code" = with_code,
                        "in_files" = in_files,
                        "with_files" = with_files)
      trigger <- private$trigger_pulling(
        cache = cache,
        storage = "repositories",
        args_list = args_list,
        verbose = verbose
      )
      if (trigger) {
        repositories <- private$get_repos_table(
          add_contributors = add_contributors,
          with_code = with_code,
          in_files = in_files,
          with_files = with_files,
          verbose = verbose,
          settings = private$settings
        ) %>%
          private$set_object_class(
            class = "repos_table",
            attr_list = args_list
          )
        private$save_to_storage(
          table = repositories
        )
      } else {
        repositories <- private$get_from_storage(
          table = "repositories",
          verbose = verbose
        )
      }
      return(repositories)
    },

    #' @description A wrapper over search API endpoints to list repositories
    #'   URLS.
    #' @param type A character, choose if `api` or `web` (`html`) URLs should be
    #'   returned.
    #' @param with_code A character vector, if defined, GitStats will pull
    #'   repositories with specified code phrases in code blobs.
    #' @param in_files A character vector of file names. Works when `with_code` is
    #'   set - then it searches code blobs only in files passed to `in_files`
    #'   parameter.
    #' @param with_files A character vector, if defined, GitStats will pull
    #'   repositories with specified files.
    #' @param cache A logical, if set to `TRUE` GitStats will retrieve the last
    #'   result from its storage.
    #' @param verbose A logical, `TRUE` by default. If `FALSE` messages and
    #'   printing output is switched off.
    #' @return A character vector.
    get_repos_urls = function(type = "web",
                              with_code = NULL,
                              in_files = NULL,
                              with_files = NULL,
                              cache = TRUE,
                              verbose = TRUE) {
      private$check_for_host()
      private$check_params_conflict(
        with_code = with_code,
        in_files = in_files,
        with_files = with_files
      )
      args_list <- list("type" = type,
                        "with_code" = with_code,
                        "in_files" = in_files,
                        "with_files" = with_files)
      trigger <- private$trigger_pulling(
        cache = cache,
        storage = "repos_urls",
        args_list = args_list,
        verbose = verbose
      )
      if (trigger) {
        repos_urls <- private$get_repos_urls_from_hosts(
          type = type,
          with_code = with_code,
          in_files = in_files,
          with_files = with_files,
          verbose = verbose
        ) %>%
          private$set_object_class(
            class = "repos_urls",
            attr_list = args_list
          )
        private$save_to_storage(
          table = repos_urls
        )
      } else {
        repos_urls <- private$get_from_storage(
          table = "repos_urls",
          verbose = verbose
        )
      }
      return(repos_urls)
    },

    #' @description A method to get information on commits.
    #' @param since A starting date for commits.
    #' @param until An end date for commits.
    #' @param cache A logical, if set to `TRUE` GitStats will retrieve the last
    #'   result from its storage.
    #' @param verbose A logical, `TRUE` by default. If `FALSE` messages and
    #'   printing output is switched off.
    get_commits = function(since,
                           until,
                           cache = TRUE,
                           verbose = TRUE) {
      private$check_for_host()
      args_list <- list("since" = since,
                        "until" = until)
      trigger <- private$trigger_pulling(
        cache = cache,
        storage = "commits",
        args_list = args_list,
        verbose = verbose
      )
      if (trigger) {
        commits <- private$get_commits_table(
          since = since,
          until = until,
          verbose = verbose
        ) %>%
          private$set_object_class(
            class = "commits_data",
            attr_list = args_list
          )
        private$save_to_storage(commits)
      } else {
        commits <- private$get_from_storage(
          table = "commits",
          verbose = verbose
        )
      }
      return(commits)
    },

    #' @title Get statistics on commits
    #' @name get_commits_stats
    #' @description Prepare statistics from the pulled commits data.
    #' @param time_interval A character, specifying time interval to show
    #'   statistics.
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
    #' @param cache A logical, if set to `TRUE` GitStats will retrieve the last
    #'   result from its storage.
    #' @param verbose A logical, `TRUE` by default. If `FALSE` messages and
    #'   printing output is switched off.
    get_users = function(logins, cache = TRUE, verbose = TRUE) {
      private$check_for_host()
      args_list <- list("logins" = logins)
      trigger <- private$trigger_pulling(
        cache = cache,
        storage = "users",
        args_list = args_list,
        verbose = verbose
      )
      if (trigger) {
        users <- private$get_users_table(logins) %>%
          private$set_object_class(
            class = "users_data",
            attr_list = args_list
          )
        private$save_to_storage(users)
      } else {
        users <- private$get_from_storage(
          table = "users",
          verbose = verbose
        )
      }
      return(users)
    },

    #' @description Pull text content of a file from all repositories.
    #' @param file_path A file path, may be a character vector.
    #' @param cache A logical, if set to `TRUE` GitStats will retrieve the last
    #'   result from its storage.
    #' @param verbose A logical, `TRUE` by default. If `FALSE` messages and
    #'   printing output is switched off.
    get_files = function(file_path, cache = TRUE, verbose = TRUE) {
      private$check_for_host()
      args_list <- list("file_path" = file_path)
      trigger <- private$trigger_pulling(
        cache = cache,
        storage = "files",
        args_list = args_list,
        verbose = verbose
      )
      if (trigger) {
        files <- private$get_files_table(
          file_path = file_path,
          verbose = verbose
        ) %>%
          private$set_object_class(
            class = "files_data",
            attr_list = args_list
          )
        private$save_to_storage(files)
      } else {
        files <- private$get_from_storage(
          table = "files",
          verbose = verbose
        )
      }
      return(files)
    },

    #' @description Get release logs of repositories.
    #' @param since A starting date for release logs.
    #' @param until An end date for release logs.
    #' @param cache A logical, if set to `TRUE` GitStats will retrieve the last
    #'   result from its storage.
    #' @param verbose A logical, `TRUE` by default. If `FALSE` messages and
    #'   printing output is switched off.
    get_release_logs = function(since,
                                until,
                                cache = TRUE,
                                verbose = TRUE) {
      private$check_for_host()
      args_list <- list(
        "since" = since,
        "until" = until
      )
      trigger <- private$trigger_pulling(
        storage = "release_logs",
        cache = cache,
        args_list = args_list,
        verbose = verbose
      )
      if (trigger) {
        release_logs <- private$get_release_logs_table(
          since = since,
          until = until,
          verbose = verbose
        ) %>%
          private$set_object_class(
            class = "release_logs",
            attr_list = args_list
          )
        private$save_to_storage(release_logs)
      } else {
        release_logs <- private$get_from_storage(
          table = "release_logs",
          verbose = verbose
        )
      }
      return(release_logs)
    },

    #' @description Wrapper over pulling repositories by code.
    #' @param package_name A character, name of the package.
    #' @param only_loading A boolean, if `TRUE` function will check only if
    #'   package is loaded in repositories, not used as dependencies.
    #' @param cache A logical, if set to `TRUE` GitStats will retrieve the last
    #'   result from its storage.
    #' @param verbose A logical, `TRUE` by default. If `FALSE` messages and
    #'   printing output is switched off.
    get_R_package_usage = function(package_name,
                                   only_loading = FALSE,
                                   cache = TRUE,
                                   verbose = TRUE) {
      private$check_for_host()
      if (is.null(package_name)) {
        cli::cli_abort("You need to define `package_name`.", call = NULL)
      }
      args_list <- list(
        "package_name" = package_name,
        "only_loading" = only_loading
      )
      trigger <- private$trigger_pulling(
        storage = "R_package_usage",
        cache = cache,
        args_list = args_list,
        verbose = verbose
      )
      if (trigger) {
        R_package_usage <- private$get_R_package_usage_table(
          package_name = package_name,
          only_loading = only_loading,
          verbose = verbose
        ) %>%
          private$set_object_class(
            class = "R_package_usage",
            attr_list = args_list
          )
        private$save_to_storage(R_package_usage)
      } else {
        R_package_usage <- private$get_from_storage(
          table = "R_package_usage",
          verbose = verbose
        )
      }
      return(R_package_usage)
    },

    #' @description Return organizations vector from GitStats.
    show_orgs = function() {
      purrr::map(private$hosts, function(host) {
        orgs <- host$.__enclos_env__$private$orgs
        purrr::map_vec(orgs, ~ URLdecode(.))
        }) %>% unlist()
    },

    #' @description switch on verbose mode
    verbose_on = function() {
      private$settings$verbose <- TRUE
    },

    #' @description switch off verbose mode
    verbose_off = function() {
      private$settings$verbose <- FALSE
    },

    is_verbose = function() {
      private$settings$verbose
    },

    #' @description A print method for a GitStats object.
    print = function() {
      cat(paste0("A ", cli::col_blue('GitStats'), " object for ", length(private$hosts)," hosts: \n"))
      private$print_hosts()
      cat(cli::col_blue("Scanning scope: \n"))
      private$print_orgs_and_repos()
      private$print_storage()
    }
  ),
  private = list(

    # @field hosts A list of API connections information.
    hosts = list(),

    # @field settings List of search preferences.
    settings = list(
      verbose = TRUE,
      cache = TRUE
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

    # Add new host
    add_new_host = function(new_host) {
      if (!is.null(new_host)) {
        private$hosts <- new_host %>%
          private$check_for_duplicate_hosts() %>%
          append(private$hosts, .)
      }
    },

    # @description Helper to check if there are any hosts.
    check_for_host = function() {
      if (length(private$hosts) == 0) {
        cli::cli_abort("Add first your hosts with `set_github_host()` or `set_gitlab_host()`.", call = NULL)
      }
    },

    # Check if parameters are in conflict
    check_params_conflict = function(with_code, in_files, with_files) {
      if (!is.null(with_code) && !is.null(with_files)) {
        cli::cli_abort(c(
          "x" = "Both `with_code` and `with_files` parameters are defined.",
          "!" = "Use either `with_code` of `with_files` parameter.",
          "i" = "If you want to search for [{with_code}] code in given files - use `in_files` parameter together with `with_code` instead."
          ), call = NULL)
      }
      if (!is.null(in_files) && is.null(with_code)) {
        cli::cli_abort(c(
          "!" = "Passing files to `in_files` parameter works only when you search code with `with_code` parameter.",
          "i" = "If you want to search for repositories with [{in_files}] files you should instead use `with_files` parameter."
          ), call = NULL)
      }
    },

    # Handler for setting verbose parameter
    set_verbose_param = function(verbose) {
      if (!is.null(verbose)) {
        if (!is.logical(verbose)) {
          cli::cli_abort("verbose parameter accepts only TRUE/FALSE values")
        }
        private$settings$verbose <- verbose
      }
    },

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
    get_from_storage = function(table, verbose) {
      if (verbose) {
        cli::cli_alert_warning(cli::col_yellow(
          glue::glue("Retrieving {table} from the GitStats storage.")
        ))
        cli::cli_alert_info(cli::col_cyan(
          "If you wish to pull the data from API once more, set `cache` parameter to `FALSE`."
        ))
      }
      private$storage[[table]]
    },

    # Decide if repositories data will be pulled from API
    trigger_pulling = function(cache, storage, args_list, verbose) {
      trigger <- FALSE
      if (private$storage_is_empty(storage)) {
        trigger <- TRUE
      } else {
        repos_parameters_changed <- private$check_if_args_changed(
          storage = storage,
          args_list = args_list
        )
        if (repos_parameters_changed) {
          if (verbose) {
            cli::cli_alert_info(cli::col_blue(
              "Parameters changed, I will pull data from API."
            ))
          }
          trigger <- TRUE
        } else if (!repos_parameters_changed && !cache) {
          if (verbose) {
            cli::cli_alert_info(cli::col_blue(
              "Cache set to FALSE, I will pull data from API."
            ))
          }
          trigger <- TRUE
        }
      }
      return(trigger)
    },

    # Check
    check_if_args_changed = function(storage, args_list) {
      storage_data <- private$storage[[paste0(storage)]]
      stored_params <- purrr::map(names(args_list), ~ attr(storage_data, .) %||% "")
      new_params <- purrr::map(args_list, ~ . %||% "")
      !all(purrr::map2_lgl(new_params, stored_params, ~ identical(.x, .y)))
    },

    # Save dates parameters as attributes of the object
    set_object_class = function(object, class, attr_list) {
      class(object) <- append(class, class(object))
      purrr::iwalk(attr_list, function(attrib, attrib_name)  {
        attr(object, attrib_name) <<- attrib
      })
      # standardize_dates()
      return(object)
    },

    # Pull repositories tables from hosts and bind them into one
    get_repos_table = function(add_contributors = FALSE,
                               with_code,
                               in_files = NULL,
                               with_files,
                               verbose,
                               settings) {
      repos_table <- purrr::map(private$hosts, function(host) {
        if (!is.null(with_code)) {
          private$get_repos_from_host_with_code(
            host = host,
            add_contributors = add_contributors,
            with_code = with_code,
            in_files = in_files,
            verbose = verbose
          )
        } else if (!is.null(with_files)) {
          privater$get_repos_from_host_with_files(
            host = host,
            add_contributors = add_contributors,
            with_files = with_files,
            verbose = verbose
          )
        } else {
          host$get_repos(
            add_contributors = add_contributors,
            verbose = verbose,
            settings = settings
          )
        }
      }) %>%
        purrr::list_rbind() %>%
        private$add_stats_to_repos()
      return(repos_table)
    },

    # Get repositories table from one host with given text in code blobs
    get_repos_from_host_with_code = function(host,
                                             add_contributors,
                                             with_code,
                                             in_files,
                                             verbose,
                                             settings) {
      purrr::map(with_code, function(with_code) {
        host$get_repos(
          add_contributors = add_contributors,
          with_code = with_code,
          in_files = in_files,
          verbose = verbose,
          settings = settings
        )
      }) %>%
        purrr::list_rbind()
    },

    # Get repositories table from one host with given files
    get_repos_from_host_with_files = function(host,
                                              add_contributors,
                                              with_files,
                                              verbose,
                                              settings) {
      purrr::map(with_files, function(with_file) {
        host$get_repos(
          add_contributors = add_contributors,
          with_file = with_file,
          verbose = verbose,
          settings = settings
        )
      }) %>%
        purrr::list_rbind()
    },

    # Get repositories character vectors from hosts and bind them into one
    get_repos_urls_from_hosts = function(type, with_code, in_files, with_files, verbose) {
      purrr::map(private$hosts, function(host) {
        if (!is.null(with_code)) {
          private$get_repos_urls_from_host_with_code(
            host = host,
            type = type,
            with_code = with_code,
            in_files = in_files,
            verbose = verbose
          )
        } else if (!is.null(with_files)) {
          private$get_repos_urls_from_host_with_files(
            host = host,
            type = type,
            with_files = with_files,
            verbose = verbose
          )
        } else {
          host$get_repos_urls(
            type = type,
            verbose = verbose
          )
        }
      }) %>%
        unlist() %>%
        unique()
    },

    # Get repositories URLs from one host with code
    get_repos_urls_from_host_with_code = function(host,
                                                  type,
                                                  with_code,
                                                  in_files,
                                                  verbose) {
      purrr::map(with_code, function(code) {
        host$get_repos_urls(
          type = type,
          with_code = code,
          in_files = in_files,
          verbose = verbose
        )
      }) %>%
        unlist()
    },

    # Get repositories URLs from one host with files
    get_repos_urls_from_host_with_files = function(host,
                                                   type,
                                                   with_files,
                                                   verbose) {
      purrr::map(with_files, function(file) {
        host$get_repos_urls(
          type = type,
          with_file = file,
          verbose = verbose
        )
      }) %>%
        unlist()
    },

    # Get commits tables from hosts and bind them into one
    get_commits_table = function(since, until, verbose) {
      commits_table <- purrr::map(private$hosts, function(host) {
        host$get_commits(
          since = since,
          until = until,
          verbose = verbose,
          settings = private$settings
        )
      }) %>%
        purrr::list_rbind()
      return(commits_table)
    },

    # Pull information on unique users in a table form
    get_users_table = function(logins) {
      purrr::map(private$hosts, function(host) {
        host$get_users(logins)
      }) %>%
        unique() %>%
        purrr::list_rbind()
    },

    # Pull content of a text file in a table form
    get_files_table = function(file_path, verbose) {
      purrr::map(private$hosts, function(host) {
        host$get_files(
          file_path = file_path,
          verbose = verbose
        )
      }) %>%
        purrr::list_rbind()
    },

    # Pull release logs tables from hosts and bind them into one
    get_release_logs_table = function(since, until, verbose) {
      purrr::map(private$hosts, function(host) {
        host$get_release_logs(
          since = since,
          until = until,
          verbose = verbose,
          settings = private$settings
        )
      }) %>%
        purrr::list_rbind()
    },

    # Pull information on package usage in a table form
    get_R_package_usage_table = function(package_name, only_loading, verbose) {
      if (!only_loading) {
        repos_with_package_as_dependency <- private$get_R_package_as_dependency(
          package_name = package_name,
          verbose = verbose
        )
      } else {
        repos_with_package_as_dependency <- NULL
      }
      repos_using_package <- private$get_R_package_loading(
        package_name = package_name,
        verbose = verbose
      )
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
    get_R_package_loading = function(package_name, verbose) {
      if (verbose) {
        cli::cli_alert_info("Checking where [{package_name}] is loaded from library...")
      }
      package_usage_phrases <- c(
        paste0("library(", package_name, ")"),
        paste0("require(", package_name, ")")
      )
      repos_using_package <- purrr::map(package_usage_phrases, ~ {
        repos_using_package <- private$get_repos_table(
          with_code = .,
          verbose = FALSE
        )
        if (!is.null(repos_using_package)) {
          repos_using_package$package_usage <- "library"
          repos_using_package <- repos_using_package %>%
            dplyr::select(repo_name, organization, fullname, platform, repo_url, api_url, package_usage)
        }
        return(repos_using_package)
      }) %>%
        purrr::list_rbind() %>%
        unique()
      return(repos_using_package)
    },

    # @description Search repositories with `package_name` in DESCRIPTION and NAMESPACE files.
    # @param package_name Name of a package.
    get_R_package_as_dependency = function(package_name, verbose) {
      if (verbose) {
        cli::cli_alert_info("Checking where [{package_name}] is used as a dependency...")
      }
      repos_with_package <- private$get_repos_table(
        with_code = package_name,
        in_files = c("DESCRIPTION", "NAMESPACE"),
        verbose = FALSE,
        settings = private$settings
      )
      if (nrow(repos_with_package) > 0) {
        repos_with_package <- repos_with_package[!duplicated(repos_with_package$api_url),]
        repos_with_package$package_usage <- "import"
      }
      repos_with_package <- repos_with_package %>%
        dplyr::select(repo_name, organization, fullname, platform, repo_url, api_url, package_usage)
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
            "x" = "You can not provide two hosts of the same API urls."
          ),
          call = NULL
          )
        }
      }

      host
    },

    # @description A helper to manage printing `GitStats` object.
    # @param name Name of item to print.
    # @param item_to_check Item to check for emptiness.
    # @param item_to_print Item to print, if not defined it is item that is checked.
    # @return Nothing, prints object.
    print_item = function(item_name,
                          item_to_check,
                          item_to_print = item_to_check) {
      if (item_name %in% c(" Organizations", " Repositories")) {
        item_to_print <- unlist(item_to_print)
        item_to_print <- purrr::map_vec(item_to_print, function(element) {
          URLdecode(element)
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
        if (host_priv$searching_scope == "org") {
          orgs <- host_priv$orgs
        }
      })
      repos <- purrr::map(private$hosts, function(host) {
        host_priv <- environment(host$initialize)$private
        if (host_priv$searching_scope == "repo") {
          repos <- host_priv$repos_fullnames
        }
      })
      private$print_item(" Organizations", orgs)
      private$print_item(" Repositories", repos)
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
