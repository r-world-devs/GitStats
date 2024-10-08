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

test_fixtures$gitlab_file_org_response <- list(
  "data" = list(
    "group" = list(
      "projects" = list(
        "count" = 3,
        "pageInfo" = list(
          "hasNextPage" = FALSE,
          "endCursor" = "xxxxxx"
        ),
        "edges" = list(
          list(
            "node" = list(
              "name" = "graphql_tests",
              "id" = "gid://gitlab/Project/61399846",
              "webUrl" = "https://gitlab.com/mbtests/graphql_tests",
              "repository" = list(
                "blobs" = list(
                  "nodes" = list() # empty response for query, no files found in org
                )
              )
            )
          ),
          list(
            "node" = list(
              "name" = "RM Tests 3",
              "id" = "gid://gitlab/Project/44346961",
              "webUrl" = "https://gitlab.com/mbtests/rm-tests-3",
              "repository" = list(
                "blobs" = list(
                  "nodes" = list(
                    list(
                      "name" = "meta_data.yaml",
                      "rawBlob" = "Some interesting text",
                      "size" = 4
                    )
                  )
                )
              )
            )
          ),
          list(
            "node" = list(
              "name" = "RM Tests 2",
              "id" = "gid://gitlab/Project/44293594",
              "webUrl" = "https://gitlab.com/mbtests/rm-tests-2",
              "repository" = list(
                "blobs" = list(
                  "nodes" = list(
                    list(
                      "name" = "meta_data.yaml",
                      "rawBlob" = "Some interesting text",
                      "size" = 5
                    )
                  )
                )
              )
            )
          )
        )
      )
    )
  )
)

test_fixtures$gitlab_file_repo_response <- list(
  "data" = list(
    "project" = list(
      "name" = "TestProject",
      "id" = "1010101",
      "webUrl"  = "https://gitlab.com/mbtests/graphql_tests",
      "repository" = list(
        "blobs" = list(
          "nodes" = list(
            list(
              "name" = "README.md",
              "rawBlob" = "# graphql_tests\n\nThis project is for testing GraphQL capabilities.\n",
              "size" =  "67"
            ),
            list(
              "name" = "project_metadata.yaml",
              "rawBlob" = "Name: GraphQL Tests",
              "size" = "19"
            )
          )
        )
      )
    )
  )
)

test_fixtures$github_png_file_response <- list(
  "data" = list(
    "repository" = list(
      "repo_id"   = "01010101",
      "repo_name" = "TestProject",
      "repo_url"  = "https://github.com/r-world-devs/GitStats",
      "file" = list(
        "text" = NULL,
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

test_fixtures$github_search_response <- list(
  "total_count" = 3,
  "incomplete_results" = FALSE,
  "items" = list(
    list(
      "name" = "test1.R",
      "path" = "examples/test1.R",
      "sha" = "0d42b9d23ddfc0bca1",
      "url" = "test_url",
      "git_url" = "test_git_url",
      "html_url" = "test_html_url",
      "repository" = list(
        "id" = 627452680,
        "url" = "https://api.github.com/repos/r-world-devs/GitStats",
        "html" = "https://github.com/r-world-devs/GitStats"
      ),
      "score" = 1
    ),
    list(
      "name" = "test2.R",
      "path" = "tests/test2.R",
      "sha" = "01238xb",
      "url" = "test_url",
      "git_url" = "test_git_url",
      "html_url" = "test_html_url",
      "repository" = list(
        "id" = 604718884,
        "url" = "https://api.github.com/repos/r-world-devs/GitStats",
        "html" = "https://github.com/r-world-devs/GitStats"
      ),
      "score" = 1
    ),
    list(
      "name" = "test3.R",
      "path" = "R/test3.R",
      "sha" = "20e19af2dda26d04f6",
      "url" = "test_url",
      "git_url" = "test_git_url",
      "html_url" = "test_html_url",
      "repository" = list(
        "id" = 495151911,
        "url" = "https://api.github.com/repos/r-world-devs/GitStats",
        "html" = "https://github.com/r-world-devs/GitStats"
      ),
      "score" = 1
    )
  )
)

test_fixtures$gitlab_files_tree_response <- list(
  "data" = list(
    "project" = list(
      "repository" = list(
        "tree" = list(
          "trees" = list(
            "nodes" = list(
              list(
                "name" = "R"
              ),
              list(
                "name" = "tests"
              )
            )
          ),
          "blobs" = list(
            "nodes" = list(
              list(
                "name" = "DESCRIPTION"
              ),
              list(
                "name" = "README.md"
              ),
              list(
                "name" = "project_metadata.yaml"
              )
            )
          )
        )
      )
    )
  )
)

test_fixtures$github_files_tree_response <- list(
  "data" = list(
    "repository" = list(
      "id"     = "R_kgD0Ivtxsg",
      "name"   = "GitStats",
      "url"    = "https://github.com/r-world-devs/GitStats",
      "object" = list(
        "entries" = list(
          list(
            "name" = ".Rbuildignore",
            "type" = "blob"
          ),
          list(
            "name" = ".Renviron",
            "type" = "blob"
          ),
          list(
            "name" = ".Rprofile",
            "type" = "blob"
          ),
          list(
            "name" = ".covrignore",
            "type" = "blob"
          ),
          list(
            "name" = "renv",
            "type" = "tree"
          ),
          list(
            "name" = "tests",
            "type" = "tree"
          ),
          list(
            "name" = "vignettes",
            "type" = "tree"
          )
        )
      )
    )
  )
)
