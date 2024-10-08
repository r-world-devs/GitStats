# files tree query for GitHub are built properly

    Code
      gh_files_tree_query
    Output
      [1] "query GetFilesFromRepo($org: String!, $repo: String!, $expression: String!) {\n          repository(owner: $org, name: $repo) {\n            id\n            name\n            url\n            object(expression: $expression) {\n              ... on Tree {\n                entries {\n                  name\n                  type\n                }\n              }\n            }\n          }\n      }"

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

# get_files_content makes use of files_structure

    Code
      files_content <- github_testhost_priv$get_files_content_from_orgs(file_path = NULL,
        host_files_structure = test_mocker$use("gh_files_structure_from_orgs"))
    Message
      i I will make use of files structure stored in GitStats.

