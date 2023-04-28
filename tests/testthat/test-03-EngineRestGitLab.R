test_rest <- EngineRestGitLab$new(
  rest_api_url = "https://gitlab.com/api/v4",
  token = Sys.getenv("GITLAB_PAT_PUBLIC")
)

# private methods

test_rest_priv <- environment(test_rest$initialize)$private

test_that("`get_group_id()` gets group's id", {
  gl_group_id <- test_rest_priv$get_group_id("mbtests")
  expect_equal(gl_group_id, 63684059)
})

test_that("`find_repos_by_id()` works", {

  gl_search_response <- test_mocker$use("gl_search_response")
  gl_search_repos_by_phrase <- test_rest_priv$find_repos_by_id(
    gl_search_response
  )
  expect_gl_repos(
    gl_search_repos_by_phrase
  )
  test_mocker$cache(gl_search_repos_by_phrase)
})

test_that("`pull_repos_languages` works", {

  repos_list <- test_mocker$use("gl_search_repos_by_phrase")
  repos_list[[1]]$id <- "45300912"
  repos_list_with_languages <- test_rest_priv$pull_repos_languages(
    repos_list = repos_list
  )
  expect_list_contains(
    repos_list_with_languages[[1]],
    "languages"
  )
})

test_that("`search_repos_by_phrase()` works", {
  gl_repos_by_phrase <- test_rest_priv$search_repos_by_phrase(
    phrase = "covid",
    org = "erasmusmc-public-health"
  )
  expect_list_contains(
    gl_repos_by_phrase[[1]],
    c("id", "description", "name", "created_at", "languages")
  )
  test_mocker$cache(gl_repos_by_phrase)
})

test_that("`tailor_repos_info()` tailors precisely `repos_list`", {
  gl_repos_by_phrase <- test_mocker$use("gl_repos_by_phrase")

  gl_repos_by_phrase_tailored <-
    test_rest_priv$tailor_repos_info(gl_repos_by_phrase)

  gl_repos_by_phrase_tailored %>%
    expect_type("list") %>%
    expect_length(length(gl_repos_by_phrase))

  expect_list_contains_only(
    gl_repos_by_phrase_tailored[[1]],
    c("id", "name", "created_at", "last_activity_at", "last_push",
      "forks", "stars", "contributors", "languages", "issues_open",
      "issues_closed", "organization"))

  expect_lt(length(gl_repos_by_phrase_tailored[[1]]),
            length(gl_repos_by_phrase[[1]]))

  test_mocker$cache(gl_repos_by_phrase_tailored)
})

test_that("`prepare_repos_table()` prepares repos table", {
  gl_repos_by_phrase_table <- test_rest_priv$prepare_repos_table(
    repos_list = test_mocker$use("gl_repos_by_phrase_tailored")
  )

  expect_repos_table(
    gl_repos_by_phrase_table
  )
  test_mocker$cache(gl_repos_by_phrase_table)
})

test_that("`pull_commits_from_org()` pulls commits from repo", {

  gl_commits_repo_1 <- test_mocker$use("gl_commits_rest_response_repo_1")

  mockery::stub(
    test_rest_priv$pull_commits_from_org,
    'private$pull_commits_from_repo',
    gl_commits_repo_1
  )

  gl_commits_org <- test_rest_priv$pull_commits_from_org(
    repos_table = test_mocker$use("gl_repos_by_phrase_table"),
    date_from = "2023-01-01",
    date_until = "2023-04-20"
  )
  expect_gl_commit(
    gl_commits_org[[1]]
  )
  test_mocker$cache(gl_commits_org)
})

test_that("`filter_commits_by_team()` filters commits by team", {

  gl_commits_org <- test_mocker$use("gl_commits_org")

  team = list(
    "Member1" = list(
      name = "Maciej Banaś",
      logins = "maciekbanas"
    )
  )

  gl_commits_team <- test_rest_priv$filter_commits_by_team(
    repos_list_with_commits = gl_commits_org,
    team = team
  )

  expect_gl_commit(
    gl_commits_team[[1]]
  )

  test_mocker$cache(gl_commits_team)

})

test_that("`tailor_commits_info()` retrieves only necessary info", {

  gl_commits_list <- test_mocker$use("gl_commits_org")

  gl_commits_list_cut <- test_rest_priv$tailor_commits_info(
    gl_commits_list,
    org = "mbtests"
  )
  expect_tailored_commits_list(
    gl_commits_list_cut[[1]][[1]]
  )
  test_mocker$cache(gl_commits_list_cut)
})

test_that("`prepare_commits_table()` prepares table of commits properly", {

  gl_commits_table <- test_rest_priv$prepare_commits_table(
    commits_list = test_mocker$use("gl_commits_list_cut")
  )
  expect_commits_table(
    gl_commits_table
  )
})

# public methods

test_that("`get_repos_contributors()` adds contributors to repos table", {

  gl_repos_table <- test_rest$get_repos_contributors(
    test_mocker$use("gl_repos_by_phrase_table")
  )
  expect_gt(
    length(gl_repos_table$contributors),
    0
  )
  test_mocker$cache(gl_repos_table)
})


test_that("`get_repos_issues()` adds issues to repos table", {

  gl_repos_by_phrase_table <- test_mocker$use("gl_repos_table")

  gl_repos_by_phrase_table <- test_rest$get_repos_issues(
    gl_repos_by_phrase_table
  )
  expect_gt(
    length(gl_repos_by_phrase_table$issues_open),
    0
  )
  expect_gt(
    length(gl_repos_by_phrase_table$issues_closed),
    0
  )
  test_mocker$cache(gl_repos_by_phrase_table)
})

test_that("`get_repos_by_phrase()` works", {

  mockery::stub(
    test_rest$get_repos,
    "private$search_repos_by_phrase",
    test_mocker$use("gl_repos_by_phrase")
  )

  settings <- list(
    search_param = "phrase",
    phrase = "covid"
  )
  expect_snapshot(
    result <- test_rest$get_repos(
      org = "erasmusmc-public-health",
      settings = settings
    )
  )
  expect_repos_table(result)

})

test_that("`get_commits()` works as expected", {

  mockery::stub(
    test_rest$get_commits,
    "private$pull_commits_from_org",
    test_mocker$use("gl_commits_org")
  )
  settings <- list(
    search_param = "org"
  )
  expect_snapshot(
    result <- test_rest$get_commits(
      org = "mbtests",
      date_from = "2023-01-01",
      date_until = "2023-04-20",
      settings = settings
    )
  )
  expect_commits_table(result)
})
