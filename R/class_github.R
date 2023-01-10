#' @export
#'
#' @importFrom R6 R6Class
#' @importFrom dplyr mutate
#' @importFrom magrittr %>%
#' @importFrom rlang %||%
#'
#' @title A GitHub API Client class
#' @description An object with methods to derive information form GitHub API.

GitHubClient <- R6::R6Class("GitHubClient",
                            inherit = GitClient,
                            cloneable = FALSE,
                            public = list(
                              owners = NULL,

                              #' @description Create a new `GitHubClient` object
                              #' @param rest_api_url A url of rest API.
                              #' @param gql_api_url A url of GraphQL API.
                              #' @param token A token.
                              #' @param owners A character vector of owners of repositories.
                              #' @return A new `GitHubClient` object
                              initialize = function(rest_api_url = NA,
                                                    gql_api_url = NA,
                                                    token = NA,
                                                    owners = NA
                              ){
                                self$rest_api_url <- rest_api_url
                                if (is.na(gql_api_url)){
                                  private$set_gql_url()
                                } else {
                                  self$gql_api_url <- gql_api_url
                                }
                                private$token <- token
                                self$owners <- owners
                              },

                              #' @description A method to list all repositories for an organization.
                              #' @param repos_owner A character vector of repository owners.
                              #' @return A data.frame of repositories
                              get_repos_by_owner = function(repos_owner = self$owners){

                                if (is.null(repos_owner)){
                                  stop("You have to define groups for your GitClient object. You can pass it to 'owners' attribute when creating new object.",
                                       call. = FALSE)
                                }

                                tryCatch({
                                  repos_dt <- purrr::map(repos_owner, function(x){

                                    perform_get_request(endpoint = paste0(self$rest_api_url, "/orgs/", x,"/repos"),
                                                                  token = private$token) %>%
                                      private$tailor_repos_info() %>%
                                      private$prepare_repos_table()
                                  }) %>%
                                    rbindlist()
                                },
                                error = function(e){

                                  warning(paste0("HTTP status ", e$status, " noted when performing request for ", self$rest_api_url,". \n Are you sure you defined properly your owners?"),
                                          call. = FALSE)

                                })

                                repos_dt
                              },

                              #' @description A method to list all repositories
                              #'   for a team.
                              #' @param team A list of team members. Specified
                              #'   by \code{set_team()} method of GitStats class
                              #'   object.
                              #' @param repos_owners
                              #' @return A data.frame of repositories
                              get_repos_by_team = function(team,
                                                           repos_owners = self$owners){

                                repos_dt <- purrr::map(repos_owners, function(x){

                                  perform_get_request(endpoint = paste0(self$rest_api_url, "/orgs/", x,"/repos"),
                                                      token = private$token) %>%
                                    private$filter_repos_by_team(team = team) %>%
                                    private$tailor_repos_info() %>%
                                    private$prepare_repos_table()
                                }) %>%
                                  rbindlist()

                                repos_dt

                              },

                              #' @description A method to find repositories with given phrase in codelines.
                              #' @param phrase A phrase to look for in codelines.
                              #' @param language A character specifying language used in repositories.
                              #' @return A data.frame of repositories.
                              get_repos_by_codephrase = function(phrase,
                                                                 language = 'R'){

                                repos_dt <- private$search_by_codephrase(phrase,
                                                                         api_url = self$rest_api_url,
                                                                         language = language) %>%
                                  purrr::map_chr(~.$repository$id) %>%
                                  unique() %>%
                                  private$find_repos_by_id() %>%
                                  private$tailor_repos_info() %>%
                                  private$prepare_repos_table()

                                message(paste0("On GitHub platform (", self$rest_api_url, ") found ", nrow(repos_dt), " repositories with searched codephrase and concerning ", language, " language."))

                                repos_dt
                              },

                              #' @description A method to get information on commits.
                              #' @param owner
                              #' @param date_from
                              #' @param date_until
                              #' @return A data.frame
                              get_commits_by_owner = function(owners = self$owners,
                                                              date_from,
                                                              date_until = Sys.time()){

                                commits_dt <- purrr::map(owners, function(x){
                                     private$get_gql_commit_query(owner = x,
                                                                  date_from,
                                                                  date_until)
                                  }) %>%
                                  private$prepare_commits_table()

                                return(commits_dt)

                              },

                              #' @description A method to get information on commits.
                              #' @param team
                              #' @param date_from
                              #' @param date_until
                              #' @return A data.frame
                              get_commits_by_team = function(team,
                                                             owners = self$owners,
                                                             date_from,
                                                             date_until = Sys.time()){

                                commits_dt <- purrr::map(owners, function(x){
                                  private$get_gql_commit_query(owner = x,
                                                               date_from = date_from,
                                                               date_until = date_until)
                                }) %>%
                                  private$filter_commits_by_team(team) %>%
                                  private$prepare_commits_table()

                                return(commits_dt)

                              },

                              #' @description A print method for a GitHubClient object
                              print = function(){
                                cat("GitHub API Client", sep = "\n")
                                cat(paste0(' url: ', self$rest_api_url), sep = "\n")
                                owners <- paste0(self$owners, collapse = ", ")
                                cat(paste0(' owners: ', owners), sep = "\n")
                              }

                            ),

                            private = list(

                              #' @description A helper to prepare table for repositories content
                              #' @param repos_list A repository list.
                              #' @return A data.frame.
                              prepare_repos_table = function(repos_list){

                                repos_dt <- purrr::map(repos_list, function(x){

                                  x$description <- x$description %||% ""

                                  data.frame(x)

                                }) %>%
                                data.table::rbindlist()

                                if (length(repos_dt) >0){
                                  repos_dt <- dplyr::mutate(repos_dt,
                                                            git_platform = "GitHub",
                                                            api_url = self$rest_api_url,
                                                            created_at = as.POSIXct(created_at),
                                                            last_activity_at = difftime(Sys.time(), as.POSIXct(last_activity_at),
                                                                                        units = "days"))
                                }

                                return(repos_dt)

                              },

                              #' @description Filter by contributors.
                              #' @param repos_list A repository list to be filtered.
                              #' @param team A character vector with team member names.
                              #' @return A list.
                              filter_repos_by_team = function(repos_list,
                                                              team){

                                purrr::map(repos_list, function(x){

                                    contributors <- tryCatch(
                                      {
                                        perform_get_request(endpoint = paste0(self$rest_api_url, "/repos/", x$full_name, "/contributors"),
                                                            token = private$token) %>% purrr::map_chr(~.$login)
                                      },
                                      error = function(e){
                                        NA
                                      })

                                    if (length(intersect(team, contributors))>0){
                                      return(x)
                                    } else {
                                      return(NULL)
                                    }

                                  })

                              },

                              #' @description Search code by phrase
                              #' @param phrase A phrase to look for in
                              #'   codelines.
                              #' @param language A character specifying language used in repositories.
                              #' @param byte_max According to GitHub
                              #'   documentation only files smaller than 384 KB
                              #'   are searchable. See
                              #'   \link{https://docs.github.com/en/rest/search?apiVersion=2022-11-28#search-code}
                              #'
                              #' @return A list as a formatted content of a
                              #'   reponse.
                              search_by_codephrase = function(phrase,
                                                              language,
                                                              byte_max = "384000",
                                                              api_url = self$rest_api_url,
                                                              token = private$token
                              ){

                                search_endpoint <- paste0(api_url, "/search/code?q='", phrase,"'+language:", language)
                                # byte_max <- as.character(byte_max)

                                total_n <- perform_get_request(search_endpoint,
                                                               token = token)[["total_count"]]

                                repos_list <- search_request(search_endpoint, total_n, byte_max, token)

                                return(repos_list)
                              },

                              #' @description Perform get request to find repositories by ids
                              #' @param repos_ids A character vector of repositories' ids.
                              #' @return A list of repos.
                              find_repos_by_id = function(repos_ids,
                                                          api_url = self$rest_api_url,
                                                          token = private$token){

                                repos_list <- purrr::map(repos_ids, function(x){

                                  content <- perform_get_request(paste0(api_url, "/repositories/", x,""),
                                                                 token)

                                })

                                repos_list
                              },

                              #' @description A helper to retrieve only important info on repos
                              #' @param repos_list A list, a formatted content of response returned by GET API request
                              #' @return A list of repos with selected information
                              tailor_repos_info = function(repos_list){

                                repos_list <- purrr::map(repos_list, function(x){

                                  list(
                                    "owner/group" = x$owner$login,
                                    "name" = x$name,
                                    "created_at" = x$created_at,
                                    "last_activity_at" = x$updated_at,
                                    "description" = x$description
                                  )

                                })

                                repos_list

                              },

                              #' @description Format list to table
                              #' @param commits_list
                              #' @param subject_type A character, a subject of search query: owner or user
                              #' @return A data.frame
                              prepare_commits_table = function(commits_list){

                                purrr::map(commits_list, function(x){

                                  purrr::imap(x, function(y, z){
                                    y$owner_group <- gsub(paste0("/", z), "", y$repository$nameWithOwner)
                                    y$repo_project <- z
                                    y$repository <- NULL
                                    y
                                  }) %>% data.table::rbindlist()

                                }) %>% data.table::rbindlist()

                              },

                              #' @description Method to filter list from GraphQL query
                              #' @param commits_list
                              #' @param team
                              #' @return A list, filtered by team members.
                              filter_commits_by_team = function(commits_list,
                                                                team){

                                commits_list <- purrr::map(commits_list, function(x){

                                  x <- purrr::map(x, function(y){

                                    y$users <- purrr::map(y$authors$edges, function(edge){
                                          tryCatch({
                                            paste0(edge$node$user$login, collapse = ",")
                                          },
                                          error = function(e){
                                            "no login"
                                          })
                                        })
                                    y$authors <- NULL

                                    y
                                      }) %>%
                                    purrr::map(function(y){

                                      author_in_team <- purrr::keep(y$users, function(user){
                                        any(unlist(strsplit(user, ",")) %in% team)
                                      })
                                      if (length(author_in_team) > 0){
                                        y$users <- NULL
                                        y
                                      } else {
                                        NULL
                                      }

                                    }) %>% purrr::discard(~is.null(.))

                                })

                                commits_list

                              },

                              #' @description Get response from GraphQL request and format it.
                              #' @param owner
                              #' @param date_from
                              #' @param date_until
                              #' @return A list of commits
                              get_gql_commit_query = function(owner,
                                                              date_from,
                                                              date_until){

                                commits_main_list <- list()

                                resp <- private$perform_gql_commit_query(owner,
                                                                         date_from,
                                                                         date_until)

                                repo_count <- resp$data$search$repositoryCount

                                message("Github (", owner, "): pulling commits from ", repo_count, " repositories.")

                                repo_names <- unlist(resp$data$search$nodes$name)

                                commits_list <- resp$data$search$nodes$defaultBranchRef$target$history$nodes
                                names(commits_list) <- repo_names
                                commits_main_list <- append(commits_main_list, commits_list)

                                has_next_page <- resp$data$search$pageInfo$hasNextPage
                                end_cursor <- resp$data$search$pageInfo$endCursor

                                while (has_next_page){

                                  resp <- private$perform_gql_commit_query(owner,
                                                                           date_from,
                                                                           date_until,
                                                                           end_cursor)

                                  repo_names <- unlist(resp$data$search$nodes$name)

                                  commits_list <- resp$data$search$nodes$defaultBranchRef$target$history$nodes
                                  names(commits_list) <- repo_names
                                  commits_main_list <- append(commits_main_list, commits_list)

                                  has_next_page <- resp$data$search$pageInfo$hasNextPage
                                  end_cursor <- resp$data$search$pageInfo$endCursor
                                }

                                commits_main_list <- purrr::discard(commits_main_list, ~length(.) == 0)

                                commits_main_list

                              },

                              #' @description
                              #' @param owner
                              #' @param date_from
                              #' @param date_until
                              #' @param end_cursor
                              perform_gql_commit_query = function(owner,
                                                                  date_from,
                                                                  date_until,
                                                                  end_cursor = ''){

                                query <- private$build_gql_commit_query(owner,
                                                                        date_from,
                                                                        date_until,
                                                                        end_cursor = end_cursor)

                                tryCatch({
                                  resp <- get_resp_gql(api_url = self$gql_api_url,
                                                       token = private$token,
                                                       query = query)
                                },
                                error = function(e){
                                  message(e$message)
                                  secs <- 7
                                  pb <- progress::progress_bar$new(
                                    format = "Retry in :elapsed",
                                    total = secs)
                                  for (i in 1:secs) {
                                    pb$tick()
                                    Sys.sleep(1)
                                  }
                                  resp <<- get_resp_gql(api_url = self$gql_api_url,
                                                        token = private$token,
                                                        query = query)
                                })

                                resp

                              },

                              #' @description
                              #' @param owner
                              #' @param date_from
                              #' @param date_until
                              #' @param after cursor value
                              #' @return A character
                              build_gql_commit_query = function(owner,
                                                                date_from,
                                                                date_until,
                                                                end_cursor){

                                if (nchar(end_cursor) == 0){
                                  after <- ''
                                } else {
                                  after <- paste0(', after:"', end_cursor,'"')
                                }

                                search_verb <- paste0("org:", owner)

                                query <- paste0('{search(query: "', search_verb, '", type: REPOSITORY, first: 100', after, '){
                                            repositoryCount
                                            nodes {
                                              ... on Repository {
                                                name
                                                defaultBranchRef {
                                                  target {
                                                    ... on Commit {
                                                     history(first: 100, since: "', git_time_stamp(date_from), '", until: "', git_time_stamp(date_until), '"){
                                                      nodes {
                                                        id
                                                        additions
                                                        deletions
                                                        committedDate
                                                        authors(first: 10) {
                                                          edges {
                                                            node {
                                                              user {
                                                                login
                                                              }
                                                              name
                                                            }
                                                          }
                                                        }
                                                        repository{
                                                          nameWithOwner
                                                        }
                                                      }
                                                     }
                                                    }
                                                  }
                                                }
                                              }
                                            }
                                            pageInfo {
                                              endCursor
                                              hasNextPage
                                            }
                                          }
                                               }')

                                query
                              },

                              #' #' @description
                              #' #' @param repo
                              #' find_owner_by_repo = function(repo){
                              #'
                              #'   list_repos <- purrr::map(self$owners, ~self$get_repos_by_owner(.)$name)
                              #'   names(list_repos) <- self$owners
                              #'   owner <- which(purrr::map_lgl(list_repos, ~repo %in% .))
                              #'
                              #'   if (length(owner)>0){
                              #'     names(owner)
                              #'   } else {
                              #'     "no owner found"
                              #'   }
                              #'
                              #' },

                              #' @description GraphQL url handler (if not provided)
                              set_gql_url = function(gql_api_url = self$gql_api_url,
                                                   rest_api_url = self$rest_api_url){

                                self$gql_api_url <- paste0(gsub("/v+.*","", rest_api_url), "/graphql")

                              }
                            )
)
