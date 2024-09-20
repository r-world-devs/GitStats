# files tree query for GitHub are built properly

    Code
      gh_files_tree_query
    Output
      [1] "query GetFilesFromRepo($org: String!, $repo: String!, $expression: String!) {\n          repository(owner: $org, name: $repo) {\n            id\n            name\n            url\n            object(expression: $expression) {\n              ... on Tree {\n                entries {\n                  name\n                  type\n                }\n              }\n            }\n          }\n      }"

# get_files_structure_from_orgs pulls files structure for repositories in orgs

    Code
      gh_files_structure_from_orgs <- github_testhost_priv$
        get_files_structure_from_orgs(pattern = "\\.md|\\.qmd|\\.png", depth = 2L,
        verbose = TRUE)
    Message
      i [Host:GitHub][Engine:GraphQl][Scope:r-world-devs] Pulling files structure...[files matching pattern: '\.md|\.qmd|\.png']...
      i [Host:GitHub][Engine:GraphQl][Scope:openpharma] Pulling files structure...[files matching pattern: '\.md|\.qmd|\.png']...

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

