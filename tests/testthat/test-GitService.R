git_hub <- GitService$new(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  orgs = c("openpharma", "pharmaverse", "insightsengineering")
)

github_env <- environment(git_hub$initialize)$private

git_lab <- GitService$new(
  rest_api_url = "https://gitlab.com/api/v4",
  token = Sys.getenv("GITLAB_PAT"),
  orgs = c("mbtests")
)

gitlab_env <- environment(git_lab$initialize)$private

test_that("Private `check_git_service()` properly identifies GitHub and GitLab", {
  urls <- c("https://api.github.com", "https://github.enterprise.com", "https://gitlab.com/api/v4", "https://code.enterprise.com")
  services <- c(rep("GitHub", 2), rep("GitLab", 2))

  purrr::walk2(urls, services, function(url, service) {
    expect_equal(
      github_env$check_git_service(api_url = url),
      service
    )
  })
})

test_that("Private `find_by_ids()` returns proper repo list", {
  ids <- c("208896481", "402384343", "483601371")
  names <- c("visR", "DataFakeR", "shinyGizmo")

  result <- github_env$find_by_id(
    ids = ids,
    objects = "repositories"
  )

  expect_type(result, "list")

  expect_equal(purrr::map_chr(result, ~ .$name), names)
})

test_that("Organizations are correctly checked if they exist", {

  expect_message(
    github_env$check_orgs(c("openparma", "r-world-devs")),
    "Organization you provided does not exist. Check spelling in: openparma"
  )

  expect_message(
    gitlab_env$check_orgs("openparma"),
    "Organization you provided does not exist. Check spelling in: openparma"
  )

})

test_that("GraphQL API is set correctly", {

  expect_s3_class(git_hub$gql_query, "GraphQLQuery")
  expect_s3_class(git_hub$gql_query, "R6")

})
