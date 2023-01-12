#' @export
#'
#' @importFrom R6 R6Class
#' @importFrom data.table rbindlist
#' @importFrom plotly plot_ly
#'
#' @title A statistics platform for Git clients
#' @description An R6 class object with methods to derive information from multiple Git platforms.
#'
GitStats <- R6::R6Class("GitStats",
                        public = list(
                          clients = list(),

                          #' @description Create a new `GitStats` object
                          #' @return A new `GitStats` object
                          initialize = function(){

                          },

                          teams = NULL,

                          repos_dt = NULL,

                          commits_dt = NULL,

                          #' @description A method to list all repositories for an organization.
                          #' @return A data.frame of repositories
                          get_repos_by_owner_or_group = function(){

                            repos_dt <- purrr::map(self$clients, function(x){

                              if ("GitHubClient" %in% class(x)){
                                x$get_repos_by_owner()
                              } else if ("GitLabClient" %in% class(x)){
                                x$get_projects_by_group()
                              }


                              }) %>%
                              rbindlist() %>%
                              dplyr::arrange(last_activity_at)

                            self$repos_dt <- repos_dt

                            print(repos_dt)

                            invisible(self)

                          },

                          #' @description A method to list all repositories
                          #'   for a team.
                          #' @param team_name A name of a team
                          #' @return A data.frame of repositories
                          get_repos_by_team = function(team_name){

                            if (is.null(self$teams)){
                              stop("You have to specify a team first with 'set_team()' method.", call. = FALSE)
                            }

                            team <- self$teams[[team_name]]

                            repos_dt <- purrr::map(self$clients, ~.$get_repos_by_team(team)) %>%
                              rbindlist() %>%
                              dplyr::arrange(last_activity_at)

                            self$repos_dt <- repos_dt

                            print(repos_dt)

                            invisible(self)

                          },

                          #' @description A method to find repositories with given phrase in codelines.
                          #' @param phrase A phrase to look for in codelines.
                          #' @param language A character specifying language used in repositories.
                          #' @return A data.frame of repositories
                          get_repos_by_codephrase = function(phrase,
                                                             language = 'R'){

                            repos_dt <- purrr::map(self$clients, ~.$get_repos_by_codephrase(phrase, language)) %>%
                              rbindlist() %>%
                              dplyr::arrange(last_activity_at)

                            self$repos_dt <- repos_dt

                            print(repos_dt)

                            invisible(self)

                          },

                          #' @description A method to get information on commits.
                          #' @param date_from
                          #' @param date_until
                          #' @param by
                          #' @return A data.frame
                          get_commits_by_owner_or_group = function(date_from,
                                                                   date_until = Sys.time()){

                            commits_dt <- purrr::map(self$clients, function(x) {

                                if ("GitHubClient" %in% class(x)){
                                  x$get_commits_by_owner(date_from = date_from,
                                                         date_until = date_until,
                                                         by = by)
                                } else if ("GitLabClient" %in% class(x)){
                                  x$get_commits_by_group(date_from = date_from,
                                                         date_until = date_until,
                                                         by = by)
                                }

                              }) %>%
                              rbindlist(use.names=TRUE)

                            commits_dt$committedDate <- as.Date(commits_dt$committedDate)

                            self$commits_dt <- commits_dt

                            print(commits_dt)

                            invisible(self)

                          },

                          #' @description A method to get information on commits.
                          #' @param team_name
                          #' @param date_from
                          #' @param date_until
                          get_commits_by_team = function(team_name,
                                                         date_from,
                                                         date_until = Sys.time()){

                            if (is.null(self$teams)){
                              stop("You have to specify a team first with 'set_team()' method.", call. = FALSE)
                            }

                            team <- self$teams[[team_name]]

                            commits_dt <- purrr::map(self$clients, function(x) {

                                commits <- x$get_commits_by_team(team,
                                                                 x$owners,
                                                                 date_from,
                                                                 date_until)

                                message(self$clients$rest_api_url, " (", team_name, " team): pulled commits from ", length(unique(commits$repo_project)), " repositories.")

                                commits
                                                     }) %>% rbindlist(use.names = TRUE)

                            commits_dt$committedDate <- as.Date(commits_dt$committedDate)

                            self$commits_dt <- commits_dt

                            print(commits_dt)

                            invisible(self)

                          },

                          #' @description Method to set connections to Git platforms
                          #' @param api_url A character, url address of API.
                          #' @param token A token.
                          #' @param owner_group A character vector.
                          #' @return Nothing, puts connection information into `$clients` slot
                          set_connection = function(api_url,
                                                    token,
                                                    owners_groups = NULL){

                            if (is.null(owners_groups)){
                              stop("You need to specify owner/owners of the repositories.", call. = FALSE)
                            }

                            if (api_url == "https://api.github.com"){
                              message("Set connection to GitHub public.")
                              self$clients <- GitHubClient$new(rest_api_url = api_url,
                                                               token = token,
                                                               owners = owners_groups) %>%
                                append(self$clients, .)
                            } else if (api_url != "https://api.github.com" && grepl("github", api_url)){
                              message("Set connection to GitHub Enterprise.")
                              self$clients <- GitHubEnterpriseClient$new(rest_api_url = api_url,
                                                                         token = token,
                                                                         owners = owners_groups) %>%
                                append(self$clients, .)
                            } else if (grepl("https://", api_url) && grepl("gitlab|code", api_url)){
                              message("Set connection to GitLab.")
                              self$clients <- GitLabClient$new(rest_api_url = api_url,
                                                               token = token,
                                                               groups = owners_groups) %>%
                                append(self$clients, .)
                            } else {
                              stop("This connection is not supported by GitStats class object.")
                            }

                            private$check_input(self$clients)

                          },

                          #' @description A method to set your team.
                          #' @param team_name A name of a team.
                          #' @return Nothing, puts team information into `$teams` slot.
                          set_team = function(team_name, ...){

                            self$teams <- list()

                            self$teams[[paste(team_name)]] <- unlist(list(...))

                          },

                          #' @description A method to plot repositories outcome.
                          #' @param repos_dt An output of one of `get_repos` methods.
                          #' @param repos_n An integer, a number of repos to show on the plot.
                          #' @return A plot.
                          plot_repos = function(repos_dt = self$repos_dt,
                                                repos_n = 10){

                            if (is.null(self$repos_dt)){
                              stop("You have to first construct your repos data.frame with one of 'get_repos' methods.",
                                   call. = FALSE)
                            }

                            repos_dt <- head(repos_dt, repos_n)
                            # repos_dt$last_activity_at <- -repos_dt$last_activity_at
                            repos_dt$name <- factor(repos_dt$name, levels = unique(repos_dt$name)[order(repos_dt$last_activity_at, decreasing = TRUE)])

                            plotly::plot_ly(repos_dt,
                                            y = ~name,
                                            x = ~last_activity_at,
                                            color = ~owner.group,
                                            type = 'bar',
                                            orientation = 'h') %>%
                              plotly::layout(yaxis = list(title = ""),
                                             xaxis = list(title = "last activity - days ago"))

                          },

                          #' @importFrom data.table :=
                          #' @description A method to plot basic commit stats
                          #' @return A plot.
                          plot_commits = function(commits_dt = self$commits_dt,
                                                  stats_by = c("day", "week", "month")){

                            if (is.null(self$commits_dt)){
                              stop("You have to first construct your repos data.frame with one of 'get_commits' methods.",
                                   call. = FALSE)
                            }

                            stats_by <- match.arg(stats_by)

                            if (stats_by == "day"){
                              commits_dt[, statsDate :=  committedDate]
                            } else if (stats_by == "week"){
                              commits_dt[, statsDate :=  paste(format(committedDate, "%-V"), format(committedDate, "%G"), sep = "-")]
                            } else if (stats_by == "month"){
                              commits_dt[, statsDate :=  as.Date(paste0(substring(committedDate, 1, 7), "-01"))]
                            }

                            commits_n = commits_dt[, .(commits_n = .N), by = .(statsDate, owner_group)]
                            commits_n = commits_n[order(statsDate)]

                            plotly::plot_ly(commits_n,
                                            x = ~statsDate,
                                            y = ~commits_n,
                                            color = ~owner_group,
                                            type = "scatter",
                                            mode = "lines+markers")

                          },

                          #' @description A method to plot commit additions and deletions.
                          #' @param commits_dt An output of one of `get_commits` methods.
                          #' @return A plot.
                          plot_commit_lines = function(commits_dt = self$commits_dt){

                            if (is.null(self$commits_dt)){
                              stop("You have to first construct your repos data.frame with one of 'get_commits' methods.",
                                   call. = FALSE)
                            }

                            commits_dt[, deletions:= -deletions]

                            plotly::plot_ly(commits_dt) %>%
                              plotly::add_trace(y = ~additions,
                                                x = ~committedDate,
                                                color = ~owner_group,
                                                type = 'bar') %>%
                              plotly::add_trace(y = ~deletions,
                                                x = ~committedDate,
                                                color = ~owner_group,
                                                type = 'bar') %>%
                              plotly::layout(yaxis = list(title = ""),
                                             xaxis = list(title = ""))

                          },

                          #' @description A print method for a GitStats object
                          print = function(){
                            cat(paste0("A GitStats object (multi-API client platform) for ", length(self$clients), " clients:"), sep = "\n")
                            purrr::walk(self$clients, ~.$print())
                          }

                        ),

                        private = list(

                          #' @description Check if input is correct: does it
                          #'   comprise of GitHubClient or GitLabClient classes
                          #'   and whether the urls do not repeat.
                          #' @param clients A list of clients of GitStats object.
                          #' @return Nothing
                          check_input = function(clients = self$clients){

                            urls <- purrr::map_chr(clients, ~.$rest_api_url)

                            if (length(urls) != length(unique(urls))){
                              stop("You can not provide two clients of the same API urls.")
                            }

                          }

                        )

)
