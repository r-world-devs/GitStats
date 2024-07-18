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

test_that("retrieve_platform works", {
  expect_equal(
    retrieve_platform("https://api.github.com/repositories/r-world-devs/GitStats"),
    "github"
  )
  expect_equal(
    retrieve_platform("https://gitlab.com/api/v4"),
    "gitlab"
  )
})
