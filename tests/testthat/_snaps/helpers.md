# `set_searching_scope` does not throw error when `orgs` or `repos` are defined

    Code
      gitlab_testhost_priv$set_searching_scope(orgs = "mbtests", repos = NULL,
        verbose = TRUE)

---

    Code
      gitlab_testhost_priv$set_searching_scope(orgs = NULL, repos = "mbtests/GitStatsTesting",
        verbose = TRUE)

# `set_searching_scope` sets scope to whole host

    Code
      gitlab_testhost_priv$set_searching_scope(orgs = NULL, repos = NULL, verbose = TRUE)
    Message
      i No `orgs` nor `repos` specified.
      i Searching scope set to [all].

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

# `set_default_token` sets default token for GitLab

    Code
      withr::with_envvar(new = c(GITLAB_PAT = Sys.getenv("GITLAB_PAT_PUBLIC")), {
        default_token <- gitlab_testhost_priv$set_default_token(verbose = TRUE)
      })
    Message
      i Using PAT from GITLAB_PAT envar.

