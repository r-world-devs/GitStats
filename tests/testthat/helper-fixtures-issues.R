github_open_issue_edge <- function(created_at) {
  list(
    "node" = list(
      "number" = 1,
      "title" = "test",
      "description" = "test",
      "created_at" = created_at,
      "closed_at" = "",
      "state" = "open",
      "url" = "test",
      "author" = list(
        "login" = "test"
      )
    )
  )
}

github_closed_issue_edge <- function(created_at) {
  list(
    "node" = list(
      "number" = 1,
      "title" = "test",
      "description" = "test",
      "created_at" = created_at,
      "closed_at" = "2025-01-01T00:00:00Z",
      "state" = "closed",
      "url" = "test",
      "author" = list(
        "login" = "test"
      )
    )
  )
}

open_issue_timestamps <- generate_random_timestamps(25, 2023, 2025)
set.seed(234)
closed_issue_timestamps <- generate_random_timestamps(25, 2023, 2025)

open_issues <- purrr::map(open_issue_timestamps, github_open_issue_edge)
closed_issues <- purrr::map(closed_issue_timestamps, github_closed_issue_edge)

test_fixtures$github_graphql_issues_response <- list(
  "data" = list(
    "repository" = list(
      "issues" = list(
        "pageInfo" = list(
          "hasNextPage" = FALSE,
          "endCursor" = ""
        ),
        "edges" = append(open_issues, closed_issues)
      )
    )
  )
)


test_fixtures$gitlab_graphql_issues_response <- list(
  "data" = list(
    "project" = list(
      "issues" = list(
        "pageInfo" = list(
          "hasNextPage" = FALSE,
          "endCursor" = ""
        ),
        "edges" = append(open_issues, closed_issues)
      )
    )
  )
)

test_fixtures$github_open_issue_response <- list(
  "url" = "test",
  "repository_url" = "test",
  "labels_url" = "test",
  "comments_url" = "test",
  "events_url" = "test",
  "html_url" = "test",
  "id" = 111111L,
  "node_id" = "xxxxxx",
  "number" = 1L,
  "title" = "Test title",
  "user" = list(),
  "labels" = list(),
  "state" = "open"
)

test_fixtures$github_closed_issue_response <- list(
  "url" = "test",
  "repository_url" = "test",
  "labels_url" = "test",
  "comments_url" = "test",
  "events_url" = "test",
  "html_url" = "test",
  "id" = 111111L,
  "node_id" = "xxxxxx",
  "number" = 1L,
  "title" = "Test title",
  "user" = list(),
  "labels" = list(),
  "state" = "closed"
)

test_fixtures$github_issues_response <- list(
  test_fixtures$github_open_issue_response,
  test_fixtures$github_open_issue_response,
  test_fixtures$github_closed_issue_response
)

test_fixtures$gitlab_issues_response <- list(
  "statistics" = list(
    "counts" = list(
      "all" = 3,
      "closed" = 2,
      "opened" = 1
    )
  )
)
