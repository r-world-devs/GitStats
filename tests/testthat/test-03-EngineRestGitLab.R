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

test_that("`search_repos_by_phrase()` works", {
  expect_snapshot(
    gl_repos_by_phrase <- test_rest_priv$search_repos_by_phrase(
      phrase = "covid",
      org = "erasmusmc-public-health"
    )
  )
  expect_list_contains(
    gl_repos_by_phrase[[1]],
    c("id", "description", "name", "created_at")
  )
  test_mock$mock(gl_repos_by_phrase)
})

test_that("`tailor_repos_info()` tailors precisely `repos_list`", {
  gl_repos_by_phrase <- test_mock$mocker$gl_repos_by_phrase

  gl_repos_by_phrase_tailored <-
    test_rest_priv$tailor_repos_info(gl_repos_by_phrase)

  gl_repos_by_phrase_tailored %>%
    expect_type("list") %>%
    expect_length(length(gl_repos_by_phrase))

  expect_list_contains_only(
    gl_repos_by_phrase_tailored[[1]],
    c("id", "name", "created_at", "last_activity_at", "last_push",
      "forks", "stars", "contributors", "issues_open", "issues_closed",
      "organization"))

  expect_lt(length(gl_repos_by_phrase_tailored[[1]]),
            length(gl_repos_by_phrase[[1]]))

  test_mock$mock(gl_repos_by_phrase_tailored)
})

test_that("`prepare_repos_table()` prepares repos table", {
  gl_repos_by_phrase_table <- test_rest_priv$prepare_repos_table(
    repos_list = test_mock$mocker$gl_repos_by_phrase_tailored
  )

  expect_repos_table(
    gl_repos_by_phrase_table
  )
  test_mock$mock(gl_repos_by_phrase_table)
})

test_that("`pull_commits_from_org()` pulls commits from repo", {

  gl_commits_repo_1 <- test_mock$mocker$gl_commits_rest_response_repo_1

  mockery::stub(
    test_rest_priv$pull_commits_from_org,
    'private$pull_commits_from_repo',
    gl_commits_repo_1
  )

  gl_commits_org <- test_rest_priv$pull_commits_from_org(
    repos_table = test_mock$mocker$gl_repos_table,
    date_from = "2023-01-01",
    date_until = "2023-04-20"
  )

  expect_gl_commit(
    gl_commits_org[[1]]
  )

  test_mock$mock(gl_commits_org)

})

test_that("`tailor_commits_info()` retrieves only necessary info", {

  gl_commits_list <- test_mock$mocker$gl_commits_org

  gl_commits_list_cut <- test_rest_priv$tailor_commits_info(
    gl_commits_list,
    org = "mbtests"
  )
  expect_tailored_commits_list(
    gl_commits_list_cut[[1]][[1]]
  )
})

# public methods

test_that("`get_repos_contributors()` adds contributors to repos table", {

  gl_repos_table <- test_rest$get_repos_contributors(
    test_mock$mocker$gl_repos_table
  )
  expect_gt(
    length(gl_repos_table$contributors),
    0
  )
  test_mock$mock(gl_repos_table)
})


test_that("`get_repos_issues()` adds issues to repos table", {

  gl_repos_by_phrase_table <- test_mock$mocker$gl_repos_by_phrase_table

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
  test_mock$mock(gl_repos_by_phrase_table)
})
