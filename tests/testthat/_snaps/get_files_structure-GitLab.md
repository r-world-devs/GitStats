# files tree query for GitLab are built properly

    Code
      gl_files_tree_query
    Output
      [1] "\n      query GetFilesTree ($fullPath: ID!, $file_path: String!) {\n        project(fullPath: $fullPath) {\n          repository {\n            tree(path: $file_path) {\n              trees (first: 100) {\n                pageInfo{\n                  endCursor\n                  hasNextPage\n                }\n                nodes {\n                  name\n                }\n              }\n              blobs (first: 100) {\n                pageInfo{\n                  endCursor\n                  hasNextPage\n                }\n                nodes {\n                  name\n                }\n              }\n            }\n          }\n        }\n      }\n      "

# get_files_structure_from_orgs pulls files structure for repositories in orgs

    Code
      gl_files_structure_from_orgs <- gitlab_testhost_priv$
        get_files_structure_from_orgs(pattern = "\\.md|\\.R", depth = 1L, verbose = TRUE,
        progress = FALSE)
    Message
      i [Host:GitLab][Engine:GraphQl][Scope:mbtests] Pulling files structure...[files matching pattern: '\.md|\.R']...
