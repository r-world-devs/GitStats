test_that("get_orgs_from_hosts works", {
  mockery::stub(
    test_gitstats_priv$get_orgs_from_hosts,
    "host$get_orgs",
    purrr::list_rbind(list(
      test_mocker$use("github_orgs_table"),
      test_mocker$use("gitlab_orgs_table")
    ))
  )
  orgs_from_hosts <- test_gitstats_priv$get_orgs_from_hosts(
    output = "full_table",
    verbose = FALSE
  )
  expect_orgs_table(
    orgs_from_hosts,
    add_cols = c("host_url", "host_name")
  )
  test_mocker$cache(orgs_from_hosts)
})

test_that("set_object_class for repos_table works correctly", {
  orgs_table <- test_gitstats_priv$set_object_class(
    object = test_mocker$use("orgs_from_hosts"),
    class = "gitstats_orgs"
  )
  expect_s3_class(orgs_table, "gitstats_orgs")
})

test_that("get_orgs works", {
  mockery::stub(
    test_gitstats$get_orgs,
    "private$get_orgs_from_hosts",
    test_mocker$use("orgs_from_hosts")
  )
  orgs_table <- test_gitstats$get_orgs()
  expect_s3_class(orgs_table, "gitstats_orgs")
  expect_orgs_table(orgs_table, add_cols = c("host_url", "host_name"))
  test_mocker$cache(orgs_table)
})

test_that("get_orgs works", {
  mockery::stub(
    get_orgs,
    "gitstats$get_orgs",
    test_mocker$use("orgs_table")
  )
  orgs_table <- get_orgs(
    test_gitstats,
    verbose = FALSE
  )
  expect_s3_class(orgs_table, "gitstats_orgs")
  test_mocker$cache(orgs_table)
})

test_that("get_orgs prints info on time used to pull data", {
  mockery::stub(
    get_orgs,
    "gitstats$get_orgs",
    test_mocker$use("orgs_table")
  )
  expect_snapshot(
    orgs_table <- get_orgs(
      test_gitstats,
      verbose = TRUE
    )
  )
})
