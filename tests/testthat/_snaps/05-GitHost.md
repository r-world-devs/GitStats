# `check_orgs_and_repos` does not throw error when `orgs` or `repos` are defined

    Code
      test_host$check_orgs_and_repos(orgs = "mbtests", repos = NULL)
    Message
      i Searching scope set to [org].

---

    Code
      test_host$check_orgs_and_repos(orgs = NULL, repos = "mbtests/GitStatsTesting")
    Message
      i Searching scope set to [repo].

# `check_orgs_and_repos` throws error when host is public one

    Do not specify `orgs` while specifing `repos`.
    x Host will not be added.
    i Specify `orgs` or `repos`.

