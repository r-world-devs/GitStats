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

# `set_default_token` sets default token for public GitHub

    Code
      default_token <- test_host$set_default_token()
    Message
      i Using PAT from GITHUB_PAT envar.

# pull_repos_contributors returns table with contributors for GitHub

    Code
      repos_table_2 <- test_host$pull_repos_contributors(repos_table = repos_table_1,
        settings = test_settings)
    Message
      i [Host:GitHub][Engine:REST] Pulling contributors...

