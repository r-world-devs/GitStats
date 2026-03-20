# get_files_structure_from_orgs() prints message

    Code
      gh_files_structure_from_orgs <- github_testhost_priv$
        get_files_structure_from_orgs(pattern = "\\.md|\\.qmd|\\.Rmd", depth = Inf,
        verbose = TRUE)
    Message
      > [r-world-devs] Pulling repositories 🌐 data...
      > Caching repositories for [r-world-devs]...
      > [Host:GitHub][Engine:REST][Scope:r-world-devs] Pulling repos 🌳 [files matching pattern: '\.md|\.qmd|\.Rmd']...

---

    Code
      gh_files_structure_from_orgs <- github_testhost_priv$
        get_files_structure_from_orgs(pattern = NULL, depth = Inf, verbose = TRUE)
    Message
      > [r-world-devs] Pulling repositories 🌐 data...
      > Caching repositories for [r-world-devs]...
      > [Host:GitHub][Engine:REST][Scope:r-world-devs] Pulling repos 🌳...

# get_files_structure_from_repos() prints message

    Code
      gh_files_structure_from_repos <- github_testhost_priv$
        get_files_structure_from_repos(pattern = "\\.md|\\.qmd|\\.Rmd", depth = Inf,
        verbose = TRUE)
    Message
      > [test_org] Pulling repositories 🌐 data...
      > Caching repositories for [test_org]...
      > [Host:GitHub][Engine:REST][Scope:test_org: 1 repos] Pulling repos 🌳 [files matching pattern: '\.md|\.qmd|\.Rmd']...

---

    Code
      gh_files_structure_from_repos <- github_testhost_priv$
        get_files_structure_from_repos(pattern = NULL, depth = Inf, verbose = TRUE)
    Message
      > [test_org] Pulling repositories 🌐 data...
      > Caching repositories for [test_org]...
      > [Host:GitHub][Engine:REST][Scope:test_org: 1 repos] Pulling repos 🌳...

# when files_structure is empty, appropriate message is returned

    Code
      github_testhost_priv$get_files_structure_from_repos(pattern = "\\.png", depth = 1L,
        verbose = TRUE)
    Message
      ! For GitHub no files 🌳 structure found.
    Output
      named list()

