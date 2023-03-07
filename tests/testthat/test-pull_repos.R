test_github <- GitHub$new(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  orgs = "r-world-devs"
)

test_github_priv <- environment(test_github$initialize)$private

test_that("`pull_repos_contributors()` adds contributors' statistics to repositories list", {
  repos_list <- readRDS("test_files/github_repos_raw.rds")

  repos_list_with_contributors <-
    test_github_priv$pull_repos_contributors(repos_list)

  expect_gt(length(repos_list_with_contributors[[1]]), length(repos_list[[1]]))
  expect_list_contains(repos_list_with_contributors, c("contributors"))
  expect_type(repos_list_with_contributors[[1]]$contributors, "character")
})

test_that("`pull_repos_issues()` adds issues statistics to repositories list", {
  repos_list <- readRDS("test_files/github_repos_raw.rds")

  repos_list_with_issues <-
    test_github_priv$pull_repos_issues(repos_list)

  expect_gt(length(repos_list_with_issues[[1]]), length(repos_list[[1]]))
  expect_list_contains(repos_list_with_issues, c("issues", "issues_open", "issues_closed"))
  expect_type(repos_list_with_issues[[1]]$issues, "integer")
  expect_type(repos_list_with_issues[[1]]$issues_open, "integer")
  expect_type(repos_list_with_issues[[1]]$issues_closed, "integer")
  purrr::walk(repos_list_with_issues, ~ expect_equal(.$issues, .$issues_open + .$issues_closed))
})

test_that("`pull_repos_from_org()` pulls correctly repositories for GitHub", {

  mockery::stub(
    test_github_priv$pull_repos_from_org,
    'private$pull_repos_contributors',
    readRDS("test_files/github_repos_contributors.rds")
  )

  mockery::stub(
    test_github_priv$pull_repos_from_org,
    'private$pull_repos_issues',
    readRDS("test_files/github_repos_issues.rds")
  )

  pulled_repos_list <-
    test_github_priv$pull_repos_from_org(org = "r-world-devs")

  expect_type(
    pulled_repos_list,
    "list"
  )

  expect_list_contains(
    pulled_repos_list,
    c("id", "name", "owner",
      "issues", "issues_open", "issues_closed",
      "contributors")
  )

})

test_gitlab <- GitLab$new(
  rest_api_url = "https://gitlab.com/api/v4",
  token = Sys.getenv("GITLAB_PAT"),
  orgs = c("erasmusmc-public-health")
)

test_gitlab_priv <- environment(test_gitlab$initialize)$private

test_that("`pull_repos_contributors()` adds contributors' statistics to repositories list", {
  repos_list <- readRDS("test_files/gitlab_repos_raw.rds")

  repos_list_with_contributors <-
    test_gitlab_priv$pull_repos_contributors(repos_list)

  expect_gt(length(repos_list_with_contributors[[1]]), length(repos_list[[1]]))
  expect_list_contains(repos_list_with_contributors, c("contributors"))
  expect_type(repos_list_with_contributors[[1]]$contributors, "character")
})

test_that("`pull_repos_issues()` adds issues statistics to repositories list", {
  repos_list <- readRDS("test_files/gitlab_repos_raw.rds")

  repos_list_with_issues <-
    test_gitlab_priv$pull_repos_issues(repos_list)

  expect_gt(length(repos_list_with_issues[[1]]), length(repos_list[[1]]))
  expect_list_contains(repos_list_with_issues, c("issues", "issues_open", "issues_closed"))
  expect_type(repos_list_with_issues[[1]]$issues, "integer")
  expect_type(repos_list_with_issues[[1]]$issues_open, "integer")
  expect_type(repos_list_with_issues[[1]]$issues_closed, "integer")
  purrr::walk(repos_list_with_issues, ~ expect_equal(.$issues, .$issues_open + .$issues_closed))
})

test_that("`pull_repos_from_org()` pulls correctly repositories for GitLab", {
  orgs <- test_gitlab$orgs

  mockery::stub(
    test_gitlab_priv$pull_repos_from_org,
    'private$pull_repos_contributors',
    readRDS("test_files/gitlab_repos_contributors.rds")
  )

  mockery::stub(
    test_gitlab_priv$pull_repos_from_org,
    'private$pull_repos_issues',
    readRDS("test_files/gitlab_repos_issues.rds")
  )

  purrr::walk(orgs, function(group) {
    repos_n <- length(get_response(
      endpoint = paste0("https://gitlab.com/api/v4/groups/", group),
      token = Sys.getenv("GITLAB_PAT")
    )[["projects"]])

    pulled_repos_list <-
      test_gitlab_priv$pull_repos_from_org(org = group)

    expect_equal(
      length(pulled_repos_list),
      repos_n
    )
  })
})
