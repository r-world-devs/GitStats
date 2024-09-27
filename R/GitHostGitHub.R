#' @noRd
GitHostGitHub <- R6::R6Class("GitHostGitHub",
  inherit = GitHost,
  public = list(
    initialize = function(orgs = NA,
                          repos = NA,
                          token = NA,
                          host = NA,
                          verbose = NA) {
      super$initialize(orgs = orgs,
                       repos = repos,
                       token = token,
                       host = host,
                       verbose = verbose)
      if (verbose) {
        cli::cli_alert_success("Set connection to GitHub.")
      }
    }
  ),
  private = list(

    # Host
    host_name = "GitHub",

    # API version
    api_version = 3,

    # Default token name
    token_name = "GITHUB_PAT",

    # Access scopes for token
    access_scopes = c("public_repo", "read:org", "read:user"),

    # Methods for engines
    engine_methods = list(
      "graphql" = list(
        "repos",
        "commits",
        "release_logs"
      ),
      "rest" = list(
        "code",
        "contributors"
      )
    ),

    # Set API URL
    set_api_url = function(host) {
      if (is.null(host)) {
        private$api_url <- "https://api.github.com"
      } else {
        private$set_custom_api_url(host)
      }
    },

    # Set web URL
    set_web_url = function(host) {
      if (is.null(host)) {
        private$web_url <- "https://github.com"
      } else {
        private$set_custom_web_url(host)
      }
    },

    # Check whether Git platform is public or internal.
    check_if_public = function(host) {
      private$is_public <- is.null(host) || grepl("github.com", host)
    },

    # Set endpoint for basic checks
    set_test_endpoint = function() {
      private$test_endpoint <- private$api_url
    },

    # Set tokens endpoint
    set_tokens_endpoint = function() {
      private$endpoints$tokens <- NULL
    },

    # Set groups endpoint
    set_orgs_endpoint = function() {
      private$endpoints$orgs <- glue::glue("{private$api_url}/orgs")
    },

    # Set projects endpoint
    set_repositories_endpoint = function() {
      private$endpoints$repositories <- glue::glue("{private$api_url}/repos")
    },

    # Setup REST and GraphQL engines
    setup_engines = function() {
      private$engines$rest <- EngineRestGitHub$new(
        rest_api_url = private$api_url,
        token = private$token,
        scan_all = private$scan_all
      )
      private$engines$graphql <- EngineGraphQLGitHub$new(
        gql_api_url = private$graphql_api_url,
        token = private$token,
        scan_all = private$scan_all
      )
    },

    # Check token scopes
    # token parameter only for need of super method
    check_token_scopes = function(response, token = NULL) {
      token_scopes <- response$headers$`x-oauth-scopes` %>%
        stringr::str_split(", ") %>%
        unlist()
      all(private$access_scopes %in% token_scopes)
    },

    # Retrieve only important info from repositories response
    tailor_repos_response = function(repos_response) {
      repos_list <- purrr::map(repos_response, function(repo) {
        list(
          "repo_id" = repo$id,
          "repo_name" = repo$name,
          "default_branch" = repo$default_branch,
          "stars" = repo$stargazers_count,
          "forks" = repo$forks_count,
          "created_at" = gts_to_posixt(repo$created_at),
          "last_activity_at" = if (!is.null(repo$pushed_at)) {
            gts_to_posixt(repo$pushed_at)
          } else {
            gts_to_posixt(repo$created_at)
          },
          "languages" = repo$language,
          "issues_open" = repo$issues_open,
          "issues_closed" = repo$issues_closed,
          "organization" = repo$owner$login,
          "repo_url" = repo$html_url
        )
      })
      return(repos_list)
    },

    # Parses repositories list into table.
    prepare_repos_table_from_graphql = function(repos_list) {
      if (length(repos_list) > 0) {
        repos_table <- purrr::map_dfr(repos_list, function(repo) {
          repo$default_branch <- if (!is.null(repo$default_branch)) {
            repo$default_branch$name
          } else {
            ""
          }
          last_activity_at <- as.POSIXct(repo$last_activity_at)
          if (length(last_activity_at) == 0) {
            last_activity_at <- gts_to_posixt(repo$created_at)
          }
          repo$languages <- purrr::map_chr(repo$languages$nodes, ~ .$name) %>%
            paste0(collapse = ", ")
          repo$created_at <- gts_to_posixt(repo$created_at)
          repo$issues_open <- repo$issues_open$totalCount
          repo$issues_closed <- repo$issues_closed$totalCount
          repo$last_activity_at <- last_activity_at
          repo$organization <- repo$organization$login
          repo <- data.frame(repo) %>%
            dplyr::relocate(
              default_branch,
              .after = repo_name
            )
        })
      } else {
        repos_table <- NULL
      }
      return(repos_table)
    },

    # Add `api_url` column to table.
    add_repo_api_url = function(repos_table) {
      if (!is.null(repos_table) && nrow(repos_table) > 0) {
        repos_table <- dplyr::mutate(
          repos_table,
          api_url = paste0(private$endpoints$repositories, "/", organization, "/", repo_name),
        )
      }
      return(repos_table)
    },

    # Get projects URL from search response
    get_repo_url_from_response = function(search_response, type, progress = TRUE) {
      purrr::map_vec(search_response, function(project) {
        if (type == "api") {
          project$repository$url
        } else {
          project$repository$html_url
        }
      })
    },

    # Pull commits from GitHub
    get_commits_from_orgs = function(since, until, verbose, progress) {
      graphql_engine <- private$engines$graphql
      commits_table <- purrr::map(private$orgs, function(org) {
        commits_table_org <- NULL
        if (!private$scan_all && verbose) {
          show_message(
            host        = private$host_name,
            engine      = "graphql",
            scope       = org,
            information = "Pulling commits"
          )
        }
        repos_names <- private$set_repositories(
          org = org
        )
        commits_table_org <- graphql_engine$get_commits_from_repos(
          org         = org,
          repos_names = repos_names,
          since       = since,
          until       = until,
          progress    = progress
        ) %>%
          private$prepare_commits_table(org)
        return(commits_table_org)
      }, .progress = if (private$scan_all && progress) {
        "[GitHost:GitHub] Pulling commits..."
      } else {
        FALSE
      }) %>%
        purrr::list_rbind()
      return(commits_table)
    },

    # Use repositories either from parameter or, if not set, pull them from API
    set_repositories = function(org) {
      if (private$searching_scope == "repo") {
        repos_names <- private$orgs_repos[[org]]
      } else {
        repos_table <- private$get_all_repos(
          verbose = FALSE
        )
        repos_names <- repos_table$repo_name
      }
      return(repos_names)
    },

    # Parses repositories' list with commits into table of commits.
    prepare_commits_table = function(repos_list_with_commits,
                                     org) {
      commits_table <- purrr::imap(repos_list_with_commits, function(repo, repo_name) {
        commits_row <- purrr::map_dfr(repo, function(commit) {
          commit_author <- commit$node$author
          commit$node$author <- commit_author$name
          commit$node$author_login <- if (!is.null(commit_author$user$login)) {
            commit_author$user$login
          } else {
            NA
          }
          commit$node$author_name <- if (!is.null(commit_author$user$name)) {
            commit_author$user$name
          } else {
            NA
          }
          commit$node$committed_date <- gts_to_posixt(commit$node$committed_date)
          commit$node
        })
        commits_row$repository <- repo_name
        commits_row
      }) %>%
        purrr::discard(~ length(.) == 1) %>%
        purrr::list_rbind()
      if (nrow(commits_table) > 0) {
        commits_table <- commits_table %>%
          dplyr::mutate(
            organization = org,
            api_url = private$api_url
          ) %>%
          dplyr::relocate(
            any_of(c("author_login", "author_name")),
            .after = author
          )
      }
      return(commits_table)
    },

    # Prepare user table.
    prepare_user_table = function(user_response) {
      if (!is.null(user_response$data$user)) {
        user_data <- user_response$data$user
        user_data[["name"]] <- user_data$name %||% ""
        user_data[["starred_repos"]] <- user_data$starred_repos$totalCount
        user_data[["commits"]] <- user_data$contributions$totalCommitContributions
        user_data[["issues"]] <- user_data$contributions$totalIssueContributions
        user_data[["pull_requests"]] <- user_data$contributions$totalPullRequestContributions
        user_data[["reviews"]] <- user_data$contributions$totalPullRequestReviewContributions
        user_data[["contributions"]] <- NULL
        user_data[["email"]] <- user_data$email %||% ""
        user_data[["location"]] <- user_data$location %||% ""
        user_data[["web_url"]] <- user_data$web_url %||% ""
        user_table <- tibble::as_tibble(user_data) %>%
          dplyr::relocate(c(commits, issues, pull_requests, reviews),
                          .after = starred_repos)
      } else {
        user_table <- NULL
      }
      return(user_table)
    },

    # Prepare files table.
    prepare_files_table = function(files_response, org, file_path) {
      if (!is.null(files_response)) {
        files_table <- purrr::map(files_response, function(repository) {
          purrr::imap(repository, function(file_data, file_name) {
            data.frame(
              "repo_name" = file_data$repo_name,
              "repo_id" = file_data$repo_id,
              "organization" = org,
              "file_path" = file_name,
              "file_content" = file_data$file$text %||% NA,
              "file_size" = file_data$file$byteSize,
              "repo_url" = file_data$repo_url
            )
          }) %>%
            purrr::list_rbind()
        }) %>%
          purrr::list_rbind()
      } else {
        files_table <- NULL
      }
      return(files_table)
    },

    # Prepare files table from REST API.
    prepare_files_table_from_rest = function(files_list) {
      files_table <- NULL
      if (!is.null(files_list)) {
        files_table <- purrr::map(files_list, function(file_data) {
          repo_fullname <- private$get_repo_fullname(file_data$url)
          org_repo <- stringr::str_split_1(repo_fullname, "/")
          data.frame(
            "repo_name" = org_repo[2],
            "repo_id" = NA_character_,
            "organization" = org_repo[1],
            "file_path" = file_data$path,
            "file_content" = file_data$content,
            "file_size" = file_data$size,
            "repo_url" = private$set_repo_url(file_data$url)
          )
        }) %>%
          purrr::list_rbind()
      }
      return(files_table)
    },

    # Get repository full name
    get_repo_fullname = function(file_url) {
      stringr::str_remove_all(file_url,
                              paste0(private$endpoints$repositories, "/")) %>%
        stringr::str_replace_all("/contents.*", "")
    },

    # Get repository url
    set_repo_url = function(repo_fullname) {
      paste0(private$endpoints$repositories, "/", repo_fullname)
    },

    # Prepare releases table.
    prepare_releases_table = function(releases_response, org, date_from, date_until) {
      if (!is.null(releases_response)) {
        releases_table <-
          purrr::map(releases_response, function(release) {
            release_table <- purrr::map(release$data$repository$releases$nodes, function(node) {
              data.frame(
                release_name = node$name,
                release_tag = node$tagName,
                published_at = gts_to_posixt(node$publishedAt),
                release_url = node$url,
                release_log = node$description
              )
            }) %>%
              purrr::list_rbind() %>%
              dplyr::mutate(
                repo_name = release$data$repository$name,
                repo_url = release$data$repository$url
              ) %>%
              dplyr::relocate(
                repo_name, repo_url,
                .before = release_name
              )
            return(release_table)
          }) %>%
          purrr::list_rbind() %>%
          dplyr::filter(
            published_at <= as.POSIXct(date_until)
          )
        if (!is.null(date_from)) {
          releases_table <- releases_table %>%
            dplyr::filter(
              published_at >= as.POSIXct(date_from)
            )
        }
      } else {
        releases_table <- NULL
      }
      return(releases_table)
    }
  )
)
