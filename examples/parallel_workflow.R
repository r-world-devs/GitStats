devtools::load_all()

set_parallel(4)

my_gitstats <- create_gitstats() |>
  set_github_host(
    token = Sys.getenv("GITHUB_PAT"),
    orgs = c("r-world-devs", "openpharma")
  )

get_commits(my_gitstats, since = "2024-01-01", cache = FALSE)

set_parallel(FALSE)

get_commits(my_gitstats, since = "2024-01-01", cache = FALSE)
