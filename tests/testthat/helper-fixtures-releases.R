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
