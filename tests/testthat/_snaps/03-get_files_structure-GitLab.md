# get_files_structure_from_orgs prints messages without pattern

    Code
      gl_files_structure <- gitlab_testhost_priv$get_files_structure_from_orgs(
        pattern = NULL, depth = Inf, verbose = TRUE, progress = FALSE)
    Message
      > Using cached repositories data...
      > [Host:GitLab][Engine:REST][Scope:mbtests] Pulling repos 🌳...

# get_files_structure_from_orgs warns when no structure found

    Code
      gl_files_structure <- gitlab_testhost_priv$get_files_structure_from_orgs(
        pattern = NULL, depth = Inf, verbose = TRUE, progress = FALSE)
    Message
      > Using cached repositories data...
      > [Host:GitLab][Engine:REST][Scope:mbtests] Pulling repos 🌳...
      ! For GitLab no files structure found.

# get_files_structure_from_repos prints message

    Code
      gl_files_structure_from_repos <- gitlab_testhost_priv$
        get_files_structure_from_repos(pattern = "\\.md", depth = 1L, verbose = TRUE,
        progress = FALSE)
    Message
      > [Host:GitLab][Engine:REST][Scope:test_group: 0 repos] Pulling repos 🌳 [files matching pattern: '\.md']...

