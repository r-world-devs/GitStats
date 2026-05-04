# Error shows, when wrong input is passed when setting connection and host is not passed

    x Token exists but does not grant access.
    i Check if you use correct token.
    ! Scope that is needed: [read_api].

# Error pops out, when two clients of the same url api are passed as input

    x You can not provide two hosts of the same API urls.

# Error pops out when `org` does not exist

    Code
      test_gitstats <- set_github_host(create_gitstats(), token = Sys.getenv(
        "GITHUB_PAT"), orgs = c("openparma"))
    Message
      > Checking owners...
    Condition
      Error in `purrr::map()`:
      i In index: 1.
      Caused by error:
      x Org/user you provided does not exist or its name was passed in a wrong way: openparma
      ! Please type your org/user name the way you see it in web URL.

---

    Code
      test_gitstats <- set_gitlab_host(create_gitstats(), token = Sys.getenv(
        "GITLAB_PAT_PUBLIC"), orgs = c("openparma", "mbtests"))
    Message
      > Checking owners...
    Condition
      Error in `purrr::map()`:
      i In index: 1.
      Caused by error:
      x Org/user you provided does not exist or its name was passed in a wrong way: openparma
      ! Please type your org/user name the way you see it in web URL.

---

    Code
      test_gitstats <- set_github_host(create_gitstats(), token = Sys.getenv(
        "GITHUB_PAT"), orgs = c("openpharma", "r_world_devs"))
    Message
      > Checking owners...
    Condition
      Error in `purrr::map()`:
      i In index: 2.
      Caused by error:
      x Org/user you provided does not exist or its name was passed in a wrong way: r_world_devs
      ! Please type your org/user name the way you see it in web URL.

