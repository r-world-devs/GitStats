# files tree query for GitLab are built properly

    Code
      gl_files_tree_query
    Output
      [1] "\n      query GetFilesTree ($fullPath: ID!, $file_path: String!) {\n        project(fullPath: $fullPath) {\n          repository {\n            tree(path: $file_path) {\n              trees (first: 100) {\n                pageInfo{\n                  endCursor\n                  hasNextPage\n                }\n                nodes {\n                  name\n                }\n              }\n              blobs (first: 100) {\n                pageInfo{\n                  endCursor\n                  hasNextPage\n                }\n                nodes {\n                  name\n                }\n              }\n            }\n          }\n        }\n      }\n      "

# get_files_content makes use of files_structure

    Code
      files_content <- gitlab_testhost_priv$get_files_content_from_orgs(file_path = NULL,
        host_files_structure = test_mocker$use("gl_files_structure_from_orgs"))
    Message
      i I will make use of files structure stored in GitStats.

