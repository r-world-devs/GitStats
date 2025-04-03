#' @noRd
#' @description A class for methods wrapping GitHub's REST API responses.
EngineRestGitHub <- R6::R6Class(
  classname = "EngineRestGitHub",
  inherit = EngineRest,
  public = list(

    # Pull repositories with files
    get_files = function(files) {
      files_list <- list()
      for (filename in files) {
        search_file_endpoint <- paste0(private$endpoints[["search"]], "filename:", filename)
        total_n <- self$response(search_file_endpoint)[["total_count"]]
        if (length(total_n) > 0) {
          search_result <- private$search_response(
            search_endpoint = search_file_endpoint,
            total_n = total_n
          ) %>%
            purrr::keep(~ .$path == filename)
          files_content <- private$get_files_content(search_result, filename)
          files_list <- append(files_list, files_content)
        }
      }
      return(files_list)
    },

    # Prepare files table from REST API.
    prepare_files_table = function(files_list) {
      files_table <- NULL
      if (!is.null(files_list)) {
        files_table <- purrr::map(files_list, function(file_data) {
          repo_fullname <- private$get_repo_fullname(file_data$url)
          org_repo <- stringr::str_split_1(repo_fullname, "/")
          data.frame(
            "repo_name" = org_repo[2],
            "repo_id" = NA_character_,
            "organization" = org_repo[1],
            "file_path" = file_data$path,
            "file_content" = file_data$content,
            "file_size" = file_data$size,
            "repo_url" = private$set_repo_url(file_data$url)
          )
        }) %>%
          purrr::list_rbind()
      }
      return(files_table)
    },

    search_for_code = function(code,
                               org = NULL,
                               filename = NULL,
                               in_path = FALSE,
                               verbose = TRUE) {
      user_query <- if (!is.null(org)) {
        paste0('+user:', org)
      } else {
        ''
      }
      query <- if (!in_path) {
        paste0('"', code, '"', user_query)
      } else {
        paste0('"', code, '"+in:path', user_query)
      }
      if (!is.null(filename)) {
        query <- paste0(query, '+in:file+filename:', filename)
      }
      search_endpoint <- paste0(private$endpoints[["search"]], query)
      if (verbose) cli::cli_alert("Searching for code [{code}]...")
      total_n <- self$response(search_endpoint)[["total_count"]]
      search_result <- if (length(total_n) > 0) {
        private$search_response(
          search_endpoint = search_endpoint,
          total_n = total_n
        )
      } else {
        list()
      }
      return(search_result)
    },

    search_repos_for_code = function(code,
                                     repos,
                                     filename = NULL,
                                     in_path = FALSE,
                                     verbose = TRUE) {
      if (verbose) cli::cli_alert("Searching for code [{code}]...")
      search_result <- purrr::map(repos, function(repo) {
        repo_query <- paste0('+repo:', repo)
        query <- if (!in_path) {
          paste0('"', code, '"', repo_query)
        } else {
          paste0('"', code, '"+in:path', repo_query)
        }
        if (!is.null(filename)) {
          query <- paste0(query, '+in:file+filename:', filename)
        }
        search_endpoint <- paste0(private$endpoints[["search"]], query)
        total_n <- self$response(search_endpoint)[["total_count"]]
        result <- if (length(total_n) > 0) {
          private$search_response(
            search_endpoint = search_endpoint,
            total_n = total_n
          )
        } else {
          list()
        }
        return(result)
      }) |>
        purrr::list_flatten()
      return(search_result)
    },

    #' Pull all repositories URLS from organization
    get_repos_urls = function(type, org, repos) {
      owner_type <- attr(org, "type") %||% "organization"
      if (owner_type == "user") {
        repo_endpoint <- paste0(private$endpoints[["users"]], utils::URLdecode(org), "/repos")
      } else {
        repo_endpoint <- paste0(private$endpoints[["organizations"]], utils::URLdecode(org), "/repos")
      }
      repos_response <- private$paginate_results(
        endpoint = repo_endpoint
      )
      if (!is.null(repos)) {
        repos_response <- repos_response %>%
          purrr::keep(~ .$name %in% repos)
      }
      repos_urls <- repos_response %>%
        purrr::map_vec(function(repository) {
          if (type == "api") {
            repository$url
          } else {
            repository$html_url
          }
        })
      return(repos_urls)
    },

    #' Add information on repository contributors.
    get_repos_contributors = function(repos_table, progress) {
      if (nrow(repos_table) > 0) {
        repo_iterator <- paste0(repos_table$organization, "/", repos_table$repo_name)
        user_name <- rlang::expr(.$login)
        repos_table$contributors <- purrr::map_chr(repo_iterator, function(repos_id) {
          tryCatch({
            contributors_endpoint <- paste0(private$endpoints[["repositories"]], repos_id, "/contributors")
            contributors_vec <- private$get_contributors_from_repo(
              contributors_endpoint = contributors_endpoint,
              user_name = user_name
            )
            return(contributors_vec)
          },
          error = function(e) {
            NA
          })
        }, .progress = progress)
      }
      return(repos_table)
    }
  ),
  private = list(

    # List of endpoints
    endpoints = list(
      search = NULL,
      organizations = NULL,
      repositories = NULL
    ),

    # Set endpoints for the API
    set_endpoints = function() {
      private$endpoints[["search"]] <- paste0(
        self$rest_api_url,
        '/search/code?q='
      )
      private$endpoints[["organizations"]] <- paste0(
        self$rest_api_url,
        "/orgs/"
      )
      private$endpoints[["users"]] <- paste0(
        self$rest_api_url,
        "/users/"
      )
      private$endpoints[["repositories"]] <- paste0(
        self$rest_api_url,
        "/repos/"
      )
    },

    # A wrapper for proper pagination of GitHub search REST API
    # @param search_endpoint A character, a search endpoint
    # @param total_n Number of results
    # @param byte_max According to GitHub documentation only files smaller than
    #   384 KB are searchable. See
    #   \link{https://docs.github.com/en/rest/search?apiVersion=2022-11-28#search-code}
    search_response = function(search_endpoint,
                               total_n,
                               byte_max = "384000") {
      if (total_n >= 0 & total_n < 1e3) {
        page_iterator <- 1:(total_n %/% 100)
        items_list <- purrr::map(page_iterator, function(page) {
          response <- self$response(
            paste0(
              search_endpoint,
              "+size:0..",
              byte_max,
              "&page=",
              page,
              "&per_page=100"
            )
          )
          return(response[["items"]])
        }) %>%
          purrr::list_flatten()
        return(items_list)
      } else if (total_n >= 1e3) {
        items_list <- list()
        index <- c(0, 50)
        spinner <- cli::make_spinner(
          which = "timeTravel",
          template = cli::col_grey(
            "GitHub search limit (1000 results) exceeded. Results will be divided. {spin}"
          )
        )
        while (index[2] < as.numeric(byte_max)) {
          size_formula <- paste0("+size:", as.character(index[1]), "..", as.character(index[2]))
          spinner$spin()
          n_count <- tryCatch({
            self$response(paste0(search_endpoint, size_formula))[["total_count"]]
          }, error = function(e) {
            NULL
          })
          if (is.null(n_count)) {
            NULL
          } else if ((n_count - 1) %/% 100 > 0) {
            total_pages <- 1:(n_count %/% 100) + 1
            items_part_list <- purrr::map(total_pages, function(page) {
              self$response(paste0(search_endpoint,
                                   size_formula,
                                   "&page=",
                                   page,
                                   "&per_page=100"))[["items"]]
            }) %>%
              purrr::list_flatten()
            items_list <- append(items_list, items_part_list)
          } else if ((n_count - 1) %/% 100 == 0) {
            response <- self$response(paste0(search_endpoint,
                                             size_formula,
                                             "&page=1&per_page=100"))
            items_list <- append(items_list, response[["items"]])
          }
          index[1] <- index[2]
          if (index[2] < 1e3) {
            index[2] <- index[2] + 50
          }
          if (index[2] >= 1e3 && index[2] < 1e4) {
            index[2] <- index[2] + 100
          }
          if (index[2] >= 1e4 && index[2] < 1e5) {
            index[2] <- index[2] + 1000
          }
          if (index[2] >= 1e5 && index[2] < 1e6) {
            index[2] <- index[2] + 10000
          }
        }
        spinner$finish()
        return(items_list)
      }
    },

    # Get files content
    get_files_content = function(search_result, filename) {
      purrr::map(search_result, ~ self$response(.$url),
                 .progress = glue::glue("Adding file [{filename}] info...")) %>%
        unique()
    },

    # Get repository full name
    get_repo_fullname = function(file_url) {
      stringr::str_remove_all(file_url,
                              paste0(private$endpoints$repositories, "/")) %>%
        stringr::str_replace_all("/contents.*", "")
    }
  )
)
