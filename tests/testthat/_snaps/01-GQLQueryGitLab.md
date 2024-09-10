# repos queries are built properly

    Code
      gl_repos_by_org_query
    Output
      [1] "query GetReposByOrg($org: ID!) {\n        group(fullPath: $org) {\n          projects(first: 100 ) {\n            count\n            pageInfo {\n              hasNextPage\n              endCursor\n            }\n            edges {\n              node {\n                repo_id: id\n                repo_name: name\n                repo_path: path\n                ... on Project {\n                  repository {\n                    rootRef\n                  }\n                }\n                stars: starCount\n                forks: forksCount\n                created_at: createdAt\n                last_activity_at: lastActivityAt\n                languages {\n                  name\n                }\n                issues: issueStatusCounts {\n                  all\n                  closed\n                  opened\n                }\n                group {\n                  path\n                }\n                repo_url: webUrl\n              }\n            }\n          }\n        }\n      }"

# user query is built properly

    Code
      gl_user_query
    Output
      [1] "\n        query GetUser($user: String!) {\n          user(username: $user) {\n            id\n            name\n            login: username\n            email: publicEmail\n            location\n            starred_repos: starredProjects {\n              count\n            }\n            pull_requests: authoredMergeRequests {\n              count\n            }\n            reviews: reviewRequestedMergeRequests {\n              count\n            }\n            avatar_url: avatarUrl\n            web_url: webUrl\n          }\n        }\n      "

# file queries are built properly

    Code
      gl_files_query
    Output
      [1] "query GetFilesByOrg($org: ID!, $file_paths: [String!]!) {\n            group(fullPath: $org) {\n              projects(first: 100) {\n                count\n                pageInfo {\n                  hasNextPage\n                  endCursor\n                }\n                edges {\n                  node {\n                    name\n                    id\n                    webUrl\n                    repository {\n                      blobs(paths: $file_paths) {\n                        nodes {\n                          name\n                          rawBlob\n                          size\n                        }\n                      }\n                    }\n                  }\n                }\n              }\n            }\n          }"

---

    Code
      gl_file_blobs_from_repo_query
    Output
      [1] "\n      query GetFilesByRepo($fullPath: ID!, $file_paths: [String!]!) {\n        project(fullPath: $fullPath) {\n          name\n          id\n          webUrl\n          repository {\n            blobs(paths: $file_paths) {\n              nodes {\n                name\n                rawBlob\n                size\n              }\n            }\n          }\n        }\n      }\n      "

# releases query is built properly

    Code
      gl_releases_query
    Output
      [1] "query GetReleasesFromRepo($project_path: ID!) {\n              project(fullPath: $project_path) {\n                name\n                webUrl\n    \t\t\t\t\t\treleases {\n                  nodes{\n                    name\n                    tagName\n                    releasedAt\n                    links {\n                      selfUrl\n                    }\n                    description\n                  }\n                }\n              }\n          }"

# files_tree query is built properly

    Code
      gl_files_tree_query
    Output
      [1] "\n      query GetFilesTree ($fullPath: ID!, $file_path: String!) {\n        project(fullPath: $fullPath) {\n          repository {\n            tree(path: $file_path) {\n              trees (first: 100) {\n                pageInfo{\n                  endCursor\n                  hasNextPage\n                }\n                nodes {\n                  name\n                }\n              }\n              blobs (first: 100) {\n                pageInfo{\n                  endCursor\n                  hasNextPage\n                }\n                nodes {\n                  name\n                }\n              }\n            }\n          }\n        }\n      }\n      "

