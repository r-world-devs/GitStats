test_fixtures <- list()

test_fixtures$empty_gql_response <- list(
  "data" = list(
    "group" = list(
      "projects" = list(
        "count" = 0,
        "pageInfo" = list(
          "hasNextPage" = FALSE,
          "endCursor" = NULL
        ),
        "edges" = list()
      )
    )
  )
)

test_fixtures$half_empty_gql_response <- list(
  "data" = list(
    "group" = list(
      "projects" = list(
        "count" = 445,
        "pageInfo" = list(
          "hasNextPage" = TRUE,
          "endCursor" = NULL
        ),
        "edges" = list()
      )
    )
  )
)

test_fixtures$github_repository_rest_response <- list(
  "id" = 627452680,
  "node_id" = "R_kgDOJWYrCA",
  "name" = "testRepo",
  "full_name" = "test-org/TestRepo",
  "private" = FALSE,
  "owner" = list(
    "login" = "test-org",
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
    "html_url" = "https://testhost.com/test-org/TestRepo",
    "url" = "https://testhost.com/api/v4/repos/test-org/TestRepo"
  )
)


test_fixtures$gitlab_repositories_rest_response <- list(
  list(
    "_links" = list("self" = "https://gitlab.com/api/v4/projects/43400864"),
    "web_url" = "https://gitlab.com/mbtests/gitstats-testing-2"
  ),
  list(
    "_links" = list("self" = "https://gitlab.com/api/v4/projects/43398933"),
    "web_url" = "https://gitlab.com/mbtests/gitstatstesting"
  )
)

github_repository_node <- list(
  "repo_id" = "xyz",
  "repo_name" = "TestRepo",
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
    "login" = "test_org"
  ),
  "repo_url" = "https://test_url"
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
          github_repository_node,
          github_repository_node,
          github_repository_node,
          github_repository_node,
          github_repository_node
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
          github_repository_node,
          github_repository_node,
          github_repository_node,
          github_repository_node,
          github_repository_node
        )
      )
    )
  )
)

gitlab_project_node <- list(
  "node" = list(
    "repo_id" = "gid://gitlab/Project/61399846",
    "repo_name" = "test_repo",
    "repo_path" = "test_repo",
    "repository" = list(
      "rootRef" = "main"
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
      "path" = "test_group"
    ),
    "repo_url" = "https://test_gitlab_url.com"
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

github_commit_edge <- list(
  "node" = list(
    "id" = "xxx",
    "committed_date" = "2023-01-25T10:26:41Z",
    "author" = list(
      "name" = "Maciej Banas",
      "user" = list(
        "name" = "Maciej Banas",
        "login" = "maciekbanas"
      )
    ),
    "additions" = 5L,
    "deletions" = 8L
  )
)

test_fixtures$github_commits_response <- list(
  "data" = list(
    "repository" = list(
      "defaultBranchRef" = list(
        "target" = list(
          "history" = list(
            "edges" = list(
              rep(github_commit_edge, 5)
            )
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
  "web_url" = "https://test_url.com",
  "stats" = list(
    "additions" = 1L,
    "deletions" = 0L,
    "total" = 1L
  )
)

test_fixtures$gitlab_commits_response <- list(
  rep(gitlab_commit, 5)
)

test_fixtures$github_file_response <- list(
  "data" = list(
    "repository" = list(
      "repo_id"   = "01010101",
      "repo_name" = "TestProject",
      "repo_url"  = "https://github.com/r-world-devs/GitStats",
      "file" = list(
        "text" = "Some interesting text.",
        "byteSize" = 50L
      )
    )
  )
)

test_fixtures$gitlab_file_org_response <- list(
  "data" = list(
    "group" = list(
      "projects" = list(
        "count" = 3,
        "pageInfo" = list(
          "hasNextPage" = FALSE,
          "endCursor" = "xxxxxx"
        ),
        "edges" = list(
          list(
            "node" = list(
              "name" = "graphql_tests",
              "id" = "gid://gitlab/Project/61399846",
              "webUrl" = "https://gitlab.com/mbtests/graphql_tests",
              "repository" = list(
                "blobs" = list(
                  "nodes" = list() # empty response for query, no files found in org
                )
              )
            )
          ),
          list(
            "node" = list(
              "name" = "RM Tests 3",
              "id" = "gid://gitlab/Project/44346961",
              "webUrl" = "https://gitlab.com/mbtests/rm-tests-3",
              "repository" = list(
                "blobs" = list(
                  "nodes" = list(
                    list(
                      "name" = "meta_data.yaml",
                      "rawBlob" = "Some interesting text",
                      "size" = 4
                    )
                  )
                )
              )
            )
          ),
          list(
            "node" = list(
              "name" = "RM Tests 2",
              "id" = "gid://gitlab/Project/44293594",
              "webUrl" = "https://gitlab.com/mbtests/rm-tests-2",
              "repository" = list(
                "blobs" = list(
                  "nodes" = list(
                    list(
                      "name" = "meta_data.yaml",
                      "rawBlob" = "Some interesting text",
                      "size" = 5
                    )
                  )
                )
              )
            )
          )
        )
      )
    )
  )
)

test_fixtures$gitlab_file_repo_response <- list(
  "data" = list(
    "project" = list(
      "name" = "TestProject",
      "id" = "1010101",
      "webUrl"  = "https://gitlab.com/mbtests/graphql_tests",
      "repository" = list(
        "blobs" = list(
          "nodes" = list(
            list(
              "name" = "README.md",
              "rawBlob" = "# graphql_tests\n\nThis project is for testing GraphQL capabilities.\n",
              "size" =  "67"
            ),
            list(
              "name" = "project_metadata.yaml",
              "rawBlob" = "Name: GraphQL Tests",
              "size" = "19"
            )
          )
        )
      )
    )
  )
)

test_fixtures$github_png_file_response <- list(
  "data" = list(
    "repository" = list(
      "repo_id"   = "01010101",
      "repo_name" = "TestProject",
      "repo_url"  = "https://github.com/r-world-devs/GitStats",
      "file" = list(
        "text" = NULL,
        "byteSize" = 50L
      )
    )
  )
)

test_fixtures$gitlab_search_response <- list(
  list(
    "basename"   = "test",
    "data"       = "some text with searched phrase",
    "path"       = "test.R",
    "filename"   = "test.R",
    "id"         = NULL,
    "ref"        = "main",
    "startline"  = 10,
    "project_id" = 43398933
  ),
  list(
    "basename"   = "test",
    "data"       = "some text with searched phrase",
    "path"       = "test.R",
    "filename"   = "test.R",
    "id"         = NULL,
    "ref"        = "main",
    "startline"  = 15,
    "project_id" = 43400864
  )
)

github_search_item <- list(
  "name" = "test1.R",
  "path" = "examples/test1.R",
  "sha" = "0d42b9d23ddfc0bca1",
  "url" = "test_url",
  "git_url" = "test_git_url",
  "html_url" = "test_html_url",
  "repository" = list(
    "id" = 627452680,
    "url" = "https://api.github.com/repos/r-world-devs/GitStats",
    "html_url" = "https://github.com/r-world-devs/GitStats"
  ),
  "score" = 1
)

test_fixtures$github_search_response <- list(
  "total_count" = 250,
  "incomplete_results" = FALSE,
  "items" = list(
    rep(github_search_item, 250)
  )
)

test_fixtures$github_search_response_large <- list(
  "total_count" = 1001,
  "incomplete_results" = FALSE,
  "items" = list(
    rep(github_search_item, 1001)
  )
)

test_fixtures$gitlab_files_tree_response <- list(
  "data" = list(
    "project" = list(
      "repository" = list(
        "tree" = list(
          "trees" = list(
            "nodes" = list(
              list(
                "name" = "R"
              ),
              list(
                "name" = "tests"
              )
            )
          ),
          "blobs" = list(
            "nodes" = list(
              list(
                "name" = "DESCRIPTION"
              ),
              list(
                "name" = "README.md"
              ),
              list(
                "name" = "project_metadata.yaml"
              ),
              list(
                "name" = "report.md"
              )
            )
          )
        )
      )
    )
  )
)

test_fixtures$github_files_tree_response <- list(
  "data" = list(
    "repository" = list(
      "id"     = "R_kgD0Ivtxsg",
      "name"   = "TestRepo",
      "url"    = "https://github.com/test-org/TestRepo",
      "object" = list(
        "entries" = list(
          list(
            "name" = ".Rbuildignore",
            "type" = "blob"
          ),
          list(
            "name" = ".Renviron",
            "type" = "blob"
          ),
          list(
            "name" = ".Rprofile",
            "type" = "blob"
          ),
          list(
            "name" = ".covrignore",
            "type" = "blob"
          ),
          list(
            "name" = "test.md",
            "type" = "blob"
          ),
          list(
            "name" = "test.qmd",
            "type" = "blob"
          ),
          list(
            "name" = "test.Rmd",
            "type" = "blob"
          ),
          list(
            "name" = "renv",
            "type" = "tree"
          ),
          list(
            "name" = "tests",
            "type" = "tree"
          ),
          list(
            "name" = "vignettes",
            "type" = "tree"
          )
        )
      )
    )
  )
)

test_fixtures$github_releases_from_repo <- list(
  "data" = list(
    "repository" = list(
      "name" = "TestProject1",
      "url"  = "test_url",
      "releases" = list(
        "nodes" = list(
          list(
            "name"    = "2.1.0",
            "tagName" = "v2.1.0",
            "publishedAt" = "2024-01-01T00:00:00Z",
            "url"         = "https://test_url/tag/v2.1.0",
            "description" = "Great features come with this release."
          ),
          list(
            "name"    = "1.1.1",
            "tagName" = "v1.1.1",
            "publishedAt" = "2023-09-28T00:00:00Z",
            "url"         = "https://test_url/tag/v1.1.0",
            "description" = "Great features come with this release."
          ),
          list(
            "name"    = "0.1.0",
            "tagName" = "v0.1.0",
            "publishedAt" = "2023-04-01T00:00:00Z",
            "url"         = "https://test_url/tag/v0.1.0",
            "description" = "Great features come with this release."
          ),
          list(
            "name"    = "0.1.1",
            "tagName" = "v0.1.1",
            "publishedAt" = "2023-05-02T00:00:00Z",
            "url"         = "https://test_url/tag/v0.1.0",
            "description" = "Great features come with this release."
          )
        )
      )
    )
  )
)

test_fixtures$gitlab_releases_from_repo <- list(
  "data" = list(
    "project" = list(
      "name" = "TestProject",
      "webUrl" = "test_url",
      "releases" = list(
        "nodes" = list(
          list(
            "name" = "TestProject 1.0.0",
            "tagName" = "1.0.0",
            "releasedAt" = "2024-06-08T00:00:00+02:00",
            "links" = list(
              "selfUrl" = "test_url/releases/1.0.0"
            ),
            "description" = "This release comes with awesome features."
          ),
          list(
            "name" = "TestProject 2.0.0",
            "tagName" = "2.0.0",
            "releasedAt" = "2024-08-08T00:00:00+02:00",
            "links" = list(
              "selfUrl" = "test_url/releases/2.0.0"
            ),
            "description" = "This release comes with awesome features."
          ),
          list(
            "name" = "TestProject 0.1.0",
            "tagName" = "0.1.0",
            "releasedAt" = "2023-06-08T00:00:00+02:00",
            "links" = list(
              "selfUrl" = "test_url/releases/0.1.0"
            ),
            "description" = "This release comes with awesome features."
          ),
          list(
            "name" = "TestProject 3.0.0",
            "tagName" = "3.0.0",
            "releasedAt" = "2023-09-08T00:00:00+02:00",
            "links" = list(
              "selfUrl" = "test_url/releases/3.0.0"
            ),
            "description" = "This release comes with awesome features."
          )
        )
      )
    )
  )
)

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
