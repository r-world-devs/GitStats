# file queries for GitLab are built properly

    Code
      gl_files_query
    Output
      [1] "query GetFilesByOrg($org: ID!, $file_paths: [String!]!) {\n            group(fullPath: $org) {\n              projects(first: 100) {\n          count\n          pageInfo {\n            hasNextPage\n            endCursor\n          }\n          edges {\n            node {\n              name\n              path\n              id\n              webUrl\n              repository {\n                blobs(paths: $file_paths) {\n                  nodes {\n                    path\n                    rawBlob\n                    size\n                    oid\n                  }\n                }\n                lastCommit {\n                  sha\n                }\n              }\n            }\n          }\n        }\n      }\n    }"

---

    Code
      gl_file_blobs_from_repo_query
    Output
      [1] "\n      query GetFilesByRepo($fullPath: ID!, $file_paths: [String!]!) {\n        project(fullPath: $fullPath) {\n          name\n          path\n          id\n          webUrl\n          repository {\n            blobs(paths: $file_paths) {\n              nodes {\n                path\n                rawBlob\n                size\n                oid\n              }\n            }\n            lastCommit {\n              sha\n            }\n          }\n        }\n      }\n      "

# GitLab GraphQL switches to iteration when query is too complex

    Code
      files_from_org_per_repo <- test_graphql_gitlab$get_files_from_org_per_repo(org = "mbtests",
        owner_type = "organization", repos_data = list(paths = "gitstatstesting"),
        file_paths = c("project_metadata.yaml", "README.md"), host_files_structure = NULL,
        verbose = TRUE)
    Message
      > Encountered query complexity error (too many files). I will divide input data into chunks...

# get_files_content_from_repos for GitLab prints message

    Code
      gl_files_table <- gitlab_testhost_priv$get_files_content_from_repos(file_path = "meta_data.yaml",
        verbose = TRUE)
    Message
      > [Host:GitLab][Engine:GraphQl][Scope:test_group: 0 repos] Pulling files content: [meta_data.yaml]...

# get_files_content makes use of files_structure

    Code
      files_content <- gitlab_testhost_priv$get_files_content_from_files_structure(
        files_structure = test_mocker$use("gl_files_structure_from_orgs"), verbose = TRUE)
    Message
      > [Host:GitLab][Engine:GraphQl][Scope:test_group] Pulling files from files structure...

