# `set_searching_scope` does not throw error when `orgs` or `repos` are defined

    Code
      gitlab_testhost_priv$set_searching_scope(orgs = "mbtests", repos = NULL,
        verbose = TRUE)
    Message
      i Searching scope set to [org].

---

    Code
      gitlab_testhost_priv$set_searching_scope(orgs = NULL, repos = "mbtests/GitStatsTesting",
        verbose = TRUE)
    Message
      i Searching scope set to [repo].

# When token is empty throw error

    Code
      github_testhost_priv$check_token("")
    Condition
      Error in `github_testhost_priv$check_token()`:
      i No token provided.

# `check_token()` prints error when token exists but does not grant access

    x Token exists but does not grant access.
    i Check if you use correct token.
    ! Scope that is needed: [public_repo, read:org, read:user].

# check_endpoint returns error if they are not correct

    x Repository you provided does not exist or its name was passed in a wrong way: https://api.github.com/repos/r-worlddevs/GitStats
    ! Please type your repository name as you see it in web URL.
    i E.g. do not use spaces. Repository names as you see on the page may differ from their web 'address'.

# `set_default_token` sets default token for public GitHub

    Code
      default_token <- github_testhost_priv$set_default_token(verbose = TRUE)
    Message
      i Using PAT from GITHUB_PAT envar.

# `set_default_token` returns error if none are found

    Code
      github_testhost_priv$set_default_token(verbose = TRUE)
    Condition
      Error:
      x No sufficient token found among: [GITHUB_PAT, GITHUB_PAT_INSUFFICIENT, GITHUB_PAT_MIN, GITHUB_PAT_ROCHE, TEST_GITHUB_PAT].
      i Check if you have correct token.
      ! Scope that is needed: [public_repo, read:org, read:user].

# `set_default_token` sets default token for GitLab

    Code
      withr::with_envvar(new = c(GITLAB_PAT = Sys.getenv("GITLAB_PAT_PUBLIC")), {
        default_token <- gitlab_testhost_priv$set_default_token(verbose = TRUE)
      })
    Message
      i Using PAT from GITLAB_PAT envar.

# `set_searching_scope` throws error when both `orgs` and `repos` are defined

    Do not specify `orgs` while specifing `repos`.
    x Host will not be added.
    i Specify `orgs` or `repos`.

