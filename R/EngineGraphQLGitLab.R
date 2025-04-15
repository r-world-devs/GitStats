#' @noRd
#' @description A class for methods wrapping GitLab's GraphQL API responses.
EngineGraphQLGitLab <- R6::R6Class(
  classname = "EngineGraphQLGitLab",
  inherit = EngineGraphQL,
  public = list(

    #' Create `EngineGraphQLGitLab` object.
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

    # Set owner type
    set_owner_type = function(owners) {
      user_or_org_query <- self$gql_query$user_or_org_query
      login_types <- purrr::map(owners, function(owner) {
        response <- self$gql_response(
          gql_query = user_or_org_query,
          vars = list(
            "username" = owner,
            "grouppath" = owner
          )
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
        return(owner)
      })
      return(login_types)
    },

    #' Get all groups from GitLab.
    get_orgs = function(orgs_count,
                        output = c("only_names", "full_table"),
                        verbose,
                        progress = verbose) {
      if (verbose) {
        cli::cli_alert("[Host:GitLab][Engine:{cli::col_yellow('GraphQL')}] Pulling organizations...")
      }
      group_cursor <- ""
      iterations_number <- round(orgs_count / 100)
      orgs_list <- purrr::map(1:iterations_number, function(x) {
        response <- self$gql_response(
          gql_query = self$gql_query$groups(),
          vars = list("groupCursor" = group_cursor)
        )
        response <- set_graphql_error_class(response)
        if (length(response$data$groups$edges) == 0) {
          class(response) <- c(class(response), "graphql_error")
        }
        if (!inherits(response, "graphql_error")) {
          if (output == "only_names") {
            orgs_list <- purrr::map(response$data$groups$edges, ~ .$node$fullPath)
          } else {
            orgs_list <- purrr::map(response$data$groups$edges, ~ .$node)
          }
          group_cursor <<- response$data$groups$pageInfo$endCursor
          return(orgs_list)
        } else {
          return(response)
        }
      }, .progress = TRUE) |>
        purrr::list_flatten()
      orgs_list <- handle_graphql_error(orgs_list, verbose)
      if (!inherits(orgs_list, "graphql_error")) {
        if (output == "only_names") {
          all_orgs <- unlist(orgs_list)
        } else if (output == "full_table") {
          all_orgs <- orgs_list
        }
      } else {
        all_orgs <- orgs_list
      }
      return(all_orgs)
    },

    get_org = function(org, verbose) {
      if (verbose) {
        cli::cli_alert("[Host:GitLab][Engine:{cli::col_yellow('GraphQL')}] Pulling {org} organization...")
      }
      response <- self$gql_response(
        gql_query = self$gql_query$group(),
        vars = list("org" = org)
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

    # Iterator over pulling pages of repositories.
    get_repos = function(repos_ids, verbose) {
      full_repos_list <- list()
      next_page <- TRUE
      repo_cursor <- ""
      while (next_page) {
        repos_response <- private$get_repos_page(
          projects_ids = paste0("gid://gitlab/Project/", repos_ids),
          type = "projects",
          repo_cursor = repo_cursor
        )
        if (inherits(repos_response, "graphql_error")) {
          full_repos_list <- repos_response
          break
        } else {
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
      }
      full_repos_list <- handle_graphql_error(full_repos_list, verbose)
      return(full_repos_list)
    },

    # Iterator over pulling pages of repositories.
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
          repo_cursor = repo_cursor
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
      full_repos_list <- handle_graphql_error(full_repos_list, verbose)
      return(full_repos_list)
    },

    # Parses repositories list into table.
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
            org <- sub(paste0("/", repo$repo_path), "", repo$repo_url) %>%
              sub("^https://[^/]+", "", .) %>%
              sub("^/", "", .)
          }
          data.frame(
            repo_id = sub(".*/(\\d+)$", "\\1", repo$repo_id),
            repo_name = repo$repo_name,
            default_branch = repo$repository$rootRef %||% "",
            stars = repo$stars,
            forks = repo$forks,
            created_at = gts_to_posixt(repo$created_at),
            last_activity_at = as.POSIXct(repo$last_activity_at),
            languages = languages,
            issues_open = repo$issues$opened %||% 0,
            issues_closed = repo$issues$closed %||% 0,
            organization = org,
            repo_url = repo$repo_url
          )
        }) |>
          purrr::list_rbind()
      } else {
        repos_table <- NULL
      }
      return(repos_table)
    },

    # Pull all given files from all repositories of a group.
    # This is a one query way to get all the necessary info.
    # However it may fail if query is too complex (too many files in file_paths).
    # This may be especially the case when trying to pull the data from earlier
    # pulled files_structure. In such a case GitStats will switch from this function
    # to iterator over repositories (multiple queries), as it is done for GitHub.
    get_files_from_org = function(org,
                                  owner_type,
                                  repos,
                                  file_paths = NULL,
                                  host_files_structure = NULL,
                                  verbose = FALSE,
                                  progress = FALSE) {
      org <- URLdecode(org)
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
          files_response <- tryCatch(
            {
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
            }
          )
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
                repos = repos,
                file_paths = file_paths,
                host_files_structure = host_files_structure,
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
        if (!is.null(repos)) {
          full_files_list <- purrr::keep(full_files_list, function(project) {
            repo_name <- private$get_repo_name_from_url(project$webUrl)
            repo_name %in% repos
          })
        }
      } else {
        full_files_list <- self$get_files_from_org_per_repo(
          org = org,
          owner_type = owner_type,
          repos = repos,
          file_paths = file_paths,
          host_files_structure = host_files_structure,
          verbose = verbose,
          progress = progress
        )
      }
      return(full_files_list)
    },

    # This method is a kind of support to the method above. It is only run when
    # one query way applied with get_files_from_org() fails due to its complexity.
    # For more info see docs above.
    get_files_from_org_per_repo = function(org,
                                           owner_type,
                                           repos,
                                           file_paths = NULL,
                                           host_files_structure = NULL,
                                           verbose = FALSE,
                                           progress = FALSE) {
      if (is.null(repos)) {
        repo_data <- private$get_repos_data(
          org = org,
          owner_type = owner_type,
          repos = repos
        )
        repos <- repo_data[["repositories"]]
      }
      org_files_list <- purrr::map(repos, function(repo) {
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
          file_paths = file_paths
        )
        if (private$is_complexity_error(files_response)) {
          if (verbose) {
            cli::cli_alert("Encountered query complexity error (too many files). I will divide input data into chunks...")
          }
          iterations_number <- round(length(file_paths) / 100)
          x <- 1
          files_response <- private$get_file_blobs_response(
            org = org,
            repo = repo,
            file_paths = file_paths[1]
          )
          nodes <- purrr::map(c(1:iterations_number), function(i) {
            files_part_response <- private$get_file_blobs_response(
              org = org,
              repo = repo,
              file_paths = file_paths[x:(i * 100)]
            )
            x <<- x + 100
            return(files_part_response$data$project$repository$blobs$nodes)
          }, .progress = verbose) |>
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
                  )
                )
              )
            )
          )
        }
        return(files_response)
      }, .progress = progress)
      return(org_files_list)
    },

    # Prepare files table.
    prepare_files_table = function(files_response, org) {
      if (!is.null(files_response)) {
        if (private$response_prepared_by_iteration(files_response)) {
          files_table <- purrr::map(files_response, function(response_data) {
            purrr::map(response_data$data$project$repository$blobs$nodes, function(file) {
              data.frame(
                "repo_name" = response_data$data$project$name,
                "repo_id" = response_data$data$project$id,
                "organization" = org,
                "file_path" = file$path,
                "file_content" = file$rawBlob,
                "file_size" = as.integer(file$size),
                "repo_url" = response_data$data$project$webUrl
              )
            }) %>%
              purrr::list_rbind()
          }) %>%
            purrr::list_rbind()
        } else {
          files_table <- purrr::map(files_response, function(project) {
            purrr::map(project$repository$blobs$nodes, function(file) {
              data.frame(
                "repo_name" = project$name,
                "repo_id" = project$id,
                "organization" = org,
                "file_path" = file$path,
                "file_content" = file$rawBlob,
                "file_size" = as.integer(file$size),
                "repo_url" = project$webUrl
              )
            }) %>%
              purrr::list_rbind()
          }) %>%
            purrr::list_rbind()
        }
      } else {
        files_table <- NULL
      }
      return(files_table)
    },

    get_files_structure_from_org = function(org,
                                            owner_type,
                                            repos = NULL,
                                            pattern = NULL,
                                            depth = Inf,
                                            verbose = TRUE,
                                            progress = TRUE) {
      repo_data <- private$get_repos_data(
        org = org,
        owner_type = owner_type,
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
      }, .progress = progress)
      names(files_structure) <- repositories
      files_structure <- purrr::discard(files_structure, ~ length(.) == 0)
      return(files_structure)
    },

    # Prepare user table.
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

    # Pull all releases from all repositories of an organization.
    get_release_logs_from_org = function(repos_names, org) {
      release_responses <- purrr::map(repos_names, function(repository) {
        releases_from_repo_query <- self$gql_query$releases_from_repo()
        response <- self$gql_response(
          gql_query = releases_from_repo_query,
          vars = list(
            "project_path" = paste0(org, "/", utils::URLdecode(repository))
          )
        )
        return(response)
      }) %>%
        purrr::discard(~ length(.$data$project$releases$nodes) == 0)
      return(release_responses)
    },

    # Prepare releases table.
    prepare_releases_table = function(releases_response, org, since, until) {
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
            }) %>%
              purrr::list_rbind() %>%
              dplyr::mutate(
                repo_name = release$data$project$name,
                repo_url = release$data$project$webUrl
              ) %>%
              dplyr::relocate(
                repo_name, repo_url,
                .before = release_name
              )
            return(release_table)
          }) %>%
          purrr::list_rbind() %>%
          dplyr::filter(
            published_at <= as.POSIXct(until)
          )
        if (!is.null(since)) {
          releases_table <- releases_table %>%
            dplyr::filter(
              published_at >= as.POSIXct(since)
            )
        }
      } else {
        releases_table <- NULL
      }
      return(releases_table)
    }
  ),
  private = list(
    is_complexity_error = function(response) {
      any(purrr::map_lgl(response$errors, ~ grepl("Query has complexity", .$message)))
    },

    # Wrapper over building GraphQL query and response.
    get_repos_page = function(org = NULL,
                              projects_ids = NULL,
                              type = "organization",
                              repo_cursor = "") {
      if (type == "organization") {
        response <- self$gql_response(
          gql_query = self$gql_query$repos_by_org(),
          vars = list(
            "org" = org,
            "repo_cursor" = repo_cursor
          )
        )
      } else if (type == "user") {
        response <- self$gql_response(
          gql_query = self$gql_query$repos_by_user(),
          vars = list(
            "username" = org,
            "repo_cursor" = repo_cursor
          )
        )
      } else if (type == "projects") {
        response <- self$gql_response(
          gql_query = self$gql_query$repos(repo_cursor),
          vars = list(
            "projects_ids" = as.character(projects_ids)
          )
        )
      }
      response <- set_graphql_error_class(response)
      return(response)
    },

    # Helper
    get_repo_name_from_url = function(web_url) {
      url_split <- stringr::str_split(web_url, ":|/")[[1]]
      repo_name <- url_split[length(url_split)]
      return(repo_name)
    },

    get_repos_data = function(org, owner_type, repos = NULL) {
      repos_list <- self$get_repos_from_org(
        org = org,
        owner_type = owner_type
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

    # An iterator over pulling issues pages from one repository.
    get_issues_from_one_repo = function(org,
                                        repo) {
      next_page <- TRUE
      full_issues_list <- list()
      issues_cursor <- ""
      while (next_page) {
        issues_response <- private$get_issues_page_from_repo(
          org = org,
          repo = repo,
          issues_cursor = issues_cursor
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

    # Wrapper over building GraphQL query and response.
    get_issues_page_from_repo = function(org,
                                         repo,
                                         issues_cursor = "") {
      issues_from_repo_query <- self$gql_query$issues_from_repo(
        issues_cursor = issues_cursor
      )
      response <- self$gql_response(
        gql_query = issues_from_repo_query,
        vars = list(
          "fullPath" = paste0(org, "/", repo)
        )
      )
      return(response)
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
    },

    response_prepared_by_iteration = function(files_response) {
      !all(purrr::map_lgl(files_response, ~ all(c("name", "id", "webUrl", "repository") %in% names(.))))
    }
  )
)
