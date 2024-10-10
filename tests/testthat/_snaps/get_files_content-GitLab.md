# file queries for GitLab are built properly

    Code
      gl_files_query
    Output
      [1] "query GetFilesByOrg($org: ID!, $file_paths: [String!]!) {\n            group(fullPath: $org) {\n              projects(first: 100) {\n          count\n          pageInfo {\n            hasNextPage\n            endCursor\n          }\n          edges {\n            node {\n              name\n              id\n              webUrl\n              repository {\n                blobs(paths: $file_paths) {\n                  nodes {\n                    name\n                    rawBlob\n                    size\n                  }\n                }\n              }\n            }\n          }\n        }\n      }\n    }"

---

    Code
      gl_file_blobs_from_repo_query
    Output
      [1] "\n      query GetFilesByRepo($fullPath: ID!, $file_paths: [String!]!) {\n        project(fullPath: $fullPath) {\n          name\n          id\n          webUrl\n          repository {\n            blobs(paths: $file_paths) {\n              nodes {\n                name\n                rawBlob\n                size\n              }\n            }\n          }\n        }\n      }\n      "

# Gitlab GraphQL switches to pulling files per repositories when query is too complex

    Code
      gitlab_files_response_by_repos <- test_graphql_gitlab$get_files_from_org(org = "mbtests",
        type = "organization", repos = NULL, file_paths = c("DESCRIPTION",
          "project_metadata.yaml", "README.md"), host_files_structure = NULL,
        only_text_files = TRUE, verbose = TRUE, progress = FALSE)
    Message
      i I will switch to pulling files per repository.

