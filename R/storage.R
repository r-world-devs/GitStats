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
#' @export
set_storage <- function(gitstats_obj,
                        type,
                        dbname,
                        schema = NULL,
                        host = NULL,
                        port = NULL,
                        user = NULL,
                        password = NULL) {
  gitstats_obj$set_storage(
    type = type,
    dbname = dbname,
    schema = schema,
    host = host,
    port = port,
    user = user,
    password = password
  )

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
