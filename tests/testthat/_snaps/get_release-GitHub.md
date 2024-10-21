# releases query is built properly

    Code
      gh_releases_query
    Output
      [1] "query GetReleasesFromRepo ($org: String!, $repo: String!) {\n          repository(owner:$org, name:$repo){\n            name\n            url\n            releases (last: 100) {\n              nodes {\n                name\n                tagName\n                publishedAt\n                url\n                description\n              }\n            }\n          }\n        }"

# `get_release_logs()` prints proper message when running

    Code
      releases_table <- github_testhost$get_release_logs(since = "2023-05-01", until = "2023-09-30",
        verbose = TRUE, progress = FALSE)
    Message
      i [Host:GitHub][Engine:GraphQl][Scope:test-org] Pulling release logs...

