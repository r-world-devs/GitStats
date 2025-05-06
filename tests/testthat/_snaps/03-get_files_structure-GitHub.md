# files tree query for GitHub are built properly

    Code
      gh_files_tree_query
    Output
      [1] "query GetFilesFromRepo($org: String!, $repo: String!, $expression: String!) {\n          repository(owner: $org, name: $repo) {\n            id\n            name\n            url\n            object(expression: $expression) {\n              ... on Tree {\n                entries {\n                  name\n                  type\n                }\n              }\n            }\n          }\n      }"

# get_files_structure_from_orgs() prints message

    Code
      gh_files_structure_from_orgs <- github_testhost_priv$
        get_files_structure_from_orgs(pattern = "\\.md|\\.qmd|\\.Rmd", depth = Inf,
        verbose = TRUE)
    Message
      > [Host:GitHub][Engine:GraphQl][Scope:test_org] Pulling files 🌳 structure...[files matching pattern: '\.md|\.qmd|\.Rmd']...

---

    Code
      gh_files_structure_from_orgs <- github_testhost_priv$
        get_files_structure_from_orgs(pattern = NULL, depth = Inf, verbose = TRUE)
    Message
      > [Host:GitHub][Engine:GraphQl][Scope:test_org] Pulling files 🌳 structure......

# get_files_structure_from_repos() prints message

    Code
      gh_files_structure_from_repos <- github_testhost_priv$
        get_files_structure_from_repos(pattern = "\\.md|\\.qmd|\\.Rmd", depth = Inf,
        verbose = TRUE)
    Message
      > [Host:GitHub][Engine:GraphQl][Scope:test_org: 1 repos] Pulling files 🌳 structure...[files matching pattern: '\.md|\.qmd|\.Rmd']...

---

    Code
      gh_files_structure_from_repos <- github_testhost_priv$
        get_files_structure_from_repos(pattern = NULL, depth = Inf, verbose = TRUE)
    Message
      > [Host:GitHub][Engine:GraphQl][Scope:test_org: 1 repos] Pulling files 🌳 structure......

# when files_structure is empty, appropriate message is returned

    Code
      github_testhost_priv$get_files_structure_from_repos(pattern = "\\.png", depth = 1L,
        verbose = TRUE)
    Message
      ! For GitHub no files structure found.
    Output
      named list()

# get_files_structure aborts when scope to scan whole host

    x This feature is not applicable to scan whole Git Host (time consuming).
    i Set `orgs` or `repos` arguments in `set_*_host()` if you wish to run this function.

