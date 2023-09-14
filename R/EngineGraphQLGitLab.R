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
         if (from == "org") {
           core_response <- repos_response$data$group$projects
           repos_list <- core_response$edges
         }
         next_page <- core_response$pageInfo$hasNextPage
         if (is.null(next_page)) next_page <- FALSE
         if (is.null(repos_list)) repos_list <- list()
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
       repos_table <- purrr::map_dfr(repos_list, function(repo) {
         repo <- repo$node
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
         repo$last_activity_at <- difftime(Sys.time(), as.POSIXct(repo$last_activity_at),
                                           units = "days"
         ) %>% round(2)
         repo$organization <- repo$group$name
         repo$group <- NULL
         data.frame(repo)
       })
       repos_table <- dplyr::mutate(
         repos_table,
         api_url = paste0(gsub("/graphql", "", self$gql_api_url), "/projects/", gsub("gid://gitlab/Project/", "", id))
       ) %>%
         dplyr::relocate(
           repo_url,
           .before = api_url
         )
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
     }
   )
)
