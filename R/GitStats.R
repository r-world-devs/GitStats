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
      self$parameters$search_param <- "org"
    },

    #' @field parameters
    parameters = list(
      search_param = NULL,
      phrase = NULL,
      team_name = NULL,
      team = list(),
      language = NULL
    ),

    #' @field storage A local database credentials to store output.
    storage = NULL,

    #' @field storage_schema A schema of database.
    storage_schema = NULL,

    #' @field use_storage A boolean to check if storage is set.
    use_storage = FALSE,

    #' @field repos_dt An output table of repositories.
    repos_dt = NULL,

    #' @field commits_dt An output table of commits.
    commits_dt = NULL,

    #' @description Set up your search parameters.
    #' @param search_param One of three: `team`, `org` or `phrase`.
    #' @param team_name A name of a team.
    #' @param phrase A phrase to look for.
    #' @param language A language of programming code.
    #' @return Nothing.
    setup = function(search_param,
                     team_name,
                     phrase,
                     language) {
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
          self$parameters$team_name <- team_name
          cli::cli_alert_success(
            paste0("Your search preferences set to {cli::col_green('team: ", team_name, "')}.")
          )
          if (length(self$team) == 0) {
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
          self$parameters$phrase <- phrase
          cli::cli_alert_success(
            paste0("Your search preferences set to {cli::col_green('phrase: ", phrase, "')}.")
          )
        }
      }
      self$parameters$search_param <- search_param
      if (!is.null(language)) {
        self$parameters$language <- private$language_handler(language)
        cli::cli_alert_success(
          paste0("Your programming language is set to <", language, ">.")
        )
      }
      if (!is.null(self$clients)) {
        purrr::walk(self$clients, function(client) {
          client$parameters <- self$parameters
        })
      }
    },

    #' @description Method to set connections to Git platforms
    #' @param api_url A character, url address of API.
    #' @param token A token.
    #' @param orgs A character vector of organisations (owners of repositories
    #'   in case of GitHub and groups of projects in case of GitLab).
    #' @return Nothing, puts connection information into `$clients` slot
    set_connection = function(api_url,
                              token,
                              orgs) {

      if (grepl("https://", api_url) && grepl("github", api_url)) {
        rest_engine <- EngineRestGitHub$new(
          token = token,
          rest_api_url = api_url
        )
        graphql_engine <- EngineGraphQLGitHub$new(
          token = token,
          gql_api_url = api_url
        )
        cli::cli_alert_success("Set connection to GitHub.")
      } else if (grepl("https://", api_url) && grepl("gitlab|code", api_url)) {
        rest_engine <- EngineRestGitLab$new(
          token = token,
          rest_api_url = api_url
        )
        graphql_engine <- NULL
        cli::cli_alert_success("Set connection to GitLab.")
      } else {
        stop("This connection is not supported by GitStats class object.")
      }

      new_client <- GitHost$new(
        orgs = orgs,
        graphql_engine = graphql_engine,
        rest_engine = rest_engine,
        parameters = self$parameters
      )

      self$clients <- new_client %>%
        private$check_client() %>%
        append(self$clients, .)
    },

    #' @description A method to set you organizations.
    #' @param ... A character vector of oganizations (repo owners or project
    #'   groups).
    #' @param api_url A url for connection.
    #' @return Nothing pass information on organizations into `$orgs` field of
    #'   `$clients`.
    set_organizations = function(...,
                                 api_url = NULL) {
      if (length(self$clients) == 0) {
        stop("Set your connections first with `set_connection()`.",
          call. = FALSE
        )
      }

      if (is.null(api_url)) {
        if (length(self$clients) == 1) {
          self$clients[[1]]$orgs <- unlist(list(...))
        } else if (length(self$clients) > 1) {
          stop("You need to specify `api_url` of your Git Host.",
            call. = FALSE
          )
        }
      } else {
        purrr::iwalk(self$clients, function(client, index) {
          if (grepl(api_url, client$rest_engine$rest_api_url)) {
            self$clients[[index]]$orgs <- unlist(list(...))
          }
        })
      }
      message("New organizations set for [", api_url, "]: ", paste(unlist(list(...)), collapse = ", "))
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

      self$parameters$team[[paste0(member_name)]] <- team_member

      cli::cli_alert_success("{member_name} successfully added to team.")
    },

    #' @description A method to set local storage for the output.
    #' @details This is a wrapper over `DBI::dbConnect()` function. This functionality
    #'   is meant among other to improve `GitStats` performance. Basically the
    #'   idea is to cache your API responses in a database and retrieve them
    #'   when necessary. E.g. when you call `get_commits(date_from =
    #'   '2020-01-01')` it will save the results to your database and when you
    #'   call it next time, `get_commits()` will retrieve from API only these
    #'   results that do not exist in the databse (the new ones).
    #' @param type A character, type of storage.
    #' @param dbname Name of database.
    #' @param schema A db schema.
    #' @param host A host.
    #' @param port An integer, port address.
    #' @param user Username.
    #' @param password A password.
    #' @return A `GitStats` object with information on local database.
    set_storage = function(type,
                           dbname,
                           schema,
                           host,
                           port,
                           user,
                           password) {
      self$storage <- DBI::dbConnect(
        drv = if (type == "Postgres") {
          RPostgres::Postgres()
        } else if (type == "SQLite") {
          RSQLite::SQLite()
        },
        dbname = dbname,
        host = host,
        port = port,
        user = user,
        password = password
      )

      self$storage_schema <- schema

      self$use_storage <- TRUE
    },

    #' @description Print content of database.
    #' @return A data.frame of table names.
    show_storage = function() {
      as.data.frame(DBI::dbListObjects(
        conn = self$storage,
        prefix = DBI::Id(schema = self$storage_schema)
      ))
    },

    #' @description Switch off storage of data.
    #' @return Nothing, turns field `$use_storage` to FALSE
    storage_off = function() {
      message("Storage will not be used.")
      self$use_storage <- FALSE
    },

    #' @description Switch on storage of data.
    #' @return Nothing, turns field `$use_storage` to TRUE
    storage_on = function() {
      self$use_storage <- TRUE
    },

    #' @description  A method to list all repositories for an organization,
    #'   a team or by a keyword.
    #' @param by A character, to choose between: \itemize{\item{org - organizations
    #'   (owners of repositories)} \item{team - A team} \item{phrase - A keyword in
    #'   code blobs.}}
    #' @param phrase A character, phrase to look for in codelines.
    #' @param language A character specifying language used in repositories.
    #' @param print_out A boolean stating whether to print an output.
    #' @return A data.frame of repositories
    get_repos = function(by,
                         phrase,
                         language,
                         print_out) {
      by <- match.arg(
        by,
        c("org", "team", "phrase")
      )

      team <- NULL
      if (by == "team") {
        if (length(self$team) == 0) {
          cli::cli_abort("You have to specify a team first with 'add_team_member()'.")
        }
        team <- self$team
      } else if (by == "phrase") {
        if (is.null(phrase)) {
          cli::cli_abort("You have to provide a phrase to look for.")
        }
      }

      repos_dt_list <- purrr::map(self$clients, ~ .$get_repos())

      if (any(purrr::map_lgl(repos_dt_list, ~ length(.) != 0))) {
        self$repos_dt <- repos_dt_list %>%
          rbindlist(use.names = TRUE) %>%
          dplyr::arrange(last_activity_at)

        if (print_out) dplyr::glimpse(self$repos_dt)

        if (self$use_storage) {
          private$save_storage(self$repos_dt,
            name = paste0("repos_by_", by)
          )
        }
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
    get_commits = function(date_from,
                           date_until,
                           by,
                           print_out) {
      if (is.null(date_from)) {
        stop("You need to define `date_from`.", call. = FALSE)
      }

      by <- match.arg(
        by,
        c("org", "team")
      )

      commits_storage <- if (self$use_storage) {
        private$check_storage(
          table_name = paste0("commits_by_", by)
        )
      }

      if (!is.null(commits_storage)) {
        # need to move date to get only new commits
        date_from <- commits_storage[["last_date"]] + lubridate::seconds(1)
      }

      team <- NULL
      if (by == "team") {
        if (length(self$team) == 0) {
          cli::cli_abort("You have to specify a team first with 'add_team_member()'.")
        }
        team <- self$team
      }

      commits_dt <- purrr::map(self$clients, function(x) {
        commits <- x$get_commits(
          date_from = date_from,
          date_until = date_until
        )

        if (by == "team" && !is.null(self$team)) {
          cli::cli_alert_success(
            paste0(
              x$git_service, " for '", self$team_name, "' team: pulled ",
              nrow(commits), " commits from ",
              length(unique(commits$repository)), " repositories."
            )
          )
        }

        commits
      }) %>% rbindlist(use.names = TRUE)

      commits_dt$committed_date <- gts_to_posixt(commits_dt$committed_date)

      self$commits_dt <- commits_dt

      if (print_out) dplyr::glimpse(commits_dt)

      if (self$use_storage) {
        private$save_storage(self$commits_dt,
          name = paste0("commits_by_", by),
          append = !is.null(commits_storage)
        )
      }

      invisible(self)
    },

    #' @description A print method for a GitStats object
    print = function() {
      cat(paste0("A <GitStats> object for ", length(self$clients), " clients:"), sep = "\n")
      clients <- purrr::map_chr(self$clients, ~ .$engines$rest$rest_api_url)
      private$print_item("Hosts", clients, paste0(clients, collapse = ", "))
      orgs <- purrr::map(self$clients, ~ paste0(.$orgs, collapse = ", ")) %>% paste0(collapse = ", ")
      private$print_item("Organisations", orgs)
      private$print_item("Search preference", self$parameters$search_param)
      private$print_item("Team", self$parameters$team_name, paste0(self$parameters$team_name, " (", length(self$parameters$team), " members)"))
      private$print_item("Phrase", self$parameters$phrase)
      private$print_item("Language", self$parameters$language)
      private$print_item("Storage", self$storage, class(self$storage)[1])
      cat(paste0(
        cli::col_blue("Storage On/Off: "),
        ifelse(self$use_storage, "ON", cli::col_grey("OFF"))
      ))
    }
  ),
  private = list(

    #' @description Save objects to a database.
    #' @param object A data.frame, an object to save.
    #' @param name Name of table.
    #' @param append A boolean to decide whether to overwrite or append table.
    #' @return Nothing.
    save_storage = function(object,
                            name,
                            append = FALSE) {
      if (!is.null(self$storage_schema)) {
        dbname <- DBI::Id(
          schema = self$storage_schema,
          table = name
        )
      } else {
        dbname <- name
      }

      if (class(self$storage)[1] != "SQLiteConnection" && grepl("repos", name)) {
        object[, last_activity_at := as.numeric(last_activity_at)]
      }

      if (!append) {
        DBI::dbWriteTable(
          conn = self$storage,
          name = dbname,
          value = object,
          overwrite = TRUE
        )
        cli::cli_alert_success(paste0("`", name, "` saved to local database."))
      } else {
        DBI::dbAppendTable(
          conn = self$storage,
          name = dbname,
          value = object
        )
        cli::cli_alert_success(paste0("`", name, "` appended to local database."))
      }
    },

    #' @description Pulls objects from a database.
    #' @param name Name of table to retrieve.
    #' @return A data.table.
    pull_storage = function(name) {
      if (!is.null(self$storage_schema)) {
        name <- DBI::Id(
          schema = self$storage_schema,
          table = name
        )
      }
      gs_table <- DBI::dbReadTable(
        conn = self$storage,
        name = name
      ) %>%
        data.table::data.table()

      if (grepl("repos", name)) {
        gs_table[, created_at := as.POSIXct(
          x = created_at,
          origin = "1970-01-01"
        )][, last_activity_at := as.difftime(
          tim = last_activity_at,
          units = "days"
        )]
      } else if (grepl("commits", name)) {
        gs_table[, committed_date := as.POSIXct(committed_date,
          origin = "1970-01-01"
        )]
      }

      gs_table
    },

    #' @description Check if `GitStats` requests for something that is already in database.
    #' @param table_name Name of table to retrieve.
    #' @return A list.
    check_storage = function(table_name) {
      storage_list <- list()

      if (private$check_storage_table(table_name)) {
        cli::cli_alert_info(paste0("`", table_name, "` is stored in your local database."))
        table_id <- DBI::Id(
          schema = self$storage_schema,
          table = table_name
        )
        db_table <- DBI::dbReadTable(
          conn = self$storage,
          name = table_id
        ) %>%
          private$check_storage_clients() %>%
          private$check_storage_orgs()

        if (is.null(db_table)) {
          cli::cli_alert_info("All commits will be pulled from API.")
          return(NULL)
        } else {
          storage_list[["db_table"]] <- db_table
          last_date <- as.POSIXct(private$pull_last_date(db_table), origin = "1970-01-01")
          storage_list[["last_date"]] <- last_date

          cli::cli_alert_info(paste0("Only commits created since ", last_date, " will be pulled from API."))

          return(storage_list)
        }
      } else {
        cli::cli_alert_info(paste0("`", table_name, "` not found in local database. All commits will be pulled from API."))
        return(NULL)
      }
    },

    #' @description Check if table name matches one in database.
    #' @param table_name Name of a table.
    #' @return A boolean.
    check_storage_table = function(table_name) {
      any(
        purrr::map(self$show_storage()["table"], ~ grepl(table_name, .)) %>%
          unlist()
      )
    },

    #' @description Check if clients are in database.
    #' @param db_table Table to check.
    #' @return A data.frame.
    check_storage_clients = function(db_table) {
      check_urls <- purrr::map_chr(self$clients, ~ .$rest_engine$rest_api_url) %in% unique(db_table$api_url)
      if (length(check_urls) > 0 & all(check_urls)) {
        cli::cli_alert_success("Clients already in database table.")
        return(db_table)
      } else if (any(check_urls)) {
        cli::cli_alert_warning("Not all clients found in database table.")
        return(NULL)
      } else {
        cli::cli_alert_warning("No clients found in database table.")
        return(NULL)
      }
    },

    #' @description Check if organizations are in database.
    #' @param db_table Table to check.
    #' @return A data.frame.
    check_storage_orgs = function(db_table) {
      if (!is.null(db_table)) {
        orgs_set <- purrr::map(self$clients, ~ .$orgs) %>%
          unlist()
        check_orgs <- orgs_set %in% unique(db_table$organization)
        if (length(check_orgs) > 0 & all(check_orgs)) {
          cli::cli_alert_success("Organizations already in database table.")
          return(db_table)
        } else if (any(check_orgs)) {
          cli::cli_alert_warning("Not all organizations found in database table.")
          return(NULL)
        } else {
          cli::cli_alert_warning("No organizations found in database table.")
          return(NULL)
        }
      } else {
        return(NULL)
      }
    },

    #' @description Check last date of creation.
    #' @param db_table Table to check.
    #' @return A date.
    pull_last_date = function(db_table) {
      max(db_table$committed_date)
    },

    #' @description Check whether the urls do not repeat in input.
    #' @param client An object of GitPlatform class
    #' @return A GitPlatform object
    check_client = function(client) {
      if (length(self$clients) > 0) {
        clients_to_check <- append(client, self$clients)

        urls <- purrr::map_chr(clients_to_check, ~ .$engines$rest$rest_api_url)

        if (length(urls) != length(unique(urls))) {
          stop("You can not provide two clients of the same API urls.
               If you wish to change/add more organizations you can do it with `set_organizations()` function.",
            call. = FALSE
          )
        }
      }

      client
    },

    #' @description Switcher to manage language names
    #' @details E.g. GitLab API will not filter
    #'   properly if you provide 'python' language
    #'   with small letter.
    #' @param language A character, language name
    #' @return A character
    language_handler = function(language) {
      if (!is.null(language)) {
        substr(language, 1, 1) <- toupper(substr(language, 1, 1))
      } else if (language %in% c("javascript", "Javascript", "js", "JS", "Js")) {
        language <- "JavaScript"
      }
      language
    },

    #' @description A helper to manage printing `GitStats` object.
    #' @param name Name of item to print.
    #' @param item_to_check Item to check for emptiness.
    #' @param item_to_print Item to print, if not defined it is item that is checked.
    #' @return Nothing, prints object.
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
