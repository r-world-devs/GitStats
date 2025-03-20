# releases query is built properly

    Code
      gh_releases_query
    Output
      [1] "query GetReleasesFromRepo ($org: String!, $repo: String!) {\n          repository(owner:$org, name:$repo){\n            name\n            url\n            releases (last: 100) {\n              nodes {\n                name\n                tagName\n                publishedAt\n                url\n                description\n              }\n            }\n          }\n        }"

