# Organizations are correctly checked if they do not exist

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
      x Group name passed in a wrong way: openparma
      ! If you are using `GitLab`, please type your group name as you see it in `url`.
      i E.g. do not use spaces. Group names as you see on the page may differ from their 'address' name.
    Message <simpleMessage>
      HTTP 404 No such address
    Output
      NULL

