#' @export
#'
#' @importFrom R6 R6Class
#' @importFrom magrittr %>%
#'
#' @title A GitHub Enterprise API Client class
#' @description An object with methods to derive information form GitHub Enterprise API.

GitHubEnterpriseClient <- R6::R6Class("GitHubEnterpriseClient",
                                      inherit = GitHubClient,

                                      public = list(

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
                                            private$get_all_commits_from_owner(x,
                                                                               date_from,
                                                                               date_until) %>%
                                              private$filter_commits_by_team(team) %>%
                                              private$tailor_commits_info(repos_owner = x) %>%
                                              private$attach_commits_stats() %>%
                                              private$prepare_commits_table()
                                          }) %>% rbindlist()

                                          return(commits_dt)

                                        }

                                      ),

                                      private = list(

                                        #' @description GitLab private method to derive
                                        #'   commits from repo with REST API.
                                        #' @param repo_owner
                                        #' @param date_from
                                        #' @param date_until
                                        #' @return A list of commits
                                        get_all_commits_from_owner= function(repo_owner,
                                                                             date_from,
                                                                             date_until = Sys.date()){

                                          # total_n <- perform_get_request(endpoint = paste0(self$rest_api_url, "/search/repositories?q='org:", repo_owner, "'"),
                                          #                                token = private$token)[["total_count"]]
                                          repos_list <- list()
                                          r_page <- 1
                                          repeat {
                                            repos_page <- perform_get_request(endpoint = paste0(self$rest_api_url, "/orgs/", repo_owner, "/repos?per_page=100&page=", r_page),
                                                                              token = private$token)
                                            if (length(repos_page) > 0){
                                              repos_list <- append(repos_list, repos_page)
                                              r_page <- r_page + 1
                                            } else {
                                              break
                                            }

                                          }

                                          repos_names <- purrr::map_chr(repos_list, ~.$full_name)

                                          pb <- progress::progress_bar$new(
                                            format = paste0("GitHub Enterprise Client (", repo_owner, "). Checking for commits since ", date_from, " in ", length(repos_names), " repos. [:bar] repo: :current/:total"),
                                            total = length(repos_names)
                                          )

                                          commits_list <- purrr::map(repos_names, function(x) {
                                            pb$tick()
                                              tryCatch({
                                                perform_get_request(endpoint = paste0(self$rest_api_url,
                                                                                      "/repos/",
                                                                                      x,
                                                                                      "/commits?since=",
                                                                                      git_time_stamp(date_from),
                                                                                      "&until=",
                                                                                      git_time_stamp(date_until)),
                                                                    token = private$token)
                                              },
                                              error = function(e){
                                                NULL
                                              })

                                          })
                                          names(commits_list) <- repos_names

                                          commits_list <- commits_list %>% purrr::discard(~length(.)==0)

                                          message("GitHub (Enterprise) (", repo_owner, "): pulled commits from ", length(commits_list), " repositories.")

                                          commits_list

                                        },

                                        #' @description Filter by contributors.
                                        #' @param commits_list A commits list to be filtered.
                                        #' @param team A character vector with team member names.
                                        filter_commits_by_team = function(commits_list,
                                                                          team){

                                          commits_list <- purrr::map(commits_list, function(repo){

                                              purrr::keep(repo, function(commit){

                                                if (length(commit$author$login>0)){
                                                  commit$author$login %in% team
                                                } else {
                                                  FALSE
                                                }

                                              })

                                            }) %>% purrr::discard(~length(.) == 0)

                                          commits_list

                                        },

                                        #' @description A helper to retrieve
                                        #'   only important info on commits
                                        #' @details In case of GitHub REST API
                                        #'   there is no possibility to retrieve
                                        #'   stats from basic get commits API
                                        #'   endpoint. It is necessary to reach
                                        #'   to the API endpoint of single
                                        #'   commit, which is done in
                                        #'   \code{attach_commit_stats()}
                                        #'   method. Therefore
                                        #'   \code{tailor_commits_info()} is
                                        #'   'poorer" than the same method for
                                        #'   GitLab Client class, where you can
                                        #'   derive stats directly from commits
                                        #'   API endpoint with \code{with_stats}
                                        #'   attribute.
                                        #' @param commits_list A list, a
                                        #'   formatted content of response
                                        #'   returned by GET API request
                                        #' @param repos_owner A character, name
                                        #'   of an owner
                                        #' @return A list of commits with
                                        #'   selected information
                                        tailor_commits_info = function(commits_list,
                                                                       repos_owner){

                                          commits_list <- purrr::imap(commits_list, function(repo, repo_name){

                                                purrr::map(repo, function(commit){

                                                  list(
                                                    "id" = commit$sha,
                                                    "owner_group" = repos_owner,
                                                    "repo_project" = gsub(pattern = paste0(repos_owner, "/"),
                                                                          replacement = "",
                                                                          x = repo_name),
                                                    # "additions" = commit$stats$additions,
                                                    # "deletions" = commit$stats$deletions,
                                                    # "commiterName" = commit$committer_name,
                                                    "committedDate" = commit$commit$committer$date
                                                  )

                                                })

                                          })

                                          commits_list

                                        },

                                        #' @description
                                        #' @param commits_list
                                        attach_commits_stats = function(commits_list){

                                          purrr::imap(commits_list, function(repo, repo_name){

                                            commit_stats <- purrr::map_chr(repo, ~.$id) %>%
                                              purrr::map(function(commit_id){

                                                commit_info <- perform_get_request(endpoint = paste0(self$rest_api_url, "/repos/", repo_name, "/commits/", commit_id),
                                                                                   token = private$token)

                                                list(additions = commit_info$stats$additions,
                                                     deletions = commit_info$stats$deletions,
                                                     files_changes = length(commit_info$files),
                                                     files_added = length(grep("added", purrr::map_chr(commit_info$files, ~.$status))),
                                                     files_modified = length(grep("modified", purrr::map_chr(commit_info$files, ~.$status))))

                                              })

                                            purrr::map2(repo, commit_stats, function(repo_commit, repo_stats){

                                              purrr::list_modify(repo_commit,
                                                                 additions = repo_stats$additions,
                                                                 deletions = repo_stats$deletions)

                                            })


                                          })

                                        },

                                        #' @description
                                        #' @param commits_list
                                        #' @return A data.frame
                                        prepare_commits_table = function(commits_list){

                                          purrr::map(commits_list, function(x){
                                            purrr::map(x, ~data.frame(.)) %>%
                                              rbindlist()
                                          }) %>% rbindlist()

                                        }

                                      ))
