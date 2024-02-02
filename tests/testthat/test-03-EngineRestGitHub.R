test_rest <- EngineRestGitHub$new(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT")
)

# private methods

test_rest_priv <- environment(test_rest$initialize)$private

test_that("`check_token()` prints error when token exists but does not grant access", {
  token <- "does_not_grant_access"
  expect_snapshot_error(
    test_rest_priv$check_token(token)
  )
})

test_that("when token is proper token is passed", {
  expect_equal(
    test_rest_priv$check_token(Sys.getenv("GITHUB_PAT")),
    Sys.getenv("GITHUB_PAT")
  )
})

test_that("`search_response()` performs search with limit under 100", {
  total_n <- test_mocker$use("gh_search_response")[["total_count"]]

  mockery::stub(
    test_rest_priv$search_response,
    "private$rest_response",
    test_mocker$use("gh_search_response")
  )
  gh_search_repos_response <- test_rest_priv$search_response(
    search_endpoint = test_mocker$use("search_endpoint"),
    total_n = total_n,
    byte_max = 384000
  )

  expect_gh_search_response(
    gh_search_repos_response[[1]]
  )
  test_mocker$cache(gh_search_repos_response)
})

test_that("Private `find_by_id()` works", {
  result <- test_rest_priv$find_repos_by_id(
    repos_list = test_mocker$use("gh_search_repos_response")
  )
  expect_list_contains(
    result[[1]],
    c("id", "node_id", "name", "full_name")
  )
})

test_that("`search_repos_by_phrase()` for GitHub prepares a list of repositories", {
  mockery::stub(
    test_rest_priv$search_repos_by_phrase,
    "private$search_response",
    test_mocker$use("gh_search_repos_response")
  )
  gh_repos_by_phrase <- test_rest_priv$search_repos_by_phrase(
    phrase = "shiny",
    org = "openpharma",
    files = NULL,
    language = "All"
  )
  expect_gh_search_response(
    gh_repos_by_phrase[[1]]
  )
  test_mocker$cache(gh_repos_by_phrase)
})

test_that("`search_repos_by_phrase()` filters responses for specific files in GitHub", {
  gh_repos_by_phrase <- test_rest_priv$search_repos_by_phrase(
    phrase = "shiny",
    org = "openpharma",
    files = "DESCRIPTION",
    language = "All"
  )
  purrr::walk(gh_repos_by_phrase, function(repo) {
    expect_gh_search_response(repo)
  })
})

test_that("`tailor_repos_info()` tailors precisely `repos_list`", {
  gh_repos_by_phrase <- test_mocker$use("gh_repos_by_phrase")

  gh_repos_by_phrase_tailored <-
    test_rest_priv$tailor_repos_info(gh_repos_by_phrase)

  gh_repos_by_phrase_tailored %>%
    expect_type("list") %>%
    expect_length(length(gh_repos_by_phrase))

  expect_list_contains_only(
    gh_repos_by_phrase_tailored[[1]],
    c(
      "repo_id", "repo_name", "created_at", "last_activity_at",
      "forks", "stars", "issues_open", "issues_closed",
      "organization"
    )
  )

  expect_lt(
    length(gh_repos_by_phrase_tailored[[1]]),
    length(gh_repos_by_phrase[[1]])
  )

  test_mocker$cache(gh_repos_by_phrase_tailored)
})

test_that("`prepare_repos_table()` prepares repos table", {
  gh_repos_by_phrase_table <- test_rest_priv$prepare_repos_table(
    repos_list = test_mocker$use("gh_repos_by_phrase_tailored")
  )
  expect_repos_table(
    gh_repos_by_phrase_table
  )
  test_mocker$cache(gh_repos_by_phrase_table)
})

test_that("`pull_repos_issues()` adds issues to repos table", {
  gh_repos_by_phrase_table <- test_mocker$use("gh_repos_by_phrase_table")

  gh_repos_by_phrase_table <- test_rest_priv$pull_repos_issues(
    gh_repos_by_phrase_table
  )
  expect_gt(
    length(gh_repos_by_phrase_table$issues_open),
    0
  )
  expect_gt(
    length(gh_repos_by_phrase_table$issues_closed),
    0
  )
  test_mocker$cache(gh_repos_by_phrase_table)
})

test_that("`paginate_results()` pulls all commits from repository", {
  commits_endpoint <- paste0(
    "https://api.github.com/repos/r-world-devs/GitStats/commits?since=",
    date_to_gts("2023-01-01"),
    "&until=",
    date_to_gts("2023-06-01")
  )
  commits_from_repo <- test_rest_priv$paginate_results(
    endpoint = commits_endpoint
  )
  expect_gh_commit_rest_response(
    commits_from_repo
  )
})

test_that("`pull_commits_from_org()` pulls all commits from organization", {
  suppressMessages({
    gh_rest_commits_from_org <- test_rest_priv$pull_commits_from_org(
      repos_table = test_mocker$use("gh_repos_table"),
      date_from = "2023-01-01",
      date_until = "2023-06-01"
    )
  })
  expect_gh_commit_rest_response(
    gh_rest_commits_from_org[[1]]
  )
  test_mocker$cache(gh_rest_commits_from_org)
})

test_that("`filter_commits_by_team()` filters properly commits by team members", {
  gh_rest_team_commits <- test_rest_priv$filter_commits_by_team(
    repos_list_with_commits = test_mocker$use("gh_rest_commits_from_org"),
    team = test_team
  )
  expect_gh_commit_rest_response(
    gh_rest_team_commits[[1]]
  )
  expect_true(
    length(gh_rest_team_commits) < length(test_mocker$use("gh_rest_commits_from_org"))
  )
  test_mocker$cache(gh_rest_team_commits)
})

test_that("`tailor_commits_info()` tailors commits list (by org and team)", {
  gh_rest_tailored_commits_list <- test_rest_priv$tailor_commits_info(
    repos_list_with_commits = test_mocker$use("gh_rest_commits_from_org"),
    org = "r-world-devs"
  )
  expect_tailored_commits_list(
    gh_rest_tailored_commits_list[[1]][[1]]
  )
  test_mocker$cache(gh_rest_tailored_commits_list)
  gh_rest_tailored_commits_list_team <- test_rest_priv$tailor_commits_info(
    repos_list_with_commits = test_mocker$use("gh_rest_team_commits"),
    org = "r-world-devs"
  )
  expect_tailored_commits_list(
    gh_rest_tailored_commits_list_team[[1]][[1]]
  )
  test_mocker$cache(gh_rest_tailored_commits_list_team)
})

test_that("`prepare_commits_table()` prepares commits table (for orgs and for teams)", {
  gh_rest_commits_table <- test_rest_priv$prepare_commits_table(
    commits_list = test_mocker$use("gh_rest_tailored_commits_list")
  )
  expect_commits_table(gh_rest_commits_table, with_stats = FALSE)
  test_mocker$cache(gh_rest_commits_table)

  gh_rest_commits_table_team <- test_rest_priv$prepare_commits_table(
    commits_list = test_mocker$use("gh_rest_tailored_commits_list_team")
  )
  expect_commits_table(gh_rest_commits_table_team, with_stats = FALSE)
  test_mocker$cache(gh_rest_commits_table_team)
})

test_that("`pull_commits_stats()` works as expected", {
  expect_snapshot(
    gh_rest_commits_table_with_stats <- test_rest_priv$pull_commits_stats(
      commits_table = test_mocker$use("gh_rest_commits_table")[1:5,]
    )
  )
  expect_commits_table(gh_rest_commits_table_with_stats)
  test_mocker$cache(gh_rest_commits_table_with_stats)
})

# public methods

test_that("`pull_repos_contributors()` adds contributors to repos table", {
  expect_snapshot(
    gh_repos_by_phrase_table <- test_rest$pull_repos_contributors(
      test_mocker$use("gh_repos_by_phrase_table")
    )
  )
  expect_repos_table(
    gh_repos_by_phrase_table,
    add_col = "contributors"
  )
  expect_gt(
    length(gh_repos_by_phrase_table$contributors),
    0
  )
  test_mocker$cache(gh_repos_by_phrase_table)
})

test_that("`pull_repos()` works", {
  mockery::stub(
    test_rest$pull_repos,
    "private$search_repos_by_phrase",
    test_mocker$use("gh_repos_by_phrase")
  )

  test_settings[["search_param"]] <- "phrase"
  test_settings[["phrase"]] <- "shiny"

  expect_snapshot(
    result <- test_rest$pull_repos(
      org = "r-world-devs",
      settings = test_settings
    )
  )

  expect_repos_table(result)
})

test_that("supportive method for getting commits works", {
  mockery::stub(
    test_rest$pull_commits_supportive,
    "self$pull_repos_supportive",
    test_mocker$use("gh_repos_table")
  )
  mockery::stub(
    test_rest$pull_commits_supportive,
    "private$pull_commits_from_org",
    test_mocker$use("gh_rest_commits_from_org")
  )
  mockery::stub(
    test_rest$pull_commits_supportive,
    "private$pull_commits_stats",
    test_mocker$use("gh_rest_commits_table_with_stats")
  )
  expect_snapshot(
    gh_rest_commits_table <- test_rest$pull_commits_supportive(
      org = "r-world-devs",
      date_from = "2023-01-01",
      date_until = "2023-07-01",
      settings = test_settings
    )
  )
  expect_commits_table(
    gh_rest_commits_table
  )
})
