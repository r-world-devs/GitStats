# get_date_gaps ----------------------------------------------------------------

test_that("get_date_gaps returns gap when extending forward", {
  test_gitstats <- create_test_gitstats(hosts = 1, priv_mode = TRUE)
  gaps <- test_gitstats$get_date_gaps(
    stored_range = c("2024-01-01", "2024-06-30"),
    requested_range = c("2024-01-01", "2024-12-31")
  )
  expect_length(gaps, 1)
  expect_equal(gaps[[1]]$since, "2024-07-01")
  expect_equal(gaps[[1]]$until, "2024-12-31")
})

test_that("get_date_gaps returns gap when extending backward", {
  test_gitstats <- create_test_gitstats(hosts = 1, priv_mode = TRUE)
  gaps <- test_gitstats$get_date_gaps(
    stored_range = c("2024-06-01", "2024-12-31"),
    requested_range = c("2024-01-01", "2024-12-31")
  )
  expect_length(gaps, 1)
  expect_equal(gaps[[1]]$since, "2024-01-01")
  expect_equal(gaps[[1]]$until, "2024-05-31")
})

test_that("get_date_gaps returns two gaps when extending both directions", {
  test_gitstats <- create_test_gitstats(hosts = 1, priv_mode = TRUE)
  gaps <- test_gitstats$get_date_gaps(
    stored_range = c("2024-04-01", "2024-09-30"),
    requested_range = c("2024-01-01", "2024-12-31")
  )
  expect_length(gaps, 2)
  expect_equal(gaps[[1]]$since, "2024-01-01")
  expect_equal(gaps[[1]]$until, "2024-03-31")
  expect_equal(gaps[[2]]$since, "2024-10-01")
  expect_equal(gaps[[2]]$until, "2024-12-31")
})

test_that("get_date_gaps returns empty when requested is within stored", {
  test_gitstats <- create_test_gitstats(hosts = 1, priv_mode = TRUE)
  gaps <- test_gitstats$get_date_gaps(
    stored_range = c("2024-01-01", "2024-12-31"),
    requested_range = c("2024-03-01", "2024-09-30")
  )
  expect_length(gaps, 0)
})

test_that("get_date_gaps returns empty when ranges are identical", {
  test_gitstats <- create_test_gitstats(hosts = 1, priv_mode = TRUE)
  gaps <- test_gitstats$get_date_gaps(
    stored_range = c("2024-01-01", "2024-12-31"),
    requested_range = c("2024-01-01", "2024-12-31")
  )
  expect_length(gaps, 0)
})

# Incremental get_commits ------------------------------------------------------

test_that("get_commits fetches only missing date range", {
  test_gitstats <- create_test_gitstats(hosts = 1)
  priv <- test_gitstats$.__enclos_env__$private

  stored_commits <- dplyr::tibble(
    repo_name = "test/repo",
    id = "abc123",
    committed_date = as.POSIXct("2024-03-15"),
    author = "author1",
    author_login = "author1",
    author_name = "Author One",
    additions = 10L,
    deletions = 5L,
    organization = "test_org",
    repo_url = "https://github.com/test/repo",
    api_url = "https://api.github.com"
  )
  class(stored_commits) <- c("gitstats_commits", class(stored_commits))
  attr(stored_commits, "date_range") <- c("2024-01-01", "2024-06-30")
  priv$storage_backend$save("commits", stored_commits)

  new_commits <- dplyr::tibble(
    repo_name = "test/repo",
    id = "def456",
    committed_date = as.POSIXct("2024-09-15"),
    author = "author2",
    author_login = "author2",
    author_name = "Author Two",
    additions = 20L,
    deletions = 10L,
    organization = "test_org",
    repo_url = "https://github.com/test/repo",
    api_url = "https://api.github.com"
  )

  mockery::stub(
    test_gitstats$get_commits,
    "private$get_commits_from_hosts",
    new_commits
  )

  suppressMessages(
    result <- test_gitstats$get_commits(
      since = "2024-01-01",
      until = "2024-12-31",
      verbose = FALSE
    )
  )

  expect_equal(nrow(result), 2)
  expect_true("abc123" %in% result$id)
  expect_true("def456" %in% result$id)
  expect_equal(attr(result, "date_range"), c("2024-01-01", "2024-12-31"))
})

test_that("get_commits deduplicates by commit id", {
  test_gitstats <- create_test_gitstats(hosts = 1)
  priv <- test_gitstats$.__enclos_env__$private

  stored_commits <- dplyr::tibble(
    repo_name = "test/repo",
    id = c("abc123", "shared"),
    committed_date = as.POSIXct(c("2024-03-15", "2024-06-30")),
    author = "author1",
    author_login = "author1",
    author_name = "Author One",
    additions = 10L,
    deletions = 5L,
    organization = "test_org",
    repo_url = "https://github.com/test/repo",
    api_url = "https://api.github.com"
  )
  class(stored_commits) <- c("gitstats_commits", class(stored_commits))
  attr(stored_commits, "date_range") <- c("2024-01-01", "2024-06-30")
  priv$storage_backend$save("commits", stored_commits)

  new_commits <- dplyr::tibble(
    repo_name = "test/repo",
    id = c("shared", "def456"),
    committed_date = as.POSIXct(c("2024-06-30", "2024-09-15")),
    author = "author1",
    author_login = "author1",
    author_name = "Author One",
    additions = 10L,
    deletions = 5L,
    organization = "test_org",
    repo_url = "https://github.com/test/repo",
    api_url = "https://api.github.com"
  )

  mockery::stub(
    test_gitstats$get_commits,
    "private$get_commits_from_hosts",
    new_commits
  )

  suppressMessages(
    result <- test_gitstats$get_commits(
      since = "2024-01-01",
      until = "2024-12-31",
      verbose = FALSE
    )
  )

  expect_equal(nrow(result), 3)
  expect_equal(sum(result$id == "shared"), 1)
})

test_that("get_commits does full fetch when storage is empty", {
  test_gitstats <- create_test_gitstats(hosts = 1)

  fresh_commits <- dplyr::tibble(
    repo_name = "test/repo",
    id = "abc123",
    committed_date = as.POSIXct("2024-03-15"),
    author = "author1",
    author_login = "author1",
    author_name = "Author One",
    additions = 10L,
    deletions = 5L,
    organization = "test_org",
    repo_url = "https://github.com/test/repo",
    api_url = "https://api.github.com"
  )

  mockery::stub(
    test_gitstats$get_commits,
    "private$get_commits_from_hosts",
    fresh_commits
  )

  suppressMessages(
    result <- test_gitstats$get_commits(
      since = "2024-01-01",
      until = "2024-12-31",
      verbose = FALSE
    )
  )

  expect_equal(nrow(result), 1)
  expect_s3_class(result, "gitstats_commits")
})

test_that("get_commits does full fetch when cache is FALSE", {
  test_gitstats <- create_test_gitstats(hosts = 1)
  priv <- test_gitstats$.__enclos_env__$private

  stored_commits <- dplyr::tibble(
    repo_name = "test/repo",
    id = "old_commit",
    committed_date = as.POSIXct("2024-03-15"),
    author = "author1",
    author_login = "author1",
    author_name = "Author One",
    additions = 10L,
    deletions = 5L,
    organization = "test_org",
    repo_url = "https://github.com/test/repo",
    api_url = "https://api.github.com"
  )
  class(stored_commits) <- c("gitstats_commits", class(stored_commits))
  attr(stored_commits, "date_range") <- c("2024-01-01", "2024-06-30")
  priv$storage_backend$save("commits", stored_commits)

  fresh_commits <- dplyr::tibble(
    repo_name = "test/repo",
    id = "new_commit",
    committed_date = as.POSIXct("2024-09-15"),
    author = "author2",
    author_login = "author2",
    author_name = "Author Two",
    additions = 20L,
    deletions = 10L,
    organization = "test_org",
    repo_url = "https://github.com/test/repo",
    api_url = "https://api.github.com"
  )

  mockery::stub(
    test_gitstats$get_commits,
    "private$get_commits_from_hosts",
    fresh_commits
  )

  suppressMessages(
    result <- test_gitstats$get_commits(
      since = "2024-01-01",
      until = "2024-12-31",
      cache = FALSE,
      verbose = FALSE
    )
  )

  # Full re-fetch, not incremental
  expect_equal(nrow(result), 1)
  expect_equal(result$id, "new_commit")
})

test_that("get_commits returns stored data when no gaps exist", {
  test_gitstats <- create_test_gitstats(hosts = 1)
  priv <- test_gitstats$.__enclos_env__$private

  stored_commits <- dplyr::tibble(
    repo_name = "test/repo",
    id = "abc123",
    committed_date = as.POSIXct("2024-03-15"),
    author = "author1",
    author_login = "author1",
    author_name = "Author One",
    additions = 10L,
    deletions = 5L,
    organization = "test_org",
    repo_url = "https://github.com/test/repo",
    api_url = "https://api.github.com"
  )
  class(stored_commits) <- c("gitstats_commits", class(stored_commits))
  attr(stored_commits, "date_range") <- c("2024-01-01", "2024-12-31")
  priv$storage_backend$save("commits", stored_commits)

  result <- test_gitstats$get_commits(
    since = "2024-01-01",
    until = "2024-12-31",
    verbose = FALSE
  )

  expect_equal(nrow(result), 1)
  expect_s3_class(result, "gitstats_commits")
})

test_that("get_commits uses stored data when requested range is a subset", {
  test_gitstats <- create_test_gitstats(hosts = 1)
  priv <- test_gitstats$.__enclos_env__$private

  stored_commits <- dplyr::tibble(
    repo_name = "test/repo",
    id = c("abc123", "def456"),
    committed_date = as.POSIXct(c("2024-03-15", "2024-09-15")),
    author = "author1",
    author_login = "author1",
    author_name = "Author One",
    additions = 10L,
    deletions = 5L,
    organization = "test_org",
    repo_url = "https://github.com/test/repo",
    api_url = "https://api.github.com"
  )
  class(stored_commits) <- c("gitstats_commits", class(stored_commits))
  attr(stored_commits, "date_range") <- c("2024-01-01", "2024-12-31")
  priv$storage_backend$save("commits", stored_commits)

  suppressMessages(
    result <- test_gitstats$get_commits(
      since = "2024-03-01",
      until = "2024-09-30",
      verbose = FALSE
    )
  )

  expect_equal(nrow(result), 2)
  expect_s3_class(result, "gitstats_commits")
  expect_equal(attr(result, "date_range"), c("2024-03-01", "2024-09-30"))
})

test_that("get_commits handles gaps with no new commits from API", {
  test_gitstats <- create_test_gitstats(hosts = 1)
  priv <- test_gitstats$.__enclos_env__$private

  stored_commits <- dplyr::tibble(
    repo_name = "test/repo",
    id = "abc123",
    committed_date = as.POSIXct("2024-03-15"),
    author = "author1",
    author_login = "author1",
    author_name = "Author One",
    additions = 10L,
    deletions = 5L,
    organization = "test_org",
    repo_url = "https://github.com/test/repo",
    api_url = "https://api.github.com"
  )
  class(stored_commits) <- c("gitstats_commits", class(stored_commits))
  attr(stored_commits, "date_range") <- c("2024-01-01", "2024-06-30")
  priv$storage_backend$save("commits", stored_commits)

  mockery::stub(
    test_gitstats$get_commits,
    "private$get_commits_from_hosts",
    dplyr::tibble(
      repo_name = character(),
      id = character(),
      committed_date = as.POSIXct(character()),
      author = character(),
      author_login = character(),
      author_name = character(),
      additions = integer(),
      deletions = integer(),
      organization = character(),
      repo_url = character(),
      api_url = character()
    )
  )

  suppressMessages(
    result <- test_gitstats$get_commits(
      since = "2024-01-01",
      until = "2024-12-31",
      verbose = FALSE
    )
  )

  expect_equal(nrow(result), 1)
  expect_equal(result$id, "abc123")
  expect_s3_class(result, "gitstats_commits")
})

test_that("get_commits prints cli messages when verbose is TRUE", {
  test_gitstats <- create_test_gitstats(hosts = 1)
  priv <- test_gitstats$.__enclos_env__$private

  stored_commits <- dplyr::tibble(
    repo_name = "test/repo",
    id = "abc123",
    committed_date = as.POSIXct("2024-03-15"),
    author = "author1",
    author_login = "author1",
    author_name = "Author One",
    additions = 10L,
    deletions = 5L,
    organization = "test_org",
    repo_url = "https://github.com/test/repo",
    api_url = "https://api.github.com"
  )
  class(stored_commits) <- c("gitstats_commits", class(stored_commits))
  attr(stored_commits, "date_range") <- c("2024-01-01", "2024-06-30")
  priv$storage_backend$save("commits", stored_commits)

  new_commits <- dplyr::tibble(
    repo_name = "test/repo",
    id = "def456",
    committed_date = as.POSIXct("2024-09-15"),
    author = "author2",
    author_login = "author2",
    author_name = "Author Two",
    additions = 20L,
    deletions = 10L,
    organization = "test_org",
    repo_url = "https://github.com/test/repo",
    api_url = "https://api.github.com"
  )

  mockery::stub(
    test_gitstats$get_commits,
    "private$get_commits_from_hosts",
    new_commits
  )

  output <- capture.output(
    result <- test_gitstats$get_commits(
      since = "2024-01-01",
      until = "2024-12-31",
      verbose = TRUE
    ),
    type = "message"
  )

  expect_true(any(grepl("cached commits", output)))
  expect_true(any(grepl("2024-01-01", output)))
  expect_true(any(grepl("Pulling commits", output)))
})
