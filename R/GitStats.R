#' @title Create a `GitStats` object
#' @name create_gitstats
#' @examples
#' my_gitstats <- create_gitstats()
#' @return A `GitStats` object.
#' @export
create_gitstats <- function() {
  GitStats$new()
}

#' @title Show hosts set in `GitStats`
#' @name show_hosts
#' @description Retrieves hosts set by `GitStats` with `set_*_host()` functions.
#' @param gitstats A GitStats object.
#' @return A list of hosts.
#' @export
show_hosts <- function(gitstats) {
  gitstats$show_hosts()
}

#' @title Show organizations set in `GitStats`
#' @name show_orgs
#' @description Retrieves organizations set or pulled by `GitStats`. Especially
#'   helpful when user is scanning whole git platform and wants to have a
#'   glimpse at organizations.
#' @param gitstats A GitStats object.
#' @return A vector of organizations.
#' @export
show_orgs <- function(gitstats) {
  gitstats$show_orgs()
}

#' @title Switch on verbose mode
#' @name verbose_on
#' @description Print all messages and output.
#' @param gitstats A GitStats object.
#' @return A GitStats object.
#' @export
verbose_on <- function(gitstats) {
  gitstats$verbose_on()
  return(invisible(gitstats))
}

#' @title Switch off verbose mode
#' @name verbose_off
#' @description Stop printing messages and output.
#' @param gitstats A GitStats object.
#' @return A GitStats object.
#' @export
verbose_off <- function(gitstats) {
  gitstats$verbose_off()
  return(invisible(gitstats))
}

#' @title Is verbose mode switched on
#' @name is_verbose
#' @param gitstats A GitStats object.
is_verbose <- function(gitstats) {
  gitstats$is_verbose()
}

GitStats <- R6::R6Class(
  classname = "GitStats",
  public = list(

    initialize = function() {
      private$storage_backend <- StorageLocal$new()
    },

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

    set_bitbucket_host = function(host,
                                  token = NULL,
                                  orgs = NULL,
                                  repos = NULL,
                                  verbose = TRUE,
                                  .error = TRUE) {
      new_host <- NULL
      new_host <- GitHostBitBucket$new(
        orgs = orgs,
        repos = repos,
        token = token,
        host = host,
        verbose = verbose,
        .error = .error
      )
      private$add_new_host(new_host)
    },

    get_orgs = function(cache = TRUE, output = "full_table", verbose = TRUE) {
      private$check_for_host()
      trigger <- private$trigger_pulling(
        cache = cache,
        storage = "organizations",
        verbose = verbose
      )
      if (trigger) {
        cli::cli_alert("Pulling organizations {cli_icons$org} data...")
        organizations <- private$get_orgs_from_hosts(
          output = output,
          verbose = verbose
        ) |>
          private$set_object_class(
            class = "gitstats_orgs"
          )
        private$save_to_storage(
          table = organizations
        )
      } else {
        organizations <- private$get_from_storage(
          table = "organizations"
        )
      }
      return(organizations)
    },

    get_repos = function(add_contributors = FALSE,
                         add_languages = TRUE,
                         with_code = NULL,
                         in_files = NULL,
                         with_files = NULL,
                         language = NULL,
                         cache = TRUE,
                         verbose = TRUE,
                         progress = TRUE,
                         fill_empty_sha = FALSE) {
      private$check_for_host()
      private$check_params_conflict(
        with_code = with_code,
        in_files = in_files,
        with_files = with_files
      )
      args_list <- list("with_code" = with_code,
                        "in_files" = in_files,
                        "with_files" = with_files,
                        "language" = language)
      trigger <- private$trigger_pulling(
        cache = cache,
        storage = "repositories",
        args_list = args_list,
        verbose = verbose
      )
      if (trigger) {
        cli::cli_alert("Pulling repositories {cli_icons$repo} data...")
        repositories <- private$get_repos_from_hosts(
          add_contributors = add_contributors,
          add_languages = add_languages,
          with_code = with_code,
          in_files = in_files,
          with_files = with_files,
          language = language,
          verbose = verbose,
          progress = progress,
          fill_empty_sha = fill_empty_sha
        )
        if (nrow(repositories) > 0) {
          repositories <- private$set_object_class(
            object = repositories,
            class = "gitstats_repos",
            attr_list = args_list
          )
          private$save_to_storage(
            table = repositories
          )
        } else {
          if (verbose) {
            cli::cli_alert_warning("No repositories {cli_icons$repo} found.")
          }
        }
      } else {
        repositories <- private$get_from_storage(
          table = "repositories"
        )
      }
      return(repositories)
    },

    get_repos_urls = function(type = "web",
                              with_code = NULL,
                              in_files = NULL,
                              with_files = NULL,
                              cache = TRUE,
                              verbose = TRUE,
                              progress = TRUE) {
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
        cli::cli_alert("Pulling repositories {cli_icons$repo} URLs...")
        repos_urls <- private$get_repos_urls_from_hosts(
          type = type,
          with_code = with_code,
          in_files = in_files,
          with_files = with_files,
          verbose = verbose,
          progress = progress
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
        }
      } else {
        repos_urls <- private$get_from_storage(
          table = "repos_urls"
        )
      }
      return(repos_urls)
    },

    get_commits = function(since,
                           until,
                           cache = TRUE,
                           verbose = TRUE,
                           progress = TRUE) {
      private$check_for_host()
      args_list <- list(
        "date_range" = c(since, as.character(until)),
        "scope" = private$get_scope_fingerprint()
      )
      trigger <- private$trigger_pulling(
        cache = cache,
        storage = "commits",
        args_list = args_list,
        verbose = verbose
      )
      if (trigger) {
        commits <- private$pull_incrementally(
          storage_name = "commits",
          fetch_fn = function(since, until) {
            private$get_commits_from_hosts(
              since = since, until = until,
              verbose = verbose, progress = progress
            )
          },
          args_list = args_list,
          dedup_columns = "id",
          cache = cache,
          verbose = verbose,
          icon = cli_icons$commit,
          pull_message = "Pulling commits {cli_icons$commit}..."
        )
        if (nrow(commits) > 0) {
          commits <- private$set_object_class(
            object = commits,
            class = "gitstats_commits",
            attr_list = args_list
          )
          private$save_to_storage(
            table = commits
          )
        } else {
          if (verbose) {
            cli::cli_alert_warning("No commits {cli_icons$commit} found.")
          }
        }
      } else {
        commits <- private$get_from_storage(
          table = "commits"
        )
      }
      return(commits)
    },

    get_issues = function(since,
                          until,
                          state,
                          cache    = TRUE,
                          verbose  = TRUE,
                          progress = TRUE) {
      private$check_for_host()
      args_list <- list(
        "state" = state,
        "date_range" = c(since, as.character(until)),
        "scope" = private$get_scope_fingerprint()
      )
      trigger <- private$trigger_pulling(
        cache = cache,
        storage = "issues",
        args_list = args_list,
        verbose = verbose
      )
      if (trigger) {
        issues <- private$pull_incrementally(
          storage_name = "issues",
          fetch_fn = function(since, until) {
            private$get_issues_from_hosts(
              since = since, until = until, state = state,
              verbose = verbose, progress = progress
            )
          },
          args_list = args_list,
          dedup_columns = c("number", "repo_name"),
          cache = cache,
          verbose = verbose,
          icon = cli_icons$issue,
          pull_message = "Getting issues {cli_icons$issue}..."
        )
        if (nrow(issues) > 0) {
          issues <- private$set_object_class(
            object = issues,
            class = "gitstats_issues",
            attr_list = args_list
          )
          private$save_to_storage(
            table = issues
          )
        } else {
          if (verbose) {
            cli::cli_alert_warning("No issues {cli_icons$issue} found.")
          }
        }
      } else {
        issues <- private$get_from_storage(
          table = "issues"
        )
      }
      return(issues)
    },

    get_pull_requests = function(since,
                                 until,
                                 state,
                                 cache    = TRUE,
                                 verbose  = TRUE,
                                 progress = TRUE) {
      private$check_for_host()
      args_list <- list(
        "state" = state,
        "date_range" = c(since, as.character(until)),
        "scope" = private$get_scope_fingerprint()
      )
      trigger <- private$trigger_pulling(
        cache = cache,
        storage = "pull_requests",
        args_list = args_list,
        verbose = verbose
      )
      if (trigger) {
        pull_requests <- private$pull_incrementally(
          storage_name = "pull_requests",
          fetch_fn = function(since, until) {
            private$get_pull_requests_from_hosts(
              since = since, until = until, state = state,
              verbose = verbose, progress = progress
            )
          },
          args_list = args_list,
          dedup_columns = c("number", "repo_name"),
          cache = cache,
          verbose = verbose,
          icon = cli_icons$pull_request,
          pull_message = "Getting pull requests {cli_icons$pull_request}..."
        )
        if (nrow(pull_requests) > 0) {
          pull_requests <- private$set_object_class(
            object = pull_requests,
            class = "gitstats_pull_requests",
            attr_list = args_list
          )
          private$save_to_storage(
            table = pull_requests
          )
        } else {
          if (verbose) {
            cli::cli_alert_warning("No pull requests {cli_icons$pull_request} found.")
          }
        }
      } else {
        pull_requests <- private$get_from_storage(
          table = "pull_requests"
        )
      }
      return(pull_requests)
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
        cli::cli_alert("Pulling users {cli_icons$user} data...")
        users <- private$get_users_from_hosts(logins) |>
          private$set_object_class(
            class = "gitstats_users",
            attr_list = args_list
          )
        private$save_to_storage(users)
      } else {
        users <- private$get_from_storage(
          table = "users"
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
        cli::cli_alert("Pulling files {cli_icons$file} content...")
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
            cli::cli_alert_warning("No files {cli_icons$file} found.")
          }
        }
      } else {
        files <- private$get_from_storage(
          table = "files"
        )
      }
      return(files)
    },

    get_repos_trees = function(pattern,
                               depth,
                               cache,
                               verbose,
                               progress) {
      private$check_for_host()
      args_list <- list(
        "file_pattern" = pattern %||% "",
        "depth" = depth
      )
      trigger <- private$trigger_pulling(
        cache = cache,
        storage = "repos_trees",
        args_list = args_list,
        verbose = verbose
      )
      if (trigger) {
        cli::cli_alert("Pulling repositories {cli_icons$tree} structure...")
        repos_trees <- private$get_repos_trees_from_hosts(
          pattern = pattern,
          depth = depth,
          verbose = verbose,
          progress = progress
        )
        if (nrow(repos_trees) > 0) {
          repos_trees <- private$set_object_class(
            object = repos_trees,
            class = "gitstats_repos_trees",
            attr_list = args_list
          )
          private$save_to_storage(repos_trees)
        } else {
          if (verbose) {
            cli::cli_alert_warning("No repos {cli_icons$tree} trees found.")
          }
        }
      } else {
        repos_trees <- private$get_from_storage(
          table = "repos_trees"
        )
      }
      return(repos_trees)
    },

    get_release_logs = function(since,
                                until = Sys.Date(),
                                cache = TRUE,
                                verbose = TRUE,
                                progress = TRUE) {
      private$check_for_host()
      args_list <- list(
        "date_range" = c(since, as.character(until)),
        "scope" = private$get_scope_fingerprint()
      )
      trigger <- private$trigger_pulling(
        storage = "release_logs",
        cache = cache,
        args_list = args_list,
        verbose = verbose
      )
      if (trigger) {
        release_logs <- private$pull_incrementally(
          storage_name = "release_logs",
          fetch_fn = function(since, until) {
            private$get_release_logs_from_hosts(
              since = since, until = until,
              verbose = verbose, progress = progress
            )
          },
          args_list = args_list,
          dedup_columns = c("release_tag", "repo_name"),
          cache = cache,
          verbose = verbose,
          icon = cli_icons$release,
          pull_message = "Pulling release logs {cli_icons$release}.."
        )
        if (nrow(release_logs) > 0) {
          release_logs <- private$set_object_class(
            object = release_logs,
            class = "gitstats_releases",
            attr_list = args_list
          )
          private$save_to_storage(release_logs)
        } else {
          if (verbose) {
            cli::cli_alert_warning("No release logs {cli_icons$release} found.")
          }
        }
      } else {
        release_logs <- private$get_from_storage(
          table = "release_logs"
        )
      }
      return(release_logs)
    },

    show_hosts = function() {
      purrr::map(private$hosts, function(host) {
        host_priv <- host$.__enclos_env__$private
        list(
          host = host_priv$host_name,
          web_url = host_priv$web_url,
          api_url = host_priv$api_url
        )
      })
    },

    show_orgs = function() {
      purrr::map(private$hosts, function(host) {
        orgs <- host$.__enclos_env__$private$orgs
        purrr::map_vec(orgs, ~ url_decode(.))
      }) |>
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

    set_local_storage = function() {
      private$storage_backend <- StorageLocal$new()
      private$propagate_storage_to_hosts()
      invisible(self)
    },

    set_postgres_storage = function(host = NULL,
                                    port = NULL,
                                    dbname = NULL,
                                    user = NULL,
                                    password = NULL,
                                    schema = "git_stats",
                                    ...) {
      args <- list(...)
      if (!is.null(host)) args$host <- host
      if (!is.null(port)) args$port <- port
      if (!is.null(dbname)) args$dbname <- dbname
      if (!is.null(user)) args$user <- user
      if (!is.null(password)) args$password <- password
      private$storage_backend <- do.call(
        StoragePostgres$new,
        c(list(schema = schema), args)
      )
      private$propagate_storage_to_hosts()
      cli::cli_alert_success("Storage set to {.val PostgreSQL}.")
      private$report_storage_contents()
      invisible(self)
    },

    set_sqlite_storage = function(dbname = ":memory:") {
      private$storage_backend <- StorageSQLite$new(dbname = dbname)
      private$propagate_storage_to_hosts()
      cli::cli_alert_success("Storage set to {.val SQLite}.")
      private$report_storage_contents()
      invisible(self)
    },

    get_storage = function(storage) {
      if (is.null(storage)) {
        stored <- private$storage_backend$list()
        result <- purrr::map(stored, ~ private$storage_backend$load(.))
        names(result) <- stored
        return(result)
      } else {
        private$storage_backend$load(storage)
      }
    },

    remove_from_storage = function(storage) {
      if (!private$storage_backend$exists(storage)) {
        cli::cli_abort("Table {.val {storage}} does not exist in storage.")
      }
      private$storage_backend$remove(storage)
      cli::cli_alert_success("Removed {.val {storage}} from storage.")
      invisible(self)
    },

    remove_postgres_storage = function() {
      if (!inherits(private$storage_backend, "StoragePostgres")) {
        cli::cli_abort("No PostgreSQL storage is set.")
      }
      private$storage_backend$drop_storage()
      cli::cli_alert_success(
        "PostgreSQL schema dropped and connection closed."
      )
      private$storage_backend <- StorageLocal$new()
      private$propagate_storage_to_hosts()
      cli::cli_alert_info("Storage set back to {.val local}.")
      invisible(self)
    },

    remove_sqlite_storage = function() {
      if (!inherits(private$storage_backend, "StorageSQLite")) {
        cli::cli_abort("No SQLite storage is set.")
      }
      dbname <- private$storage_backend$.__enclos_env__$private$dbname
      private$storage_backend$drop_storage()
      if (!is.null(dbname) && dbname != ":memory:") {
        cli::cli_alert_success(
          "SQLite database file {.file {dbname}} removed."
        )
      } else {
        cli::cli_alert_success(
          "In-memory SQLite database removed."
        )
      }
      private$storage_backend <- StorageLocal$new()
      private$propagate_storage_to_hosts()
      cli::cli_alert_info("Storage set back to {.val local}.")
      invisible(self)
    },

    get_storage_metadata = function(storage = NULL) {
      if (!is.null(storage) && !private$storage_backend$exists(storage)) {
        cli::cli_abort("Table {.val {storage}} does not exist in storage.")
      }
      private$storage_backend$get_metadata(storage)
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

    hosts = list(),

    settings = list(
      verbose = TRUE,
      cache   = TRUE
    ),

    storage_backend = NULL,

    add_new_host = function(new_host) {
      if (!is.null(new_host)) {
        new_host <- new_host |>
          private$check_for_duplicate_hosts()
        if (!is.null(private$storage_backend)) {
          new_host$set_storage_backend(private$storage_backend)
        }
        private$hosts <- append(private$hosts, new_host)
      }
    },

    check_for_host = function() {
      if (length(private$hosts) == 0) {
        cli::cli_abort("Add first your hosts with `set_github_host()`, `set_gitlab_host()`, or `set_bitbucket_host()`.", call = NULL)
      }
    },

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

    set_verbose_param = function(verbose) {
      if (!is.null(verbose)) {
        if (!is.logical(verbose)) {
          cli::cli_abort("verbose parameter accepts only TRUE/FALSE values")
        }
        private$settings$verbose <- verbose
      }
    },

    storage_is_empty = function(table) {
      !private$storage_backend$exists(table)
    },

    save_to_storage = function(table) {
      table_name <- deparse(substitute(table))
      private$storage_backend$save(table_name, table)
    },

    propagate_storage_to_hosts = function() {
      purrr::walk(private$hosts, function(host) {
        host$set_storage_backend(private$storage_backend)
      })
    },

    report_storage_contents = function() {
      stored_names <- private$storage_backend$list()
      if (length(stored_names) == 0) {
        cli::cli_alert_info("Database is empty.")
      } else {
        cli::cli_alert_info("Database contains data:")
        purrr::walk(stored_names, function(name) {
          data <- private$storage_backend$load(name)
          n <- if (inherits(data, "data.frame")) nrow(data) else length(data)
          cli::cli_bullets(c(" " = "{name}: {n} records"))
        })
      }
    },

    get_from_storage = function(table) {
      cli::cli_alert_warning(cli::col_yellow(
        glue::glue("Getting cached {table} data.")
      ))
      cli::cli_alert_info(cli::col_cyan(
        "If you wish to pull the data from API once more, set `cache` parameter to `FALSE`."
      ))
      private$storage_backend$load(table)
    },

    trigger_pulling = function(cache, storage, args_list = NULL, verbose) {
      trigger <- FALSE
      if (private$storage_is_empty(storage)) {
        trigger <- TRUE
      } else {
        if (!is.null(args_list)) {
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
      }
      return(trigger)
    },

    check_if_args_changed = function(storage, args_list) {
      storage_data <- private$storage_backend$load(storage)
      stored_params <- purrr::map(names(args_list), ~ attr(storage_data, .) %||% "")
      new_params <- purrr::map(args_list, ~ . %||% "")
      !all(purrr::map2_lgl(new_params, stored_params, ~ identical(.x, .y)))
    },

    get_date_gaps = function(stored_range, requested_range) {
      stored_since <- as.Date(stored_range[1])
      stored_until <- as.Date(stored_range[2])
      req_since <- as.Date(requested_range[1])
      req_until <- as.Date(requested_range[2])
      gaps <- list()
      if (req_since < stored_since) {
        gaps <- c(gaps, list(list(
          since = as.character(req_since),
          until = as.character(stored_since - 1)
        )))
      }
      if (req_until > stored_until) {
        gaps <- c(gaps, list(list(
          since = as.character(stored_until + 1),
          until = as.character(req_until)
        )))
      }
      gaps
    },

    pull_incrementally = function(storage_name,
                                  fetch_fn,
                                  args_list,
                                  dedup_columns,
                                  cache,
                                  verbose,
                                  icon,
                                  pull_message = NULL) {
      stored_data <- private$storage_backend$load(storage_name)
      stored_range <- attr(stored_data, "date_range")
      requested_range <- args_list[["date_range"]]
      non_date_args_changed <- private$non_date_args_changed(
        stored_data, args_list
      )
      if (!is.null(stored_data) && !is.null(stored_range) &&
            cache && !non_date_args_changed) {
        gaps <- private$get_date_gaps(stored_range, requested_range)
        if (length(gaps) > 0) {
          if (verbose) {
            cli::cli_alert_info(
              "Using cached {storage_name} {icon} from {.val {stored_range[1]}} to {.val {stored_range[2]}}."
            )
            gap_ranges <- purrr::map_chr(
              gaps, ~ paste(.x$since, "to", .x$until)
            )
            cli::cli_alert(
              "Pulling {storage_name} {icon} from API for: {.val {gap_ranges}}."
            )
          }
          new_data <- purrr::map(gaps, function(gap) {
            fetch_fn(since = gap$since, until = gap$until)
          }) |>
            purrr::list_rbind()
          if (nrow(new_data) > 0) {
            class(stored_data) <- class(stored_data)[
              !grepl("^gitstats_", class(stored_data))
            ]
            result <- dplyr::bind_rows(stored_data, new_data) |>
              dplyr::distinct(
                dplyr::across(dplyr::all_of(dedup_columns)),
                .keep_all = TRUE
              )
          } else {
            result <- stored_data
            class(result) <- class(result)[
              !grepl("^gitstats_", class(result))
            ]
          }
        } else {
          result <- stored_data
        }
      } else {
        if (verbose && !is.null(pull_message)) {
          cli::cli_alert(pull_message)
        }
        result <- fetch_fn(
          since = requested_range[1],
          until = requested_range[2]
        )
      }
      result
    },

    get_scope_fingerprint = function() {
      orgs <- purrr::map(private$hosts, function(host) {
        host$.__enclos_env__$private$orgs
      }) |> unlist()
      repos <- purrr::map(private$hosts, function(host) {
        host_priv <- environment(host$initialize)$private
        if ("repo" %in% host_priv$searching_scope) {
          host_priv$repos_fullnames
        }
      }) |> unlist()
      scope <- sort(unique(c(orgs, repos)))
      paste(scope, collapse = ",")
    },

    non_date_args_changed = function(stored_data, args_list) {
      non_date_args <- args_list[names(args_list) != "date_range"]
      if (length(non_date_args) == 0) return(FALSE)
      stored_params <- purrr::map(
        names(non_date_args), ~ attr(stored_data, .) %||% ""
      )
      new_params <- purrr::map(non_date_args, ~ . %||% "")
      !all(purrr::map2_lgl(new_params, stored_params, ~ identical(.x, .y)))
    },

    set_object_class = function(object, class, attr_list = NULL) {
      class(object) <- append(class, class(object))
      if (!is.null(attr_list)) {
        purrr::iwalk(attr_list, function(attrib, attrib_name)  {
          attr(object, attrib_name) <<- attrib
        })
      }
      return(object)
    },

    get_orgs_from_hosts = function(output, verbose) {
      orgs_from_hosts <- purrr::map(private$hosts, function(host) {
        host$get_orgs(
          output = output,
          verbose = verbose
        )
      })
      if (output == "full_table") {
        orgs_from_hosts |>
          purrr::list_rbind()
      } else {
        orgs_from_hosts |>
          purrr::list_flatten()
      }
    },

    get_repos_from_hosts = function(add_contributors = FALSE,
                                    add_languages = TRUE,
                                    with_code,
                                    in_files = NULL,
                                    with_files,
                                    language = NULL,
                                    output = "table",
                                    verbose = TRUE,
                                    progress = TRUE,
                                    fill_empty_sha = FALSE) {
      repos_table <- purrr::map(private$hosts, function(host) {
        if (!is.null(with_code)) {
          private$get_repos_from_host_with_code(
            host = host,
            add_contributors = add_contributors,
            add_languages = add_languages,
            with_code = with_code,
            in_files = in_files,
            language = language,
            output = output,
            verbose = verbose,
            progress = progress
          )
        } else if (!is.null(with_files)) {
          private$get_repos_from_host_with_files(
            host = host,
            add_contributors = add_contributors,
            add_languages = add_languages,
            with_files = with_files,
            language = language,
            output = output,
            verbose = verbose,
            progress = progress
          )
        } else {
          host$get_repos(
            add_contributors = add_contributors,
            add_languages = add_languages,
            verbose = verbose,
            progress = progress,
            fill_empty_sha = fill_empty_sha
          )
        }
      }) |>
        purrr::list_rbind() |>
        dplyr::as_tibble() |>
        private$add_stats_to_repos() |>
        dplyr::as_tibble()
      return(repos_table)
    },

    get_repos_from_host_with_code = function(host,
                                             add_contributors,
                                             add_languages,
                                             with_code,
                                             in_files,
                                             language,
                                             output,
                                             verbose,
                                             progress) {
      purrr::map(with_code, function(with_code) {
        host$get_repos(
          add_contributors = add_contributors,
          add_languages = add_languages,
          with_code = with_code,
          in_files = in_files,
          language = language,
          output = output,
          verbose = verbose,
          progress = progress
        )
      }) |>
        purrr::list_rbind()
    },

    get_repos_from_host_with_files = function(host,
                                              add_contributors,
                                              add_languages,
                                              with_files,
                                              language,
                                              output,
                                              verbose,
                                              progress) {
      purrr::map(with_files, function(with_file) {
        host$get_repos(
          add_contributors = add_contributors,
          add_languages = add_languages,
          with_file = with_file,
          language = language,
          output = output,
          verbose = verbose,
          progress = progress
        )
      }) |>
        purrr::list_rbind()
    },

    get_repos_urls_from_hosts = function(type,
                                         with_code,
                                         in_files,
                                         with_files,
                                         verbose,
                                         progress) {
      purrr::map(private$hosts, function(host) {
        if (!is.null(with_code)) {
          private$get_repos_urls_from_host_with_code(
            host = host,
            type = type,
            with_code = with_code,
            in_files = in_files,
            verbose = verbose,
            progress = progress
          )
        } else if (!is.null(with_files)) {
          private$get_repos_urls_from_host_with_files(
            host = host,
            type = type,
            with_files = with_files,
            verbose = verbose,
            progress = progress
          )
        } else {
          host$get_repos_urls(
            type = type,
            verbose = verbose,
            progress = progress
          )
        }
      }) |>
        unlist() |>
        unique()
    },

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
      }) |>
        unlist()
    },

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
      }) |>
        unlist()
    },

    get_commits_from_hosts = function(since, until, verbose, progress) {
      commits_table <- purrr::map(private$hosts, function(host) {
        host$get_commits(
          since    = since,
          until    = until,
          verbose  = verbose,
          progress = progress
        )
      }) |>
        purrr::list_rbind() |>
        dplyr::as_tibble()
      return(commits_table)
    },

    get_issues_from_hosts = function(since, until, state, verbose, progress) {
      issues_table <- purrr::map(private$hosts, function(host) {
        host$get_issues(
          since    = since,
          until    = until,
          state    = state,
          verbose  = verbose,
          progress = progress
        )
      }) |>
        purrr::list_rbind() |>
        dplyr::as_tibble()
      return(issues_table)
    },

    get_pull_requests_from_hosts = function(since, until, state, verbose, progress) {
      pr_table <- purrr::map(private$hosts, function(host) {
        host$get_pull_requests(
          since    = since,
          until    = until,
          state    = state,
          verbose  = verbose,
          progress = progress
        )
      }) |>
        purrr::list_rbind() |>
        dplyr::as_tibble()
      return(pr_table)
    },

    get_users_from_hosts = function(logins) {
      purrr::map(private$hosts, function(host) {
        host$get_users(logins)
      }) |>
        unique() |>
        purrr::list_rbind() |>
        dplyr::as_tibble()
    },

    get_repos_trees_from_hosts = function(pattern,
                                          depth,
                                          verbose,
                                          progress) {
      purrr::map(private$hosts, function(host) {
        files_tree_table <- host$get_files_structure(
          pattern = pattern,
          depth = depth,
          verbose = verbose,
          progress = progress
        ) |>
          purrr::discard(~ length(.) == 0) |>
          purrr::imap(function(org_tree, org_name) {
            org_files_tree <- purrr::imap(org_tree, function(files_tree, repo_name) {
              dplyr::tibble(
                "repo_id" = attr(files_tree, "repo_id"),
                "repo_name" = repo_name,
                "files_tree" = list(files_tree)
              )
            }) |>
              purrr::list_rbind() |>
              dplyr::mutate(
                organization = org_name
              ) |>
              dplyr::relocate(
                organization, .before = files_tree
              )
          }) |>
          purrr::list_rbind() |>
          dplyr::mutate(
            githost = retrieve_githost(host$.__enclos_env__$private$api_url)
          )
      }) |>
        purrr::list_rbind()
    },

    get_files_from_hosts = function(pattern,
                                    depth,
                                    file_path,
                                    verbose,
                                    progress) {
      purrr::map(private$hosts, function(host) {
        if (is.null(file_path)) {
          files_structure <- host$get_files_structure(
            pattern = pattern,
            depth = depth,
            verbose = verbose,
            progress = progress
          ) |>
            purrr::discard(~ length(.) == 0)
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

    get_release_logs_from_hosts = function(since, until, verbose, progress) {
      purrr::map(private$hosts, function(host) {
        host$get_release_logs(
          since = since,
          until = until,
          verbose = verbose,
          progress = progress
        )
      }) |>
        purrr::list_rbind() |>
        dplyr::as_tibble()
    },

    add_stats_to_repos = function(repos_table) {
      if (nrow(repos_table > 0)) {
        repos_table <- repos_table |>
          dplyr::mutate(
            last_activity = difftime(
              Sys.time(),
              last_activity_at,
              units = "days"
            ) |> round(2)
          )
        if ("contributors" %in% colnames(repos_table)) {
          repos_table <- dplyr::mutate(
            repos_table,
            contributors_n = purrr::map_vec(contributors, function(contributors_string) {
              length(stringr::str_split(contributors_string[1], ", ")[[1]])
            })
          ) |>
            dplyr::relocate(
              contributors,
              .after = last_activity
            )
        }
      } else {
        repos_table <- NULL
      }
      return(repos_table)
    },

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

    print_item = function(item_name,
                          item_to_check,
                          item_to_print = item_to_check) {
      if (item_name %in% c(" Organizations", " Repositories")) {
        item_to_print <- unlist(item_to_print)
        item_to_print <- purrr::map_vec(item_to_print, function(element) {
          url_decode(element)
        })
        list_items <- cut_item_to_print(item_to_print)
        item_to_print <- paste0("[", cli::col_green(length(item_to_print)), "] ", list_items)
      }
      cat(paste0(
        cli::col_blue(paste0(item_name, ": ")),
        ifelse(
          is.null(item_to_check),
          cli::col_grey("<not defined>"),
          item_to_print
        ), "\n"
      ))
    },

    print_hosts = function() {
      hosts <- purrr::map_chr(private$hosts, function(host) {
        host_priv <- environment(host$initialize)$private
        host_priv$engines$rest$rest_api_url
      })
      private$print_item("Hosts", hosts, paste0(hosts, collapse = ", "))
    },

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

    print_storage = function() {
      backend_type <- if (inherits(private$storage_backend, "StoragePostgres")) {
        "PostgreSQL"
      } else if (inherits(private$storage_backend, "StorageSQLite")) {
        "SQLite"
      } else {
        "local"
      }
      stored_names <- private$storage_backend$list()
      gitstats_storage <- purrr::map(stored_names, function(storage_name) {
        storage_object <- private$storage_backend$load(storage_name)
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
      }) |>
        purrr::discard(~is.null(.))
      if (length(gitstats_storage) == 0) {
        private$print_item(
          glue::glue("Storage [{backend_type}]"),
          cli::col_grey("<no data in storage>")
        )
      } else {
        cat(cli::col_blue(glue::glue("Storage [{backend_type}]:")))
        cat("\n")
        cat(paste0(" ", gitstats_storage, collapse = "\n"))
      }
    },

    print_storage_attribute = function(storage_data, storage_name) {
      if (!storage_name %in% c("repositories", "organizations")) {
        storage_attr <- switch(storage_name,
                               "repos_urls" = "type",
                               "repos_trees" = "file_pattern",
                               "files" = "file_pattern",
                               "commits" = "date_range",
                               "issues" = "date_range",
                               "pull_requests" = "date_range",
                               "release_logs" = "date_range",
                               "users" = "logins")
        attr_data <- attr(storage_data, storage_attr)
        attr_name <- switch(storage_attr,
                            "type" = "type",
                            "file_pattern" = "file pattern",
                            "date_range" = "date range",
                            "logins" = "logins")
        if (length(attr_data) > 1) {
          separator <- if (storage_attr == "date_range") {
            " - "
          } else {
            ", "
          }
          attr_data <- attr_data |> paste0(collapse = separator)
        }
        return(cli::col_grey(glue::glue("[{attr_name}: {trimws(attr_data)}]")))
      } else {
        return("")
      }
    }
  )
)

#' @title Enable parallel processing
#' @name set_parallel
#' @description Set up parallel processing for API calls using mirai daemons.
#'   When enabled, GitStats fetches data from multiple repositories
#'   concurrently. Call `set_parallel(FALSE)` or `set_parallel(0)` to revert
#'   to sequential execution.
#' @param workers Number of parallel workers. Set to `TRUE` for automatic
#'   detection, a positive integer for a specific count, or `FALSE`/`0` to
#'   disable parallelism.
#' @return Invisibly returns the status from `mirai::daemons()`.
#' @examples
#' \dontrun{
#'   my_gitstats <- create_gitstats() |>
#'     set_github_host(
#'       token = Sys.getenv("GITHUB_PAT"),
#'       orgs = c("r-world-devs", "openpharma")
#'     )
#'   set_parallel(4)
#'   get_commits(my_gitstats, since = "2024-01-01")
#'   set_parallel(FALSE) # revert to sequential
#' }
#' @export
set_parallel <- function(workers = TRUE) {
  if (isFALSE(workers) || identical(workers, 0L) || identical(workers, 0)) {
    status <- mirai::daemons(0)
    cli::cli_alert_info("Parallel processing disabled.")
  } else {
    if (isTRUE(workers)) {
      workers <- parallel::detectCores(logical = FALSE)
      if (is.na(workers) || workers < 2L) workers <- 2L
    }
    status <- mirai::daemons(workers)
    # Export all GitStats namespace objects to daemon global environments.
    # This works regardless of whether the package is installed or loaded
    # via devtools::load_all(). Using ... (not .args) so objects are
    # assigned to the daemon's global env where they can be found by name.
    ns <- asNamespace("GitStats")
    ns_objects <- as.list(ns, all.names = TRUE)
    do.call(mirai::everywhere, c(list(quote({})), ns_objects))
    cli::cli_alert_success(
      "Parallel processing enabled with {workers} workers."
    )
  }
  return(invisible(status))
}
