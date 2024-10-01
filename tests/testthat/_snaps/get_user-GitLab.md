# user query is built properly

    Code
      gl_user_query
    Output
      [1] "\n        query GetUser($user: String!) {\n          user(username: $user) {\n            id\n            name\n            login: username\n            email: publicEmail\n            location\n            starred_repos: starredProjects {\n              count\n            }\n            pull_requests: authoredMergeRequests {\n              count\n            }\n            reviews: reviewRequestedMergeRequests {\n              count\n            }\n            avatar_url: avatarUrl\n            web_url: webUrl\n          }\n        }\n      "

