github_commit_edge <- function(timestamp, author) {
  list(
    "node" = list(
      "id" = "xxx",
      "committed_date" = timestamp,
      "author" = list(
        "name" = author,
        "user" = list(
          "name" = "Maciej Banas",
          "login" = "maciekbanas"
        )
      ),
      "additions" = 5L,
      "deletions" = 8L,
      "repository" = list(
        "url" = "test_url"
      )
    )
  )
}

set.seed(123)
commit_timestamps <- generate_random_timestamps(25, 2023, 2024)
commit_authors <- generate_random_names(25, c("John Test", "Barbara Check", "Bob Test"))

test_fixtures$github_commits_response <- list(
  "data" = list(
    "repository" = list(
      "defaultBranchRef" = list(
        "target" = list(
          "history" = list(
            "edges" = purrr::map2(commit_timestamps, commit_authors, github_commit_edge)
          )
        )
      )
    )
  )
)

gitlab_commit <- list(
  "id" = "xxxxxxxxxxxxxxxxx",
  "short_id" = "xxx",
  "created_at" = "2023-04-05T12:07:50.000+00:00",
  "parent_ids" = list(
    "iiiiiiiiiiiiiii"
  ),
  "title" = "Test title",
  "message" = "Test title",
  "author_name" = "Maciej Banas",
  "author_email" = "testmail@test.com",
  "authored_date" = "2023-04-05T12:07:50.000+00:00",
  "committer_name" = "Maciej Banas",
  "committer_email" = "testmail@test.com",
  "committed_date" = "2023-04-05T12:07:50.000+00:00",
  "trailers" = list(),
  "extedned_trailers" = list(),
  "web_url" = "https://test_url.com/-/commit/sxsxsxsx",
  "stats" = list(
    "additions" = 1L,
    "deletions" = 0L,
    "total" = 1L
  )
)

test_fixtures$gitlab_commits_response <- rep(list(gitlab_commit), 5)
