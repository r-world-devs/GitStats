# Set connection returns appropriate messages

    Code
      set_host(gitstats_obj = test_gitstats, api_url = "https://api.github.com",
        token = Sys.getenv("GITHUB_PAT"), orgs = c("openpharma", "r-world-devs"))
    Message
      v Set connection to GitHub.
      i Your search parameter set to [org].

---

    Code
      test_gitstats %>% set_host(api_url = "https://gitlab.com/api/v4", token = Sys.getenv(
        "GITLAB_PAT_PUBLIC"), orgs = c("mbtests"))
    Message
      v Set connection to GitLab.
      i Your search parameter set to [org].

# When empty token for GitHub, GitStats pulls default token

    Code
      test_gitstats <- create_gitstats() %>% set_host(api_url = "https://api.github.com",
        orgs = c("openpharma", "r-world-devs"))
    Message
      i Using PAT from GITHUB_PAT envar.
      v Set connection to GitHub.
      i Your search parameter set to [org].

# When empty token for GitLab, GitStats pulls default token

    Code
      withr::with_envvar(new = c(GITLAB_PAT = Sys.getenv("GITLAB_PAT_PUBLIC")), {
        test_gitstats <- create_gitstats() %>% set_host(api_url = "https://gitlab.com/api/v4",
          orgs = "mbtests")
      })
    Message
      i Using PAT from GITLAB_PAT envar.
      v Set connection to GitLab.
      i Your search parameter set to [org].

# Set GitHub host with particular repos vector instead of orgs

    Code
      test_gitstats %>% set_host(api_url = "https://api.github.com", token = Sys.getenv(
        "GITHUB_PAT"), repos = c("r-world-devs/GitStats",
        "r-world-devs/shinyCohortBuilder", "openpharma/GithubMetrics",
        "openpharma/DataFakeR"))
    Message
      v Set connection to GitHub.
      i Your search parameter set to [repo].

# Set GitLab host with particular repos vector instead of orgs

    Code
      test_gitstats %>% set_host(api_url = "https://gitlab.com/api/v4", token = Sys.getenv(
        "GITLAB_PAT_PUBLIC"), repos = c("mbtests/gitstatstesting",
        "mbtests/gitstats-testing-2"))
    Message
      v Set connection to GitLab.
      i Your search parameter set to [repo].

# Set host prints error when repos and orgs are defined and host is not passed to GitStats

    Do not specify `orgs` while specifing `repos`.
    x Host will not be added.
    i Specify `orgs` or `repos`.

# Error shows if organizations are not specified and host is not passed

    You need to specify `orgs` for public Git Host.
    x Host will not be added.
    i Add organizations to your `orgs` parameter.

# Error shows, when wrong input is passed when setting connection and host is not passed

    This connection is not supported by GitStats class object.
    x Host will not be added.

# Error pops out, when two clients of the same url api are passed as input

    Code
      test_gitstats %>% set_host(api_url = "https://api.github.com", token = Sys.getenv(
        "GITHUB_PAT"), orgs = "pharmaverse") %>% set_host(api_url = "https://api.github.com",
        token = Sys.getenv("GITHUB_PAT"), orgs = "openpharma")
    Message
      v Set connection to GitHub.
      i Your search parameter set to [org].
      v Set connection to GitHub.
      i Your search parameter set to [org].
    Condition
      Error:
      ! You can not provide two hosts of the same API urls.
                     If you wish to change/add more organizations you can do it with `set_organizations()` function.

# `Org` name is not passed to the object if it does not exist

    Code
      test_gitstats <- create_gitstats() %>% set_host(api_url = "https://api.github.com",
        token = Sys.getenv("GITHUB_PAT"), orgs = c("openparma"))
    Message
      x Organization you provided does not exist or its name was passed in a wrong way: https://api.github.com/orgs/openparma
      ! Please type your organization name as you see it in `url`.
      i E.g. do not use spaces. Organization names as you see on the page may differ from their 'address' name.
      HTTP 404 No such address
      v Set connection to GitHub.
      i Your search parameter set to [org].

---

    Code
      test_gitstats <- create_gitstats() %>% set_host(api_url = "https://gitlab.com/api/v4",
        token = Sys.getenv("GITLAB_PAT_PUBLIC"), orgs = c("openparma", "mbtests"))
    Message
      x Organization you provided does not exist or its name was passed in a wrong way: https://gitlab.com/api/v4/groups/openparma
      ! Please type your organization name as you see it in `url`.
      i E.g. do not use spaces. Organization names as you see on the page may differ from their 'address' name.
      HTTP 404 No such address
      v Set connection to GitLab.
      i Your search parameter set to [org].

---

    Code
      test_gitstats <- create_gitstats() %>% set_host(api_url = "https://api.github.com",
        token = Sys.getenv("GITHUB_PAT"), orgs = c("openpharma", "r_world_devs"))
    Message
      x Organization you provided does not exist or its name was passed in a wrong way: https://api.github.com/orgs/r_world_devs
      ! Please type your organization name as you see it in `url`.
      i E.g. do not use spaces. Organization names as you see on the page may differ from their 'address' name.
      HTTP 404 No such address
      v Set connection to GitHub.
      i Your search parameter set to [org].

