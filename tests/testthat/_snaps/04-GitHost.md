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

# `get_files_content()` pulls files in the table format

    Code
      gh_files_table <- test_host$get_files_content(file_path = "LICENSE")

---

    Code
      gl_files_table <- test_host_gitlab$get_files_content(file_path = "README.md")

# `get_files_content()` pulls files only for the repositories specified

    Code
      gh_files_table <- test_host$get_files_content(file_path = "renv.lock")
    Message
      i [Host:GitHub][Engine:GraphQl][Scope:r-world-devs] Pulling files content: [renv.lock]...
      i [Host:GitHub][Engine:GraphQl][Scope:openpharma] Pulling files content: [renv.lock]...

# GitHost prepares table from GitLab repositories response

    Code
      gl_repos_by_code_table <- test_host_gitlab$prepare_repos_table_from_rest(
        repos_list = test_mocker$use("gl_repos_by_code_tailored"))
    Message
      i Preparing repositories table...

# `get_files_content()` pulls two files in the table format

    Code
      gl_files_table <- test_host_gitlab$get_files_content(file_path = c(
        "meta_data.yaml", "README.md"))
    Message
      i [Host:GitLab][Engine:GraphQl][Scope:mbtests] Pulling files content: [meta_data.yaml, README.md]...

