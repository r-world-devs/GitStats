test_mocker <- Mocker$new()

test_team <- list(
  "Member1" = list(
    logins = "galachad"
  ),
  "Member2" = list(
    logins = "Cotau"
  ),
  "Member3" = list(
    logins = c("maciekbanas", "banasm")
  )
)

test_settings <- list(
  verbose = TRUE,
  storage = TRUE
)

test_settings_silence <- list(
  verbose = FALSE,
  storage = TRUE
)

test_settings_repo <- list(
  searching_scope = "repo",
  verbose = TRUE,
  storage = TRUE
)

if (nchar(Sys.getenv("GITHUB_PAT")) == 0) {
  cli::cli_abort(c(
    "x" = "You did not set up your GITHUB_PAT environment variable.",
    "i" = "If you wish to run tests for GitHub - set up your GITHUB_PAT enviroment variable (as a GitHub access token on github.com)."
  ))
}
if (nchar(Sys.getenv("GITHUB_PAT")) > 0) {
  tryCatch({
    httr2::request("https://api.github.com") %>%
    httr2::req_headers("Authorization" = paste0("Bearer ", Sys.getenv("GITHUB_PAT"))) %>%
    httr2::req_perform()
    },
  error = function(e) {
    if (grepl("401", e$message)) {
      cli::cli_abort(c(
        "x" = "Your GITHUB_PAT enviroment variable does not grant access. Please setup your GITHUB_PAT before running tests.",
        "i" = "If you wish to run tests for GitHub - set up your GITHUB_PAT enviroment variable (as a GitHub access token on github.com)."
      ))
    }
  })
}
if (nchar(Sys.getenv("GITLAB_PAT_PUBLIC")) == 0) {
  cli::cli_abort(c(
    "x" = "You did not set up your GITLAB_PAT_PUBLIC environment variable.",
    "i" = "If you wish to run tests for GitLab - set up your GITLAB_PAT_PUBLIC enviroment variable (as a GitLab access token on gitlab.com)."
  ))
}
if (nchar(Sys.getenv("GITLAB_PAT_PUBLIC")) > 0) {
  tryCatch({
    httr2::request("https://gitlab.com/api/v4/projects") %>%
      httr2::req_headers("Authorization" = paste0("Bearer ", Sys.getenv("GITLAB_PAT_PUBLIC"))) %>%
      httr2::req_perform()
  },
  error = function(e) {
    if (grepl("401", e$message)) {
      cli::cli_abort(c(
        "x" = "Your GITLAB_PAT_PUBLIC enviroment variable does not grant access. Please setup your GITLAB_PAT_PUBLIC before running tests.",
        "i" = "If you wish to run tests for GitLab - set up your GITLAB_PAT_PUBLIC enviroment variable (as a GitLab access token on gitlab.com)."
      ))
    }
  })
}
