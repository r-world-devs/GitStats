test_gitstats <- create_gitstats()

test_that("Error appears when no orgs are specified when pulling repos", {

  suppressMessages(
    test_gitstats$clients[[1]] <- GitHub$new(
      rest_api_url = "https://api.github.com",
      token = Sys.getenv("GITHUB_PAT")
    )
  )

  expect_snapshot_error(
    get_repos(
      gitstats_obj = test_gitstats,
      by = "org"
    )
  )
})

test_that("`get_repos()` returns repos table", {

  test_gitstats$clients[[1]] <- GitHub$new(
    rest_api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT"),
    orgs = "r-world-devs"
  )

  expect_snapshot(
    get_repos(
      gitstats_obj = test_gitstats,
      print_out = FALSE
    )
  )

  expect_repos_table(test_gitstats$repos_dt)
})

test_that("Getting repos by language works correctly", {

  expect_snapshot(
    get_repos(
      gitstats_obj = test_gitstats,
      language = "Python",
      print_out = FALSE
    )
  )
})

test_that("Proper information pops out when one wants to get team stats without specifying team", {
  expect_error(
    get_repos(
      gitstats_obj = test_gitstats,
      by = "team"
    ),
    "You have to specify a team first"
  )
})

test_that("Proper information pops out when one wants to get stats by phrase without specifying phrase", {
  expect_snapshot(
    error = TRUE,
    get_repos(
      gitstats_obj = test_gitstats,
      by = "phrase"
    )
  )
})

test_that("Getting repositories by teams works", {
  test_github <- GitHub$new(
    rest_api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT"),
    orgs = "r-world-devs"
  )
  mockery::stub(
    test_github$get_repos,
    'private$pull_repos_from_org',
    readRDS("test_files/github_repos_table.rds")
  )
  expect_snapshot(
    result <- test_github$get_repos(
        by = "team",
        team = list(
          "Member1" = list(
            logins = "kalimu"
          ),
          "Member2" = list(
            logins = "epijim"
          )
        )
      )
  )
  expect_repos_table(result)

  expect_true(
    all(grepl("kalimu|epijim", result$contributors))
  )
})

test_gitlab <- GitLab$new(
  rest_api_url = "https://gitlab.com/api/v4",
  token = Sys.getenv("GITLAB_PAT"),
  orgs = c("mbtests")
)

test_that("`get_repos()` methods pulls repositories from GitLab and translates output into `data.frame`", {
  expect_snapshot(
    repos <-
      test_gitlab$get_repos(by = "org")
  )
  expect_repos_table(repos)
})

test_that("`get_repos()` throws empty tables for GitLab", {
  expect_snapshot(
    repos_Python <-
      test_gitlab$get_repos(
        by = "org",
        language = "Python"
      )
  )
  expect_empty_table(repos_Python)
})

test_github <- GitHub$new(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  orgs = "r-world-devs"
)

test_that("`get_repos()` methods pulls repositories from GitHub and translates output into `data.frame`", {
  mockery::stub(
    test_github$get_repos,
    'private$pull_repos_from_org',
    readRDS("test_files/github_repos_table.rds")
  )

  expect_snapshot(
    repos <-
      test_github$get_repos(by = "org")
  )
  expect_repos_table(repos)
 })

test_that("`get_repos()` throws empty tables for GitHub", {

  expect_snapshot(
    repos_JS <-
      test_github$get_repos(
        by = "org",
        language = "Javascript"
      )
  )
  expect_empty_table(repos_JS)
})
