# get_repos_urls prints messages

    Code
      repo_urls <- test_gitstats$get_repos_urls(verbose = TRUE)
    Message
      > Pulling repositories 🌐 URLs...

# get_repos_urls prints time used to pull data

    Code
      get_repos_urls(gitstats = test_gitstats, with_code = "shiny", in_files = "DESCRIPTION",
        verbose = TRUE)
    Message
      v Data pulled in 0 secs
    Output
      # Repository URLs:
      - https://github.test.com/api/test_url
      - https://gitlab.com/mbtests/graphql_tests
      - https://gitlab.com/mbtests/gitstats-testing-2
      
      # Host Summary:
      - github.test.com: 1 URL(s)
      - gitlab.com: 2 URL(s)

# get_repos_urls prints when data is longer than 5

    Code
      get_repos_urls(gitstats = test_gitstats, with_code = "shiny", in_files = "DESCRIPTION",
        verbose = FALSE)
    Message
      v Data pulled in 0 secs
    Output
      # Repository URLs (showing first 5 of 15):
      - https://github.test.com/api/test_url
      - https://gitlab.com/mbtests/graphql_tests
      - https://gitlab.com/mbtests/gitstats-testing-2
      - https://github.test.com/api/test_url
      - https://gitlab.com/mbtests/graphql_tests
      
      # Host Summary:
      - github.test.com: 5 URL(s)
      - gitlab.com: 10 URL(s)

