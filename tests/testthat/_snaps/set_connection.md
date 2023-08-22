# Set connection returns appropriate messages

    Code
      set_connection(gitstats_obj = test_gitstats, api_url = "https://api.github.com",
        token = Sys.getenv("GITHUB_PAT"), orgs = c("openpharma", "r-world-devs"))
    Message <cliMessage>
      v Set connection to GitHub.

---

    Code
      test_gitstats %>% set_connection(api_url = "https://gitlab.com/api/v4", token = Sys.getenv(
        "GITLAB_PAT_PUBLIC"), orgs = c("mbtests"))
    Message <cliMessage>
      v Set connection to GitLab.

# When empty token for GitHub, GitStats pulls default token

    Code
      test_gitstats <- create_gitstats() %>% set_connection(api_url = "https://api.github.com",
        orgs = c("openpharma", "r-world-devs"))
    Message <cliMessage>
      i Using PAT from GITHUB_PAT envar.
      v Set connection to GitHub.

# When empty token for GitLab, GitStats pulls default token

    Code
      withr::with_envvar(new = c(GITLAB_PAT = Sys.getenv("GITLAB_PAT_PUBLIC")), {
        test_gitstats <- create_gitstats() %>% set_connection(api_url = "https://gitlab.com/api/v4",
          orgs = "mbtests")
      })
    Message <cliMessage>
      i Using PAT from GITLAB_PAT envar.
      v Set connection to GitLab.

# Warning shows if organizations are not specified and host is not passed

    Code
      test_gitstats %>% set_connection(api_url = "https://api.github.com", token = Sys.getenv(
        "GITHUB_PAT"))
    Message <cliMessage>
      ! You need to specify `orgs` for public Git platform.
      x Host will not be passed.

# Warning shows, when wrong input is passed when setting connection and host is not passed

    Code
      set_connection(gitstats_obj = test_gitstats, api_url = "https://avengers.com",
        token = Sys.getenv("GITLAB_PAT_PUBLIC"))
    Message <cliMessage>
      ! This connection is not supported by GitStats class object.
      x Host will not be passed.

# Error pops out, when two clients of the same url api are passed as input

    Code
      test_gitstats %>% set_connection(api_url = "https://api.github.com", token = Sys.getenv(
        "GITHUB_PAT"), orgs = "pharmaverse") %>% set_connection(api_url = "https://api.github.com",
        token = Sys.getenv("GITHUB_PAT"), orgs = "openpharma")
    Message <cliMessage>
      v Set connection to GitHub.
      v Set connection to GitHub.
    Error <simpleError>
      You can not provide two hosts of the same API urls.
                     If you wish to change/add more organizations you can do it with `set_organizations()` function.

# `Org` name is not passed to the object if it does not exist

    Code
      test_gitstats <- create_gitstats() %>% set_connection(api_url = "https://api.github.com",
        token = Sys.getenv("GITHUB_PAT"), orgs = c("openparma"))
    Message <cliMessage>
      x Organization you provided does not exist. Check spelling in: openparma
    Message <simpleMessage>
      HTTP 404 No such address
    Message <cliMessage>
      v Set connection to GitHub.

---

    Code
      test_gitstats <- create_gitstats() %>% set_connection(api_url = "https://gitlab.com/api/v4",
        token = Sys.getenv("GITLAB_PAT_PUBLIC"), orgs = c("openparma", "mbtests"))
    Message <cliMessage>
      x Group name passed in a wrong way: openparma
      ! If you are using `GitLab`, please type your group name as you see it in `url`.
      i E.g. do not use spaces. Group names as you see on the page may differ from their 'address' name.
    Message <simpleMessage>
      HTTP 404 No such address
    Message <cliMessage>
      v Set connection to GitLab.

# Error with message pops out, when you pass to your `GitLab` connection group name as you see it on the page (not from url)

    Code
      test_gitstats <- create_gitstats() %>% set_connection(api_url = "https://gitlab.com/api/v4",
        token = Sys.getenv("GITLAB_PAT_PUBLIC"), orgs = "MB Tests")
    Message <cliMessage>
      x Group name passed in a wrong way: MB Tests
      ! If you are using `GitLab`, please type your group name as you see it in `url`.
      i E.g. do not use spaces. Group names as you see on the page may differ from their 'address' name.
    Message <simpleMessage>
      HTTP 404 No such address
    Message <cliMessage>
      v Set connection to GitLab.

---

    Code
      test_gitstats <- create_gitstats() %>% set_connection(api_url = "https://gitlab.com/api/v4",
        token = Sys.getenv("GITLAB_PAT_PUBLIC"), orgs = c("mbtests", "MB Tests"))
    Message <cliMessage>
      x Group name passed in a wrong way: MB Tests
      ! If you are using `GitLab`, please type your group name as you see it in `url`.
      i E.g. do not use spaces. Group names as you see on the page may differ from their 'address' name.
    Message <simpleMessage>
      HTTP 404 No such address
    Message <cliMessage>
      v Set connection to GitLab.

