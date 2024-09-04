# When token is empty throw error

    Code
      test_host$check_token("")
    Condition
      Error in `test_host$check_token()`:
      i No token provided.

# `check_token()` prints error when token exists but does not grant access

    x Token exists but does not grant access.
    i Check if you use correct token. Check scopes your token is using.

# check_endpoint returns error if they are not correct

    x Repository you provided does not exist or its name was passed in a wrong way: https://api.github.com/repos/r-worlddevs/GitStats
    ! Please type your repository name as you see it in web URL.
    i E.g. do not use spaces. Repository names as you see on the page may differ from their web 'address'.

# `set_default_token` sets default token for public GitHub

    Code
      default_token <- test_host$set_default_token()
    Message
      i Using PAT from GITHUB_PAT envar.

# `get_all_repos()` works as expected

    Code
      gh_repos_table <- test_host$get_all_repos()
    Message
      i [Host:GitHub][Engine:GraphQl][Scope:openpharma] Pulling repositories...
      i [Host:GitHub][Engine:GraphQl][Scope:r-world-devs] Pulling repositories...

# get_files_structure_from_orgs pulls files structure for repositories in orgs

    Code
      gh_files_structure_from_orgs <- test_host$get_files_structure_from_orgs(
        pattern = "\\.md|\\.qmd", depth = 1L, verbose = TRUE)
    Message
      i [Host:GitHub][Engine:GraphQl][Scope:r-world-devs] Pulling files structure...[files matching pattern: '\.md|\.qmd']...
      i [Host:GitHub][Engine:GraphQl][Scope:openpharma] Pulling files structure...[files matching pattern: '\.md|\.qmd']...

