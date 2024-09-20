# releases query is built properly

    Code
      gl_releases_query
    Output
      [1] "query GetReleasesFromRepo($project_path: ID!) {\n              project(fullPath: $project_path) {\n                name\n                webUrl\n    \t\t\t\t\t\treleases {\n                  nodes{\n                    name\n                    tagName\n                    releasedAt\n                    links {\n                      selfUrl\n                    }\n                    description\n                  }\n                }\n              }\n          }"

