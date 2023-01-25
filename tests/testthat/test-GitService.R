test_that("Private pull_repos_from_org pulls correctly repositories for GitHub", {
  git_hub <- GitService$new(
    rest_api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT"),
    orgs = c("openpharma", "pharmaverse", "insightsengineering")
  )

  github_env <- environment(git_hub$initialize)$private

  orgs <- git_hub$orgs

  purrr::walk(orgs, function(org) {
    repos_n <- perform_get_request(
      endpoint = paste0("https://api.github.com/orgs/", org),
      token = Sys.getenv("GITHUB_PAT")
    )[["public_repos"]]

    expect_equal(
      length(github_env$pull_repos_from_org(org = org,
                                            git_service = "GitHub")),
      repos_n
    )
  })
})

test_that("Private pull_repos_from_rg pulls correctly repositories for GitLab", {
  testthat::skip_on_ci()

  git_lab <- GitService$new(
    rest_api_url = "https://gitlab.com/api/v4",
    token = Sys.getenv("GITLAB_PAT"),
    orgs = c("erasmusmc-public-health")
  )

  gitlab_env <- environment(git_lab$initialize)$private

  orgs <- git_lab$orgs

  purrr::walk(orgs, function(group) {
    repos_n <- length(perform_get_request(
      endpoint = paste0("https://gitlab.com/api/v4/groups/", group),
      token = Sys.getenv("GITLAB_PAT")
    )[["projects"]])

    expect_equal(
      length(gitlab_env$pull_repos_from_org(org = group,
                                            git_service = "GitLab")),
      repos_n
    )
  })
})
