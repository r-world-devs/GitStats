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
         repos_response <- private$pull_repos_page(
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
     get_files_from_org = function(org, repos, file_path_vec, host_files_structure, verbose = FALSE) {
       org <- URLdecode(org)
       full_files_list <- list()
       next_page <- TRUE
       end_cursor <- ""
       if (!is.null(host_files_structure)) {
         file_path_vec <- private$get_path_from_files_structure(
           host_files_structure = host_files_structure,
           org = org
         )
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
               "file_paths" = file_path_vec
             )
           )
         },
         error = function(e) {
           list()
         })
         if (length(files_response$data$group) == 0) {
           cli::cli_alert_danger("Empty")
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
     pull_release_logs_from_org = function(repos_names, org) {
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

     # Wrapper over building GraphQL query and response.
     pull_repos_page = function(org = NULL,
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

     get_file_response = function(org, repo, file_path, files_query) {
       files_response <- self$gql_response(
         gql_query = files_query,
         vars = list(
           "fullPath" = paste0(org, "/", repo),
           "file_path" = file_path
         )
       )
       return(files_response)
     },

     get_path_from_files_structure = function(host_files_structure, org) {
       host_files_structure[[org]] %>% unlist() %>% unique()
     },

     get_files_structure_from_repo = function(org, repo, pattern = NULL, depth = Inf) {
       files_tree_response <- private$get_file_response(
         org = org,
         repo = repo,
         file_path = "",
         files_query = self$gql_query$files_tree_from_repo()
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
           files_tree_response <- private$get_file_response(
             org = org,
             repo = repo,
             file_path = dir,
             files_query = self$gql_query$files_tree_from_repo()
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
