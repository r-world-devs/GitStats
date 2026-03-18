test_that("when dates format passed `date_to_gts()` prepares git time stamps with zeros", {
  dates <- as.Date(c("2022-12-19", "2023-01-15", "2020-06-05"))
  gts <- c("2022-12-19T00:00:00Z", "2023-01-15T00:00:00Z", "2020-06-05T00:00:00Z")

  purrr::walk2(dates, gts, ~ expect_equal(date_to_gts(.x), .y))
})

test_that("when posixt format passed `date_to_gts()` prepares git time stamps with precision to seconds", {
  posixt <- as.POSIXct(c("2022-12-19 12:27:15", "2022-12-19 12:21:55", "2022-12-19 11:55:39"))
  gts <- c("2022-12-19T12:27:15Z", "2022-12-19T12:21:55Z", "2022-12-19T11:55:39Z")

  purrr::walk2(posixt, gts, ~ expect_equal(date_to_gts(.x), .y))
})

test_that("`gts_to_posixt()` transforms git timestamp format into posixt format", {
  gts <- c("2022-12-19T12:27:15Z", "2022-12-19T12:21:55Z", "2022-12-19T11:55:39Z")
  posixt <- lubridate::as_datetime(c("2022-12-19 12:27:15", "2022-12-19 12:21:55", "2022-12-19 11:55:39"))

  expect_equal(gts_to_posixt(gts), posixt)
})

test_that("retrieve_githost works", {
  expect_equal(
    retrieve_githost("https://api.github.com/repositories/r-world-devs/GitStats"),
    "github"
  )
  expect_equal(
    retrieve_githost("https://gitlab.com/api/v4"),
    "gitlab"
  )
})

test_that("parse_until_param returns date + 1 day", {
  expect_equal(
    parse_until_param("2025-12-08"),
    lubridate::as_datetime("2025-12-09")
  )
})

test_that("url_encode encodes reserved characters", {
  expect_equal(url_encode("my/path"), "my%2Fpath")
  expect_equal(url_encode("a b"), "a%20b")
})

test_that("url_decode decodes encoded strings", {
  expect_equal(url_decode("my%2Fpath"), "my/path")
  expect_equal(url_decode("a%20b"), "a b")
})

test_that("`standardize_dates` converts to datetime and drops NULLs", {
  dates <- list("2024-01-15", NULL, "2024-06-01")
  result <- standardize_dates(dates)
  expect_equal(
    result,
    c(lubridate::as_datetime("2024-01-15"), lubridate::as_datetime("2024-06-01"))
  )
})

test_that("`standardize_dates` returns empty vector for all NULLs", {
  result <- standardize_dates(list(NULL, NULL))
  expect_length(result, 0)
})

test_that("`is_name` returns TRUE for multi-word strings", {
  expect_true(is_name("John Doe"))
  expect_true(is_name("Jane Mary Smith"))
})

test_that("`is_name` returns FALSE for single-word strings", {
  expect_false(is_name("johndoe"))
})

test_that("`is_login` returns TRUE for single lowercase word", {
  expect_true(is_login("johndoe"))
  expect_true(is_login("user123"))
})

test_that("`is_login` returns FALSE for multi-word or uppercase strings", {
  expect_false(is_login("John Doe"))
  expect_false(is_login("JohnDoe"))
})

test_that("`get_gitlab_repo_id` extracts numeric id from URL", {
  expect_equal(get_gitlab_repo_id("https://gitlab.com/api/v4/projects/12345"), "12345")
  expect_equal(get_gitlab_repo_id("projects/99"), "99")
})

test_that("`set_progress_bar` returns host name when progress is TRUE", {
  mock_private <- list(host_name = "GitHub")
  result <- set_progress_bar(TRUE, mock_private)
  expect_equal(as.character(result), "GitHub")
})

test_that("`set_progress_bar` returns FALSE when progress is FALSE", {
  mock_private <- list(host_name = "GitHub")
  result <- set_progress_bar(FALSE, mock_private)
  expect_false(result)
})
