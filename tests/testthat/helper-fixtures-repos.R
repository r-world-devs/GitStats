test_fixtures$github_repository_rest_response <- list(
  "id" = 627452680,
  "node_id" = "R_kgDOJWYrCA",
  "name" = "testRepo",
  "full_name" = "test_org/TestRepo",
  "private" = FALSE,
  "owner" = list(
    "login" = "test_org",
    "id" = 103638913,
    "node_id" = "O_kgDOBi1ngQ",
    "avatar_url" = "https://avatars.githubusercontent.com/u/103638913?v=4"
  ),
  "html_url" = "https://testhost.com/test-org/TestRepo",
  "description" = NULL,
  "fork" = FALSE,
  "url" = "https://testhost.com/api/v4/repos/test-org/TestRepo",
  "forks_url" = "https://testhost.com/api/v4/repos/test-org/TestRepo/forks",
  "collaborators_url" = "https://testhost.com/api/v4/repos/test-org/TestRepo/collaborators{/collaborator}",
  "teams_url" = "https://testhost.com/api/v4/repos/test-org/TestRepo/teams",
  "events_url" = "https://testhost.com/api/v4/repos/test-org/TestRepo/events",
  "branches_url" = "https://testhost.com/api/v4/repos/test-org/TestRepo/branches{/branch}",
  "created_at" = "2023-04-13T13:52:24Z",
  "pushed_at" = "2023-12-21T20:36:23Z",
  "size" = 211L,
  "stargazers_count" = 2,
  "watchers_count" = 2,
  "language" = "R",
  "forks_count" = 0,
  "open_issues_count" = 3L
)

test_fixtures$github_repositories_rest_response <- list(
  test_fixtures$github_repository_rest_response,
  list(
    "id" = 2222222222222,
    "name" = "testRepo2",
    "html_url" = "https://testhost.com/test-org/TestRepo",
    "url" = "https://testhost.com/api/v4/repos/test-org/TestRepo"
  ),
  list(
    "id" = 2222222222222,
    "name" = "testRepo3",
    "html_url" = "https://testhost.com/test-org/TestRepo",
    "url" = "https://testhost.com/api/v4/repos/test-org/TestRepo"
  )
)


test_fixtures$gitlab_repositories_rest_response <- list(
  list(
    "id" = "1111",
    "name" = "test repo 1",
    "path" = "test_repo_1",
    "path_with_namespace" = "test_org/test_repo_1",
    "default_branch" = "main",
    "star_count" = 5L,
    "forks_count" = 2L,
    "created_at" = "2023-04-13T13:52:24Z",
    "last_activity_at" = "2025-04-09T17:04:00Z",
    "open_issues_count" = 10L,
    "path" = "testRepo1",
    "_links" = list("self" = "https://gitlab.com/api/v4/projects/43400864"),
    "web_url" = "https://gitlab.com/mbtests/gitstats-testing-2"
  ),
  list(
    "id" = "2222",
    "name" = "test repo 2",
    "path" = "test_repo_2",
    "path_with_namespace" = "test_org/test_repo_2",
    "default_branch" = "devel",
    "star_count" = 5L,
    "forks_count" = 2L,
    "created_at" = "2023-04-14T13:52:24Z",
    "last_activity_at" = "2025-04-09T17:04:00Z",
    "open_issues_count" = 10L,
    "path" = "testRepo2",
    "_links" = list("self" = "https://gitlab.com/api/v4/projects/43398933"),
    "web_url" = "https://gitlab.com/mbtests/gitstatstesting"
  ),
  list(
    "id" = "3333",
    "name" = "test repo 3",
    "path" = "test_repo_3",
    "path_with_namespace" = "test_org/test_repo_3",
    "default_branch" = "test",
    "star_count" = 5L,
    "forks_count" = 2L,
    "created_at" = "2023-05-23T13:52:24Z",
    "last_activity_at" = "2025-04-09T17:04:00Z",
    "open_issues_count" = 10L,
    "path" = "testRepo3",
    "_links" = list("self" = "https://gitlab.com/api/v4/projects/43398933"),
    "web_url" = "https://gitlab.com/mbtests/gitstatstesting"
  )
)

github_repository_node <- function(org_name, repo_name) {
  list(
    "repo_id" = "test_node_id",
    "repo_name" = repo_name,
    "repo_path" = repo_name,
    "repo_fullpath" = paste0(org_name, "/", repo_name),
    "default_branch" = list(
      "name" = "main"
    ),
    "stars" = 10,
    "forks" = 2,
    "created_at" = "2022-04-20T00:00:00Z",
    "last_activity_at" = "2023-04-20T00:00:00Z",
    "languages" = list(
      "nodes" = list(
        list(
          "name" = "R"
        ),
        list(
          "name" = "CSS"
        ),
        list(
          "name" = "JavaScript"
        )
      )
    ),
    "issues_open" = list(
      "totalCount" = 10
    ),
    "issues_closed" = list(
      "totalCount" = 5
    ),
    "organization" = list(
      "login" = "r-world-devs"
    ),
    "repo_url" = "https://github.test.com/api/test_url",
    "defaultBranchRef" = list(
      "target" = list(
        "oid" = "1a2b3c4e5f"
      )
    )
  )
}

test_fixtures$github_repos_by_ids_response <- list(
  "data" = list(
    "nodes" = list(
      github_repository_node("TestOrg", "TestRepo"),
      github_repository_node("TestOrg", "TestRepo1"),
      github_repository_node("TestOrg", "TestRepo2"),
      github_repository_node("TestOrg", "TestRepo3"),
      github_repository_node("TestOrg", "TestRepo4")
    )
  )
)

test_fixtures$github_repos_by_org_response <- list(
  "data" = list(
    "repositoryOwner" = list(
      "repositories" = list(
        "totalCount" = 5,
        "pageInfo" = list(
          "endCursor" = "xyx",
          "hasNextPage" = FALSE
        ),
        "nodes" = list(
          github_repository_node("r-world-devs", "GitStats"),
          github_repository_node("r-world-devs", "GitAI"),
          github_repository_node("r-world-devs", "cohortBuilder"),
          github_repository_node("r-world-devs", "shinyCohortBuilder"),
          github_repository_node("r-world-devs", "shinyGizmo")
        )
      )
    )
  )
)

test_fixtures$github_repos_by_user_response <- list(
  "data" = list(
    "user" = list(
      "repositories" = list(
        "totalCount" = 5,
        "pageInfo" = list(
          "endCursor" = "xyx",
          "hasNextPage" = FALSE
        ),
        "nodes" = list(
          github_repository_node("TestOrg", "TestRepo"),
          github_repository_node("TestOrg", "TestRepo1"),
          github_repository_node("TestOrg", "TestRepo2"),
          github_repository_node("TestOrg", "TestRepo3"),
          github_repository_node("TestOrg", "TestRepo4")
        )
      )
    )
  )
)

gitlab_project_node <- list(
  "node" = list(
    "repo_id" = "gid://gitlab/Project/61399846",
    "repo_name" = "gitstatstesting",
    "repo_path" = "gitstatstesting",
    "repo_fullpath" = "mbtests/gitstatstesting",
    "repository" = list(
      "rootRef" = "main",
      "lastCommit" = list(
        "sha" = "1a2bc3d4e5"
      )
    ),
    "stars" = 8,
    "forks" = 3,
    "created_at" = "2023-09-18T00:00:00Z",
    "last_activity_at" = "2024-09-18T00:00:00Z",
    "languages" = list(
      list(
        "name" = "Python"
      ),
      list(
        "name" = "R"
      )
    ),
    "issues" = list(
      "all" = 10,
      "closed" = 8,
      "opened" = 2
    ),
    "namespace" = list(
      "path" = "mbtests"
    ),
    "repo_url" = "https://gitlab.com/mbtests/gitstatstesting"
  )
)

test_fixtures$gitlab_repos_by_org_response <- list(
  "data" = list(
    "group" = list(
      "projects" = list(
        "count" = 5,
        "pageInfo" = list(
          "hasNextPage" = FALSE,
          "endCursor" = "xyz"
        ),
        "edges" = list(
          gitlab_project_node,
          gitlab_project_node,
          gitlab_project_node,
          gitlab_project_node,
          gitlab_project_node
        )
      )
    )
  )
)

test_fixtures$gitlab_repos_by_user_response <- list(
  "data" = list(
    "projects" = list(
      "count" = 5,
      "pageInfo" = list(
        "hasNextPage" = FALSE,
        "endCursor" = "xyz"
      ),
      "edges" = list(
        gitlab_project_node,
        gitlab_project_node,
        gitlab_project_node,
        gitlab_project_node,
        gitlab_project_node
      )
    )
  )
)

test_fixtures$gitlab_repos_response_flawed <- list(
  "data" = list(
    "projects" = list(
      "count" = 5,
      "pageInfo" = list(
        "hasNextPage" = NULL,
        "endCursor" = "xyz"
      ),
      "edges" = NULL
    )
  )
)

test_fixtures$gitlab_languages_response <- list(
  "Python" = 100,
  "R" = 50
)

test_fixtures$github_user_login <- list(
  "data" = list(
    "user" = list(
      "__typename" = "User",
      "login" = "test_user"
    ),
    "organization" = NULL
  )
)

test_fixtures$github_org_login <- list(
  "data" = list(
    "user" = NULL,
    "organization" = list(
      "__typename" = "Organization",
      "login" = "test_org"
    )
  )
)

test_fixtures$github_contributor_response <- list(
  "login" = "test_login",
  "id" = 11111L,
  "node_id" = "xxxxx",
  "avatar_url" = "",
  "gravatar_id" = "",
  "url" = "",
  "html_url" = "",
  "followers_url" = ""
)

test_fixtures$github_contributors_response <- list(
  test_fixtures$github_contributor_response,
  test_fixtures$github_contributor_response,
  test_fixtures$github_contributor_response
)
