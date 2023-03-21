test_github <- GitHub$new(
  rest_api_url = "https://api.github.com",
  token = Sys.getenv("GITHUB_PAT"),
  orgs = "pharmaverse"
)

test_github_priv <- environment(test_github$initialize)$private

test_that("`search_response()` performs search with limit under 100", {
  search_endpoint <- "https://api.github.com/search/code?q='covid'+user:pharmaverse"
  total_n <- private$rest_response(search_endpoint,
                          token = Sys.getenv("GITHUB_PAT"))[["total_count"]]
  expect_type(
    test_github_priv$search_response(
      search_endpoint = search_endpoint,
      total_n = total_n,
      byte_max = 384000
    ),
    "list"
  )
})

test_that("`search_response()` performs search with limit over 100 and under 1000", {
  search_endpoint <- "https://api.github.com/search/code?q='maps'+user:eurostat"
  total_n <- private$rest_response(search_endpoint,
                          token = Sys.getenv("GITHUB_PAT"))[["total_count"]]
  expect_type(
    test_github_priv$search_response(
      search_endpoint = search_endpoint,
      total_n = total_n,
      byte_max = 384000
    ),
    "list"
  )
})
