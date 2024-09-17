# files tree query for GitHub and GitLab are built properly

    Code
      gh_files_tree_query
    Output
      [1] "query GetFilesFromRepo($org: String!, $repo: String!, $expression: String!) {\n          repository(owner: $org, name: $repo) {\n            id\n            name\n            url\n            object(expression: $expression) {\n              ... on Tree {\n                entries {\n                  name\n                  type\n                }\n              }\n            }\n          }\n      }"

---

    Code
      gl_files_tree_query
    Output
      [1] "\n      query GetFilesTree ($fullPath: ID!, $file_path: String!) {\n        project(fullPath: $fullPath) {\n          repository {\n            tree(path: $file_path) {\n              trees (first: 100) {\n                pageInfo{\n                  endCursor\n                  hasNextPage\n                }\n                nodes {\n                  name\n                }\n              }\n              blobs (first: 100) {\n                pageInfo{\n                  endCursor\n                  hasNextPage\n                }\n                nodes {\n                  name\n                }\n              }\n            }\n          }\n        }\n      }\n      "

# file queries for GitLab and GitHub are built properly

    Code
      gl_files_query
    Output
      [1] "query GetFilesByOrg($org: ID!, $file_paths: [String!]!) {\n            group(fullPath: $org) {\n              projects(first: 100) {\n                count\n                pageInfo {\n                  hasNextPage\n                  endCursor\n                }\n                edges {\n                  node {\n                    name\n                    id\n                    webUrl\n                    repository {\n                      blobs(paths: $file_paths) {\n                        nodes {\n                          name\n                          rawBlob\n                          size\n                        }\n                      }\n                    }\n                  }\n                }\n              }\n            }\n          }"

---

    Code
      gl_file_blobs_from_repo_query
    Output
      [1] "\n      query GetFilesByRepo($fullPath: ID!, $file_paths: [String!]!) {\n        project(fullPath: $fullPath) {\n          name\n          id\n          webUrl\n          repository {\n            blobs(paths: $file_paths) {\n              nodes {\n                name\n                rawBlob\n                size\n              }\n            }\n          }\n        }\n      }\n      "

---

    Code
      gh_file_blobs_from_repo_query
    Output
      [1] "query GetFileBlobFromRepo($org: String!, $repo: String!, $expression: String!) {\n          repository(owner: $org, name: $repo) {\n            repo_id: id\n            repo_name: name\n            repo_url: url\n            file: object(expression: $expression) {\n              ... on Blob {\n                text\n                byteSize\n              }\n            }\n          }\n      }"

# Gitlab GraphQL switches to pulling files per repositories when query is too complex

    Code
      gitlab_files_response_by_repos <- test_graphql_gitlab$get_files_from_org(org = "mbtests",
        repos = NULL, file_paths = c("DESCRIPTION", "project_metadata.yaml",
          "README.md"), host_files_structure = NULL, only_text_files = TRUE, verbose = TRUE,
        progress = FALSE)
    Message
      i I will switch to pulling files per repository.

# get_files_structure_from_orgs pulls files structure for repositories in orgs

    Code
      gh_files_structure_from_orgs <- github_testhost_priv$
        get_files_structure_from_orgs(pattern = "\\.md|\\.qmd|\\.png", depth = 2L,
        verbose = TRUE)
    Message
      i [Host:GitHub][Engine:GraphQl][Scope:r-world-devs] Pulling files structure...[files matching pattern: '\.md|\.qmd|\.png']...
      i [Host:GitHub][Engine:GraphQl][Scope:openpharma] Pulling files structure...[files matching pattern: '\.md|\.qmd|\.png']...

---

    Code
      gl_files_structure_from_orgs <- gitlab_testhost_priv$
        get_files_structure_from_orgs(pattern = "\\.md|\\.R", depth = 1L, verbose = TRUE)
    Message
      i [Host:GitLab][Engine:GraphQl][Scope:mbtests] Pulling files structure...[files matching pattern: '\.md|\.R']...

# when files_structure is empty, appropriate message is returned

    Code
      github_testhost_priv$get_files_structure_from_orgs(pattern = "\\.png", depth = 1L,
        verbose = TRUE)
    Message
      i [Host:GitHub][Engine:GraphQl][Scope:r-world-devs] Pulling files structure...[files matching pattern: '\.png']...
      i [Host:GitHub][Engine:GraphQl][Scope:openpharma] Pulling files structure...[files matching pattern: '\.png']...
      ! For GitHub no files structure found.
    Output
      named list()

# `get_files_content()` pulls files in the table format

    Code
      gh_files_table <- github_testhost$get_files_content(file_path = "LICENSE")

---

    Code
      gl_files_table <- gitlab_testhost$get_files_content(file_path = "README.md")

# `get_files_content()` pulls files only for the repositories specified

    Code
      gh_files_table <- github_testhost$get_files_content(file_path = "renv.lock")
    Message
      i [Host:GitHub][Engine:GraphQl][Scope:r-world-devs] Pulling files content: [renv.lock]...
      i [Host:GitHub][Engine:GraphQl][Scope:openpharma] Pulling files content: [renv.lock]...

# `get_files_content()` pulls two files in the table format

    Code
      gl_files_table <- gitlab_testhost$get_files_content(file_path = c(
        "meta_data.yaml", "README.md"))
    Message
      i [Host:GitLab][Engine:GraphQl][Scope:mbtests] Pulling files content: [meta_data.yaml, README.md]...

