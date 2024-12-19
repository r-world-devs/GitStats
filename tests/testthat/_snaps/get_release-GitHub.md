# releases query is built properly

    Code
      gh_releases_query
    Output
      [1] "query GetReleasesFromRepo ($org: String!, $repo: String!) {\n          repository(owner:$org, name:$repo){\n            name\n            url\n            releases (last: 100) {\n              nodes {\n                name\n                tagName\n                publishedAt\n                url\n                description\n              }\n            }\n          }\n        }"

# `get_release_logs()` is set to scan whole git host

    Code
      gh_releases_table <- github_testhost_all$get_release_logs(since = "2023-01-01",
        until = "2023-02-28", verbose = TRUE, progress = FALSE)
    Message
      i [GitHub][Engine:GraphQL] Pulling all organizations...

