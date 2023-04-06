test_gitstats <- create_gitstats()

test_that("`Set_storage()` passes information to `storage` field", {
  expect_null(test_gitstats$storage)

  set_storage(
    gitstats_obj = test_gitstats,
    type = "SQLite",
    dbname = "test_files/test_db"
  )

  expect_length(test_gitstats$storage, 1)
  expect_true(test_gitstats$use_storage)
  expect_s4_class(test_gitstats$storage, "SQLiteConnection")
})

test_gitstats_priv <- environment(test_gitstats$initialize)$private

test_commits <- data.frame(id = c("1", "2", "3"),
                           committed_date = as.POSIXct(c("2022-03-01", "2022-10-05", "2022-12-31")),
                           author = rep("author", 3),
                           additions = rep(as.integer(12), 3),
                           deletions = rep(as.integer(20), 3),
                           repository = rep("Test", 3),
                           organization = rep("r-world-devs", 3),
                           api_url = rep("https://api.github.com", 3))

commits_before <- readRDS("test_files/commits_before.rds")

test_that("`GitStats$save_storage()` saves table to db", {
  expect_snapshot(
    test_gitstats_priv$save_storage(test_commits,
                                    "test_commits")
  )
  expect_snapshot(
    test_gitstats_priv$save_storage(commits_before,
                                    "commits_by_org")
  )
})

test_commits_new <- data.frame(id = c("4", "5"),
                               committed_date = as.POSIXct(c("2023-01-01", "2023-02-03")),
                               author = rep("author", 2),
                               additions = rep(as.integer(15), 2),
                               deletions = rep(as.integer(8), 2),
                               repository = rep("Test", 2),
                               organization = rep("r-world-devs", 2),
                               api_url = rep("https://api.github.com", 2)
                              )

test_that("`GitStats$save_storage()` appends table to db", {
  expect_snapshot(
    test_gitstats_priv$save_storage(test_commits_new,
                                    "test_commits",
                                    append = TRUE)
  )
})

test_that("`GitStats$pull_storage()` retrieves table from db", {
  expect_commits_table(
    test_gitstats_priv$pull_storage("test_commits")
  )
})


test_that("`show_storage()` shows list of tables", {
  output <- show_storage(test_gitstats)
  expect_length(output, 2)
  expect_equal(nrow(output), 2)
  expect_true(grepl("test_commits", output$table[2]))
  expect_true(grepl("commits_by_org", output$table[1]))
})

test_that("`GitStats$check_storage_table()` finds table in db", {

  expect_true(
    test_gitstats_priv$check_storage_table("test_commits")
  )
})

test_that("`GitStats$check_storage()` finds tables in db", {
  expect_snapshot(
    test_gitstats_priv$check_storage("test_commits")
  )
})

test_that("`GitStats$check_storage()` does not find table in db", {
  expect_snapshot(
    test_gitstats_priv$check_storage("test_table_non_existent")
  )
})

test_that("`GitStats$check_storage_clients()` finds clients (api urls) in db and returns output (table)", {
  test_gitstats$clients[[1]] <- TestClient$new(
    rest_api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT"),
    orgs = "r-world-devs"
  )
  expect_snapshot(
    test_gitstats_priv$check_storage_clients(test_commits)
  )
})

test_that("`GitStats$check_storage_clients()` does not find all clients (api urls) in db", {
  test_gitstats$clients[[2]] <- TestClient$new(
    rest_api_url = "https://gitlab.com/api/v4",
    token = Sys.getenv("GITLAB_PAT"),
    orgs = "mbtests"
  )
  expect_snapshot(
    test_gitstats_priv$check_storage_clients(test_commits)
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
    test_gitstats_priv$check_storage_clients(test_commits)
  )
})

test_that("`GitStats$check_storage()` finds table, but does not find clients", {
  expect_snapshot(
    test_gitstats_priv$check_storage("test_commits")
  )
})

test_that("`GitStats$check_storage_orgs()` finds organizations in db and returns output (table)", {
  test_gitstats$clients[[1]] <- TestClient$new(
    rest_api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT"),
    orgs = "r-world-devs"
  )
  expect_snapshot(
    test_gitstats_priv$check_storage_orgs(test_commits)
  )
})

test_that("`GitStats$check_storage_orgs()` does not find all organizations in db", {
  test_gitstats$clients[[1]] <- TestClient$new(
    rest_api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT"),
    orgs = c("r-world-devs", "openpharma")
  )

  expect_snapshot(
    test_gitstats_priv$check_storage_orgs(test_commits)
  )
})

test_that("`GitStats$check_storage_orgs()` finds none of organizations in db", {
  test_gitstats$clients[[1]] <- TestClient$new(
    rest_api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT"),
    orgs = "openpharma"
  )

  expect_snapshot(
    test_gitstats_priv$check_storage_orgs(test_commits)
  )
})

test_that("`GitStats$check_storage()` finds table, but does not find orgs", {
  expect_snapshot(
    test_gitstats_priv$check_storage("test_commits")
  )
})

test_gitstats$clients <- list()
test_gitstats$clients[[1]] <- GitHub$new(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  orgs = c("r-world-devs")
)

test_that("When storage is set, `GitStats` saves pulled repos to database", {

  expect_snapshot(
    test_gitstats %>%
      get_repos(print_out = FALSE)
  )

  gitstats_priv <- environment(test_gitstats$initialize)$private

  saved_output <- gitstats_priv$pull_storage(name = "repos_by_org")

  expect_repos_table(saved_output)

  expect_equal(
    test_gitstats$repos_dt,
    saved_output
  )
  DBI::dbRemoveTable(conn = test_gitstats$storage,
                     "repos_by_org")
})

test_that("Switching storage on and off works", {

  expect_snapshot(
    test_gitstats %>%
      storage_off()
  )
  expect_false(test_gitstats$use_storage)

  test_gitstats %>%
    storage_on()
  expect_true(test_gitstats$use_storage)
})

test_that("When storage is set and table stores commits, it pulls from API only
  recent commits and then appends to the database only these new ones.", {

  mockery::stub(
    test_gitstats$get_commits,
    'private$save_storage',
    NULL
  )

  act_msgs <- testthat::capture_messages({
    test_gitstats$get_commits(
      date_from = "2022-11-01",
      date_until = "2023-02-01",
      by = "org",
      print_out = FALSE
    )
  })

  exp_msgs <- c(
    "`commits_by_org` is stored in your local database",
    "Clients already in database table",
    "Organizations already in database table",
    "Only commits created since 2022-12-20 16:09:26 will be pulled from API."
  )

  purrr::walk(exp_msgs, ~expect_match(act_msgs, ., all = FALSE))

  commits_after <- test_gitstats$commits_dt
  diff_rows <- nrow(commits_after) - nrow(commits_before)

  expect_gt(diff_rows, 0)

  # expect no duplicates of commits (the dates from are set correctly)
  expect_equal(length(unique(commits_after$id)), nrow(commits_after))

  DBI::dbDisconnect(
    conn = test_gitstats$storage
  )
})
