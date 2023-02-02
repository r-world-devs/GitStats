#' @importFrom R6 R6Class
#' @importFrom data.table rbindlist :=
#' @importFrom purrr map
#' @importFrom tibble tibble
#' @importFrom DBI dbConnect dbWriteTable dbReadTable dbListTables Id
#' @importFrom RPostgres Postgres
#' @importFrom RSQLite SQLite
#' @importFrom RMySQL MySQL
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

    #' @field team A character vector containing team members.
    team = NULL,

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

    #' @description Method to set connections to Git platforms
    #' @param api_url A character, url address of API.
    #' @param token A token.
    #' @param orgs A character vector of organisations (owners of repositories
    #'   in case of GitHub and groups of projects in case of GitLab).
    #' @param set_org_limit An integer defining how many orgs API may pull.
    #' @return Nothing, puts connection information into `$clients` slot
    set_connection = function(api_url,
                              token,
                              orgs = NULL,
                              set_org_limit = 300) {

      if (grepl("github", api_url)) {
        message("Set connection to GitHub.")
        new_client <- GitHub$new(
          rest_api_url = api_url,
          token = token,
          orgs = orgs,
          org_limit = set_org_limit
        )
      } else if (grepl("https://", api_url) && grepl("gitlab|code", api_url)) {
        message("Set connection to GitLab.")
        new_client <- GitLab$new(
          rest_api_url = api_url,
          token = token,
          orgs = orgs,
          org_limit = set_org_limit
        )
      } else {
        stop("This connection is not supported by GitStats class object.")
      }

      self$clients <- new_client %>%
        private$check_client() %>%
        private$check_token() %>%
        append(self$clients, .)
    },

    #' @description A method to set you organizations.
    #' @param ... A character vector of oganizations (repo owners or project
    #'   groups).
    #' @param api_url A url for connection.
    #' @return Nothing pass information on organizations into `$orgs` field of
    #'   `$clients`.
    set_organizations = function(...,
                                 api_url = NULL
                                 ) {

      if (length(self$clients) == 0) {
        stop("Set your connections first with `set_connection()`.",
             call. = FALSE)
      }

      if (is.null(api_url)) {
        if (length(self$clients) == 1) {
          api_url <- self$clients[[1]]$rest_api_url
          self$clients[[1]]$orgs <- unlist(list(...))
        } else if (length(self$clients) > 1) {
          stop("You need to specify `api_url` of your Git Service.",
               call. = FALSE)
        }
      } else {

        purrr::iwalk(self$clients, function(client, index) {
          if (grepl(api_url, client$rest_api_url)) {
            self$clients[[index]]$orgs <- unlist(list(...))
          }
        })

      }

      message("New organizations set for [", api_url, "]: ", paste(unlist(list(...)), collapse = ", "))

    },

    #' @description A method to set your team.
    #' @param team_name A name of a team.
    #' @param ... A character vector of team members (names and logins).
    #' @return Nothing, pass team information into `$team` field.
    set_team = function(team_name, ...) {
      self$team <- list()

      self$team[[paste(team_name)]] <- unlist(list(...))
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
          } else if (type == "MySQL") {
            RMySQL::MySQL()
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

      as.data.frame(DBI::dbListObjects(conn = self$storage,
                                       prefix = DBI::Id(schema = self$storage_schema)))

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
    get_repos = function(by = "org",
                         phrase = NULL,
                         language = NULL,
                         print_out = TRUE) {
      by <- match.arg(
        by,
        c("org", "team", "phrase")
      )

      team <- NULL
      if (by == "team") {
        if (is.null(self$team)) {
          stop("You have to specify a team first with 'set_team()' method.", call. = FALSE)
        }
        team <- self$team[[1]]
      } else if (by == "phrase") {
        if (is.null(phrase)) {
          stop("You have to provide a phrase to look for.", call. = FALSE)
        }
      }

      repos_dt_list <- purrr::map(self$clients, ~ .$get_repos(
        by = by,
        language = language,
        team = team
      ))

      if (any(purrr::map_lgl(repos_dt_list, ~ length(.) != 0))) {
        self$repos_dt <- repos_dt_list %>%
          rbindlist() %>%
          dplyr::arrange(last_activity_at)

        if (print_out) print(self$repos_dt)

        if (self$use_storage) {
          private$save_storage(self$repos_dt,
                               name = paste0("repos_by_", by))
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

      commits_storage <- if (self$use_storage) {
        private$check_storage(
          table_name = paste0("commits_by_", by)
          )
      }

      if (!is.null(commits_storage)) {
        date_from <- commits_storage[["last_date"]]
      }

      team <- NULL
      if (by == "team") {
        if (is.null(self$team)) {
          stop("You have to specify a team first with 'set_team()' method.", call. = FALSE)
        }
        team <- self$team[[1]]
      }

      commits_dt <- purrr::map(self$clients, function(x) {
        commits <- x$get_commits(
          date_from = date_from,
          date_until = date_until,
          by = by,
          team = team
        )

        if (!is.null(self$team)) {
          message(x$git_service, " for '", names(self$team), "' team: pulled commits from ", length(unique(commits$repository)), " repositories.")
        }

        commits
      }) %>% rbindlist(use.names = TRUE)

      commits_dt$committed_date <- as.Date(commits_dt$committed_date)

      self$commits_dt <- commits_dt

      if (print_out) print(commits_dt)

      if (self$use_storage) {
        private$save_storage(self$commits_dt,
                             name = paste0("commits_by_", by),
                             append = is.null(commits_storage))
      }

      invisible(self)
    },

    #' @description A print method for a GitStats object
    print = function() {
      cat(paste0("A GitStats object (multi-API client platform) for ", length(self$clients), " clients:"), sep = "\n")
      purrr::walk(self$clients, ~ .$print())
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
        DBI::dbWriteTable(conn = self$storage,
                          name = dbname,
                          value = object,
                          overwrite = TRUE)
        message("`", name, "` saved to local database.")
      } else {
        DBI::dbAppendTable(conn = self$storage,
                           name = dbname,
                           value = object)
        message("`", name, "` appended to local database.")
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
      gs_table <- DBI::dbReadTable(conn = self$storage,
                                   name = name) %>%
        data.table::data.table()

      if (grepl("repos", name)) {
        gs_table[, created_at := as.POSIXct(x = created_at,
                                            origin = "1970-01-01")
        ][, last_activity_at := as.difftime(tim = last_activity_at,
                                            units = "days")]
      } else if (grepl("commits", name)) {
        gs_table[, committed_date := as.Date(committed_date,
                                            origin = "1970-01-01")]
      }

      gs_table

    },

    #' @description Check if `GitStats` requests for something that is already in database.
    #' @param table_name Name of table to retrieve.
    #' @return A list.
    check_storage = function(table_name) {

      storage_list <- list()

      if (private$check_storage_table(table_name)) {
        message("`", table_name, "` is stored in your local database.")
        table_id <- DBI::Id(
          schema = self$storage_schema,
          table = table_name
        )
        db_table <- DBI::dbReadTable(conn = self$storage,
                                     name = table_id) %>%
          private$check_storage_clients() %>%
          private$check_storage_orgs()

        if (is.null(db_table)) {
          message("All commits will be pulled from API.")
          return(NULL)
        } else {
          storage_list[["db_table"]] <- db_table
          last_date <- as.POSIXct(private$pull_last_date(db_table), origin = "1970-01-01")
          storage_list[["last_date"]] <- last_date

          message("Only commits created since ", last_date, " will be pulled from API.")

          return(storage_list)
        }
      } else {
        message("`", table_name, "` not found in local database. All commits will be pulled from API.")
        return(NULL)
      }

    },

    #' @description Check if table name matches one in database.
    #' @param table_name Name of a table.
    #' @return A boolean.
    check_storage_table = function(table_name) {

      any(
        purrr::map(self$show_storage()["table"], ~grepl(table_name, .)) %>%
          unlist()
      )

    },

    #' @description Check if clients are in database.
    #' @param db_table Table to check.
    #' @return A data.frame.
    check_storage_clients = function(db_table) {
      check_urls <- purrr::map_chr(self$clients, ~.$rest_api_url) %in% unique(db_table$api_url)
      if (all(check_urls)) {
        return(db_table)
      } else if (any(check_urls)) {
        message("Not all clients found in database table.")
        return(NULL)
      } else {
        message("No clients found in database table.")
        return(NULL)
      }
    },

    #' @description Check if organizations are in database.
    #' @param db_table Table to check.
    #' @return A data.frame.
    check_storage_orgs = function(db_table) {
      if (!is.null(db_table)) {
        orgs_set <- purrr::map(self$clients, ~.$orgs) %>%
          unlist()
        check_orgs <- orgs_set %in% unique(db_table$organisation)
        if (all(check_orgs)) {
          return(db_table)
        } else if (any(check_orgs)){
          message("Not all organizations found in database table.")
          return(NULL)
        } else {
          message("No organizations found in database table")
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
    #' @param client An object of GitService class
    #' @return A GitService object
    check_client = function(client) {
      if (length(self$clients) > 0) {
        clients_to_check <- append(client, self$clients)

        urls <- purrr::map_chr(clients_to_check, ~ .$rest_api_url)

        if (length(urls) != length(unique(urls))) {
          stop("You can not provide two clients of the same API urls.
               If you wish to change/add more organizations you can do it with `set_organizations()` function.",
               call. = FALSE)
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
#' my_gitstats <- create_gitstats()
#' @return A `GitStats` object.
#' @export
create_gitstats <- function() {
  GitStats$new()
}

#' @title Setting connections
#' @name set_connection
#' @param api_url A character, url address of API.
#' @param token A token.
#' @param orgs A character vector of organisations (owners of repositories
#'   in case of GitHub and groups of projects in case of GitLab).
#' @param gitstats_obj A GitStats object.
#' @param set_org_limit An integer defining how many orgs API may pull.
#' @return A `GitStats` class object with added information on connection
#'   (`$clients` field).
#' @examples
#' \dontrun{
#' my_gitstats <- create_gitstats() %>%
#'   set_connection(
#'     api_url = "https://api.github.com",
#'     token = Sys.getenv("GITHUB_PAT"),
#'     orgs = c("r-world-devs", "openpharma", "pharmaverse")
#'   ) %>%
#'   set_connection(
#'     api_url = "https://gitlab.com/api/v4",
#'     token = Sys.getenv("GITLAB_PAT"),
#'     orgs = "erasmusmc-public-health"
#'   )
#' }
#' @export
set_connection <- function(gitstats_obj,
                           api_url,
                           token,
                           orgs = NULL,
                           set_org_limit = 300) {
  gitstats_obj$set_connection(
    api_url = api_url,
    token = token,
    orgs = orgs,
    set_org_limit = set_org_limit
  )

  return(invisible(gitstats_obj))
}

#' @title Choose your organizations.
#' @name set_organizations
#' @description A method to set you organizations.
#' @param gitstats_obj A GitStats object.
#' @param ... A character vector of oganizations (repo owners or project
#'   groups).
#' @param api_url A url for connection.
#' @return A `GitStats` class object with added information on organizations
#'   into `$orgs` of a `client`.
#' @examples
#' \dontrun{
#' ### with one connection,
#' my_gitstats <- create_gitstats() %>%
#'   set_connection(
#'     api_url = "https://api.github.com",
#'     token = Sys.getenv("GITHUB_PAT"),
#'     orgs = c("r-world-devs")
#'   )
#'
#' my_gitstats %>%
#'   set_organizations("openpharma", "pharmaverse")
#'
#' ### with multiple connections - remember to specify
#' `api_url` when setting organizations
#'
#' my_gitstats <- create_gitstats() %>%
#'  set_connection(
#'     api_url = "https://api.github.com",
#'     token = Sys.getenv("GITHUB_PAT"),
#'     orgs = c("r-world-devs")
#'  ) %>%
#'  set_connection(
#'     api_url = "https://gitlab.com/api/v4",
#'     token = Sys.getenv("GITLAB_PAT"),
#'     orgs = "erasmusmc-public-health"
#'  )
#'
#'  my_gitstats %>%
#'   set_organizations(api_url = "https://api.github.com",
#'                     "openpharma", "pharmaverse")
#'
#' }
#' @export
set_organizations <- function(gitstats_obj,
                             ...,
                             api_url = NULL) {

  gitstats_obj$set_organizations(api_url = api_url,
                                 ... = ...)

  return(invisible(gitstats_obj))
}

#' @title Set your team.
#' @name set_team
#' @description Declare your team members (logins, full names) to obtain
#'   statistics \code{by = "team"}.
#' @details Bear in mind that on different Git platforms, team members may use
#'   different logins. You have to specify all of them, if you want to get team
#'   statistics from all your Git clients.
#' @param gitstats_obj A GitStats object.
#' @param team_name A name of a team.
#' @param ... A character vector of team members (names and logins).
#' @return A `GitStats` class object with added information to `$team` field.
#' @examples
#' \dontrun{
#' my_gitstats <- create_gitstats() %>%
#'   set_connection(
#'     api_url = "https://api.github.com",
#'     token = Sys.getenv("GITHUB_PAT"),
#'     orgs = c("r-world-devs", "openpharma", "pharmaverse")
#'   ) %>%
#'   set_team("RWD-IE", "galachad", "kalimu", "Cotau",
#'            "krystian8207", "marcinkowskak", "maciekbanas") %>%
#'   get_repos(by = "team")
#' }
#' @export
set_team <- function(gitstats_obj, team_name, ...) {
  gitstats_obj$set_team(team_name, ...)

  return(invisible(gitstats_obj))
}

#' @title Set a storage for your output
#' @name set_storage
#' @description Function to set local storage (database) for the output.
#' @details This is a wrapper over `dbConnect()` function. This functionality
#'   is meant among other to improve `GitStats` performance. Basically the
#'   idea is to cache your API responses in a database and retrieve them
#'   when necessary. E.g. when you call `get_commits(date_from =
#'   '2020-01-01')` it will save the results to your database and when you
#'   call it next time, `get_commits()` will retrieve from API only these
#'   results that do not exist in the databse (the new ones).
#' @param gitstats_obj A GitStats object.
#' @param type A character, type of storage.
#' @param dbname Name of database.
#' @param schema A db schema.
#' @param host A host.
#' @param port An integer, port address.
#' @param user Username.
#' @param password A password.
set_storage <- function(gitstats_obj,
                        type,
                        dbname,
                        schema = NULL,
                        host = NULL,
                        port = NULL,
                        user = NULL,
                        password = NULL) {
  gitstats_obj$set_storage(type = type,
                           dbname = dbname,
                           schema = schema,
                           host = host,
                           port = port,
                           user = user,
                           password = password)

  return(invisible(gitstats_obj))
}

#' @title Show content of database.
#' @param gitstats_obj A GitStats object.
#' @name show_storage
#' @description Print content of database.
#' @return A data.frame of table names.
#' @export
show_storage <- function(gitstats_obj) {

  gitstats_obj$show_storage()

}

#' @title Switch off storage of data.
#' @name storage_off
#' @param gitstats_obj A GitStats object.
#' @return A `GitStats` class object with field `$use_storage` turned to FALSE
#' @export
storage_off <- function(gitstats_obj) {
  gitstats_obj$storage_off()
  return(invisible(gitstats_obj))
}

#' @title Switch on storage of data.
#' @name storage_on
#' @param gitstats_obj A GitStats object.
#' @return A `GitStats` class object with field `$use_storage` turned to TRUE
#' @export
storage_on <- function(gitstats_obj) {
  gitstats_obj$storage_on()
  return(invisible(gitstats_obj))
}

#' @title Get information on repositories
#' @name get_repos
#' @description  List all repositories for an organization, a team or by a
#'   keyword.
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
#'   set_connection(
#'     api_url = "https://api.github.com",
#'     token = Sys.getenv("GITHUB_PAT"),
#'     orgs = c("r-world-devs", "openpharma", "pharmaverse")
#'   ) %>%
#'   set_connection(
#'     api_url = "https://gitlab.com/api/v4",
#'     token = Sys.getenv("GITLAB_PAT"),
#'     orgs = "erasmusmc-public-health"
#'   ) %>%
#'   get_repos(language = "R")
#'
#' my_gitstats$get_repos(
#'   by = "phrase",
#'   phrase = "diabetes",
#'   language = "R"
#' )
#' }
#' @export
get_repos <- function(gitstats_obj,
                      by = "org",
                      phrase = NULL,
                      language = NULL,
                      print_out = TRUE) {
  gitstats_obj$get_repos(
    by = by,
    phrase = phrase,
    language = language,
    print_out = print_out
  )

  return(invisible(gitstats_obj))
}

#' @title Get information on commits.
#' @name get_commits
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
#'   set_connection(
#'     api_url = "https://api.github.com",
#'     token = Sys.getenv("GITHUB_PAT"),
#'     orgs = c("r-world-devs", "openpharma", "pharmaverse")
#'   ) %>%
#'   set_connection(
#'     api_url = "https://gitlab.com/api/v4",
#'     token = Sys.getenv("GITLAB_PAT"),
#'     orgs = "erasmusmc-public-health"
#'   ) %>%
#'   get_commits(date_from = "2020-01-01")
#'
#' my_gitstats %>%
#'   set_team("RWD-IE", "galachad", "kalimu", "Cotau",
#'            "krystian8207", "marcinkowskak", "maciekbanas") %>%
#'   get_commits(
#'     date_from = "2020-01-01",
#'     date_until = "2022-12-31",
#'     by = "team"
#'   )
#' }
#' @export
get_commits <- function(gitstats_obj,
                        date_from = NULL,
                        date_until = Sys.time(),
                        by = "org",
                        print_out = TRUE) {
  gitstats_obj$get_commits(
    date_from = date_from,
    date_until = date_until,
    by = by,
    print_out = print_out
  )

  return(invisible(gitstats_obj))
}
