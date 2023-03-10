test_github <- GitHub$new(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  orgs = "r-world-devs"
)

test_github_priv <- environment(test_github$initialize)$private

test_that("`tailor_repos_info()` tailors precisely `repos_list`", {
  repos_full <- readRDS("test_files/github_repos_by_org.rds")

  tailored_repos <-
    test_github_priv$tailor_repos_info(repos_full)

  tailored_repos %>%
    expect_type("list") %>%
    expect_length(length(repos_full)) %>%
    expect_list_contains_only(c(
      "organisation", "name", "created_at", "last_activity_at",
      "forks", "stars", "contributors", "issues", "issues_open", "issues_closed",
      "description"
    ))

  expect_lt(length(tailored_repos[[1]]), length(repos_full[[1]]))
})

test_gitlab <- GitLab$new(
  rest_api_url = "https://gitlab.com/api/v4",
  token = Sys.getenv("GITLAB_PAT"),
  orgs = c("erasmusmc-public-health")
)

test_gitlab_priv <- environment(test_gitlab$initialize)$private

test_that("`tailor_repos_info()` tailors precisely `repos_list`", {
  repos_full <- readRDS("test_files/gitlab_repos_by_org.rds")

  tailored_repos <-
    test_gitlab_priv$tailor_repos_info(repos_full)

  tailored_repos %>%
    expect_type("list") %>%
    expect_length(length(repos_full)) %>%
    expect_list_contains_only(c(
      "organisation", "name", "created_at", "last_activity_at",
      "forks", "stars", "contributors", "issues", "issues_open", "issues_closed",
      "description"
    ))

  expect_lt(length(tailored_repos[[1]]), length(repos_full[[1]]))
})
