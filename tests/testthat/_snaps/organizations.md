# Organizations are correctly checked if they are not present

    Code
      test_host$check_for_organizations()
    Error <rlang_error>
      Please specify first organizations for [https://api.github.com] with `set_organizations()`.

# Organizations are correctly checked if their names are invalid

    Code
      test_github$check_organizations(c("openparma", "r-world-devs"))
    Message <cliMessage>
      x Organization you provided does not exist. Check spelling in: openparma
    Message <simpleMessage>
      HTTP 404 No such address
    Output
      [1] "r-world-devs"

---

    Code
      test_gitlab$check_organizations("openparma")
    Message <cliMessage>
      x Group name passed in a wrong way: openparma
      ! If you are using `GitLab`, please type your group name as you see it in `url`.
      i E.g. do not use spaces. Group names as you see on the page may differ from their 'address' name.
    Message <simpleMessage>
      HTTP 404 No such address
    Output
      NULL

