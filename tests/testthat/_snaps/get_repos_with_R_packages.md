# get_R_package_loading turns to othed method if it reaches 10 thous. limit

    Code
      R_package_loading <- test_gitstats_priv$get_R_package_loading(package_name = "purrr",
        verbose = TRUE)
    Message
      > Checking where [purrr] is loaded from library...
      ! Reached 10 thousand response limit.
      i I will cut search responses into `orgs`.
      ! Reached 10 thousand response limit.
      i I will cut search responses into `orgs`.

# when get_repos_with_R_packages_from_hosts output is empty return warning

    Code
      test_gitstats$get_repos_with_R_packages_from_hosts(packages = "non-existing-package",
        only_loading = FALSE, verbose = TRUE)
    Message
      ! No usage of R packages found.
    Output
      data frame with 0 columns and 0 rows

# get_repos_with_R_packages records timespan of the process

    Code
      R_package_usage_table <- get_repos_with_R_packages(gitstats = test_gitstats,
        packages = c("shiny", "purrr"), verbose = TRUE)
    Message
      v Data pulled in 0 secs

