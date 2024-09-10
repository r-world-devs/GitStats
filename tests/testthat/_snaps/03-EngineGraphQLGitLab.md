# Gitlab GraphQL switches to pulling files per repositories when query is too complex

    Code
      gitlab_files_response_by_repos <- test_gql_gl$get_files_from_org(org = "mbtests",
        repos = NULL, file_paths = c("DESCRIPTION", "project_metadata.yaml",
          "README.md"), host_files_structure = NULL, verbose = TRUE, progress = FALSE)
    Message
      i I will switch to pulling files per repository.

