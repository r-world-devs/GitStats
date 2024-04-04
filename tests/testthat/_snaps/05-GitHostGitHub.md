# When token is empty throw error

    Code
      test_host$check_token("")
    Condition
      Error in `test_host$check_token()`:
      i No token provided.

# `check_token()` prints error when token exists but does not grant access

    x Token exists but does not grant access.
    i Check if you use correct token. Check scopes your token is using.

# check_endpoint returns warning and FALSE if they are not correct

    Code
      check <- test_host$check_endpoint(endpoint = "https://api.github.com/repos/r-worlddevs/GitStats",
        type = "Repository")
    Message
      x Repository you provided does not exist or its name was passed in a wrong way: https://api.github.com/repos/r-worlddevs/GitStats
      ! Please type your repository name as you see it in `url`.
      i E.g. do not use spaces. Repository names as you see on the page may differ from their 'address' name.
      HTTP 404 No such address

# `set_default_token` sets default token for public GitHub

    Code
      default_token <- test_host$set_default_token()
    Message
      i Using PAT from GITHUB_PAT envar.

# GitHost pulls repos from orgs

    Code
      gh_repos_table <- test_host$pull_repos_from_host(test_settings)
    Message
      i [GitHub][Engine:GraphQL][org:openpharma] Pulling repositories...
      i [GitHub][Engine:GraphQL][org:r-world-devs] Pulling repositories...

# GitHost filters GitHub repositories' (pulled by org) table by languages

    Code
      result <- test_host$filter_repos_by_language(repos_table, language = "JavaScript")
    Message
      i Filtering by language.

# GitHost filters GitHub repositories' (pulled by team) table by languages

    Code
      result <- test_host$filter_repos_by_language(repos_table, language = "CSS")
    Message
      i Filtering by language.

# GitHost filters GitHub repositories' (pulled by phrase) table by languages

    Code
      result <- test_host$filter_repos_by_language(gh_repos_table, language = "R")
    Message
      i Filtering by language.

# pull_repos returns table of repositories

    Code
      repos_table <- test_host$pull_repos(settings = test_settings)

# pull_repos_contributors returns table with contributors for GitHub

    Code
      repos_table_2 <- test_host$pull_repos_contributors(repos_table_1, test_settings)
    Message
      i [GitHub][Engine:REST][org:openpharma and r-world-devs] Pulling contributors...

