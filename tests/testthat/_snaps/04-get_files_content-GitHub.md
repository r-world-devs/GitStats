# file queries for GitHub are built properly

    Code
      gh_file_blobs_from_repo_query
    Output
      [1] "query GetFileBlobFromRepo($org: String!, $repo: String!, $expression: String!) {\n          repository(owner: $org, name: $repo) {\n            repo_id: id\n            repo_name: name\n            repo_url: url\n            defaultBranchRef {\n              target {\n                ... on Commit {\n                  oid\n                }\n              }\n            }\n            file: object(expression: $expression) {\n              ... on Blob {\n                text\n                byteSize\n                oid\n              }\n            }\n          }\n      }"

# get_files_content makes use of files_structure

    Code
      files_content <- github_testhost_priv$get_files_content_from_files_structure(
        files_structure = test_mocker$use("gh_files_structure_from_orgs"), verbose = TRUE,
        progress = FALSE)
    Message
      > [Host:GitHub][Engine:GraphQl][Scope:r-world-devs] Pulling files from files structure...

# get_files_content skips if no files found in files_structure

    Code
      files_content <- github_testhost_priv$get_files_content_from_files_structure(
        files_structure = test_mocker$use("gh_empty_files_structure"), verbose = TRUE,
        progress = FALSE)
    Message
      ! [GitHub] No files found. Skipping pulling files content.

