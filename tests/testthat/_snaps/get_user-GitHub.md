# user query is built properly

    Code
      gh_user_query
    Output
      [1] "\n        query GetUser($user: String!) {\n          user(login: $user) {\n            id\n            name\n            login\n            email\n            location\n            starred_repos: starredRepositories {\n              totalCount\n            }\n            contributions: contributionsCollection {\n              totalIssueContributions\n              totalCommitContributions\n              totalPullRequestContributions\n              totalPullRequestReviewContributions\n            }\n            avatar_url: avatarUrl\n            web_url: websiteUrl\n          }\n        }"

