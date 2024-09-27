test_fixtures <- list()

test_fixtures$empty_gql_response <- list(
  "data" = list(
    "group" = list(
      "projects" = list(
        "count" = 0,
        "pageInfo" = list(
          "hasNextPage" = FALSE,
          "endCursor" = NULL
        ),
        "edges" = list()
      )
    )
  )
)

test_fixtures$half_empty_gql_response <- list(
  "data" = list(
    "group" = list(
      "projects" = list(
        "count" = 445,
        "pageInfo" = list(
          "hasNextPage" = TRUE,
          "endCursor" = NULL
        ),
        "edges" = list()
      )
    )
  )
)

test_fixtures$github_file_response <- list(
  "data" = list(
    "repository" = list(
      "repo_id"   = "01010101",
      "repo_name" = "TestProject",
      "repo_url"  = "https://github.com/r-world-devs/GitStats",
      "file" = list(
        "text" = "Some interesting text.",
        "byteSize" = 50L
      )
    )
  )
)

test_fixtures$gitlab_search_response <- list(
  list(
    "basename"   = "test",
    "data"       = "some text with searched phrase",
    "path"       = "test.R",
    "filename"   = "test.R",
    "id"         = NULL,
    "ref"        = "main",
    "startline"  = 10,
    "project_id" = 43398933
  ),
  list(
    "basename"   = "test",
    "data"       = "some text with searched phrase",
    "path"       = "test.R",
    "filename"   = "test.R",
    "id"         = NULL,
    "ref"        = "main",
    "startline"  = 15,
    "project_id" = 43400864
  )
)
