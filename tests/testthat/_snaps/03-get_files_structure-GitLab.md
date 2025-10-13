# files tree query for GitLab are built properly

    Code
      gl_files_tree_query
    Output
      [1] "\n      query GetFilesTree ($fullPath: ID!, $file_path: String!) {\n        project(fullPath: $fullPath) {\n          id\n          repository {\n            tree(path: $file_path) {\n              trees (first: 100) {\n                pageInfo{\n                  endCursor\n                  hasNextPage\n                }\n                nodes {\n                  name\n                }\n              }\n              blobs (first: 100) {\n                pageInfo{\n                  endCursor\n                  hasNextPage\n                }\n                nodes {\n                  name\n                }\n              }\n            }\n            lastCommit {\n              sha\n            }\n          }\n        }\n      }\n      "

# get_files_structure_from_repos prints message

    Code
      gl_files_structure_from_repos <- gitlab_testhost_priv$
        get_files_structure_from_repos(pattern = "\\.md", depth = 1L, verbose = TRUE,
        progress = FALSE)
    Message
      > [Host:GitLab][Engine:GraphQl][Scope:test_group: 0 repos] Pulling repos 🌳 [files matching pattern: '\.md']...

