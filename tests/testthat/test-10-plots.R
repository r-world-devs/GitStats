test_that("plots show error message when no input", {
  expect_snapshot_error(
    plot_repos()
  )
  expect_snapshot_error(
    plot_commits_stats()
  )
})

test_that("repositories plot is plotted", {
  repos_data <- test_mocker$use("repos_table")
  repos_plot <- plot_repos(repos_data, n = 20)
  expect_s3_class(repos_plot, "ggplot")
  repos_plotly <- plot_repos(repos_data, plotly_mode = TRUE)
  expect_s3_class(repos_plotly, "plotly")
  repos_plot <- plot_repos(
    repos_data,
    value_to_plot = "contributors_n",
    value_decreasing = FALSE
  )
  expect_s3_class(repos_plot, "ggplot")
})

test_that("commits plot is plotted", {
  commits_stats <- test_mocker$use("commits_stats")
  commits_plot <- plot_commits_stats(commits_stats)
  expect_s3_class(commits_plot, "ggplot")
  commits_plotly <- plot_commits_stats(commits_stats, plotly_mode = TRUE)
  expect_s3_class(commits_plotly, "plotly")
})
