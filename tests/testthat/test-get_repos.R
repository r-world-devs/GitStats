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

  test_gitstats$clients[[2]] <- GitLab$new(
    rest_api_url = "https://gitlab.com/api/v4",
    token = Sys.getenv("GITLAB_PAT"),
    orgs = "mbtests"
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

########## GitHub tests

test_github <- GitHub$new(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  orgs = "r-world-devs"
)

test_that("Getting repositories by teams works", {

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
            logins = "maciekbanas"
          )
        )
      )
  )
  expect_repos_table(result)

  expect_true(
    all(grepl("kalimu|maciekbanas", result$contributors))
  )
})

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

########## GitLab tests

test_gitlab <- GitLab$new(
  rest_api_url = "https://gitlab.com/api/v4",
  token = Sys.getenv("GITLAB_PAT"),
  orgs = c("erasmusmc-public-health", "mbtests")
)

test_that("`get_repos()` methods pulls repositories from GitLab and translates output into `data.frame`", {
  expect_snapshot(
    repos <-
      test_gitlab$get_repos(by = "org")
  )
  expect_repos_table(repos)

  expect_snapshot(
    repos <-
      test_gitlab$get_repos(by = "phrase",
                            phrase = "covid")
  )
  expect_repos_table(repos)
})

test_that("`get_repos()` throws empty tables for GitLab", {
  expect_snapshot(
    repos_R <-
      test_gitlab$get_repos(
        by = "org",
        language = "Ruby"
      )
  )
  expect_empty_table(repos_R)
})
