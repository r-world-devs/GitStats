test_gitstats <- create_gitstats()

test_that("`get_repos()` returns repos table", {

  test_gitstats$clients[[1]] <- GitHub$new(
    rest_api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT"),
    orgs = "r-world-devs"
  )

  mockery::stub(
    get_repos,
    'private$pull_repos_from_org',
    readRDS("test_files/github_repos_by_org.rds")
  )

  expect_message(
    get_repos(
      gitstats_obj = test_gitstats,
      print_out = FALSE
    ),
    "Pulling repositories..."
  )

  expect_repos_table(test_gitstats$repos_dt)
})


test_that("Getting repos by phrase and language works correctly", {

  test_gitstats$clients[[1]] <- GitHub$new(
    rest_api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT"),
    orgs = "pharmaverse"
  )

  mockery::stub(
    get_repos,
    'private$search_by_keyword',
    readRDS("test_files/pulled_repos_by_lang.rds")
  )

  expect_snapshot(
    get_repos(
      gitstats_obj = test_gitstats,
      by = "phrase",
      phrase = "covid",
      language = "R",
      print_out = FALSE
    )
  )
  expect_repos_table(test_gitstats$repos_dt)

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

test_that("`get_repos()` by team in case when no `orgs` are specified pulls organizations first, then repos", {

  suppressMessages(
    test_gitstats$clients[[1]] <- GitHub$new(
      rest_api_url = "https://api.github.com",
      token = Sys.getenv("GITHUB_PAT")
    )
  )

  expect_snapshot(
    test_gitstats %>%
      set_team(
        team_name = "RWD-IE",
        "galachad",
        "kalimu",
        "maciekbanas",
        "Cotau",
        "krystian8207",
        "marcinkowskak"
      ) %>%
      get_repos(
        by = "team",
        print_out = FALSE
      )
  )
  expect_repos_table(test_gitstats$repos_dt)
})

test_gitlab <- GitLab$new(
  rest_api_url = "https://gitlab.com/api/v4",
  token = Sys.getenv("GITLAB_PAT"),
  orgs = c("mbtests")
)

test_that("`get_repos()` methods pulls repositories from GitLab and translates output into `data.frame`", {
  mockery::stub(
    test_gitlab$get_repos,
    'private$pull_repos_from_org',
    readRDS("test_files/gitlab_repos_by_org.rds")
  )

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
    readRDS("test_files/github_repos_by_org.rds")
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
