# `pull_repos()` works as expected

    Code
      gl_repos_org <- test_gql_gl$pull_repos(org = "mbtests", settings = settings)
    Message
      i [GitLab][Engine:GraphQL][org:mbtests] Pulling repositories...

# `pull_files()` pulls files in the table format

    Code
      gl_files_table <- test_gql_gl$pull_files(org = "mbtests", file_path = "README.md")
    Message
      i [Engine:GraphQL][org:mbtests] Pulling README.md files...

