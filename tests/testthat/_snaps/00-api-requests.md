# `perform_request()` for GraphQL handles error 503

    Code
      response <- test_graphql_github_priv$perform_request(gql_query = "{\n      viewer {\n        login\n      }\n    }",
        vars = NULL, token = Sys.getenv("GITHUB_PAT"))
    Message
      x 503

