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

