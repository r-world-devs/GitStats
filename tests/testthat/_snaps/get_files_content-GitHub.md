# file queries for GitHub are built properly

    Code
      gh_file_blobs_from_repo_query
    Output
      [1] "query GetFileBlobFromRepo($org: String!, $repo: String!, $expression: String!) {\n          repository(owner: $org, name: $repo) {\n            repo_id: id\n            repo_name: name\n            repo_url: url\n            file: object(expression: $expression) {\n              ... on Blob {\n                text\n                byteSize\n              }\n            }\n          }\n      }"

# `get_files_content()` pulls files only for the repositories specified

    Code
      gh_files_table <- github_testhost$get_files_content(file_path = "renv.lock")
    Message
      i [Host:GitHub][Engine:GraphQl][Scope:r-world-devs] Pulling files content: [renv.lock]...
      i [Host:GitHub][Engine:GraphQl][Scope:openpharma] Pulling files content: [renv.lock]...

