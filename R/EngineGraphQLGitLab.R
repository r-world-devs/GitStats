EngineGraphQLGitLab <- R6::R6Class(
  classname = "EngineGraphQLGitLab",
  inherit = EngineGraphQL,
  public = list(
    initialize = function(gql_api_url,
                          token,
                          scan_all = FALSE) {
      super$initialize(
        gql_api_url = gql_api_url,
        token = token,
        scan_all = scan_all
      )
      self$gql_query <- GQLQueryGitLab$new()
    },

    set_owner_type = function(owners, verbose = TRUE) {
      user_or_org_query <- self$gql_query$user_or_org_query
      login_types <- purrr::map(owners, function(owner) {
        cached <- private[["owner_types_cache"]][[owner]]
        if (!is.null(cached)) {
          return(cached)
        }
        response <- self$gql_response(
          gql_query = user_or_org_query,
          vars = list(
            "username" = owner,
            "grouppath" = owner
          ),
          verbose = verbose
        )
        if (!all(purrr::map_lgl(response$data, is.null))) {
          type <- purrr::discard(response$data, is.null) |>
            names()
          if (type == "group") {
            type <- "organization"
          }
          attr(owner, "type") <- type
        } else {
          attr(owner, "type") <- "not found"
        }
        private[["owner_types_cache"]][[owner]] <- owner
        return(owner)
      })
      return(login_types)
    },

    get_orgs = function(orgs_count,
                        output = c("only_names", "full_table"),
                        verbose,
                        progress = verbose) {
      if (verbose) {
        cli::cli_alert("[Host:GitLab][Engine:{cli::col_yellow('GraphQL')}] Pulling organizations {cli_icons$org}...")
      }
      group_cursor <- ""
      iterations_number <- round(orgs_count / 100)
      full_orgs_list <- list()
      for (x in 1:iterations_number) {
        response <- self$gql_response(
          gql_query = self$gql_query$groups(),
          vars = list("groupCursor" = group_cursor),
          verbose = verbose
        )
        if (!inherits(response, "graphql_error")) {
          if (output == "only_names") {
            orgs_list <- purrr::map(response$data$groups$edges, ~ .$node$fullPath)
          } else {
            orgs_list <- purrr::map(response$data$groups$edges, ~ .$node)
          }
          group_cursor <- response$data$groups$pageInfo$endCursor
          full_orgs_list <- append(full_orgs_list, orgs_list)
        } else {
          full_orgs_list <- response
          break
        }
      }
      full_orgs_list <- private$handle_graphql_error(full_orgs_list, verbose)
      if (!inherits(full_orgs_list, "graphql_error")) {
        if (output == "only_names") {
          all_orgs <- unlist(full_orgs_list)
        } else if (output == "full_table") {
          all_orgs <- full_orgs_list
        }
      } else {
        all_orgs <- full_orgs_list
      }
      return(all_orgs)
    },

    get_org = function(org, verbose) {
      if (verbose) {
        cli::cli_alert("[Host:GitLab][Engine:{cli::col_yellow('GraphQL')}] Pulling {org} organization {cli_icons$org}...")
      }
      response <- self$gql_response(
        gql_query = self$gql_query$group(),
        vars = list("org" = org),
        verbose = verbose
      )
      if (length(response$data$group) == 0) {
        class(response) <- c(class(response), "graphql_error")
        return(response)
      } else {
        return(response$data$group)
      }
    },

    prepare_orgs_table = function(full_orgs_list) {
      orgs_table <- purrr::map(full_orgs_list, function(org_node) {
        org_node$avatarUrl <- org_node$avatarUrl %||% ""
        data.frame(org_node)
      }) |>
        purrr::list_rbind() |>
        dplyr::rename(path = fullPath,
                      url = webUrl,
                      repos_count = projectsCount,
                      members_count = groupMembersCount,
                      avatar_url = avatarUrl) |>
        dplyr::relocate(avatar_url, .before = repos_count) |>
        tibble::as_tibble()
      return(orgs_table)
    },

    get_repos = function(repos_ids, verbose) {
      full_repos_list <- list()
      next_page <- TRUE
      repo_cursor <- ""
      while (next_page) {
        repos_response <- private$get_repos_page(
          projects_ids = paste0("gid://gitlab/Project/", repos_ids),
          type = "projects",
          repo_cursor = repo_cursor,
          verbose = verbose
        )
        if (inherits(repos_response, "graphql_error")) {
          if (inherits(repos_response, "graphql_no_fields_error")) {
            full_repos_list <- repos_response
            break
          }
          repos_response <- private$get_repos_page(
            projects_ids = paste0("gid://gitlab/Project/", repos_ids),
            type = "projects",
            repo_cursor = repo_cursor,
            verbose = verbose
          )
        }
        core_response <- repos_response$data$projects
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
      full_repos_list <- private$handle_graphql_error(full_repos_list, verbose)
      return(full_repos_list)
    },

    get_repos_from_org = function(org  = NULL,
                                  owner_type = c("organization", "user"),
                                  verbose = TRUE) {
      full_repos_list <- list()
      next_page <- TRUE
      repo_cursor <- ""
      while (next_page) {
        repos_response <- private$get_repos_page(
          org = org,
          type = owner_type,
          repo_cursor = repo_cursor,
          verbose = verbose
        )
        if (inherits(repos_response, "graphql_error")) {
          full_repos_list <- repos_response
          break
        } else {
          core_response <- if (owner_type == "organization") {
            repos_response$data$group$projects
          } else {
            repos_response$data$projects
          }
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
      }
      full_repos_list <- private$handle_graphql_error(full_repos_list, verbose)
      return(full_repos_list)
    },

    prepare_repos_table = function(repos_list, org) {
      if (length(repos_list) > 0) {
        repos_table <- purrr::map(repos_list, function(repo) {
          repo <- repo$node
          languages <- if (length(repo$languages) > 0) {
            purrr::map_chr(repo$languages, ~ .$name) |>
              paste0(collapse = ", ")
          } else {
            ""
          }
          if (!is.null(repo$namespace)) {
            org <- repo$namespace$path
          }
          if (is.null(org)) {
            org <- sub(paste0("/", repo$repo_path), "", repo$repo_url) |>
              stringr::str_replace_all("^https://[^/]+", "") |>
              stringr::str_replace_all("^/", "")
          }
          data.frame(
            repo_id = get_gitlab_repo_id(repo$repo_id),
            repo_name = repo$repo_path,
            repo_fullpath = repo$repo_fullpath,
            default_branch = repo$repository$rootRef %||% "",
            stars = repo$stars,
            forks = repo$forks,
            created_at = gts_to_posixt(repo$created_at),
            last_activity_at = as.POSIXct(repo$last_activity_at),
            languages = languages,
            issues_open = repo$issues$opened %||% 0,
            issues_closed = repo$issues$closed %||% 0,
            organization = org,
            repo_url = repo$repo_url,
            commit_sha = repo$repository$lastCommit$sha %||% NA_character_
          )
        }) |>
          purrr::list_rbind()
      } else {
        repos_table <- NULL
      }
      return(repos_table)
    },

    get_files_from_org = function(org,
                                  owner_type,
                                  repos_data,
                                  file_paths = NULL,
                                  host_files_structure = NULL,
                                  verbose = FALSE) {
      org <- url_decode(org)
      full_files_list <- list()
      next_page <- TRUE
      end_cursor <- ""
      if (!is.null(host_files_structure)) {
        file_paths <- private$get_path_from_files_structure(
          host_files_structure = host_files_structure,
          org = org
        )
      } else {
        file_paths <- file_paths[grepl(text_files_pattern, file_paths)]
      }
      if (owner_type == "organization") {
        while (next_page) {
          files_query <- self$gql_query$files_by_org(
            end_cursor = end_cursor
          )
          files_response <- self$gql_response(
            gql_query = files_query,
            vars = list(
              "org" = org,
              "file_paths" = file_paths
            ),
            verbose = verbose
          )
          if (inherits(files_response, "graphql_error")) {
            files_response <- list()
          }
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
                owner_type = owner_type,
                repos_data = repos_data,
                file_paths = file_paths,
                host_files_structure = host_files_structure,
                verbose = verbose
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
          }) |>
            purrr::discard(~ length(.$repository$blobs$nodes) == 0)
          if (is.null(files_list)) files_list <- list()
          if (length(files_list) > 0) {
            next_page <- projects$pageInfo$hasNextPage
          } else {
            next_page <- FALSE
          }
          if (is.null(next_page)) next_page <- FALSE
          if (next_page) {
            end_cursor <- projects$pageInfo$endCursor
          } else {
            end_cursor <- ""
          }
          full_files_list <- append(full_files_list, files_list)
        }
        if (!is.null(repos_data)) {
          full_files_list <- purrr::keep(full_files_list, function(project) {
            repo_name <- private$get_repo_name_from_url(project$webUrl)
            repo_name %in% repos_data$paths
          })
        }
      } else {
        full_files_list <- self$get_files_from_org_per_repo(
          org = org,
          owner_type = owner_type,
          repos_data = repos_data,
          file_paths = file_paths,
          host_files_structure = host_files_structure,
          verbose = verbose
        )
      }
      return(full_files_list)
    },

    get_files_from_org_per_repo = function(org,
                                           owner_type,
                                           repos_data,
                                           file_paths = NULL,
                                           host_files_structure = NULL,
                                           verbose = FALSE) {
      org_files_list <- gitstats_map(repos_data$paths, function(repo) {
        if (!is.null(host_files_structure)) {
          file_paths <- private$get_path_from_files_structure(
            host_files_structure = host_files_structure,
            org = org,
            repo = repo
          )
        }
        files_response <- private$get_file_blobs_response(
          org = org,
          repo = repo,
          file_paths = file_paths,
          verbose = verbose
        )
        if (private$is_complexity_error(files_response)) {
          if (verbose) {
            cli::cli_alert_warning("[{repo}] Encountered query complexity error. Too many files ({length(file_paths)})).")
            cli::cli_alert_info("I will run queries per 1 file.")
          }
          files_response <- private$get_file_blobs_response(
            org = org,
            repo = repo,
            file_paths = file_paths[1],
            verbose = verbose
          )
          nodes <- purrr::map(seq_along(file_paths), function(i) {
            files_part_response <- private$get_file_blobs_response(
              org = org,
              repo = repo,
              file_paths = file_paths[i],
              verbose = verbose
            )
            return(files_part_response$data$project$repository$blobs$nodes)
          }) |>
            purrr::list_flatten()
          files_response <- list(
            "data" = list(
              "project" = list(
                "name" = repo,
                "id" = files_response$data$project$id,
                "webUrl" = files_response$data$project$webUrl,
                "repository" = list(
                  "blobs" = list(
                    "nodes" = nodes
                  ),
                  "lastCommit" = list(
                    "sha" = files_response$data$project$repository$lastCommit$sha
                  )
                )
              )
            )
          )
        }
        return(files_response)
      })
      return(org_files_list)
    },

    prepare_files_table = function(files_response, org) {
      if (!is.null(files_response)) {
        if (private$response_prepared_by_iteration(files_response)) {
          files_table <- purrr::map(files_response, function(response_data) {
            private$prepare_files_table_row(
              project = response_data$data$project,
              org = org
            )
          }) |>
            purrr::list_rbind()
        } else {
          files_table <- purrr::map(files_response, function(project) {
            private$prepare_files_table_row(
              project = project,
              org = org
            )
          }) |>
            purrr::list_rbind()
        }
      } else {
        files_table <- NULL
      }
      return(files_table)
    },

    prepare_user_table = function(user_response) {
      if (!is.null(user_response$data$user)) {
        user_data <- user_response$data$user
        user_data[["name"]] <- user_data$name %||% ""
        user_data[["starred_repos"]] <- user_data$starred_repos$count
        user_data[["pull_requests"]] <- user_data$pull_requests$count
        user_data[["reviews"]] <- user_data$reviews$count
        user_data[["email"]] <- user_data$email %||% ""
        user_data[["location"]] <- user_data$location %||% ""
        user_data[["web_url"]] <- user_data$web_url %||% ""
        user_table <- tibble::as_tibble(user_data) |>
          dplyr::mutate(commits = NA,
                        issues = NA) |>
          dplyr::relocate(
            c(commits, issues),
            .after = starred_repos
          )
      } else {
        user_table <- NULL
      }
      return(user_table)
    },

    get_release_logs_from_org = function(repos_names, org, verbose = TRUE) {
      release_responses <- gitstats_map(repos_names, function(repository) {
        releases_from_repo_query <- self$gql_query$releases_from_repo()
        response <- self$gql_response(
          gql_query = releases_from_repo_query,
          vars = list(
            "project_path" = paste0(org, "/", url_decode(repository))
          ),
          verbose = verbose
        )
        return(response)
      }) |>
        purrr::discard(~ length(.$data$project$releases$nodes) == 0)
      return(release_responses)
    },

    prepare_releases_table = function(releases_response, org) {
      if (length(releases_response) > 0) {
        releases_table <-
          purrr::map(releases_response, function(release) {
            release_table <- purrr::map(release$data$project$releases$nodes, function(node) {
              data.frame(
                release_name = node$name,
                release_tag = node$tagName,
                published_at = gts_to_posixt(node$releasedAt),
                release_url = node$links$selfUrl,
                release_log = node$description
              )
            }) |>
              purrr::list_rbind() |>
              dplyr::mutate(
                repo_name = release$data$project$name,
                repo_url = release$data$project$webUrl
              ) |>
              dplyr::relocate(
                repo_name, repo_url,
                .before = release_name
              )
            return(release_table)
          }) |>
          purrr::list_rbind()
      } else {
        releases_table <- NULL
      }
      return(releases_table)
    }
  ),
  private = list(
    get_repos_page = function(org = NULL,
                              projects_ids = NULL,
                              type = "organization",
                              repo_cursor = "",
                              verbose = TRUE) {
      if (type == "organization") {
        response <- self$gql_response(
          gql_query = self$gql_query$repos_by_org(),
          vars = list(
            "org" = org,
            "repo_cursor" = repo_cursor
          ),
          verbose = verbose
        )
      } else if (type == "user") {
        response <- self$gql_response(
          gql_query = self$gql_query$repos_by_user(),
          vars = list(
            "username" = org,
            "repo_cursor" = repo_cursor
          ),
          verbose = verbose
        )
      } else if (type == "projects") {
        response <- self$gql_response(
          gql_query = self$gql_query$repos(repo_cursor),
          vars = list(
            "projects_ids" = as.character(projects_ids)
          ),
          verbose = verbose
        )
      }
      return(response)
    },

    get_repo_name_from_url = function(web_url) {
      url_split <- stringr::str_split(web_url, ":|/")[[1]]
      repo_name <- url_split[length(url_split)]
      return(repo_name)
    },

    get_file_blobs_response = function(org, repo, file_paths, verbose = TRUE) {
      file_blobs_response <- self$gql_response(
        gql_query = self$gql_query$file_blob_from_repo(),
        vars = list(
          "fullPath" = paste0(org, "/", repo),
          "file_paths" = file_paths
        ),
        verbose = verbose
      )
      return(file_blobs_response)
    },

    prepare_files_table_row = function(project, org) {
      purrr::map(project$repository$blobs$nodes, function(file) {
        if (!is.null(file)) {
          project_id <- project$id %||% NA_character_
          repo_url <- project$webUrl %||% NA_character_
          commit_sha <- project$repository$lastCommit$sha %||% NA_character_
          data.frame(
            "repo_id" = get_gitlab_repo_id(project_id),
            "repo_name" = project$path %||% project$name,
            "organization" = org,
            "file_path" = file$path,
            "file_content" = file$rawBlob,
            "file_size" = as.integer(file$size),
            "file_id" = file$oid,
            "repo_url" = repo_url,
            "commit_sha" = commit_sha
          )
        }
      }) |>
        purrr::list_rbind()
    },

    get_issues_from_one_repo = function(org,
                                        repo,
                                        verbose = TRUE) {
      next_page <- TRUE
      full_issues_list <- list()
      issues_cursor <- ""
      while (next_page) {
        issues_response <- private$get_issues_page_from_repo(
          org = org,
          repo = repo,
          issues_cursor = issues_cursor,
          verbose = verbose
        )
        issues_list <- issues_response$data$project$issues$edges
        next_page <- issues_response$data$project$issues$pageInfo$hasNextPage
        if (is.null(next_page)) next_page <- FALSE
        if (is.null(issues_list)) issues_list <- list()
        if (next_page) {
          issues_cursor <- issues_response$data$project$issues$pageInfo$endCursor
        } else {
          issues_cursor <- ""
        }
        full_issues_list <- append(full_issues_list, issues_list)
      }
      return(full_issues_list)
    },

    get_issues_page_from_repo = function(org,
                                         repo,
                                         issues_cursor = "",
                                         verbose = TRUE) {
      issues_from_repo_query <- self$gql_query$issues_from_repo(
        issues_cursor = issues_cursor
      )
      response <- self$gql_response(
        gql_query = issues_from_repo_query,
        vars = list(
          "fullPath" = paste0(org, "/", repo)
        ),
        verbose = verbose
      )
      return(response)
    },

    get_pr_from_one_repo = function(org,
                                    repo,
                                    verbose = TRUE) {
      next_page <- TRUE
      full_pr_list <- list()
      pr_cursor <- ""
      while (next_page) {
        pr_response <- private$get_pr_page_from_repo(
          org = org,
          repo = repo,
          pr_cursor = pr_cursor,
          verbose = verbose
        )
        pr_list <- pr_response$data$project$mergeRequests$edges
        next_page <- pr_response$data$project$mergeRequests$pageInfo$hasNextPage
        if (is.null(next_page)) next_page <- FALSE
        if (is.null(pr_list)) pr_list <- list()
        if (next_page) {
          pr_cursor <- pr_response$data$project$mergeRequests$pageInfo$endCursor
        } else {
          pr_cursor <- ""
        }
        full_pr_list <- append(full_pr_list, pr_list)
      }
      return(full_pr_list)
    },

    get_pr_page_from_repo = function(org,
                                     repo,
                                     pr_cursor = "",
                                     verbose = TRUE) {
      pr_from_repo_query <- self$gql_query$pull_requests_from_repo(
        pr_cursor = pr_cursor
      )
      response <- self$gql_response(
        gql_query = pr_from_repo_query,
        vars = list(
          "fullPath" = paste0(org, "/", repo)
        ),
        verbose = verbose
      )
      if (inherits(response, "graphql_error")) {
        response <- self$gql_response(
          gql_query = pr_from_repo_query,
          vars = list(
            "org" = org,
            "repo" = repo
          ),
          verbose = verbose
        )
      }
      return(response)
    },

    response_prepared_by_iteration = function(files_response) {
      !all(purrr::map_lgl(files_response, ~ all(c("name", "id", "webUrl", "repository") %in% names(.))))
    }
  )
)
