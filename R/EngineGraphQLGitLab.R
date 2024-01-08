#' @noRd
#' @importFrom dplyr relocate
#'
#' @title A EngineGraphQLGitLab class
#' @description A class for methods wrapping GitLab's GraphQL API responses.
EngineGraphQLGitLab <- R6::R6Class("EngineGraphQLGitLab",
   inherit = EngineGraphQL,
   public = list(

     #' @description Create `EngineGraphQLGitLab` object.
     #' @param gql_api_url GraphQL API url.
     #' @param token A token.
     #' @param scan_all A boolean.
     initialize = function(gql_api_url,
                           token,
                           scan_all = FALSE) {
       super$initialize(gql_api_url = gql_api_url,
                        token = token,
                        scan_all = scan_all)
       self$gql_query <- GQLQueryGitLab$new()
     },

     #' @description Get all groups from GitLab.
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

     #' @description A method to retrieve all repositories for an organization in
     #'   a table format.
     #' @param org An organization.
     #' @param settings A list of  `GitStats` settings.
     #' @return A table.
     pull_repos = function(org,
                           settings) {
       org <- gsub("%2f", "/", org)
       if (settings$search_param == "org") {
         if (!private$scan_all) {
           cli::cli_alert_info("[GitLab][Engine:{cli::col_yellow('GraphQL')}][org:{org}] Pulling repositories...")
         }
         repos_table <- private$pull_repos_from_org(
           from = "org",
           org = org
         ) %>%
           private$prepare_repos_table()
       } else {
         repos_table <- NULL
       }
       return(repos_table)
     },

     #' @description An empty method to satisfy engine iterator.
     #' @param org An organization.
     #' @param settings A list of  `GitStats` settings.
     #' @return Nothing.
     pull_repos_supportive = function(org,
                                      settings) {
       NULL
     },

     #' @description Method to get commits.
     #' @details This method is empty as this class does not support pulling
     #'   commits - it is done for GitLab via REST. Still the method must
     #'   exist as it is called from the GitHost wrapper above.
     #' @param org An organization.
     #' @param date_from A starting date to look commits for.
     #' @param date_until An end date to look commits for.
     #' @param settings A list of  `GitStats` settings.
     #' @return A table of commits.
     pull_commits = function(org,
                             repos = NULL,
                             date_from,
                             date_until = Sys.date(),
                             settings) {
       NULL
     }

   ),

   private = list(

     # @description Iterator over pulling pages of repositories.
     # @param from A character specifying if organization or user.
     # @param org An organization.
     # @param user A user.
     # @return A list of repositories from organization.
     pull_repos_from_org = function(from,
                                    org = NULL,
                                    users = NULL) {
       full_repos_list <- list()
       next_page <- TRUE
       repo_cursor <- ""
       while (next_page) {
         repos_response <- private$pull_repos_page(
           from = from,
           org = org,
           users = users,
           repo_cursor = repo_cursor
         )
         if (length(repos_response$data$group) == 0) {
           cli::cli_abort("Empty")
         }
         if (from == "org") {
           core_response <- repos_response$data$group$projects
           repos_list <- core_response$edges
         }
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

     # @description Wrapper over building GraphQL query and response.
     # @param from A character specifying if organization or user
     # @param org An organization.
     # @param user A user.
     # @param repo_cursor An end cursor for repos page.
     # @return A list of repositories.
     pull_repos_page = function(from,
                                org = NULL,
                                users = NULL,
                                repo_cursor = "") {
       if (from == "org") {
         repos_query <- self$gql_query$repos_by_org(
           repo_cursor = repo_cursor
         )
         response <- self$gql_response(
           gql_query = repos_query,
           vars = list("org" = org)
         )
       }
       return(response)
     },

     # @description Parses repositories list into table.
     # @param repos_list A list of repositories.
     # @return Table of repositories.
     prepare_repos_table = function(repos_list) {
       if (length(repos_list) > 0) {
         repos_table <- purrr::map_dfr(repos_list, function(repo) {
           repo <- repo$node
           repo$default_branch <- repo$repository$rootRef
           repo$repository <- NULL
           repo$languages <- if (length(repo$languages) > 0) {
             purrr::map_chr(repo$languages, ~ .$name) %>%
               paste0(collapse = ", ")
           } else {
             ""
           }
           repo$created_at <- gts_to_posixt(repo$created_at)
           repo$issues_open <- repo$issues$opened
           repo$issues_closed <- repo$issues$closed
           repo$issues <- NULL
           repo$last_activity_at <- as.POSIXct(repo$last_activity_at)
           repo$organization <- repo$group$name
           repo$group <- NULL
           data.frame(repo)
         }) %>%
           dplyr::relocate(
             repo_url,
             .after = organization
           ) %>%
           dplyr::relocate(
             default_branch,
             .after = repo_name
           )
       } else {
         repos_table <- NULL
       }
       return(repos_table)
     },

     # @description Prepare user table.
     # @param user_response A list.
     # @return A table with information on user.
     prepare_user_table = function(user_response) {
       if (!is.null(user_response$data$user)) {
         user_data <- user_response$data$user
         user_data$name <- user_data$name %||% ""
         user_data$starred_repos <- user_data$starred_repos$count
         user_data$pull_requests <- user_data$pull_requests$count
         user_data$reviews <- user_data$reviews$count
         user_data$email <- user_data$email %||% ""
         user_data$location <- user_data$location %||% ""
         user_data$web_url <- user_data$web_url %||% ""
         user_table <- tibble::as_tibble(user_data) %>%
           dplyr::mutate(commits = NA,
                         issues = NA) %>%
           dplyr::relocate(c(commits, issues),
                           .after = starred_repos)
       } else {
         user_table <- NULL
       }
       return(user_table)
     },

     # @description Pull all given files from all repositories of a group.
     # @param org An organization.
     # @param file_path Path to a file.
     # @param pulled_repos Optional, if not empty, function will make use of the
     #   argument to iterate over it when pulling files.
     # @return A response in a list form.
     pull_file_from_org = function(org, file_path, pulled_repos = NULL) {
       org <- gsub("%2f", "/", org)
       if (!is.null(pulled_repos)) {
         repos_table <- pulled_repos %>%
           dplyr::filter(organization == org)
         full_files_list <- private$pull_file_from_repos(
           file_path = file_path,
           repos_table = repos_table
         )
       } else {
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
       }
       return(full_files_list)
     },

     # @description Pull all given files from given repositories.
     # @param file_path Path to a file.
     # @param repos_table Repositories table.
     # @return A response in a list form.
     pull_file_from_repos = function(file_path, repos_table) {
       files_list <- purrr::map(repos_table$repo_url, function(repo_url) {
         files_query <- self$gql_query$files_from_repo()
         files_response <- self$gql_response(
           gql_query = files_query,
           vars = list(
             "file_paths" = file_path,
             "project_path" = stringr::str_replace(repo_url, ".*(?<=.com/)", "")
           )
         )
         return(files_response)
       }) %>%
         purrr::discard(~ length(.$data$project$repository$blobs$nodes) == 0) %>%
         purrr::map(~ .$data$project)
       return(files_list)
     },

     # @description Prepare files table.
     # @param files_response A list.
     # @param org An organization.
     # @return A table with information on files.
     prepare_files_table = function(files_response, org, file_path) {
       if (!is.null(files_response)) {
         files_table <- purrr::map(files_response, function(project) {
           purrr::map(project$repository$blobs$nodes, function(file) {
             data.frame(
               "repo_name" = project$name,
               "repo_id" = project$id,
               "organization" = org,
               "file_path" = file$name,
               "file_content" = file$rawBlob,
               "file_size" = as.integer(file$size),
               "repo_url" = project$webUrl,
               "api_url" = self$gql_api_url
             )
           }) %>%
             purrr::list_rbind()
         }) %>%
           purrr::list_rbind()
       } else {
         files_table <- NULL
       }
       return(files_table)
     }
   )
)
