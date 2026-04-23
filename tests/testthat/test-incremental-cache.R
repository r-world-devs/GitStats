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
  attr(stored_commits, "scope") <- "test_org"
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
  expect_in("abc123", result$id)
  expect_in("def456", result$id)
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
  attr(stored_commits, "scope") <- "test_org"
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
  attr(stored_commits, "scope") <- "test_org"
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
  attr(stored_commits, "scope") <- "test_org"
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
  attr(stored_commits, "scope") <- "test_org"
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
  attr(stored_commits, "scope") <- "test_org"
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
  attr(stored_commits, "scope") <- "test_org"
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

# non_date_args_changed --------------------------------------------------------

test_that("non_date_args_changed returns FALSE when no non-date args", {
  test_gitstats <- create_test_gitstats(hosts = 1, priv_mode = TRUE)
  data <- dplyr::tibble(x = 1)
  attr(data, "date_range") <- c("2024-01-01", "2024-06-30")
  result <- test_gitstats$non_date_args_changed(
    data, list("date_range" = c("2024-01-01", "2024-12-31"))
  )
  expect_false(result)
})

test_that("non_date_args_changed returns TRUE when state changed", {
  test_gitstats <- create_test_gitstats(hosts = 1, priv_mode = TRUE)
  data <- dplyr::tibble(x = 1)
  attr(data, "date_range") <- c("2024-01-01", "2024-06-30")
  attr(data, "state") <- "open"
  result <- test_gitstats$non_date_args_changed(
    data, list("date_range" = c("2024-01-01", "2024-12-31"), "state" = "all")
  )
  expect_true(result)
})

test_that("non_date_args_changed returns FALSE when state is same", {
  test_gitstats <- create_test_gitstats(hosts = 1, priv_mode = TRUE)
  data <- dplyr::tibble(x = 1)
  attr(data, "date_range") <- c("2024-01-01", "2024-06-30")
  attr(data, "state") <- "open"
  result <- test_gitstats$non_date_args_changed(
    data, list("date_range" = c("2024-01-01", "2024-12-31"), "state" = "open")
  )
  expect_false(result)
})

test_that("non_date_args_changed returns TRUE when scope changed", {
  test_gitstats <- create_test_gitstats(hosts = 1, priv_mode = TRUE)
  data <- dplyr::tibble(x = 1)
  attr(data, "date_range") <- c("2024-01-01", "2024-06-30")
  attr(data, "scope") <- "old_org"
  result <- test_gitstats$non_date_args_changed(
    data, list("date_range" = c("2024-01-01", "2024-12-31"), "scope" = "new_org")
  )
  expect_true(result)
})

test_that("non_date_args_changed returns FALSE when scope is same", {
  test_gitstats <- create_test_gitstats(hosts = 1, priv_mode = TRUE)
  data <- dplyr::tibble(x = 1)
  attr(data, "date_range") <- c("2024-01-01", "2024-06-30")
  attr(data, "scope") <- "test_org"
  result <- test_gitstats$non_date_args_changed(
    data, list("date_range" = c("2024-01-01", "2024-12-31"), "scope" = "test_org")
  )
  expect_false(result)
})

# Scope change triggers full re-fetch -----------------------------------------

test_that("get_commits does full re-fetch when scanning scope changes", {
  test_gitstats <- create_test_gitstats(hosts = 1)
  priv <- test_gitstats$.__enclos_env__$private

  stored_commits <- dplyr::tibble(
    repo_name = "old_org/repo",
    id = "old_commit",
    committed_date = as.POSIXct("2024-03-15"),
    author = "author1",
    author_login = "author1",
    author_name = "Author One",
    additions = 10L,
    deletions = 5L,
    organization = "old_org",
    repo_url = "https://github.com/old_org/repo",
    api_url = "https://api.github.com"
  )
  class(stored_commits) <- c("gitstats_commits", class(stored_commits))
  attr(stored_commits, "date_range") <- c("2024-01-01", "2024-06-30")
  attr(stored_commits, "scope") <- "old_org"
  priv$storage_backend$save("commits", stored_commits)

  fresh_commits <- dplyr::tibble(
    repo_name = "test_org/repo",
    id = "new_commit",
    committed_date = as.POSIXct("2024-03-15"),
    author = "author1",
    author_login = "author1",
    author_name = "Author One",
    additions = 10L,
    deletions = 5L,
    organization = "test_org",
    repo_url = "https://github.com/test_org/repo",
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
      until = "2024-06-30",
      verbose = FALSE
    )
  )

  # Full re-fetch: only new data, old data discarded
  expect_equal(nrow(result), 1)
  expect_equal(result$id, "new_commit")
})

test_that("get_issues does full re-fetch when scanning scope changes", {
  test_gitstats <- create_test_gitstats(hosts = 1)
  priv <- test_gitstats$.__enclos_env__$private

  stored_issues <- dplyr::tibble(
    repo_name = "old_org/repo",
    number = 1L,
    title = "Old issue",
    description = "desc",
    created_at = as.POSIXct("2024-03-15"),
    closed_at = as.POSIXct(NA),
    state = "open",
    url = "https://github.com/old_org/repo/issues/1",
    author = "author1",
    organization = "old_org",
    api_url = "https://api.github.com"
  )
  class(stored_issues) <- c("gitstats_issues", class(stored_issues))
  attr(stored_issues, "date_range") <- c("2024-01-01", "2024-06-30")
  attr(stored_issues, "state") <- "open"
  attr(stored_issues, "scope") <- "old_org"
  priv$storage_backend$save("issues", stored_issues)

  fresh_issues <- dplyr::tibble(
    repo_name = "test_org/repo",
    number = 5L,
    title = "New issue",
    description = "desc",
    created_at = as.POSIXct("2024-03-15"),
    closed_at = as.POSIXct(NA),
    state = "open",
    url = "https://github.com/test_org/repo/issues/5",
    author = "author1",
    organization = "test_org",
    api_url = "https://api.github.com"
  )

  mockery::stub(
    test_gitstats$get_issues,
    "private$get_issues_from_hosts",
    fresh_issues
  )

  suppressMessages(
    result <- test_gitstats$get_issues(
      since = "2024-01-01",
      until = "2024-06-30",
      state = "open",
      verbose = FALSE
    )
  )

  expect_equal(nrow(result), 1)
  expect_equal(result$number, 5L)
})

# Incremental get_issues -------------------------------------------------------

test_that("get_issues fetches only missing date range", {
  test_gitstats <- create_test_gitstats(hosts = 1)
  priv <- test_gitstats$.__enclos_env__$private

  stored_issues <- dplyr::tibble(
    repo_name = "test/repo",
    number = 1L,
    title = "Old issue",
    description = "desc",
    created_at = as.POSIXct("2024-03-15"),
    closed_at = as.POSIXct(NA),
    state = "open",
    url = "https://github.com/test/repo/issues/1",
    author = "author1",
    organization = "test_org",
    api_url = "https://api.github.com"
  )
  class(stored_issues) <- c("gitstats_issues", class(stored_issues))
  attr(stored_issues, "date_range") <- c("2024-01-01", "2024-06-30")
  attr(stored_issues, "state") <- "open"
  attr(stored_issues, "scope") <- "test_org"
  priv$storage_backend$save("issues", stored_issues)

  new_issues <- dplyr::tibble(
    repo_name = "test/repo",
    number = 2L,
    title = "New issue",
    description = "desc",
    created_at = as.POSIXct("2024-09-15"),
    closed_at = as.POSIXct(NA),
    state = "open",
    url = "https://github.com/test/repo/issues/2",
    author = "author2",
    organization = "test_org",
    api_url = "https://api.github.com"
  )

  mockery::stub(
    test_gitstats$get_issues,
    "private$get_issues_from_hosts",
    new_issues
  )

  suppressMessages(
    result <- test_gitstats$get_issues(
      since = "2024-01-01",
      until = "2024-12-31",
      state = "open",
      verbose = FALSE
    )
  )

  expect_equal(nrow(result), 2)
  expect_in(1L, result$number)
  expect_in(2L, result$number)
  expect_equal(attr(result, "date_range"), c("2024-01-01", "2024-12-31"))
})

test_that("get_issues does full re-fetch when state changes", {
  test_gitstats <- create_test_gitstats(hosts = 1)
  priv <- test_gitstats$.__enclos_env__$private

  stored_issues <- dplyr::tibble(
    repo_name = "test/repo",
    number = 1L,
    title = "Open issue",
    description = "desc",
    created_at = as.POSIXct("2024-03-15"),
    closed_at = as.POSIXct(NA),
    state = "open",
    url = "https://github.com/test/repo/issues/1",
    author = "author1",
    organization = "test_org",
    api_url = "https://api.github.com"
  )
  class(stored_issues) <- c("gitstats_issues", class(stored_issues))
  attr(stored_issues, "date_range") <- c("2024-01-01", "2024-06-30")
  attr(stored_issues, "state") <- "open"
  attr(stored_issues, "scope") <- "test_org"
  priv$storage_backend$save("issues", stored_issues)

  all_issues <- dplyr::tibble(
    repo_name = "test/repo",
    number = c(1L, 3L),
    title = c("Open issue", "Closed issue"),
    description = "desc",
    created_at = as.POSIXct(c("2024-03-15", "2024-04-01")),
    closed_at = as.POSIXct(c(NA, "2024-05-01")),
    state = c("open", "closed"),
    url = paste0("https://github.com/test/repo/issues/", c(1, 3)),
    author = "author1",
    organization = "test_org",
    api_url = "https://api.github.com"
  )

  mockery::stub(
    test_gitstats$get_issues,
    "private$get_issues_from_hosts",
    all_issues
  )

  suppressMessages(
    result <- test_gitstats$get_issues(
      since = "2024-01-01",
      until = "2024-06-30",
      state = "all",
      verbose = FALSE
    )
  )

  expect_equal(nrow(result), 2)
  expect_in("closed", result$state)
})

# Incremental get_pull_requests ------------------------------------------------

test_that("get_pull_requests fetches only missing date range", {
  test_gitstats <- create_test_gitstats(hosts = 1)
  priv <- test_gitstats$.__enclos_env__$private

  stored_prs <- dplyr::tibble(
    repo_name = "test/repo",
    number = 10L,
    created_at = as.POSIXct("2024-03-15"),
    merged_at = as.POSIXct(NA),
    state = "open",
    author = "author1",
    source_branch = "feature",
    target_branch = "main",
    organization = "test_org",
    api_url = "https://api.github.com"
  )
  class(stored_prs) <- c("gitstats_pull_requests", class(stored_prs))
  attr(stored_prs, "date_range") <- c("2024-01-01", "2024-06-30")
  attr(stored_prs, "state") <- "all"
  attr(stored_prs, "scope") <- "test_org"
  priv$storage_backend$save("pull_requests", stored_prs)

  new_prs <- dplyr::tibble(
    repo_name = "test/repo",
    number = 20L,
    created_at = as.POSIXct("2024-09-15"),
    merged_at = as.POSIXct("2024-09-20"),
    state = "merged",
    author = "author2",
    source_branch = "hotfix",
    target_branch = "main",
    organization = "test_org",
    api_url = "https://api.github.com"
  )

  mockery::stub(
    test_gitstats$get_pull_requests,
    "private$get_pull_requests_from_hosts",
    new_prs
  )

  suppressMessages(
    result <- test_gitstats$get_pull_requests(
      since = "2024-01-01",
      until = "2024-12-31",
      state = "all",
      verbose = FALSE
    )
  )

  expect_equal(nrow(result), 2)
  expect_in(10L, result$number)
  expect_in(20L, result$number)
  expect_equal(attr(result, "date_range"), c("2024-01-01", "2024-12-31"))
})

# Incremental get_release_logs -------------------------------------------------

test_that("get_release_logs fetches only missing date range", {
  test_gitstats <- create_test_gitstats(hosts = 1)
  priv <- test_gitstats$.__enclos_env__$private

  stored_releases <- dplyr::tibble(
    repo_name = "test/repo",
    repo_url = "https://github.com/test/repo",
    release_name = "v1.0",
    release_tag = "v1.0.0",
    published_at = as.POSIXct("2024-03-15"),
    release_url = "https://github.com/test/repo/releases/v1.0.0",
    release_log = "Initial release"
  )
  class(stored_releases) <- c("gitstats_releases", class(stored_releases))
  attr(stored_releases, "date_range") <- c("2024-01-01", "2024-06-30")
  attr(stored_releases, "scope") <- "test_org"
  priv$storage_backend$save("release_logs", stored_releases)

  new_releases <- dplyr::tibble(
    repo_name = "test/repo",
    repo_url = "https://github.com/test/repo",
    release_name = "v2.0",
    release_tag = "v2.0.0",
    published_at = as.POSIXct("2024-09-15"),
    release_url = "https://github.com/test/repo/releases/v2.0.0",
    release_log = "Major update"
  )

  mockery::stub(
    test_gitstats$get_release_logs,
    "private$get_release_logs_from_hosts",
    new_releases
  )

  suppressMessages(
    result <- test_gitstats$get_release_logs(
      since = "2024-01-01",
      until = "2024-12-31",
      verbose = FALSE
    )
  )

  expect_equal(nrow(result), 2)
  expect_in("v1.0.0", result$release_tag)
  expect_in("v2.0.0", result$release_tag)
  expect_equal(attr(result, "date_range"), c("2024-01-01", "2024-12-31"))
})

