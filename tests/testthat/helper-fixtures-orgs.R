github_org_edge <- list(
  "node" = list(
    "name" = "test_name",
    "description" = "test_description",
    "login" = "test_login",
    "url" = "test_url",
    "repositories" = list(
      "totalCount" = 5L
    ),
    "membersWithRole" = list(
      "totalCount" = 3L
    ),
    "avatarUrl" = "test_url"
  )
)

test_fixtures$graphql_gh_orgs_response <- list(
  "data" = list(
    "search" = list(
      "pageInfo" = list(
        "hasNextPage" = FALSE,
        "endCursor" = ""
      ),
      "edges" = list(
        github_org_edge,
        github_org_edge,
        github_org_edge
      )
    )
  )
)

test_fixtures$graphql_gh_org_response <- list(
  "data" = list(
    "organization" = github_org_edge$node
  )
)

test_fixtures$graphql_gl_orgs_count_response <- list(
  "data" = list(
    "groups" = list(
      "count" = 3L
    )
  )
)

gitlab_org_edge <- list(
  "node" = list(
    "name" = "mbtests",
    "description" = "test_description",
    "fullPath" = "mbtests",
    "webUrl" = "web_url",
    "projectsCount" = 5L,
    "groupMembersCount" = 3L,
    "avatarUrl" = "test_url"
  )
)

test_fixtures$graphql_gl_orgs_response <- list(
  "data" = list(
    "groups" = list(
      "pageInfo" = list(
        "endCursor" = "",
        "hasNextPage" = FALSE
      ),
      "edges" = list(
        gitlab_org_edge,
        gitlab_org_edge,
        gitlab_org_edge
      )
    )
  )
)

test_fixtures$graphql_gl_org_response <- list(
  "data" = list(
    "group" = gitlab_org_edge$node
  )
)

test_fixtures$rest_gl_org_response <- list(
  "id" = 11111,
  "web_url" = "url",
  "name" = "mbtests",
  "path" = "mbtests",
  "description" = "test_description"
)
