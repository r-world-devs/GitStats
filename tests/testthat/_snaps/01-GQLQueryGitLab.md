# repos queries are built properly

    Code
      gl_repos_by_org_query
    Output
      [1] "query GetReposByOrg($org: ID!) {\n        group(fullPath: $org) {\n          projects(first: 100 ) {\n            count\n            pageInfo {\n              hasNextPage\n              endCursor\n            }\n            edges {\n              node {\n                repo_id: id\n                repo_name: name\n                ... on Project {\n                  repository {\n                    rootRef\n                  }\n                }\n                stars: starCount\n                forks: forksCount\n                created_at: createdAt\n                last_activity_at: lastActivityAt\n                languages {\n                  name\n                }\n                issues: issueStatusCounts {\n                  all\n                  closed\n                  opened\n                }\n                group {\n                  name\n                }\n                repo_url: webUrl\n              }\n            }\n          }\n        }\n      }"

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
      gl_repo_files_query
    Output
      [1] "query GetFilesFromRepo($file_paths: [String!]!, $project_path: ID!) {\n              project(fullPath: $project_path) {\n                name\n                id\n                webUrl\n                repository {\n                  blobs(paths: $file_paths) {\n                    nodes {\n                      name\n                      rawBlob\n                      size\n                    }\n                  }\n                }\n              }\n          }"

