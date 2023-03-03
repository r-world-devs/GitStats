# Set connection returns appropriate messages

    Code
      set_connection(gitstats_obj = test_gitstats, api_url = "https://api.github.com",
        token = Sys.getenv("GITHUB_PAT"), orgs = c("openpharma", "r-world-devs")) %>%
        set_connection(api_url = "https://gitlab.com/api/v4", token = Sys.getenv(
          "GITLAB_PAT"), orgs = c("mbtests"))
    Message <cliMessage>
      v Set connection to GitHub.
      v Set connection to GitLab.

