# Set connection returns appropriate messages

    Code
      set_connection(gitstats_obj = test_gitstats, api_url = "https://api.github.com",
        token = Sys.getenv("GITHUB_PAT"), orgs = c("openpharma", "r-world-devs")) %>%
        set_connection(api_url = "https://gitlab.com/api/v4", token = Sys.getenv(
          "GITLAB_PAT"), orgs = c("mbtests"))
    Message <cliMessage>
      v Set connection to GitHub.
      v Set connection to GitLab.

# Adequate condition shows if organizations are not specified

    Code
      test_gitstats %>% set_connection(api_url = "https://api.github.com", token = Sys.getenv(
        "GITHUB_PAT"))
    Message <cliMessage>
      ! No organizations specified.
      v Set connection to GitHub.

---

    Code
      test_gitstats %>% set_connection(api_url = "https://gitlab.com/api/v4", token = Sys.getenv(
        "GITLAB_PAT"))
    Message <cliMessage>
      ! No organizations specified.
      v Set connection to GitLab.

# Errors pop out, when wrong input is passed when setting connection

    Code
      set_connection(gitstats_obj = test_gitstats, api_url = "https://avengers.com",
        token = Sys.getenv("GITLAB_PAT"))
    Error <simpleError>
      This connection is not supported by GitStats class object.

# Error pops out, when two clients of the same url api are passed as input

    Code
      test_gitstats %>% set_connection(api_url = "https://api.github.com", token = Sys.getenv(
        "GITHUB_PAT"), orgs = "pharmaverse") %>% set_connection(api_url = "https://api.github.com",
        token = Sys.getenv("GITHUB_PAT"), orgs = "openpharma")
    Message <cliMessage>
      v Set connection to GitHub.
      v Set connection to GitHub.
    Error <simpleError>
      You can not provide two clients of the same API urls.
                     If you wish to change/add more organizations you can do it with `set_organizations()` function.

# When token is empty throw error and do not pass connection

    Code
      set_connection(gitstats_obj = test_gitstats, api_url = "https://api.github.com",
        token = Sys.getenv("TOKEN_THAT_DOES_NOT_EXIST"), orgs = "r-world-devs")
    Message <simpleMessage>
      HTTP 401 Unauthorized.
    Message <cliMessage>
      v Set connection to GitHub.
    Error <rlang_error>
      i No token provided for `https://api.github.com`.
      x Host will not be passed to `GitStats` object.

# Warning shows up, when token is invalid

    Code
      set_connection(gitstats_obj = test_gitstats, api_url = "https://api.github.com",
        token = "INVALID_TOKEN", orgs = "r-world-devs")
    Message <simpleMessage>
      HTTP 401 Unauthorized.
    Message <cliMessage>
      v Set connection to GitHub.
    Error <rlang_error>
      i Token provided for `https://api.github.com` is invalid.
      x Host will not be passed to `GitStats` object.

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
        token = Sys.getenv("GITLAB_PAT"), orgs = c("openparma", "mbtests"))
    Message <cliMessage>
      x Organization you provided does not exist. Check spelling in: openparma
    Message <simpleMessage>
      HTTP 404 No such address
    Message <cliMessage>
      v Set connection to GitLab.

# Error with message pops out, when you pass to your `GitLab` connection group name as you see it on the page (not from url)

    Code
      test_gitstats <- create_gitstats() %>% set_connection(api_url = "https://gitlab.com/api/v4",
        token = Sys.getenv("GITLAB_PAT"), orgs = "MB Tests")
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
        token = Sys.getenv("GITLAB_PAT"), orgs = c("mbtests", "MB Tests"))
    Message <cliMessage>
      x Group name passed in a wrong way: MB Tests
      ! If you are using `GitLab`, please type your group name as you see it in `url`.
      i E.g. do not use spaces. Group names as you see on the page may differ from their 'address' name.
    Message <simpleMessage>
      HTTP 404 No such address
    Message <cliMessage>
      v Set connection to GitLab.

