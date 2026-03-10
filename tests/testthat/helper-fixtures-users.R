test_fixtures$github_user_response <- list(
  "data" = list(
    "user" = list(
      "id" = "xxx",
      "name" = "Mr Test",
      "login" = "testlogin",
      "email" = "",
      "location" = NULL,
      "starred_repos" = list(
        "totalCount" = 15L
      ),
      "contributions" = list(
        "totalCommitContributions" = 100L,
        "totalIssueContributions" = 50L,
        "totalPullRequestContributions" = 25L,
        "totalPullRequestReviewContributions" = 5L
      ),
      "avatar_url" = "",
      "web_url" = NULL
    )
  )
)

test_fixtures$gitlab_user_response <- list(
  "data" = list(
    "user" = list(
      "id" = "xxx",
      "name" = "Mr Test",
      "login" = "testlogin",
      "email" = "",
      "location" = NULL,
      "starred_repos" = list(
        "count" = 15L
      ),
      "pull_requests" = list(
        "count" = 2L
      ),
      "reviews" = list(
        "count" = 5L
      ),
      "avatar_url" = "",
      "web_url" = "https://gitlab.com/maciekbanas"
    )
  )
)

test_fixtures$gitlab_user_search_response <- list(
  list(
    "id" = "xxx",
    "username" = "maciekbanas",
    "name" = "Maciej Banas",
    "state" = "active",
    "locked" = FALSE,
    "avatar_url" = "",
    "web_url" = ""
  )
)
