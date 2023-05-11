# `get_authors_ids()` works as expected

    Code
      test_gql_gh$get_authors_ids(test_team)
    Output
      [1] "MDQ6VXNlcjQyOTYzOTA=" "MDQ6VXNlcjE5NzI5ODQ0" "MDQ6VXNlcjc0MjEyOTMz"
      [4] "MDQ6VXNlcjMwOTMxODE5"

# `pull_commits_from_one_repo()` prepares formatted list

    Code
      commits_from_repo
    Output
      [[1]]
      [[1]]$node
      [[1]]$node$id
      [1] "C_kwDOIvtxstoAKGE1ZGJiOTU2MzU2Njk4MjllN2Q4OTQzYWU5YjAwNDA2NWVmYzIxNWM"
      
      [[1]]$node$committed_date
      [1] "2023-01-10T12:43:59Z"
      
      [[1]]$node$author
      [[1]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]]$node$additions
      [1] 242
      
      [[1]]$node$deletions
      [1] 19
      
      
      
      [[2]]
      [[2]]$node
      [[2]]$node$id
      [1] "C_kwDOIvtxstoAKDEwNmYxYTdlOGU5MTQzNDdhNWQ3YjQ1NWY1MDE3NjE2YTVlNzYyYmM"
      
      [[2]]$node$committed_date
      [1] "2023-01-10T11:01:42Z"
      
      [[2]]$node$author
      [[2]]$node$author$name
      [1] "maciekbanas"
      
      
      [[2]]$node$additions
      [1] 21
      
      [[2]]$node$deletions
      [1] 0
      
      
      
      [[3]]
      [[3]]$node
      [[3]]$node$id
      [1] "C_kwDOIvtxstoAKDgwZjFmMzMwYTNlODgzNmFjY2Y5NzI0MzhkMTBlMGE4ZWUwNGMwOWI"
      
      [[3]]$node$committed_date
      [1] "2023-01-09T15:31:38Z"
      
      [[3]]$node$author
      [[3]]$node$author$name
      [1] "maciekbanas"
      
      
      [[3]]$node$additions
      [1] 4
      
      [[3]]$node$deletions
      [1] 4
      
      
      
      [[4]]
      [[4]]$node
      [[4]]$node$id
      [1] "C_kwDOIvtxstoAKDRhZjg4NDFkZjBiZjIxN2UxYjFiNDM1YzVjZWZjZDFiNzk1ZWZjYzA"
      
      [[4]]$node$committed_date
      [1] "2023-01-09T14:54:35Z"
      
      [[4]]$node$author
      [[4]]$node$author$name
      [1] "maciekbanas"
      
      
      [[4]]$node$additions
      [1] 2326
      
      [[4]]$node$deletions
      [1] 0
      
      
      

# `pull_commits_from_repos()` pulls commits from repos

    Code
      commits_from_repos
    Output
      [[1]]
      [[1]][[1]]
      [[1]][[1]]$node
      [[1]][[1]]$node$id
      [1] "C_kwDOIvtxstoAKGE1ZGJiOTU2MzU2Njk4MjllN2Q4OTQzYWU5YjAwNDA2NWVmYzIxNWM"
      
      [[1]][[1]]$node$committed_date
      [1] "2023-01-10T12:43:59Z"
      
      [[1]][[1]]$node$author
      [[1]][[1]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[1]]$node$additions
      [1] 242
      
      [[1]][[1]]$node$deletions
      [1] 19
      
      
      
      [[1]][[2]]
      [[1]][[2]]$node
      [[1]][[2]]$node$id
      [1] "C_kwDOIvtxstoAKDEwNmYxYTdlOGU5MTQzNDdhNWQ3YjQ1NWY1MDE3NjE2YTVlNzYyYmM"
      
      [[1]][[2]]$node$committed_date
      [1] "2023-01-10T11:01:42Z"
      
      [[1]][[2]]$node$author
      [[1]][[2]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[2]]$node$additions
      [1] 21
      
      [[1]][[2]]$node$deletions
      [1] 0
      
      
      
      [[1]][[3]]
      [[1]][[3]]$node
      [[1]][[3]]$node$id
      [1] "C_kwDOIvtxstoAKDgwZjFmMzMwYTNlODgzNmFjY2Y5NzI0MzhkMTBlMGE4ZWUwNGMwOWI"
      
      [[1]][[3]]$node$committed_date
      [1] "2023-01-09T15:31:38Z"
      
      [[1]][[3]]$node$author
      [[1]][[3]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[3]]$node$additions
      [1] 4
      
      [[1]][[3]]$node$deletions
      [1] 4
      
      
      
      [[1]][[4]]
      [[1]][[4]]$node
      [[1]][[4]]$node$id
      [1] "C_kwDOIvtxstoAKDRhZjg4NDFkZjBiZjIxN2UxYjFiNDM1YzVjZWZjZDFiNzk1ZWZjYzA"
      
      [[1]][[4]]$node$committed_date
      [1] "2023-01-09T14:54:35Z"
      
      [[1]][[4]]$node$author
      [[1]][[4]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[4]]$node$additions
      [1] 2326
      
      [[1]][[4]]$node$deletions
      [1] 0
      
      
      
      

# `get_repos()` works as expected

    Code
      gh_repos_org <- test_gql_gh$get_repos(org = "r-world-devs", settings = settings)
    Message <cliMessage>
      i [GitHub][Engine:GraphQL][org:r-world-devs] Pulling repositories...

---

    Code
      gh_repos_team <- test_gql_gh$get_repos(org = "r-world-devs", settings = settings)
    Message <cliMessage>
      i [GitHub][Engine:GraphQL][org:r-world-devs][team:] Pulling repositories...

# `get_commits()` retrieves commits in the table format

    Code
      commits_table <- test_gql_gh$get_commits(org = "r-world-devs", date_from = "2023-01-01",
        date_until = "2023-02-28", settings = settings)
    Message <cliMessage>
      i [GitHub][Engine:GraphQL][org:r-world-devs] Pulling commits...

