git_hub <- GitService$new(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  orgs = c("openpharma", "pharmaverse", "insightsengineering")
)

github_env <- environment(git_hub$initialize)$private

test_that("Private check_git_service properly identifies GitHub and GitLab", {

  urls <- c("https://api.github.com", "https://github.enterprise.com", "https://gitlab.com/api/v4", "https://code.enterprise.com")
  services <- c(rep("GitHub", 2), rep("GitLab", 2))

  purrr::walk2(urls, services, function(url, service) {
    expect_equal(github_env$check_git_service(api_url = url),
                 service)
  })

})

test_that("Private pull_repos_from_org pulls correctly repositories for GitHub", {

  orgs <- git_hub$orgs

  purrr::walk(orgs, function(org) {
    repos_n <- get_response(
      endpoint = paste0("https://api.github.com/orgs/", org),
      token = Sys.getenv("GITHUB_PAT")
    )[["public_repos"]]

    expect_equal(
      length(github_env$pull_repos_from_org(org = org)),
      repos_n
    )
  })
})

test_that("Private pull_repos_from_org pulls correctly repositories for GitLab", {
  testthat::skip_on_ci()

  git_lab <- GitService$new(
    rest_api_url = "https://gitlab.com/api/v4",
    token = Sys.getenv("GITLAB_PAT"),
    orgs = c("erasmusmc-public-health")
  )

  gitlab_env <- environment(git_lab$initialize)$private

  orgs <- git_lab$orgs

  purrr::walk(orgs, function(group) {
    repos_n <- length(get_response(
      endpoint = paste0("https://gitlab.com/api/v4/groups/", group),
      token = Sys.getenv("GITLAB_PAT")
    )[["projects"]])

    expect_equal(
      length(gitlab_env$pull_repos_from_org(org = group)),
      repos_n
    )
  })
})

test_that("Private find_by_ids returns proper repo list", {
  ids <- c("208896481", "402384343", "483601371")
  names <- c("visR", "DataFakeR", "shinyGizmo")

  result <- github_env$find_by_id(ids = ids,
                                  objects = "repositories")

  expect_type(result, "list")

  expect_equal(purrr::map_chr(result, ~.$name), names)
})
