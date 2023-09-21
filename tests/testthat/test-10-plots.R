test_that("plots show error message when no input", {
  expect_snapshot_error(
    gitstats_plot()
  )
})

test_that("repositories plot is plotted", {
  repos_stats <- test_mocker$use("repos_stats")
  repos_plot <- gitstats_plot(repos_stats, n = 20)
  expect_s3_class(repos_plot, "ggplot")
  repos_plotly <- gitstats_plot(repos_stats, plotly_mode = TRUE)
  expect_s3_class(repos_plotly, "plotly")
})

test_that("repositories plot is plotted", {
  repos_stats <- test_mocker$use("repos_stats_contributors")
  repos_plot <- gitstats_plot(
    repos_stats,
    value_to_plot = "contributors_n",
    value_decreasing = FALSE
  )
  expect_s3_class(repos_plot, "ggplot")
  repos_plotly <- gitstats_plot(repos_stats, plotly_mode = TRUE)
  expect_s3_class(repos_plotly, "plotly")
})

test_that("commits plot is plotted", {
  commits_stats <- test_mocker$use("commits_stats")

  commits_plot <- gitstats_plot(commits_stats)
  expect_s3_class(commits_plot, "ggplot")
  commits_plotly <- gitstats_plot(commits_stats, plotly_mode = TRUE)
  expect_s3_class(commits_plotly, "plotly")
})
