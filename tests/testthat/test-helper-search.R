test_that("`search_request()` performs search with limit under 100", {
  search_endpoint <- "https://api.github.com/search/code?q='covid'+user:pharmaverse"
  total_n <- get_response(search_endpoint,
                          token = Sys.getenv("GITHUB_PAT"))[["total_count"]]
  expect_type(
    search_request(
      search_endpoint = search_endpoint,
      total_n = total_n,
      byte_max = 384000,
      token = Sys.getenv("GITHUB_PAT")
    ),
    "list"
  )
})

test_that("`search_request()` performs search with limit over 100 and under 1000", {
  search_endpoint <- "https://api.github.com/search/code?q='maps'+user:eurostat"
  total_n <- get_response(search_endpoint,
                          token = Sys.getenv("GITHUB_PAT"))[["total_count"]]
  expect_type(
    search_request(
      search_endpoint = search_endpoint,
      total_n = total_n,
      byte_max = 384000,
      token = Sys.getenv("GITHUB_PAT")
    ),
    "list"
  )
})
