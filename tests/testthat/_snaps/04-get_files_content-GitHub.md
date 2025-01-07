# file queries for GitHub are built properly

    Code
      gh_file_blobs_from_repo_query
    Output
      [1] "query GetFileBlobFromRepo($org: String!, $repo: String!, $expression: String!) {\n          repository(owner: $org, name: $repo) {\n            repo_id: id\n            repo_name: name\n            repo_url: url\n            file: object(expression: $expression) {\n              ... on Blob {\n                text\n                byteSize\n              }\n            }\n          }\n      }"

# get_files_content makes use of files_structure

    Code
      files_content <- github_testhost_priv$get_files_content_from_files_structure(
        files_structure = test_mocker$use("gh_files_structure_from_orgs"))

