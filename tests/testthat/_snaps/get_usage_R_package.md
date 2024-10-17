# when get_R_package_usage_from_hosts output is empty return warning

    Code
      test_gitstats$get_R_package_usage_from_hosts(packages = "non-existing-package",
        only_loading = FALSE, verbose = TRUE)
    Message
      ! No usage of R packages found.
    Output
      data frame with 0 columns and 0 rows

