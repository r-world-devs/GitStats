#' @noRd
#' @description A highest-level class to manage data pulled from different hosts.
GitStats <- R6::R6Class(
  classname = "GitStats",
  public = list(

    set_github_host = function(host,
                               token = NULL,
                               orgs = NULL,
                               repos = NULL,
                               verbose = TRUE,
                               .error = TRUE) {
      new_host <- NULL
      new_host <- GitHostGitHub$new(
        orgs = orgs,
        repos = repos,
        token = token,
        host = host,
        verbose = verbose,
        .error = .error
      )
      private$add_new_host(new_host)
    },

    set_gitlab_host = function(host,
                               token = NULL,
                               orgs = NULL,
                               repos = NULL,
                               verbose = TRUE,
                               .error = TRUE) {
      new_host <- NULL
      new_host <- GitHostGitLab$new(
        orgs = orgs,
        repos = repos,
        token = token,
        host = host,
        verbose = verbose,
        .error = .error
      )
      private$add_new_host(new_host)
    },

    get_repos = function(add_contributors = FALSE,
                         with_code        = NULL,
                         in_files         = NULL,
                         with_files       = NULL,
                         cache            = TRUE,
                         verbose          = TRUE,
                         progress         = TRUE) {
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
        cache     = cache,
        storage   = "repositories",
        args_list = args_list,
        verbose   = verbose
      )
      if (trigger) {
        repositories <- private$get_repos_from_hosts(
          add_contributors = add_contributors,
          with_code        = with_code,
          in_files         = in_files,
          with_files       = with_files,
          verbose          = verbose,
          progress         = progress
        ) %>%
          private$set_object_class(
            class     = "gitstats_repos",
            attr_list = args_list
          )
        private$save_to_storage(
          table = repositories
        )
      } else {
        repositories <- private$get_from_storage(
          table   = "repositories",
          verbose = verbose
        )
      }
      return(repositories)
    },

    get_repos_urls = function(type       = "web",
                              with_code  = NULL,
                              in_files   = NULL,
                              with_files = NULL,
                              cache      = TRUE,
                              verbose    = TRUE,
                              progress   = TRUE) {
      private$check_for_host()
      private$check_params_conflict(
        with_code = with_code,
        in_files = in_files,
        with_files = with_files
      )
      args_list <- list("type"       = type,
                        "with_code"  = with_code,
                        "in_files"   = in_files,
                        "with_files" = with_files)
      trigger <- private$trigger_pulling(
        cache     = cache,
        storage   = "repos_urls",
        args_list = args_list,
        verbose   = verbose
      )
      if (trigger) {
        repos_urls <- private$get_repos_urls_from_hosts(
          type       = type,
          with_code  = with_code,
          in_files   = in_files,
          with_files = with_files,
          verbose    = verbose,
          progress   = progress
        )
        if (!is.null(repos_urls)) {
          repos_urls <- private$set_object_class(
            object = repos_urls,
            class = "gitstats_repos_urls",
            attr_list = args_list
          )
          private$save_to_storage(
            table = repos_urls
          )
        } else if (verbose) {
          cli::cli_alert_warning(
            cli::col_yellow("No findings.")
          )
        }
      } else {
        repos_urls <- private$get_from_storage(
          table = "repos_urls",
          verbose = verbose
        )
      }
      return(repos_urls)
    },

    get_commits = function(since,
                           until,
                           cache    = TRUE,
                           verbose  = TRUE,
                           progress = TRUE) {
      private$check_for_host()
      args_list <- list("date_range" = c(since, as.character(until)))
      trigger <- private$trigger_pulling(
        cache     = cache,
        storage   = "commits",
        args_list = args_list,
        verbose   = verbose
      )
      if (trigger) {
        commits <- private$get_commits_from_hosts(
          since    = since,
          until    = until,
          verbose  = verbose,
          progress = progress
        ) %>%
          private$set_object_class(
            class     = "gitstats_commits",
            attr_list = args_list
          )
        private$save_to_storage(
          table = commits
        )
      } else {
        commits <- private$get_from_storage(
          table = "commits",
          verbose = verbose
        )
      }
      return(commits)
    },

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
        users <- private$get_users_from_hosts(logins) %>%
          private$set_object_class(
            class = "gitstats_users",
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

    get_files = function(pattern,
                         depth,
                         file_path = NULL,
                         cache = TRUE,
                         verbose = TRUE,
                         progress = verbose) {
      private$check_for_host()
      args_list <- list(
        "file_pattern" = paste(file_path, pattern),
        "depth" = depth
      )
      trigger <- private$trigger_pulling(
        cache = cache,
        storage = "files",
        args_list = args_list,
        verbose = verbose
      )
      if (trigger) {
        files <- private$get_files_from_hosts(
          pattern = pattern,
          depth = depth,
          file_path = file_path,
          verbose = verbose,
          progress = progress
        )
        if (nrow(files) > 0) {
          files <- private$set_object_class(
            object = files,
            class = "gitstats_files",
            attr_list = args_list
          )
          private$save_to_storage(files)
        } else {
          if (verbose) {
            cli::cli_alert_warning("No files found.")
          }
        }
      } else {
        files <- private$get_from_storage(
          table = "files",
          verbose = verbose
        )
      }
      return(files)
    },

    get_release_logs = function(since,
                                until    = Sys.Date(),
                                cache    = TRUE,
                                verbose  = TRUE,
                                progress = TRUE) {
      private$check_for_host()
      args_list <- list("date_range" = c(since, as.character(until)))
      trigger <- private$trigger_pulling(
        storage   = "release_logs",
        cache     = cache,
        args_list = args_list,
        verbose   = verbose
      )
      if (trigger) {
        release_logs <- private$get_release_logs_from_hosts(
          since    = since,
          until    = until,
          verbose  = verbose,
          progress = progress
        ) %>%
          private$set_object_class(
            class     = "gitstats_releases",
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

    get_R_package_usage = function(packages,
                                   only_loading = FALSE,
                                   split_output = FALSE,
                                   cache        = TRUE,
                                   verbose      = TRUE) {
      private$check_for_host()
      if (is.null(packages)) {
        cli::cli_abort("You need to define at least one `package_name`.", call = NULL)
      }
      args_list <- list(
        "packages"     = packages,
        "only_loading" = only_loading
      )
      trigger <- private$trigger_pulling(
        storage   = "R_package_usage",
        cache     = cache,
        args_list = args_list,
        verbose   = verbose
      )
      if (trigger) {
        R_package_usage <- private$get_R_package_usage_from_hosts(
          packages     = packages,
          only_loading = only_loading,
          split_output = split_output,
          verbose      = verbose
        )
        if ((!split_output && nrow(R_package_usage) > 0) ||
              (split_output && any(purrr::map_lgl(R_package_usage, ~ nrow(.) > 0)))) {
          R_package_usage <- private$set_object_class(
            object    = R_package_usage,
            class     = "gitstats_package_usage",
            attr_list = args_list
          )
          private$save_to_storage(R_package_usage)
        }
      } else {
        R_package_usage <- private$get_from_storage(
          table   = "R_package_usage",
          verbose = verbose
        )
      }
      return(R_package_usage)
    },

    show_orgs = function() {
      purrr::map(private$hosts, function(host) {
        orgs <- host$.__enclos_env__$private$orgs
        purrr::map_vec(orgs, ~ URLdecode(.))
      }) %>%
        unlist()
    },

    verbose_on = function() {
      private$settings$verbose <- TRUE
    },

    verbose_off = function() {
      private$settings$verbose <- FALSE
    },

    is_verbose = function() {
      private$settings$verbose
    },

    get_storage = function(storage) {
      if (is.null(storage)) {
        private$storage
      } else {
        private$storage[[storage]]
      }
    },

    print = function() {
      cat(paste0("A ", cli::col_blue('GitStats'), " object for ", length(private$hosts), " hosts: \n"))
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
      cache   = TRUE
    ),

    # @field storage for results
    storage = list(
      repositories    = NULL,
      commits         = NULL,
      users           = NULL,
      files           = NULL,
      files_structure = NULL,
      R_package_usage = NULL,
      release_logs    = NULL
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
          "i" = "If you want to search for [{with_code}] code in given files
          - use `in_files` parameter together with `with_code` instead."
        ), call = NULL)
      }
      if (!is.null(in_files) && is.null(with_code)) {
        cli::cli_abort(c(
          "!" = "Passing files to `in_files` parameter works only when you
          search code with `with_code` parameter.",
          "i" = "If you want to search for repositories with [{in_files}] files
          you should instead use `with_files` parameter."
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

    # Set object class with attributes
    set_object_class = function(object, class, attr_list) {
      class(object) <- append(class, class(object))
      purrr::iwalk(attr_list, function(attrib, attrib_name)  {
        attr(object, attrib_name) <<- attrib
      })
      return(object)
    },

    # Pull repositories tables from hosts and bind them into one
    get_repos_from_hosts = function(add_contributors = FALSE,
                                    with_code,
                                    in_files         = NULL,
                                    with_files,
                                    output           = "table_full",
                                    verbose          = TRUE,
                                    progress         = TRUE) {
      repos_table <- purrr::map(private$hosts, function(host) {
        if (!is.null(with_code)) {
          private$get_repos_from_host_with_code(
            host             = host,
            add_contributors = add_contributors,
            with_code        = with_code,
            in_files         = in_files,
            output           = output,
            verbose          = verbose,
            progress         = progress
          )
        } else if (!is.null(with_files)) {
          private$get_repos_from_host_with_files(
            host             = host,
            add_contributors = add_contributors,
            with_files       = with_files,
            output           = output,
            verbose          = verbose,
            progress         = progress
          )
        } else {
          host$get_repos(
            add_contributors = add_contributors,
            verbose          = verbose,
            progress         = progress
          )
        }
      }) %>%
        purrr::list_rbind() %>%
        dplyr::as_tibble()
      if (output == "table_full") {
        repos_table <- repos_table %>%
          private$add_stats_to_repos() %>%
          dplyr::as_tibble()
      }
      return(repos_table)
    },

    # Get repositories table from one host with given text in code blobs
    get_repos_from_host_with_code = function(host,
                                             add_contributors,
                                             with_code,
                                             in_files,
                                             output,
                                             verbose,
                                             progress) {
      purrr::map(with_code, function(with_code) {
        host$get_repos(
          add_contributors = add_contributors,
          with_code        = with_code,
          in_files         = in_files,
          output           = output,
          verbose          = verbose,
          progress         = progress
        )
      }) %>%
        purrr::list_rbind()
    },

    # Get repositories table from one host with given files
    get_repos_from_host_with_files = function(host,
                                              add_contributors,
                                              with_files,
                                              output,
                                              verbose,
                                              progress) {
      purrr::map(with_files, function(with_file) {
        host$get_repos(
          add_contributors = add_contributors,
          with_file        = with_file,
          output           = output,
          verbose          = verbose,
          progress         = progress
        )
      }) %>%
        purrr::list_rbind()
    },

    # Get repositories character vectors from hosts and bind them into one
    get_repos_urls_from_hosts = function(type,
                                         with_code,
                                         in_files,
                                         with_files,
                                         verbose,
                                         progress) {
      purrr::map(private$hosts, function(host) {
        if (!is.null(with_code)) {
          private$get_repos_urls_from_host_with_code(
            host      = host,
            type      = type,
            with_code = with_code,
            in_files  = in_files,
            verbose   = verbose,
            progress  = progress
          )
        } else if (!is.null(with_files)) {
          private$get_repos_urls_from_host_with_files(
            host       = host,
            type       = type,
            with_files = with_files,
            verbose    = verbose,
            progress   = progress
          )
        } else {
          host$get_repos_urls(
            type     = type,
            verbose  = verbose,
            progress = progress
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
                                                  verbose,
                                                  progress) {
      purrr::map(with_code, function(code) {
        host$get_repos_urls(
          type      = type,
          with_code = code,
          in_files  = in_files,
          verbose   = verbose,
          progress  = progress
        )
      }) %>%
        unlist()
    },

    # Get repositories URLs from one host with files
    get_repos_urls_from_host_with_files = function(host,
                                                   type,
                                                   with_files,
                                                   verbose,
                                                   progress) {
      purrr::map(with_files, function(file) {
        host$get_repos_urls(
          type      = type,
          with_file = file,
          verbose   = verbose,
          progress  = progress
        )
      }) %>%
        unlist()
    },

    # Get commits tables from hosts and bind them into one
    get_commits_from_hosts = function(since, until, verbose, progress) {
      commits_table <- purrr::map(private$hosts, function(host) {
        host$get_commits(
          since    = since,
          until    = until,
          verbose  = verbose,
          progress = progress
        )
      }) %>%
        purrr::list_rbind() %>%
        dplyr::as_tibble()
      return(commits_table)
    },

    # Pull information on unique users in a table form
    get_users_from_hosts = function(logins) {
      purrr::map(private$hosts, function(host) {
        host$get_users(logins)
      }) %>%
        unique() %>%
        purrr::list_rbind() %>%
        dplyr::as_tibble()
    },

    # Pull content of a text file in a table form
    get_files_from_hosts = function(pattern,
                                    depth,
                                    file_path,
                                    verbose,
                                    progress) {
      purrr::map(private$hosts, function(host) {
        if (is.null(file_path)) {
          files_structure <- host$get_files_structure(
            pattern  = pattern,
            depth    = depth,
            verbose  = verbose,
            progress = progress
          ) |>
            purrr::discard(~ length(.) == 0)
          if (length(files_structure) == 0) {
            files_structure <- NULL
          }
        } else {
          files_structure <- NULL
        }
        host$get_files_content(
          file_path = file_path,
          files_structure = files_structure,
          verbose = verbose,
          progress = progress
        )
      }) |>
        purrr::list_rbind() |>
        dplyr::as_tibble()
    },

    # Pull release logs tables from hosts and bind them into one
    get_release_logs_from_hosts = function(since, until, verbose, progress) {
      purrr::map(private$hosts, function(host) {
        host$get_release_logs(
          since    = since,
          until    = until,
          verbose  = verbose,
          progress = progress
        )
      }) %>%
        purrr::list_rbind() %>%
        dplyr::as_tibble()
    },

    # Pull information on package usage in a table form
    get_R_package_usage_from_hosts = function(packages,
                                              only_loading,
                                              split_output = FALSE,
                                              verbose = TRUE) {
      packages_usage_list <- purrr::map(packages, function(package_name) {
        if (!only_loading) {
          repos_with_package_as_dependency <- private$get_R_package_as_dependency(
            package_name = package_name,
            verbose      = verbose
          )
        } else {
          repos_with_package_as_dependency <- NULL
        }
        repos_using_package <- private$get_R_package_loading(
          package_name = package_name,
          verbose      = verbose
        )
        package_usage_table <- purrr::list_rbind(
          list(
            repos_with_package_as_dependency,
            repos_using_package
          )
        )
        if (nrow(package_usage_table) > 0) {
          duplicated_repos <- package_usage_table$api_url[duplicated(package_usage_table$api_url)]
          package_usage_table <- package_usage_table[!duplicated(package_usage_table$api_url), ]
          package_usage_table <- package_usage_table %>%
            dplyr::mutate(
              package_usage = ifelse(api_url %in% duplicated_repos, "import, library", package_usage)
            )
          package_usage_table <- dplyr::mutate(
            package_usage_table,
            package = package_name,
            repo_fullname = paste0(organization, "/", repo_name)
          ) %>%
            dplyr::relocate(
              package, package_usage,
              .before = repo_id
            ) %>%
            dplyr::relocate(
              repo_fullname,
              .after = repo_id
            )
        }
        return(package_usage_table)
      })
      if (split_output) {
        packages_usage_result <- purrr::set_names(packages_usage_list, packages)
        if (all(purrr::map_lgl(packages_usage_result, ~ nrow(.) == 0)) && verbose) {
          cli::cli_alert_warning(
            cli::col_yellow(
              "No usage of R packages found."
            )
          )
        }
      } else {
        packages_usage_result <- purrr::list_rbind(packages_usage_list)
        if (nrow(packages_usage_result) == 0 && verbose) {
          cli::cli_alert_warning(
            cli::col_yellow(
              "No usage of R packages found."
            )
          )
        }
      }
      return(packages_usage_result)
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
        repos_using_package <- private$get_repos_from_hosts(
          with_code  = .,
          output     = "table_min",
          verbose    = FALSE,
          progress   = FALSE
        )
        if (nrow(repos_using_package) > 0) {
          repos_using_package$package_usage <- "library"
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
      repos_with_package <- private$get_repos_from_hosts(
        with_code  = package_name,
        in_files   = c("DESCRIPTION", "NAMESPACE"),
        output     = "table_min",
        verbose    = FALSE,
        progress   = FALSE
      )
      if (nrow(repos_with_package) > 0) {
        repos_with_package <- repos_with_package[!duplicated(repos_with_package$api_url), ]
        repos_with_package$package_usage <- "import"
      }
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
            ) %>% round(2)
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
        list_items <- cut_item_to_print(item_to_print)
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
        if ("org" %in% host_priv$searching_scope) {
          orgs <- host_priv$orgs
        }
      })
      repos <- purrr::map(private$hosts, function(host) {
        host_priv <- environment(host$initialize)$private
        if ("repo" %in% host_priv$searching_scope) {
          repos <- host_priv$repos_fullnames
        }
      })
      private$print_item(" Organizations", orgs)
      private$print_item(" Repositories", repos)
    },

    # print storage
    print_storage = function() {
      gitstats_storage <- purrr::imap(private$storage, function(storage_object, storage_name) {
        if (!is.null(storage_object)) {
          storage_size <- if (inherits(storage_object, "data.frame")) {
            nrow(storage_object)
          } else {
            length(storage_object)
          }
          glue::glue(
            "{stringr::str_to_title(storage_name)}: {storage_size} {private$print_storage_attribute(storage_object, storage_name)}"
          )
        }
      }) %>%
        purrr::discard(~is.null(.))
      if (length(gitstats_storage) == 0) {
        private$print_item(
          "Storage",
          cli::col_grey("<no data in storage>")
        )
      } else {
        cat(paste0(
          cli::col_blue("Storage: \n"),
          paste0(" ", gitstats_storage, collapse = "\n")
        ))
      }
    },

    # print storage attribute
    print_storage_attribute = function(storage_data, storage_name) {
      if (storage_name != "repositories") {
        storage_attr <- switch(storage_name,
                               "repos_urls" = "type",
                               "files" = "file_pattern",
                               "commits" = "date_range",
                               "release_logs" = "date_range",
                               "users" = "logins",
                               "R_package_usage" = "packages")
        attr_data <- attr(storage_data, storage_attr)
        attr_name <- switch(storage_attr,
                            "type" = "type",
                            "file_pattern" = "file pattern",
                            "date_range" = "date range",
                            "packages" = "packages",
                            "logins" = "logins")
        if (length(attr_data) > 1) {
          separator <- if (storage_attr == "date_range") {
            " - "
          } else {
            ", "
          }
          attr_data <- attr_data %>% paste0(collapse = separator)
        }
        return(cli::col_grey(glue::glue("[{attr_name}: {trimws(attr_data)}]")))
      } else {
        return("")
      }
    }
  )
)
