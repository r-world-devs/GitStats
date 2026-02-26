test_fixtures_pr <- list()

github_open_pr_edge <- function(created_at) {
  list(
    "node" = list(
      "number" = 1,
      "created_at" = created_at,
      "merged_at" = "",
      "state" = "open",
      "author" = list(
        "login" = "test"
      ),
      "source_branch" = "dev",
      "target_branch" = "main"
    )
  )
}

github_closed_pr_edge <- function(created_at) {
  list(
    "node" = list(
      "number" = 1,
      "created_at" = created_at,
      "merged_at" = "2027-01-01T00:00:00Z",
      "state" = "closed",
      "author" = list(
        "login" = "test"
      ),
      "source_branch" = "dev",
      "target_branch" = "main"
    )
  )
}

open_pr_timestamps <- generate_random_timestamps(25, 2024, 2026)
set.seed(234)
closed_pr_timestamps <- generate_random_timestamps(25, 2024, 2026)

open_prs <- purrr::map(open_pr_timestamps, github_open_pr_edge)
closed_prs <- purrr::map(closed_pr_timestamps, github_closed_pr_edge)

test_fixtures_pr$github_graphql_pr_response <- list(
  "data" = list(
    "repository" = list(
      "pullRequests" = list(
        "pageInfo" = list(
          "hasNextPage" = FALSE,
          "endCursor" = ""
        ),
        "edges" = append(open_prs, closed_prs)
      )
    )
  )
)


test_fixtures_pr$gitlab_graphql_pr_response <- list(
  "data" = list(
    "project" = list(
      "mergeRequests" = list(
        "pageInfo" = list(
          "hasNextPage" = FALSE,
          "endCursor" = ""
        ),
        "edges" = append(open_prs, closed_prs)
      )
    )
  )
)
