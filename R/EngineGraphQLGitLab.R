#' @noRd
#' @description A class for methods wrapping GitLab's GraphQL API responses.
EngineGraphQLGitLab <- R6::R6Class("EngineGraphQLGitLab",
   inherit = EngineGraphQL,
   public = list(

     #' Create `EngineGraphQLGitLab` object.
     initialize = function(gql_api_url,
                           token,
                           scan_all = FALSE) {
       super$initialize(gql_api_url = gql_api_url,
                        token = token,
                        scan_all = scan_all)
       self$gql_query <- GQLQueryGitLab$new()
     },

     #' Get all groups from GitLab.
     pull_orgs = function() {
       group_cursor <- ""
       has_next_page <- TRUE
       full_orgs_list <- list()
       while(has_next_page) {
         response <- self$gql_response(
           gql_query = self$gql_query$groups(),
           vars = list("groupCursor" = group_cursor)
         )
         if (length(response$data$groups$edges) == 0) {
           cli::cli_abort(
             c(
               "x" = "Empty response.",
               "!" = "Your token probably does not cover scope to pull organizations.",
               "i" = "Set `read_api` scope when creating GitLab token."
             )
           )
         }
         orgs_list <- purrr::map(response$data$groups$edges, ~.$node$fullPath)
         full_orgs_list <- append(full_orgs_list, orgs_list)
         has_next_page <- response$data$groups$pageInfo$hasNextPage
         group_cursor <- response$data$groups$pageInfo$endCursor
       }
       all_orgs <- unlist(full_orgs_list)
       return(all_orgs)
     },

     # Iterator over pulling pages of repositories.
     get_repos_from_org = function(org = NULL) {
       full_repos_list <- list()
       next_page <- TRUE
       repo_cursor <- ""
       while (next_page) {
         repos_response <- private$get_repos_page(
           org = org,
           repo_cursor = repo_cursor
         )
         if (length(repos_response$data$group) == 0) {
           cli::cli_abort("Empty")
         }
         core_response <- repos_response$data$group$projects
         repos_list <- core_response$edges
         next_page <- core_response$pageInfo$hasNextPage
         if (is.null(next_page)) next_page <- FALSE
         if (is.null(repos_list)) repos_list <- list()
         if (length(repos_list) == 0) next_page <- FALSE
         if (next_page) {
           repo_cursor <- core_response$pageInfo$endCursor
         } else {
           repo_cursor <- ""
         }
         full_repos_list <- append(full_repos_list, repos_list)
       }
       return(full_repos_list)
     },

     # Pull all given files from all repositories of a group.
     # This is a one query way to get all the necessary info.
     # However it may fail if query is too complex (too many files in file_paths).
     # This may be especially the case when trying to pull the data from earlier
     # pulled files_structure. In such a case GitStats will switch from this function
     # to iterator over repositories (multiple queries), as it is done for GitHub.
     get_files_from_org = function(org,
                                   repos,
                                   file_paths,
                                   host_files_structure,
                                   only_text_files,
                                   verbose = FALSE,
                                   progress = verbose) {
       org <- URLdecode(org)
       full_files_list <- list()
       next_page <- TRUE
       end_cursor <- ""
       if (!is.null(host_files_structure)) {
         file_paths <- private$get_path_from_files_structure(
           host_files_structure = host_files_structure,
           only_text_files = only_text_files,
           org = org
         )
       } else if (is.null(host_files_structure) && only_text_files) {
         file_paths <- file_paths[!grepl(non_text_files_pattern, file_paths)]
       }
       while (next_page) {
         files_query <- self$gql_query$files_by_org(
           end_cursor = end_cursor
         )
         files_response <- tryCatch({
           self$gql_response(
             gql_query = files_query,
             vars = list(
               "org" = org,
               "file_paths" = file_paths
             )
           )
         },
         error = function(e) {
           list()
         })
         if (private$is_query_error(files_response)) {
           if (verbose) {
             purrr::walk(files_response$errors, ~ cli::cli_alert_warning(.))
           }
           if (private$is_complexity_error(files_response)) {
             if (verbose) {
               cli::cli_alert_info(
                 cli::col_br_cyan("I will switch to pulling files per repository.")
               )
             }
             full_files_list <- self$get_files_from_org_per_repo(
               org = org,
               repos = repos,
               file_paths = file_paths,
               host_files_structure = host_files_structure,
               only_text_files = only_text_files,
               verbose = verbose,
               progress = progress
             )
             return(full_files_list)
           }
         }
         if (length(files_response$data$group) == 0 && verbose) {
           cli::cli_alert_danger("Empty response.")
         }
         projects <- files_response$data$group$projects
         files_list <- purrr::map(projects$edges, function(edge) {
           edge$node
         }) %>%
           purrr::discard(~ length(.$repository$blobs$nodes) == 0)
         if (is.null(files_list)) files_list <- list()
         if (length(files_list) > 0) {
           next_page <- files_response$pageInfo$hasNextPage
         } else {
           next_page <- FALSE
         }
         if (is.null(next_page)) next_page <- FALSE
         if (next_page) {
           end_cursor <- files_response$pageInfo$endCursor
         } else {
           end_cursor <- ""
         }
         full_files_list <- append(full_files_list, files_list)
       }
       if (!is.null(repos)) {
         full_files_list <- purrr::keep(full_files_list, function(project) {
           repo_name <- private$get_repo_name_from_url(project$webUrl)
           repo_name %in% repos
         })
       }
       return(full_files_list)
     },

     # This method is a kind of support to the method above. It is only run when
     # one query way applied with get_files_from_org() fails due to its complexity.
     # For more info see docs above.
     get_files_from_org_per_repo = function(org,
                                            repos,
                                            file_paths = NULL,
                                            host_files_structure = NULL,
                                            only_text_files = TRUE,
                                            verbose = FALSE,
                                            progress = verbose) {
       if (is.null(repos)) {
         repo_data <- private$get_repos_data(
           org = org,
           repos = repos
         )
         repos <- repo_data[["repositories"]]
       }
       org_files_list <- purrr::map(repos, function(repo) {
         if (!is.null(host_files_structure)) {
           file_paths <- private$get_path_from_files_structure(
             host_files_structure = host_files_structure,
             only_text_files = only_text_files,
             org = org,
             repo = repo
           )
         }
         files_response <- tryCatch({
           private$get_file_blobs_response(
             org = org,
             repo = repo,
             file_paths = file_paths
           )
         },
         error = function(e) {
           list()
         })
       }, .progress = progress)
       return(org_files_list)
     },

     get_files_structure_from_org = function(org, repos, pattern = NULL, depth = Inf, verbose = FALSE) {
       repo_data <- private$get_repos_data(
         org = org,
         repos = repos
       )
       repositories <- repo_data[["repositories"]]
       files_structure <- purrr::map(repositories, function(repo) {
         private$get_files_structure_from_repo(
           org = org,
           repo = repo,
           pattern = pattern,
           depth = depth
         )
       }, .progress = verbose)
       names(files_structure) <- repositories
       files_structure <- purrr::discard(files_structure, ~ length(.) == 0)
       return(files_structure)
     },

     # Pull all releases from all repositories of an organization.
     get_release_logs_from_org = function(repos_names, org) {
       release_responses <- purrr::map(repos_names, function(repository) {
         releases_from_repo_query <- self$gql_query$releases_from_repo()
         response <- self$gql_response(
           gql_query = releases_from_repo_query,
           vars = list(
             "project_path" = utils::URLdecode(repository)
           )
         )
         return(response)
       }) %>%
         purrr::discard(~ length(.$data$project$releases$nodes) == 0)
       return(release_responses)
     }

   ),

   private = list(

     is_complexity_error = function(response) {
       any(purrr::map_lgl(response$errors, ~ grepl("Query has complexity", .$message)))
     },

     # Wrapper over building GraphQL query and response.
     get_repos_page = function(org = NULL,
                                repo_cursor = "") {
       repos_query <- self$gql_query$repos_by_org(
         repo_cursor = repo_cursor
       )
       response <- self$gql_response(
         gql_query = repos_query,
         vars = list("org" = org)
       )
       return(response)
     },

     # Helper
     get_repo_name_from_url = function(web_url) {
       url_split <- stringr::str_split(web_url, ":|/")[[1]]
       repo_name <- url_split[length(url_split)]
       return(repo_name)
     },

     get_repos_data = function(org, repos = NULL) {
       repos_list <- self$get_repos_from_org(
         org = org
       )
       if (!is.null(repos)) {
         repos_list <- purrr::keep(repos_list, ~ .$node$repo_path %in% repos)
       }
       result <- list(
         "repositories" = purrr::map_vec(repos_list, ~ .$node$repo_path)
       )
       return(result)
     },

     get_file_blobs_response = function(org, repo, file_paths) {
       file_blobs_response <- self$gql_response(
         gql_query = self$gql_query$file_blob_from_repo(),
         vars = list(
           "fullPath" = paste0(org, "/", repo),
           "file_paths" = file_paths
         )
       )
       return(file_blobs_response)
     },

     get_files_tree_response = function(org, repo, file_path) {
       files_tree_response <- self$gql_response(
         gql_query = self$gql_query$files_tree_from_repo(),
         vars = list(
           "fullPath" = paste0(org, "/", repo),
           "file_path" = file_path
         )
       )
       return(files_tree_response)
     },

     get_files_structure_from_repo = function(org, repo, pattern = NULL, depth = Inf) {
       files_tree_response <- private$get_files_tree_response(
         org = org,
         repo = repo,
         file_path = ""
       )
       files_and_dirs_list <- private$get_files_and_dirs(
         files_tree_response = files_tree_response
       )
       if (length(files_and_dirs_list$dirs) > 0) {
         folders_exist <- TRUE
       } else {
         folders_exist <- FALSE
       }
       all_files_and_dirs_list <- files_and_dirs_list
       dirs <- files_and_dirs_list$dirs
       tier <- 1
       while (folders_exist && tier < depth) {
         new_dirs_list <- c()
         for (dir in dirs) {
           files_tree_response <- private$get_files_tree_response(
             org = org,
             repo = repo,
             file_path = dir
           )
           files_and_dirs_list <- private$get_files_and_dirs(
             files_tree_response = files_tree_response
           )
           if (length(files_and_dirs_list$files) > 0) {
             all_files_and_dirs_list$files <- append(
               all_files_and_dirs_list$files,
               paste0(dir, "/", files_and_dirs_list$files)
             )
           }
           if (length(files_and_dirs_list$dirs) > 0) {
             new_dirs_list <- c(new_dirs_list, paste0(dir, "/", files_and_dirs_list$dirs))
           }
         }
         if (length(new_dirs_list) > 0) {
           dirs <- new_dirs_list
           folders_exist <- TRUE
           tier <- tier + 1
         } else {
           folders_exist <- FALSE
         }
       }
       if (!is.null(pattern)) {
         files_structure <- private$filter_files_by_pattern(
           files_structure = all_files_and_dirs_list$files,
           pattern = pattern
         )
       } else {
         files_structure <- all_files_and_dirs_list$files
       }
       return(files_structure)
     },

     get_files_and_dirs = function(files_tree_response) {
       tree_nodes <- files_tree_response$data$project$repository$tree$trees$nodes
       blob_nodes <- files_tree_response$data$project$repository$tree$blobs$nodes
       dirs <- purrr::map_vec(tree_nodes, ~ .$name) %>%
         unlist() %>%
         unname()
       files <- purrr::map_vec(blob_nodes, ~ .$name) %>%
         unlist() %>%
         unname()
       result <- list(
         "dirs" = dirs,
         "files" = files
       )
       return(result)
     }
   )
)
