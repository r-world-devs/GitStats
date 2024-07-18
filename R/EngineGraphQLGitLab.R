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
     pull_repos_from_org = function(org = NULL) {
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
     pull_files_from_org = function(org, repos, file_path) {
       org <- URLdecode(org)
       full_files_list <- list()
       next_page <- TRUE
       end_cursor <- ""
       while (next_page) {
         files_query <- self$gql_query$files_by_org(
           end_cursor = end_cursor
         )
         files_response <- self$gql_response(
           gql_query = files_query,
           vars = list(
             "org" = org,
             "file_paths" = file_path
           )
         )
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
     }
   )
)
