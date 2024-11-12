# Set connection returns appropriate messages

    Code
      set_github_host(gitstats_obj = test_gitstats, token = Sys.getenv("GITHUB_PAT"),
      orgs = c("openpharma", "r-world-devs"))
    Message
      i Searching scope set to [org].
      i Checking organizations...
      v Set connection to GitHub.

---

    Code
      test_gitstats %>% set_gitlab_host(token = Sys.getenv("GITLAB_PAT_PUBLIC"),
      orgs = c("mbtests"))
    Message
      i Searching scope set to [org].
      i Checking organizations...
      v Set connection to GitLab.

# When empty token for GitHub, GitStats pulls default token

    Code
      test_gitstats <- create_gitstats() %>% set_github_host(orgs = c("openpharma",
        "r-world-devs"))
    Message
      i Using PAT from GITHUB_PAT envar.
      i Searching scope set to [org].
      i Checking organizations...
      v Set connection to GitHub.

# When empty token for GitLab, GitStats pulls default token

    Code
      withr::with_envvar(new = c(GITLAB_PAT = Sys.getenv("GITLAB_PAT_PUBLIC")), {
        test_gitstats <- create_gitstats() %>% set_gitlab_host(orgs = "mbtests")
      })
    Message
      i Using PAT from GITLAB_PAT envar.
      i Searching scope set to [org].
      i Checking organizations...
      v Set connection to GitLab.

# Set GitHub host with particular repos vector instead of orgs

    Code
      test_gitstats %>% set_github_host(token = Sys.getenv("GITHUB_PAT"), repos = c(
        "r-world-devs/GitStats", "r-world-devs/shinyCohortBuilder",
        "openpharma/GithubMetrics", "openpharma/DataFakeR"))
    Message
      i Searching scope set to [repo].
      i Checking repositories...
      v Set connection to GitHub.

# Set GitLab host with particular repos vector instead of orgs

    Code
      test_gitstats %>% set_gitlab_host(token = Sys.getenv("GITLAB_PAT_PUBLIC"),
      repos = c("mbtests/gitstatstesting", "mbtests/gitstats-testing-2"))
    Message
      i Searching scope set to [repo].
      i Checking repositories...
      v Set connection to GitLab.

# Set host prints error when repos and orgs are defined and host is not passed to GitStats

    Do not specify `orgs` while specifing `repos`.
    x Host will not be added.
    i Specify `orgs` or `repos`.

# Error shows if organizations are not specified and host is not passed

    You need to specify `orgs` for public Git Host.
    x Host will not be added.
    i Add organizations to your `orgs` parameter.

# Error shows, when wrong input is passed when setting connection and host is not passed

    x Token exists but does not grant access.
    i Check if you use correct token.
    ! Scope that is needed: [read_api].

# Error pops out, when two clients of the same url api are passed as input

    Code
      test_gitstats %>% set_github_host(token = Sys.getenv("GITHUB_PAT"), orgs = "pharmaverse") %>%
        set_github_host(token = Sys.getenv("GITHUB_PAT"), orgs = "openpharma")
    Message
      i Searching scope set to [org].
      i Checking organizations...
      v Set connection to GitHub.
      i Searching scope set to [org].
      i Checking organizations...
      v Set connection to GitHub.
    Condition
      Error:
      x You can not provide two hosts of the same API urls.

# Error pops out when `org` does not exist

    Code
      test_gitstats <- create_gitstats() %>% set_github_host(token = Sys.getenv(
        "GITHUB_PAT"), orgs = c("openparma"))
    Message
      i Searching scope set to [org].
      i Checking organizations...
    Condition
      Error in `purrr::map()`:
      i In index: 1.
      Caused by error:
      x Organization you provided does not exist or its name was passed in a wrong way: https://api.github.com/orgs/openparma
      ! Please type your organization name as you see it in web URL.
      i E.g. do not use spaces. Organization names as you see on the page may differ from their web 'address'.

---

    Code
      test_gitstats <- create_gitstats() %>% set_gitlab_host(token = Sys.getenv(
        "GITLAB_PAT_PUBLIC"), orgs = c("openparma", "mbtests"))
    Message
      i Searching scope set to [org].
      i Checking organizations...
    Condition
      Error in `purrr::map()`:
      i In index: 1.
      Caused by error:
      x Organization you provided does not exist or its name was passed in a wrong way: https://gitlab.com/api/v4/groups/openparma
      ! Please type your organization name as you see it in web URL.
      i E.g. do not use spaces. Organization names as you see on the page may differ from their web 'address'.

---

    Code
      test_gitstats <- create_gitstats() %>% set_github_host(token = Sys.getenv(
        "GITHUB_PAT"), orgs = c("openpharma", "r_world_devs"))
    Message
      i Searching scope set to [org].
      i Checking organizations...
    Condition
      Error in `purrr::map()`:
      i In index: 2.
      Caused by error:
      x Organization you provided does not exist or its name was passed in a wrong way: https://api.github.com/orgs/r_world_devs
      ! Please type your organization name as you see it in web URL.
      i E.g. do not use spaces. Organization names as you see on the page may differ from their web 'address'.

