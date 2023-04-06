# Organizations are correctly checked if they exist

    Code
      github_env$check_orgs(c("openparma", "r-world-devs"))
    Message <cliMessage>
      x Organization you provided does not exist. Check spelling in: openparma
    Message <simpleMessage>
      HTTP 404 No such address
    Output
      [1] "r-world-devs"

---

    Code
      gitlab_env$check_orgs("openparma")
    Message <cliMessage>
      x Organization you provided does not exist. Check spelling in: openparma
    Message <simpleMessage>
      HTTP 404 No such address
    Output
      NULL

