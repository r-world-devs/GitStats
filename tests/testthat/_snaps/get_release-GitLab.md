# releases query is built properly

    Code
      gl_releases_query
    Output
      [1] "query GetReleasesFromRepo($project_path: ID!) {\n              project(fullPath: $project_path) {\n                name\n                webUrl\n    \t\t\t\t\t\treleases {\n                  nodes{\n                    name\n                    tagName\n                    releasedAt\n                    links {\n                      selfUrl\n                    }\n                    description\n                  }\n                }\n              }\n          }"

# `get_release_logs_from_orgs()` prints proper message

    Code
      releases_from_orgs <- gitlab_testhost_priv$get_release_logs_from_orgs(since = "2023-05-01",
        until = "2023-09-30", verbose = TRUE, progress = FALSE)
    Message
      > [Host:GitLab][Engine:GraphQl][Scope:test_group] Pulling release logs...

# `get_release_logs_from_repos()` works

    Code
      releases_from_repos <- gitlab_testhost_priv$get_release_logs_from_repos(since = "2023-05-01",
        until = "2023-09-30", verbose = TRUE, progress = FALSE)
    Message
      > [Host:GitLab][Engine:GraphQl][Scope:test_org: 1 repos] Pulling release logs...

