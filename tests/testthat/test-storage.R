test_gitstats <- create_gitstats()

test_that("`Set_storage()` passes information to `storage` field", {
  expect_null(test_gitstats$storage)

  set_storage(
    gitstats_obj = test_gitstats,
    type = "SQLite",
    dbname = "storage/test_db.sqlite"
  )

  expect_length(test_gitstats$storage, 1)
  expect_true(test_gitstats$use_storage)
  expect_s4_class(test_gitstats$storage, "SQLiteConnection")
})

test_gitstats_priv <- environment(test_gitstats$initialize)$private

test_table <- data.frame(id = c("1", "2", "3"),
                         organisation = rep("r-world-devs", 3),
                         repository = rep("Test", 3),
                         api_url = rep("https://api.github.com", 3))

DBI::dbWriteTable(conn = test_gitstats$storage,
                  name = "test_table",
                  value = test_table,
                  overwrite = TRUE)

test_that("`GitStats$check_storage()` finds tables in db", {
  expect_snapshot(
    test_gitstats_priv$check_storage("test_table")
  )
})

test_that("`GitStats$check_storage()` does not find table in db", {
  expect_snapshot(
    test_gitstats_priv$check_storage("test_table_non_existent")
  )
})

test_that("`GitStats$check_storage_clients()` finds clients (api urls) in db", {
  test_gitstats$clients[[1]] <- TestClient$new(
    rest_api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT"),
    orgs = "r-world-devs"
  )
  expect_snapshot(
    test_gitstats_priv$check_storage_clients(test_table)
  )
})

test_that("`GitStats$check_storage_clients()` does not find all clients (api urls) in db", {
  test_gitstats$clients[[2]] <- TestClient$new(
    rest_api_url = "https://gitlab.com/api/v4",
    token = Sys.getenv("GITLAB_PAT"),
    orgs = "mbtests"
  )
  expect_snapshot(
    test_gitstats_priv$check_storage_clients(test_table)
  )
})

test_that("`GitStats$check_storage_clients()` finds none of clients (api urls) in db", {
  test_gitstats$clients <- list()
  test_gitstats$clients[[1]] <- TestClient$new(
    rest_api_url = "https://gitlab.com/api/v4",
    token = Sys.getenv("GITLAB_PAT"),
    orgs = "mbtests"
  )
  expect_snapshot(
    test_gitstats_priv$check_storage_clients(test_table)
  )
})

test_that("`GitStats$check_storage()` finds table, but does not find clients", {
  expect_snapshot(
    test_gitstats_priv$check_storage("test_table")
  )
})

test_that("`GitStats$check_storage_orgs()` finds organizations in db", {
  test_gitstats$clients[[1]] <- TestClient$new(
    rest_api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT"),
    orgs = "r-world-devs"
  )
  expect_snapshot(
    test_gitstats_priv$check_storage_orgs(test_table)
  )
})

test_that("`GitStats$check_storage_orgs()` does not find all organizations in db", {
  test_gitstats$clients[[1]] <- TestClient$new(
    rest_api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT"),
    orgs = c("r-world-devs", "openpharma")
  )

  expect_snapshot(
    test_gitstats_priv$check_storage_orgs(test_table)
  )
})

test_that("`GitStats$check_storage_orgs()` finds none of organizations in db", {
  test_gitstats$clients[[1]] <- TestClient$new(
    rest_api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT"),
    orgs = "openpharma"
  )

  expect_snapshot(
    test_gitstats_priv$check_storage_orgs(test_table)
  )
})

test_that("`GitStats$check_storage()` finds table, but does not find orgs", {
  expect_snapshot(
    test_gitstats_priv$check_storage("test_table")
  )
})

DBI::dbRemoveTable(conn = test_gitstats$storage,
                   name = "test_table")

# test_that("When storage is set, `GitStats` saves pulled repos to database", {
#
#   tryCatch(
#     {
#       DBI::dbRemoveTable(
#         conn = test_gitstats$storage,
#         name = "repos_by_org"
#       )
#     },
#     error = function(e) message("`repos_by_org` not found in db.")
#   )
#
#   test_gitstats %>%
#     get_repos(print_out = FALSE)
#
#   gitstats_priv <- environment(test_gitstats$initialize)$private
#
#   saved_output <- gitstats_priv$pull_storage(name = "repos_by_org")
#
#   expect_repos_table(saved_output)
#
#   expect_equal(
#     test_gitstats$repos_dt,
#     saved_output
#   )
# })
#
# test_that("When storage is set, `GitStats` with `get_commits()` first saves tables, pulls all given commits
#   and saves them to table.", {
#
#   tryCatch(
#     {
#       DBI::dbRemoveTable(
#         conn = test_gitstats$storage,
#         name = "commits_by_org"
#       )
#     },
#     error = function(e) message("`commits_by_org` not found in db.")
#   )
#
#   testthat::expect_snapshot(test_gitstats %>%
#                               get_commits(
#                                 date_from = "2022-12-01",
#                                 date_until = "2022-12-31",
#                                 print_out = FALSE
#                               ))
#
#   gitstats_priv <- environment(test_gitstats$initialize)$private
#   commits_before <- gitstats_priv$pull_storage("commits_by_org")
#
#   expect_commits_table(commits_before)
#
#   expect_equal(
#     test_gitstats$commits_dt,
#     commits_before
#   )
# })
#
# test_that("When storage is set and table stores commits, it pulls from API only recent commits
#   and then appends to the database only these new ones.", {
#
#   gitstats_priv <- environment(test_gitstats$initialize)$private
#   commits_before <- gitstats_priv$pull_storage("commits_by_org")
#
#   expect_snapshot(test_gitstats %>%
#           get_commits(
#             date_from = "2022-10-01",
#             print_out = FALSE
#           ))
#
#   commits_after <- gitstats_priv$pull_storage("commits_by_org")
#
#   diff_rows <- nrow(commits_after) - nrow(commits_before)
#
#   expect_gt(diff_rows, 0)
#
#   # expect no duplicates of commits (the dates from are set correctly)
#   expect_equal(length(unique(commits_after$id)), nrow(commits_after))
# })
