#' @noRd
GitHostGitLab <- R6::R6Class("GitHostGitLab",
  inherit = GitHost,
  public = list(
    initialize = function(orgs = NA,
                          repos = NA,
                          token = NA,
                          host = NA,
                          verbose = NA) {
      repos <- if (!is.null(repos)) {
        url_encode(repos)
      }
      orgs <- if (!is.null(orgs)) {
        url_encode(orgs)
      }
      super$initialize(orgs = orgs,
                       repos = repos,
                       token = token,
                       host = host,
                       verbose = verbose)
      if (private$verbose) {
        cli::cli_alert_success("Set connection to GitLab.")
      }
    }
  ),
  private = list(

    # Host
    host_name = "GitLab",

    # API version
    api_version = 4,

    # Default token name
    token_name = "GITLAB_PAT",

    # Access scopes for token
    access_scopes = c("api", "read_api"),

    # Methods for engines
    engine_methods = list(
      "graphql" = list(
        "repos",
        "release_logs"
      ),
      "rest" = list(
        "code",
        "commits",
        "contributors"
      )
    ),

    # Set API url
    set_api_url = function(host) {
      if (is.null(host)) {
        private$api_url <- glue::glue(
          "https://gitlab.com/api/v{private$api_version}"
        )
      } else {
        private$set_custom_api_url(host)
      }
    },

    # Check whether Git platform is public or internal.
    check_if_public = function(host) {
      private$is_public <- is.null(host) || grepl("gitlab.com", host)
    },

    # Set endpoint for basic checks
    set_test_endpoint = function() {
      private$test_endpoint = glue::glue("{private$api_url}/projects")
    },

    # Set tokens endpoint
    set_tokens_endpoint = function() {
      private$endpoints$tokens = glue::glue("{private$api_url}/personal_access_tokens")
    },

    # Set groups endpoint
    set_orgs_endpoint = function() {
      private$endpoints$orgs = glue::glue("{private$api_url}/groups")
    },

    # Set projects endpoint
    set_repositories_endpoint = function() {
      private$endpoints$repositories = glue::glue("{private$api_url}/projects")
    },

    # Setup REST and GraphQL engines
    setup_engines = function() {
      private$engines$rest <- EngineRestGitLab$new(
          rest_api_url = private$api_url,
          token = private$token,
          scan_all = private$scan_all
      )
      private$engines$graphql <- EngineGraphQLGitLab$new(
          gql_api_url = private$graphql_api_url,
          token = private$token,
          scan_all = private$scan_all
      )
    },

    # check token scopes
    # response parameter only for need of super method
    check_token_scopes = function(response = NULL, token) {
      token_scopes <- httr2::request(private$endpoints$tokens) %>%
        httr2::req_headers("Authorization" = paste0("Bearer ", token)) %>%
        httr2::req_perform() %>%
        httr2::resp_body_json() %>%
        purrr::keep(~ .$active) %>%
        purrr::map(function(pat) {
          data.frame(scopes = unlist(pat$scopes), date = pat$last_used_at)
        }) %>%
        purrr::list_rbind() %>%
        dplyr::filter(
          date == max(date)
        ) %>%
        dplyr::select(scopes) %>%
        unlist()
      any(private$access_scopes %in% token_scopes)
    },

    # Retrieve only important info from repositories response
    tailor_repos_response = function(repos_response) {
      repos_list <- purrr::map(repos_response, function(project) {
        list(
          "repo_id" = project$id,
          "repo_name" = project$name,
          "default_branch" = project$default_branch,
          "stars" = project$star_count,
          "forks" = project$fork_count,
          "created_at" = project$created_at,
          "last_activity_at" = project$last_activity_at,
          "languages" = paste0(project$languages, collapse = ", "),
          "issues_open" = project$issues_open,
          "issues_closed" = project$issues_closed,
          "organization" = project$namespace$path,
          "repo_url" = project$web_url
        )
      })
      return(repos_list)
    },

    # Parses repositories list into table.
    prepare_repos_table_from_graphql = function(repos_list) {
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
          repo$organization <- repo$group$path
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

    # Add `api_url` column to table.
    add_repo_api_url = function(repos_table){
      if (!is.null(repos_table) && nrow(repos_table) > 0) {
        repos_table <- dplyr::mutate(
            repos_table,
            api_url = paste0(private$endpoints$repositories,
                             "/",
                             stringr::str_match(repo_id, "[0-9].*"))
          )
      }
      return(repos_table)
    },

    # Pull commits from GitHub
    pull_commits_from_host = function(since, until, settings) {
      rest_engine <- private$engines$rest
      commits_table <- purrr::map(private$orgs, function(org) {
        commits_table_org <- NULL
        if (!private$scan_all && private$verbose) {
          show_message(
            host = private$host_name,
            engine = "rest",
            scope = utils::URLdecode(org),
            information = "Pulling commits"
          )
        }
        repos_names <- private$set_repositories(
          org = org,
          settings = settings
        )
        commits_table_org <- rest_engine$pull_commits_from_repos(
          repos_names = repos_names,
          since = since,
          until = until
        ) %>%
          private$tailor_commits_info(org = org) %>%
          private$prepare_commits_table() %>%
          rest_engine$get_commits_authors_handles_and_names(
            verbose = private$verbose
          )
        return(commits_table_org)
      }, .progress = if (private$scan_all && private$verbose) {
        "[GitHost:GitLab] Pulling commits..."
      } else {
        FALSE
      }) %>%
        purrr::list_rbind()
      return(commits_table)
    },

    # Use repositories either from parameter or, if not set, pull them from API
    set_repositories = function(org, settings) {
      if (private$searching_scope == "repo") {
        repos <- private$orgs_repos[[org]]
        repos_names <- paste0(org, "%2f", repos)
      } else {
        repos_table <- private$pull_all_repos(
          verbose = FALSE,
          settings = settings
        )
        gitlab_web_url <- stringr::str_extract(private$api_url, "^.*?(?=api)")
        repos <- stringr::str_remove(repos_table$repo_url, gitlab_web_url)
        repos_names <- utils::URLencode(repos, reserved = TRUE)
      }
      return(repos_names)
    },

    # Get only important info on commits.
    tailor_commits_info = function(repos_list_with_commits,
                                   org) {
      repos_list_with_commits_cut <- purrr::map(repos_list_with_commits, function(repo) {
        purrr::map(repo, function(commit) {
          list(
            "id" = commit$id,
            "committed_date" = gts_to_posixt(commit$committed_date),
            "author" = commit$author_name,
            "additions" = commit$stats$additions,
            "deletions" = commit$stats$deletions,
            "repository" = gsub(
              pattern = paste0("/-/commit/", commit$id),
              replacement = "",
              x = gsub(paste0("(.*)", org, "/"), "", commit$web_url)
            ),
            "organization" = org
          )
        })
      })
      return(repos_list_with_commits_cut)
    },

    # A helper to turn list of data.frames into one data.frame
    prepare_commits_table = function(commits_list) {
      commits_dt <- purrr::map(commits_list, function(x) {
        purrr::map(x, ~ data.frame(.)) %>%
          purrr::list_rbind()
      }) %>% purrr::list_rbind()

      if (length(commits_dt) > 0) {
        commits_dt <- dplyr::mutate(
          commits_dt,
          api_url = private$api_url
        )
      }
      return(commits_dt)
    },

    # Prepare user table.
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

    # Prepare files table.
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
              "repo_url" = project$webUrl
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
          org_repo <- stringr::str_split_1(file_data$repo_fullname, "/")
          org <- paste0(org_repo[1:(length(org_repo) - 1)], collapse = "/")
          data.frame(
            "repo_name" = file_data$repo_name,
            "repo_id" = as.character(file_data$repo_id),
            "organization" = org,
            "file_path" = file_data$file_path,
            "file_content" = file_data$content,
            "file_size" = file_data$size,
            "repo_url" = file_data$repo_url
          )
        }) %>%
          purrr::list_rbind() %>%
          unique()
      }
      return(files_table)
    },

    # Prepare releases table.
    prepare_releases_table = function(releases_response, org, date_from, date_until) {
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
