# commits_by_repo query is built properly

    Code
      gh_commits_by_repo_query
    Output
      [1] "{\n          repository(name: \"GitStats\", owner: \"r-world-devs\") {\n            defaultBranchRef {\n              target {\n                ... on Commit {\n                  history(since: \"2023-01-01T00:00:00Z\"\n                          until: \"2023-02-28T00:00:00Z\"\n                          \n                          ) {\n                    pageInfo {\n                      hasNextPage\n                      endCursor\n                    }\n                    edges {\n                      node {\n                        ... on Commit {\n                          id\n                          committed_date: committedDate\n                          author {\n                            name\n                            user {\n                              name\n                              login\n                            }\n                          }\n                          additions\n                          deletions\n                        }\n                      }\n                    }\n                  }\n                }\n              }\n            }\n          }\n        }"

# repos_by_org query is built properly

    Code
      gh_repos_by_org_query
    Output
      [1] "\n        query GetReposByOrg($org: String!) {\n          repositoryOwner(login: $org) {\n            ... on Organization {\n              repositories(first: 100 ) {\n              totalCount\n        pageInfo {\n          endCursor\n          hasNextPage\n        }\n        nodes {\n          repo_id: id\n          repo_name: name\n          default_branch: defaultBranchRef {\n            name\n          }\n          stars: stargazerCount\n          forks: forkCount\n          created_at: createdAt\n          last_activity_at: pushedAt\n          languages (first: 5) { nodes {name} }\n          issues_open: issues (first: 100 states: [OPEN]) {\n            totalCount\n          }\n          issues_closed: issues (first: 100 states: [CLOSED]) {\n            totalCount\n          }\n          organization: owner {\n            login\n          }\n          repo_url: url\n        }\n              }\n            }\n          }\n        }"

# user query is built properly

    Code
      gh_user_query
    Output
      [1] "\n        query GetUser($user: String!) {\n          user(login: $user) {\n            id\n            name\n            login\n            email\n            location\n            starred_repos: starredRepositories {\n              totalCount\n            }\n            contributions: contributionsCollection {\n              totalIssueContributions\n              totalCommitContributions\n              totalPullRequestContributions\n              totalPullRequestReviewContributions\n            }\n            avatar_url: avatarUrl\n            web_url: websiteUrl\n          }\n        }"

# file query is built properly

    Code
      gh_files_query
    Output
      [1] "query GetFilesByRepo($org: String!, $repo: String!, $file_path: String!) {\n          repository(owner: $org, name: $repo) {\n            id\n            name\n            url\n            object(expression: $file_path) {\n              ... on Blob {\n                text\n                byteSize\n              }\n            }\n          }\n      }"

# releases query is built properly

    Code
      gh_releases_query
    Output
      [1] "query GetReleasesFromRepo ($org: String!, $repo: String!) {\n          repository(owner:$org, name:$repo){\n            name\n            url\n            releases (last: 100) {\n              nodes {\n                name\n                tagName\n                publishedAt\n                url\n                description\n              }\n            }\n          }\n        }"

