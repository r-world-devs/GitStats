# `set_searching_scope` does not throw error when `orgs` or `repos` are defined

    Code
      test_host$set_searching_scope(orgs = "mbtests", repos = NULL)
    Message
      i Searching scope set to [org].

---

    Code
      test_host$set_searching_scope(orgs = NULL, repos = "mbtests/GitStatsTesting")
    Message
      i Searching scope set to [repo].

# `prepare_repos_table()` prepares repos table

    Code
      gh_repos_by_code_table <- test_host$prepare_repos_table_from_rest(repos_list = test_mocker$
        use("gh_repos_by_code_tailored"))
    Message
      i Preparing repositories table...

# `pull_all_repos()` works as expected

    Code
      gh_repos_table <- test_host$pull_all_repos(settings = test_settings)
    Message
      i [Host:GitHub][Engine:GraphQl][Scope:r-world-devs] Pulling repositories...

# `pull_files()` pulls files in the table format

    Code
      gh_files_table <- test_host$pull_files(file_path = "LICENSE", settings = test_settings)
    Message
      i [Host:GitHub][Engine:GraphQl][Scope:r-world-devs] Pulling files: [LICENSE]...

---

    Code
      gl_files_table <- test_host_gitlab$pull_files(file_path = "README.md",
        settings = test_settings)
    Message
      i [Host:GitLab][Engine:GraphQl][Scope:mbtests] Pulling files: [README.md]...

# `pull_release_logs()` pulls release logs in the table format

    Code
      releases_table <- test_host$pull_release_logs(since = "2023-05-01", until = "2023-09-30",
        verbose = TRUE, settings = test_settings)
    Message
      i [Host:GitHub][Engine:GraphQl][Scope:r-world-devs] Pulling release logs...

# GitHost prepares table from GitLab repositories response

    Code
      gl_repos_by_code_table <- test_host_gitlab$prepare_repos_table_from_rest(
        repos_list = test_mocker$use("gl_repos_by_code_tailored"))
    Message
      i Preparing repositories table...

# `pull_files()` pulls two files in the table format

    Code
      gl_files_table <- test_host_gitlab$pull_files(file_path = c("meta_data.yaml",
        "README.md"), settings = test_settings)
    Message
      i [Host:GitLab][Engine:GraphQl][Scope:mbtests] Pulling files: [meta_data.yaml, README.md]...

