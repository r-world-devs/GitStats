test_fixtures$github_file_response <- list(
  "data" = list(
    "repository" = list(
      "repo_id"   = "01010101",
      "repo_name" = "TestProject",
      "repo_url"  = "https://github.com/r-world-devs/GitStats",
      "file" = list(
        "text" = "Some interesting text.",
        "byteSize" = 50L,
        "oid" = "12345"
      ),
      "defaultBranchRef" = list(
        "target" = list(
          "oid" = "54321abcde"
        )
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
              "path" = "graphql_tests",
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
              "path" = "rm_tests_3",
              "id" = "gid://gitlab/Project/44346961",
              "webUrl" = "https://gitlab.com/mbtests/rm-tests-3",
              "repository" = list(
                "blobs" = list(
                  "nodes" = list(
                    list(
                      "path" = "meta_data.yaml",
                      "rawBlob" = "Some interesting text",
                      "size" = 4,
                      "oid" = "1a2b3c"
                    )
                  )
                ),
                "lastCommit" = list(
                  "sha" = "e5f6d7"
                )
              )
            )
          ),
          list(
            "node" = list(
              "name" = "RM Tests 2",
              "path" = "rm_tests_2",
              "id" = "gid://gitlab/Project/44293594",
              "webUrl" = "https://gitlab.com/mbtests/rm-tests-2",
              "repository" = list(
                "blobs" = list(
                  "nodes" = list(
                    list(
                      "path" = "meta_data.yaml",
                      "rawBlob" = "Some interesting text",
                      "size" = 5,
                      "oid" = "1a2b3c"
                    )
                  )
                ),
                "lastCommit" = list(
                  "sha" = "e5f6d7"
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
      "path" = "TestProject",
      "id" = "1010101",
      "webUrl"  = "https://gitlab.com/mbtests/graphql_tests",
      "repository" = list(
        "blobs" = list(
          "nodes" = list(
            list(
              "path" = "README.md",
              "rawBlob" = "This project is for testing GraphQL capabilities.",
              "size" =  "67",
              "oid" = "1a2b3c"
            ),
            list(
              "path" = "project_metadata.yaml",
              "rawBlob" = "GraphQL Tests",
              "size" = "19",
              "oid" = "1a2b3c"
            )
          )
        ),
        "lastCommit" = list(
          "sha" = "e5f6d7"
        )
      )
    )
  )
)

test_fixtures$gitlab_search_response <- list(
  list(
    "basename"= "test",
    "data" = "some text with searched phrase",
    "path" = "test.R",
    "filename" = "test.R",
    "id" = NULL,
    "ref" = "main",
    "startline" = 10,
    "project_id" = 61399846
  ),
  list(
    "basename" = "test",
    "data" = "some text with searched phrase",
    "path" = "test.R",
    "filename" = "test.R",
    "id" = NULL,
    "ref" = "main",
    "startline" = 15,
    "project_id" = 43400864
  )
)

github_search_item <- list(
  "name" = "test1.R",
  "path" = "examples/test1.R",
  "sha" = "0d42b9d23ddfc0bca1",
  "url" = "test_url",
  "git_url" = "test_git_url",
  "html_url" = "test_html_url",
  "repository" = list(
    "node_id" = "test_node_id",
    "id" = 627452680,
    "url" = "https://api.github.com/repos/r-world-devs/GitStats",
    "html_url" = "https://github.com/r-world-devs/GitStats"
  ),
  "score" = 1
)

test_fixtures$github_file_rest_response <- github_search_item

test_fixtures$github_search_response <- list(
  "total_count" = 250,
  "incomplete_results" = FALSE,
  "items" = list(
    rep(github_search_item, 250)
  )
)

test_fixtures$github_search_response_large <- list(
  "total_count" = 1001,
  "incomplete_results" = FALSE,
  "items" = list(
    rep(github_search_item, 1001)
  )
)

test_fixtures$gitlab_files_tree_response <- list(
  "data" = list(
    "project" = list(
      "id" = "123456",
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
              ),
              list(
                "name" = "report.md"
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
      "id" = "R_kgD0Ivtxsg",
      "name" = "TestRepo",
      "url" = "https://github.com/test_org/TestRepo",
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
            "name" = "test_file.R",
            "type" = "blob"
          ),
          list(
            "name" = "test.md",
            "type" = "blob"
          ),
          list(
            "name" = "test.qmd",
            "type" = "blob"
          ),
          list(
            "name" = "test.Rmd",
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

test_fixtures$gitlab_file_rest_response <- list(
  "file_name" = "test.R",
  "file_path" = "test.R",
  "size" = 19L,
  "encoding" = "base64",
  "content" = "test content",
  "ref" = "main",
  "blob_id" = "1a2b3c",
  "commit_id" = "e5f6d7",
  "last_commit_id" = "e5f6d7"
)
