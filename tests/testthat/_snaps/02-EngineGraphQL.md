# `gql_response()` work as expected

    Code
      commits_by_repo_gql_response
    Output
      $data
      $data$repository
      $data$repository$defaultBranchRef
      $data$repository$defaultBranchRef$target
      $data$repository$defaultBranchRef$target$history
      $data$repository$defaultBranchRef$target$history$pageInfo
      $data$repository$defaultBranchRef$target$history$pageInfo$hasNextPage
      [1] TRUE
      
      $data$repository$defaultBranchRef$target$history$pageInfo$endCursor
      [1] "ef0eb77371d1c51a5571981518a26303cb1363ee 99"
      
      
      $data$repository$defaultBranchRef$target$history$edges
      $data$repository$defaultBranchRef$target$history$edges[[1]]
      $data$repository$defaultBranchRef$target$history$edges[[1]]$node
      $data$repository$defaultBranchRef$target$history$edges[[1]]$node$id
      [1] "C_kwDOIvtxstoAKGUyY2ZlNzQ0NTk1N2E2OTU1MzljOTAyM2M2YzljOTAwODFmMDhhY2Y"
      
      $data$repository$defaultBranchRef$target$history$edges[[1]]$node$committed_date
      [1] "2023-02-27T10:46:57Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[1]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[1]]$node$author$name
      [1] "Maciej Banaś"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[1]]$node$additions
      [1] 1
      
      $data$repository$defaultBranchRef$target$history$edges[[1]]$node$deletions
      [1] 10
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[2]]
      $data$repository$defaultBranchRef$target$history$edges[[2]]$node
      $data$repository$defaultBranchRef$target$history$edges[[2]]$node$id
      [1] "C_kwDOIvtxstoAKGVlZTZiZGQ4ZTEwODY3ZjU2ZWY4OWFiZDdkMzAwNzViMTc2ZDJiM2M"
      
      $data$repository$defaultBranchRef$target$history$edges[[2]]$node$committed_date
      [1] "2023-02-27T10:14:37Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[2]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[2]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[2]]$node$additions
      [1] 2
      
      $data$repository$defaultBranchRef$target$history$edges[[2]]$node$deletions
      [1] 0
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[3]]
      $data$repository$defaultBranchRef$target$history$edges[[3]]$node
      $data$repository$defaultBranchRef$target$history$edges[[3]]$node$id
      [1] "C_kwDOIvtxstoAKDYwOGVkOGEyZmViYWNmMzVkMzJmOWY3YzAzZWI0NzAzNzFjODlmZWM"
      
      $data$repository$defaultBranchRef$target$history$edges[[3]]$node$committed_date
      [1] "2023-02-27T09:43:16Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[3]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[3]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[3]]$node$additions
      [1] 0
      
      $data$repository$defaultBranchRef$target$history$edges[[3]]$node$deletions
      [1] 2
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[4]]
      $data$repository$defaultBranchRef$target$history$edges[[4]]$node
      $data$repository$defaultBranchRef$target$history$edges[[4]]$node$id
      [1] "C_kwDOIvtxstoAKDJiZjVjYWMwZDBiNjI5MjNkY2FhN2FjZGI4MjQ0Mzk4NjBlZWUzYWI"
      
      $data$repository$defaultBranchRef$target$history$edges[[4]]$node$committed_date
      [1] "2023-02-24T13:25:14Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[4]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[4]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[4]]$node$additions
      [1] 1
      
      $data$repository$defaultBranchRef$target$history$edges[[4]]$node$deletions
      [1] 1
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[5]]
      $data$repository$defaultBranchRef$target$history$edges[[5]]$node
      $data$repository$defaultBranchRef$target$history$edges[[5]]$node$id
      [1] "C_kwDOIvtxstoAKDllZjdiZGU1MmE4ZjMwZGM2OWU0OWIzZWExMzEyZGYxMDMyM2I1NzM"
      
      $data$repository$defaultBranchRef$target$history$edges[[5]]$node$committed_date
      [1] "2023-02-24T13:16:10Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[5]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[5]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[5]]$node$additions
      [1] 0
      
      $data$repository$defaultBranchRef$target$history$edges[[5]]$node$deletions
      [1] 9
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[6]]
      $data$repository$defaultBranchRef$target$history$edges[[6]]$node
      $data$repository$defaultBranchRef$target$history$edges[[6]]$node$id
      [1] "C_kwDOIvtxstoAKGRkYjA4OTJhN2I5YTQ2Mjk2ZDc5NWViMzA0ZmQxNTk1MmM5MjEyZTQ"
      
      $data$repository$defaultBranchRef$target$history$edges[[6]]$node$committed_date
      [1] "2023-02-24T12:58:54Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[6]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[6]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[6]]$node$additions
      [1] 2
      
      $data$repository$defaultBranchRef$target$history$edges[[6]]$node$deletions
      [1] 0
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[7]]
      $data$repository$defaultBranchRef$target$history$edges[[7]]$node
      $data$repository$defaultBranchRef$target$history$edges[[7]]$node$id
      [1] "C_kwDOIvtxstoAKDMwZDIwOTMzOTEyZTljZmE5MjQ4MDhhMzM0Y2Q3MDVmM2M2OWRhNzU"
      
      $data$repository$defaultBranchRef$target$history$edges[[7]]$node$committed_date
      [1] "2023-02-24T11:04:03Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[7]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[7]]$node$author$name
      [1] "Maciej Banaś"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[7]]$node$additions
      [1] 14
      
      $data$repository$defaultBranchRef$target$history$edges[[7]]$node$deletions
      [1] 10
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[8]]
      $data$repository$defaultBranchRef$target$history$edges[[8]]$node
      $data$repository$defaultBranchRef$target$history$edges[[8]]$node$id
      [1] "C_kwDOIvtxstoAKDdjMmM1YTU3YTI1MDIxOGY2MzM4Njg2OWFjM2E0MmEwNDkzYWViMzI"
      
      $data$repository$defaultBranchRef$target$history$edges[[8]]$node$committed_date
      [1] "2023-02-24T10:37:42Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[8]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[8]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[8]]$node$additions
      [1] 0
      
      $data$repository$defaultBranchRef$target$history$edges[[8]]$node$deletions
      [1] 0
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[9]]
      $data$repository$defaultBranchRef$target$history$edges[[9]]$node
      $data$repository$defaultBranchRef$target$history$edges[[9]]$node$id
      [1] "C_kwDOIvtxstoAKDU0MTc0ZjdlMzFhMjk1OThjMjc0ZmM1MjkyMWNjNWM0ODIyNmRmMWU"
      
      $data$repository$defaultBranchRef$target$history$edges[[9]]$node$committed_date
      [1] "2023-02-24T10:24:27Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[9]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[9]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[9]]$node$additions
      [1] 6
      
      $data$repository$defaultBranchRef$target$history$edges[[9]]$node$deletions
      [1] 1
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[10]]
      $data$repository$defaultBranchRef$target$history$edges[[10]]$node
      $data$repository$defaultBranchRef$target$history$edges[[10]]$node$id
      [1] "C_kwDOIvtxstoAKGU4NmRjZjNmM2IzZDgyMDg2YWE5MTMyOTY5NWY5NTM4NjY5ODhmN2Q"
      
      $data$repository$defaultBranchRef$target$history$edges[[10]]$node$committed_date
      [1] "2023-02-24T09:30:17Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[10]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[10]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[10]]$node$additions
      [1] 8
      
      $data$repository$defaultBranchRef$target$history$edges[[10]]$node$deletions
      [1] 9
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[11]]
      $data$repository$defaultBranchRef$target$history$edges[[11]]$node
      $data$repository$defaultBranchRef$target$history$edges[[11]]$node$id
      [1] "C_kwDOIvtxstoAKGJmNTRhNDNhZWY1NDhkNWE5ZTcwNDQ1ZTBhMGQ3NGE5MzhjNTZlMWU"
      
      $data$repository$defaultBranchRef$target$history$edges[[11]]$node$committed_date
      [1] "2023-02-24T08:56:32Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[11]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[11]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[11]]$node$additions
      [1] 2
      
      $data$repository$defaultBranchRef$target$history$edges[[11]]$node$deletions
      [1] 0
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[12]]
      $data$repository$defaultBranchRef$target$history$edges[[12]]$node
      $data$repository$defaultBranchRef$target$history$edges[[12]]$node$id
      [1] "C_kwDOIvtxstoAKDc4Mzc2NTk1OGY3YWMxZDFhNjU0M2Y5ZjA2MTEwOWI1NzA4NmY3NDU"
      
      $data$repository$defaultBranchRef$target$history$edges[[12]]$node$committed_date
      [1] "2023-02-23T15:17:12Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[12]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[12]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[12]]$node$additions
      [1] 60
      
      $data$repository$defaultBranchRef$target$history$edges[[12]]$node$deletions
      [1] 2
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[13]]
      $data$repository$defaultBranchRef$target$history$edges[[13]]$node
      $data$repository$defaultBranchRef$target$history$edges[[13]]$node$id
      [1] "C_kwDOIvtxstoAKDI2NDYxYzA5NzczNzM4NzhmMTE3NmI1MzhmZTM5ZjNkYmNhMDVjMmI"
      
      $data$repository$defaultBranchRef$target$history$edges[[13]]$node$committed_date
      [1] "2023-02-21T15:19:10Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[13]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[13]]$node$author$name
      [1] "Maciej Banaś"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[13]]$node$additions
      [1] 5334
      
      $data$repository$defaultBranchRef$target$history$edges[[13]]$node$deletions
      [1] 2488
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[14]]
      $data$repository$defaultBranchRef$target$history$edges[[14]]$node
      $data$repository$defaultBranchRef$target$history$edges[[14]]$node$id
      [1] "C_kwDOIvtxstoAKDhhNGE5MzMxMzA3NzU5M2RiNjEzY2I2NjAxMzNjMWI4NTM5YWQzMjk"
      
      $data$repository$defaultBranchRef$target$history$edges[[14]]$node$committed_date
      [1] "2023-02-20T14:57:36Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[14]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[14]]$node$author$name
      [1] "Maciej Banaś"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[14]]$node$additions
      [1] 56
      
      $data$repository$defaultBranchRef$target$history$edges[[14]]$node$deletions
      [1] 17
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[15]]
      $data$repository$defaultBranchRef$target$history$edges[[15]]$node
      $data$repository$defaultBranchRef$target$history$edges[[15]]$node$id
      [1] "C_kwDOIvtxstoAKGEzMjhlMjQwZDBlMWNhZmYxNzBlNDE3MjRkMmQ5N2RmNmRkOWJkMmE"
      
      $data$repository$defaultBranchRef$target$history$edges[[15]]$node$committed_date
      [1] "2023-02-20T10:38:14Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[15]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[15]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[15]]$node$additions
      [1] 39
      
      $data$repository$defaultBranchRef$target$history$edges[[15]]$node$deletions
      [1] 1
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[16]]
      $data$repository$defaultBranchRef$target$history$edges[[16]]$node
      $data$repository$defaultBranchRef$target$history$edges[[16]]$node$id
      [1] "C_kwDOIvtxstoAKGIyOWYyYjMzYzE1YjhkOWNiM2Y5ZjA1Mjg0MzllZjhhYzY3ZGIzOTQ"
      
      $data$repository$defaultBranchRef$target$history$edges[[16]]$node$committed_date
      [1] "2023-02-20T08:55:54Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[16]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[16]]$node$author$name
      [1] "Maciej Banaś"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[16]]$node$additions
      [1] 17
      
      $data$repository$defaultBranchRef$target$history$edges[[16]]$node$deletions
      [1] 16
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[17]]
      $data$repository$defaultBranchRef$target$history$edges[[17]]$node
      $data$repository$defaultBranchRef$target$history$edges[[17]]$node$id
      [1] "C_kwDOIvtxstoAKGNkMzJlNDRkYjY3ZTlhOTc4YjMzNTVmOTYzOTQxNTZlMGYyOWUwYmM"
      
      $data$repository$defaultBranchRef$target$history$edges[[17]]$node$committed_date
      [1] "2023-02-20T08:54:45Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[17]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[17]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[17]]$node$additions
      [1] 17
      
      $data$repository$defaultBranchRef$target$history$edges[[17]]$node$deletions
      [1] 16
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[18]]
      $data$repository$defaultBranchRef$target$history$edges[[18]]$node
      $data$repository$defaultBranchRef$target$history$edges[[18]]$node$id
      [1] "C_kwDOIvtxstoAKDk3OTE0NjQ5MjY4NGRhODRlNzkxODFiZDQ3N2Q4N2MzZjZiNDIyNjk"
      
      $data$repository$defaultBranchRef$target$history$edges[[18]]$node$committed_date
      [1] "2023-02-17T09:19:20Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[18]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[18]]$node$author$name
      [1] "Maciej Banaś"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[18]]$node$additions
      [1] 69
      
      $data$repository$defaultBranchRef$target$history$edges[[18]]$node$deletions
      [1] 38
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[19]]
      $data$repository$defaultBranchRef$target$history$edges[[19]]$node
      $data$repository$defaultBranchRef$target$history$edges[[19]]$node$id
      [1] "C_kwDOIvtxstoAKDcxOWU1NjQ0NDc5YjJkYjI1MGE3NDc0NDBiNzQ5NGRiZWFiYjI4YmM"
      
      $data$repository$defaultBranchRef$target$history$edges[[19]]$node$committed_date
      [1] "2023-02-17T09:18:06Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[19]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[19]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[19]]$node$additions
      [1] 69
      
      $data$repository$defaultBranchRef$target$history$edges[[19]]$node$deletions
      [1] 38
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[20]]
      $data$repository$defaultBranchRef$target$history$edges[[20]]$node
      $data$repository$defaultBranchRef$target$history$edges[[20]]$node$id
      [1] "C_kwDOIvtxstoAKDdlNzQ2Njg4MDNlZmFmYjM1MWNiZjhjZjA4OTQ2Njk2NmRkZWVhODI"
      
      $data$repository$defaultBranchRef$target$history$edges[[20]]$node$committed_date
      [1] "2023-02-16T15:25:16Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[20]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[20]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[20]]$node$additions
      [1] 10
      
      $data$repository$defaultBranchRef$target$history$edges[[20]]$node$deletions
      [1] 9
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[21]]
      $data$repository$defaultBranchRef$target$history$edges[[21]]$node
      $data$repository$defaultBranchRef$target$history$edges[[21]]$node$id
      [1] "C_kwDOIvtxstoAKGM5NzI5OTdkOWFkNTJiOTM1OGMyMTNlM2ZiMDU2M2RlOGI1MzU0M2E"
      
      $data$repository$defaultBranchRef$target$history$edges[[21]]$node$committed_date
      [1] "2023-02-16T15:09:23Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[21]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[21]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[21]]$node$additions
      [1] 12
      
      $data$repository$defaultBranchRef$target$history$edges[[21]]$node$deletions
      [1] 0
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[22]]
      $data$repository$defaultBranchRef$target$history$edges[[22]]$node
      $data$repository$defaultBranchRef$target$history$edges[[22]]$node$id
      [1] "C_kwDOIvtxstoAKGRmZDgyZjFhNjllNTdhMjAyYmQwZGE0Yjg2OTlmNTIwMDA5YTkxYjg"
      
      $data$repository$defaultBranchRef$target$history$edges[[22]]$node$committed_date
      [1] "2023-02-16T13:52:25Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[22]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[22]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[22]]$node$additions
      [1] 1
      
      $data$repository$defaultBranchRef$target$history$edges[[22]]$node$deletions
      [1] 0
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[23]]
      $data$repository$defaultBranchRef$target$history$edges[[23]]$node
      $data$repository$defaultBranchRef$target$history$edges[[23]]$node$id
      [1] "C_kwDOIvtxstoAKDUxNTMyN2FjZDk0YTQ5ZTk1ZGRkMjZiYzQxZmE0MTM5YWU4ZjcyYjc"
      
      $data$repository$defaultBranchRef$target$history$edges[[23]]$node$committed_date
      [1] "2023-02-16T13:07:06Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[23]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[23]]$node$author$name
      [1] "Maciej Banaś"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[23]]$node$additions
      [1] 182
      
      $data$repository$defaultBranchRef$target$history$edges[[23]]$node$deletions
      [1] 45
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[24]]
      $data$repository$defaultBranchRef$target$history$edges[[24]]$node
      $data$repository$defaultBranchRef$target$history$edges[[24]]$node$id
      [1] "C_kwDOIvtxstoAKDEwNWI4OTk3ZDRmM2ViMjBhNTAwNWUzN2FhMDJlM2E2NDI1ZmVlYjU"
      
      $data$repository$defaultBranchRef$target$history$edges[[24]]$node$committed_date
      [1] "2023-02-16T13:02:10Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[24]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[24]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[24]]$node$additions
      [1] 26
      
      $data$repository$defaultBranchRef$target$history$edges[[24]]$node$deletions
      [1] 9
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[25]]
      $data$repository$defaultBranchRef$target$history$edges[[25]]$node
      $data$repository$defaultBranchRef$target$history$edges[[25]]$node$id
      [1] "C_kwDOIvtxstoAKDM0YWIzMWQ3MTUwOTU1Mjk3YzU1MDQ2NjNkYWZjODU3MWE2MWYwOGQ"
      
      $data$repository$defaultBranchRef$target$history$edges[[25]]$node$committed_date
      [1] "2023-02-16T12:12:45Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[25]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[25]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[25]]$node$additions
      [1] 14
      
      $data$repository$defaultBranchRef$target$history$edges[[25]]$node$deletions
      [1] 0
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[26]]
      $data$repository$defaultBranchRef$target$history$edges[[26]]$node
      $data$repository$defaultBranchRef$target$history$edges[[26]]$node$id
      [1] "C_kwDOIvtxstoAKDEzZDUzMTcyOGFkNzgyMmViYTdlMzEyZDQyN2E0MjIzZjhiYWE3NGI"
      
      $data$repository$defaultBranchRef$target$history$edges[[26]]$node$committed_date
      [1] "2023-02-16T12:07:26Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[26]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[26]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[26]]$node$additions
      [1] 112
      
      $data$repository$defaultBranchRef$target$history$edges[[26]]$node$deletions
      [1] 36
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[27]]
      $data$repository$defaultBranchRef$target$history$edges[[27]]$node
      $data$repository$defaultBranchRef$target$history$edges[[27]]$node$id
      [1] "C_kwDOIvtxstoAKGVjYTE4YTJkNzhlZDJlODg2ODljYzQwMDFlYjVlYjA3OTAzYTJhNTY"
      
      $data$repository$defaultBranchRef$target$history$edges[[27]]$node$committed_date
      [1] "2023-02-16T11:17:00Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[27]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[27]]$node$author$name
      [1] "Maciej Banaś"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[27]]$node$additions
      [1] 673
      
      $data$repository$defaultBranchRef$target$history$edges[[27]]$node$deletions
      [1] 521
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[28]]
      $data$repository$defaultBranchRef$target$history$edges[[28]]$node
      $data$repository$defaultBranchRef$target$history$edges[[28]]$node$id
      [1] "C_kwDOIvtxstoAKGU3ZjhmODk5OGM3ZTU3N2ZkNTUxNjQ3NDVmYmE3ZTVhMjE4OTk5MjE"
      
      $data$repository$defaultBranchRef$target$history$edges[[28]]$node$committed_date
      [1] "2023-02-16T09:37:11Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[28]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[28]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[28]]$node$additions
      [1] 34
      
      $data$repository$defaultBranchRef$target$history$edges[[28]]$node$deletions
      [1] 4
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[29]]
      $data$repository$defaultBranchRef$target$history$edges[[29]]$node
      $data$repository$defaultBranchRef$target$history$edges[[29]]$node$id
      [1] "C_kwDOIvtxstoAKGU1MWUyMWQ0M2I0ZGIxMWRhM2U1MDQ5OTYxOGY2NTlmNzYwZTc4YTY"
      
      $data$repository$defaultBranchRef$target$history$edges[[29]]$node$committed_date
      [1] "2023-02-10T14:51:00Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[29]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[29]]$node$author$name
      [1] "Maciej Banaś"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[29]]$node$additions
      [1] 673
      
      $data$repository$defaultBranchRef$target$history$edges[[29]]$node$deletions
      [1] 521
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[30]]
      $data$repository$defaultBranchRef$target$history$edges[[30]]$node
      $data$repository$defaultBranchRef$target$history$edges[[30]]$node$id
      [1] "C_kwDOIvtxstoAKDI0NjMyZTQ3MWE1ZGJhMjNkNmVkYzFkNTUyMzNiN2VmZWFjNDhhZmY"
      
      $data$repository$defaultBranchRef$target$history$edges[[30]]$node$committed_date
      [1] "2023-02-10T14:27:55Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[30]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[30]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[30]]$node$additions
      [1] 111
      
      $data$repository$defaultBranchRef$target$history$edges[[30]]$node$deletions
      [1] 177
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[31]]
      $data$repository$defaultBranchRef$target$history$edges[[31]]$node
      $data$repository$defaultBranchRef$target$history$edges[[31]]$node$id
      [1] "C_kwDOIvtxstoAKDA0MTk1NTkzYmMxMjkzMzFhNWI0NDA1OGU1Yjc2MGJkN2M0NzU2NjE"
      
      $data$repository$defaultBranchRef$target$history$edges[[31]]$node$committed_date
      [1] "2023-02-10T14:02:41Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[31]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[31]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[31]]$node$additions
      [1] 76
      
      $data$repository$defaultBranchRef$target$history$edges[[31]]$node$deletions
      [1] 27
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[32]]
      $data$repository$defaultBranchRef$target$history$edges[[32]]$node
      $data$repository$defaultBranchRef$target$history$edges[[32]]$node$id
      [1] "C_kwDOIvtxstoAKGNkZTQ4ZmZlMmZkNDU2ZWYwNjc2ZjE2NGMzZDhkMmM1NjI4Zjk5N2Q"
      
      $data$repository$defaultBranchRef$target$history$edges[[32]]$node$committed_date
      [1] "2023-02-10T12:49:45Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[32]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[32]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[32]]$node$additions
      [1] 42
      
      $data$repository$defaultBranchRef$target$history$edges[[32]]$node$deletions
      [1] 0
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[33]]
      $data$repository$defaultBranchRef$target$history$edges[[33]]$node
      $data$repository$defaultBranchRef$target$history$edges[[33]]$node$id
      [1] "C_kwDOIvtxstoAKDE3NWViMGM1NWIwZTY2ZTM4M2MyODg4OGZiMTIxYWMwYzBmNzJhZDg"
      
      $data$repository$defaultBranchRef$target$history$edges[[33]]$node$committed_date
      [1] "2023-02-10T12:49:17Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[33]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[33]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[33]]$node$additions
      [1] 88
      
      $data$repository$defaultBranchRef$target$history$edges[[33]]$node$deletions
      [1] 0
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[34]]
      $data$repository$defaultBranchRef$target$history$edges[[34]]$node
      $data$repository$defaultBranchRef$target$history$edges[[34]]$node$id
      [1] "C_kwDOIvtxstoAKDFhNzg1OGQwNTM0NDZmNmNkODZhMzRlODA0OGEyNzk0ODE1YzY5NDU"
      
      $data$repository$defaultBranchRef$target$history$edges[[34]]$node$committed_date
      [1] "2023-02-10T12:48:51Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[34]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[34]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[34]]$node$additions
      [1] 3
      
      $data$repository$defaultBranchRef$target$history$edges[[34]]$node$deletions
      [1] 90
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[35]]
      $data$repository$defaultBranchRef$target$history$edges[[35]]$node
      $data$repository$defaultBranchRef$target$history$edges[[35]]$node$id
      [1] "C_kwDOIvtxstoAKDMzYjBiM2U4ZTQxZWExZmU0NmZjYzQ3ZmQ1ZjA4ZGFlNTUzNWE1NzI"
      
      $data$repository$defaultBranchRef$target$history$edges[[35]]$node$committed_date
      [1] "2023-02-10T11:55:50Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[35]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[35]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[35]]$node$additions
      [1] 383
      
      $data$repository$defaultBranchRef$target$history$edges[[35]]$node$deletions
      [1] 257
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[36]]
      $data$repository$defaultBranchRef$target$history$edges[[36]]$node
      $data$repository$defaultBranchRef$target$history$edges[[36]]$node$id
      [1] "C_kwDOIvtxstoAKDBiOTAwMTYxNzJhMWMyYmRjOWM0ZjBhMTI3NDJkYzU2MzlkMGRjOTg"
      
      $data$repository$defaultBranchRef$target$history$edges[[36]]$node$committed_date
      [1] "2023-02-08T09:22:27Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[36]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[36]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[36]]$node$additions
      [1] 15
      
      $data$repository$defaultBranchRef$target$history$edges[[36]]$node$deletions
      [1] 51
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[37]]
      $data$repository$defaultBranchRef$target$history$edges[[37]]$node
      $data$repository$defaultBranchRef$target$history$edges[[37]]$node$id
      [1] "C_kwDOIvtxstoAKDdhNTE3OTA2ZmJkYzAxYzMzZDEzNzA4YTJjNGJmZTc5ZTJmNjJjYmQ"
      
      $data$repository$defaultBranchRef$target$history$edges[[37]]$node$committed_date
      [1] "2023-02-08T09:17:57Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[37]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[37]]$node$author$name
      [1] "Maciej Banaś"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[37]]$node$additions
      [1] 60
      
      $data$repository$defaultBranchRef$target$history$edges[[37]]$node$deletions
      [1] 45
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[38]]
      $data$repository$defaultBranchRef$target$history$edges[[38]]$node
      $data$repository$defaultBranchRef$target$history$edges[[38]]$node$id
      [1] "C_kwDOIvtxstoAKDc2MWJlMjU5OTBkMzBkMzE2MjNiNzY1YTgxNGMyZmEyYWNlZWRlNmQ"
      
      $data$repository$defaultBranchRef$target$history$edges[[38]]$node$committed_date
      [1] "2023-02-08T09:14:56Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[38]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[38]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[38]]$node$additions
      [1] 60
      
      $data$repository$defaultBranchRef$target$history$edges[[38]]$node$deletions
      [1] 45
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[39]]
      $data$repository$defaultBranchRef$target$history$edges[[39]]$node
      $data$repository$defaultBranchRef$target$history$edges[[39]]$node$id
      [1] "C_kwDOIvtxstoAKGQ0OThkMGE3YWY4NGFjM2MxMzgyZTQ4OTIyNDkzOGZkNTYxY2ExOWU"
      
      $data$repository$defaultBranchRef$target$history$edges[[39]]$node$committed_date
      [1] "2023-02-07T13:54:01Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[39]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[39]]$node$author$name
      [1] "Maciej Banaś"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[39]]$node$additions
      [1] 1766
      
      $data$repository$defaultBranchRef$target$history$edges[[39]]$node$deletions
      [1] 578
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[40]]
      $data$repository$defaultBranchRef$target$history$edges[[40]]$node
      $data$repository$defaultBranchRef$target$history$edges[[40]]$node$id
      [1] "C_kwDOIvtxstoAKDljYTI1M2EyNjFjZDQ4ZWUwMDRkOTkzODc2OWVkNjg1ZWNiY2JhODE"
      
      $data$repository$defaultBranchRef$target$history$edges[[40]]$node$committed_date
      [1] "2023-02-07T13:53:46Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[40]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[40]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[40]]$node$additions
      [1] 1
      
      $data$repository$defaultBranchRef$target$history$edges[[40]]$node$deletions
      [1] 1
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[41]]
      $data$repository$defaultBranchRef$target$history$edges[[41]]$node
      $data$repository$defaultBranchRef$target$history$edges[[41]]$node$id
      [1] "C_kwDOIvtxstoAKDJmMDMyMWI1Y2IyMzlkNWQ1YzgzNmRkNmQ2OTVmZDFjYjFmYmMyZjE"
      
      $data$repository$defaultBranchRef$target$history$edges[[41]]$node$committed_date
      [1] "2023-02-07T13:15:59Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[41]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[41]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[41]]$node$additions
      [1] 358
      
      $data$repository$defaultBranchRef$target$history$edges[[41]]$node$deletions
      [1] 338
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[42]]
      $data$repository$defaultBranchRef$target$history$edges[[42]]$node
      $data$repository$defaultBranchRef$target$history$edges[[42]]$node$id
      [1] "C_kwDOIvtxstoAKGZiNTQ3OTZiOWRmODc3OWRkZTJjNzAzZDQwYjBlOWVhN2Q2NjA5NGI"
      
      $data$repository$defaultBranchRef$target$history$edges[[42]]$node$committed_date
      [1] "2023-02-07T13:06:23Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[42]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[42]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[42]]$node$additions
      [1] 5
      
      $data$repository$defaultBranchRef$target$history$edges[[42]]$node$deletions
      [1] 0
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[43]]
      $data$repository$defaultBranchRef$target$history$edges[[43]]$node
      $data$repository$defaultBranchRef$target$history$edges[[43]]$node$id
      [1] "C_kwDOIvtxstoAKDJkOTE1YTE4N2JlYTc0MGRiMzNlZTJlMDhjMzcwNDJlZTE4ZGUwMzQ"
      
      $data$repository$defaultBranchRef$target$history$edges[[43]]$node$committed_date
      [1] "2023-02-07T12:36:00Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[43]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[43]]$node$author$name
      [1] "Maciej Banaś"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[43]]$node$additions
      [1] 517
      
      $data$repository$defaultBranchRef$target$history$edges[[43]]$node$deletions
      [1] 287
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[44]]
      $data$repository$defaultBranchRef$target$history$edges[[44]]$node
      $data$repository$defaultBranchRef$target$history$edges[[44]]$node$id
      [1] "C_kwDOIvtxstoAKDQ1YjY0YWM1OGQ0NGE3ZjIyMjZkZDlkMTU2NmJhOTZjY2Q4OWEzYjM"
      
      $data$repository$defaultBranchRef$target$history$edges[[44]]$node$committed_date
      [1] "2023-02-07T12:16:25Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[44]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[44]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[44]]$node$additions
      [1] 2
      
      $data$repository$defaultBranchRef$target$history$edges[[44]]$node$deletions
      [1] 0
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[45]]
      $data$repository$defaultBranchRef$target$history$edges[[45]]$node
      $data$repository$defaultBranchRef$target$history$edges[[45]]$node$id
      [1] "C_kwDOIvtxstoAKGFiY2M3MzQzZDcyNWNjNTI2ZDNjOGQ0MTdlM2YzMGY0NzkzM2QyMTk"
      
      $data$repository$defaultBranchRef$target$history$edges[[45]]$node$committed_date
      [1] "2023-02-07T11:03:01Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[45]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[45]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[45]]$node$additions
      [1] 0
      
      $data$repository$defaultBranchRef$target$history$edges[[45]]$node$deletions
      [1] 0
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[46]]
      $data$repository$defaultBranchRef$target$history$edges[[46]]$node
      $data$repository$defaultBranchRef$target$history$edges[[46]]$node$id
      [1] "C_kwDOIvtxstoAKGVhMWU1MTYxYTgyY2VkNzNkOTY5NmU4Y2MwOWY0MTczZDkwYTUxNzI"
      
      $data$repository$defaultBranchRef$target$history$edges[[46]]$node$committed_date
      [1] "2023-02-07T10:56:56Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[46]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[46]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[46]]$node$additions
      [1] 77
      
      $data$repository$defaultBranchRef$target$history$edges[[46]]$node$deletions
      [1] 27
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[47]]
      $data$repository$defaultBranchRef$target$history$edges[[47]]$node
      $data$repository$defaultBranchRef$target$history$edges[[47]]$node$id
      [1] "C_kwDOIvtxstoAKDBmNWZlYzQ4OGMyYTkwNGRlYTNlMGRkODEwYjZkOGI4N2ZiOGM4YmI"
      
      $data$repository$defaultBranchRef$target$history$edges[[47]]$node$committed_date
      [1] "2023-02-07T10:08:50Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[47]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[47]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[47]]$node$additions
      [1] 108
      
      $data$repository$defaultBranchRef$target$history$edges[[47]]$node$deletions
      [1] 29
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[48]]
      $data$repository$defaultBranchRef$target$history$edges[[48]]$node
      $data$repository$defaultBranchRef$target$history$edges[[48]]$node$id
      [1] "C_kwDOIvtxstoAKDNkMzYxM2RmNjc0M2JiZGVmMmEwNGM2Y2UxYTYwOWU4YzJkODFkOTU"
      
      $data$repository$defaultBranchRef$target$history$edges[[48]]$node$committed_date
      [1] "2023-02-07T09:14:17Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[48]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[48]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[48]]$node$additions
      [1] 94
      
      $data$repository$defaultBranchRef$target$history$edges[[48]]$node$deletions
      [1] 29
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[49]]
      $data$repository$defaultBranchRef$target$history$edges[[49]]$node
      $data$repository$defaultBranchRef$target$history$edges[[49]]$node$id
      [1] "C_kwDOIvtxstoAKGIwYmJkMmRhODg1OTlmZmJmYmQ5MjYwZGIxZTBmZTNlNzM2NTVlYzk"
      
      $data$repository$defaultBranchRef$target$history$edges[[49]]$node$committed_date
      [1] "2023-02-06T12:42:07Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[49]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[49]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[49]]$node$additions
      [1] 4
      
      $data$repository$defaultBranchRef$target$history$edges[[49]]$node$deletions
      [1] 4
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[50]]
      $data$repository$defaultBranchRef$target$history$edges[[50]]$node
      $data$repository$defaultBranchRef$target$history$edges[[50]]$node$id
      [1] "C_kwDOIvtxstoAKDNjMmNjZGQ0MGUwODk4YzBjNDA1NTczMmUxMGZiNzhkNzQ5ZWUyMjI"
      
      $data$repository$defaultBranchRef$target$history$edges[[50]]$node$committed_date
      [1] "2023-02-06T12:04:09Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[50]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[50]]$node$author$name
      [1] "Maciej Banaś"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[50]]$node$additions
      [1] 59
      
      $data$repository$defaultBranchRef$target$history$edges[[50]]$node$deletions
      [1] 84
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[51]]
      $data$repository$defaultBranchRef$target$history$edges[[51]]$node
      $data$repository$defaultBranchRef$target$history$edges[[51]]$node$id
      [1] "C_kwDOIvtxstoAKGUwNGI2NmE5YmYwNDM0ZWFmM2JhMjY2MDVjNjgyNDhlNDVmOTAyZjI"
      
      $data$repository$defaultBranchRef$target$history$edges[[51]]$node$committed_date
      [1] "2023-02-06T11:55:50Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[51]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[51]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[51]]$node$additions
      [1] 16
      
      $data$repository$defaultBranchRef$target$history$edges[[51]]$node$deletions
      [1] 10
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[52]]
      $data$repository$defaultBranchRef$target$history$edges[[52]]$node
      $data$repository$defaultBranchRef$target$history$edges[[52]]$node$id
      [1] "C_kwDOIvtxstoAKDZmMTEzODY1NTAxZmVlZmVkYzJiNjUyOTUwZDU0YTMzNGM4ZjFmYTY"
      
      $data$repository$defaultBranchRef$target$history$edges[[52]]$node$committed_date
      [1] "2023-02-06T11:54:26Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[52]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[52]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[52]]$node$additions
      [1] 43
      
      $data$repository$defaultBranchRef$target$history$edges[[52]]$node$deletions
      [1] 74
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[53]]
      $data$repository$defaultBranchRef$target$history$edges[[53]]$node
      $data$repository$defaultBranchRef$target$history$edges[[53]]$node$id
      [1] "C_kwDOIvtxstoAKDAzZGQzMDU5MzdiZjhjMjZhM2FkODk2YTE5OWEzMzMxZjMyMjdjYzA"
      
      $data$repository$defaultBranchRef$target$history$edges[[53]]$node$committed_date
      [1] "2023-02-06T10:52:24Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[53]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[53]]$node$author$name
      [1] "Maciej Banaś"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[53]]$node$additions
      [1] 78
      
      $data$repository$defaultBranchRef$target$history$edges[[53]]$node$deletions
      [1] 19
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[54]]
      $data$repository$defaultBranchRef$target$history$edges[[54]]$node
      $data$repository$defaultBranchRef$target$history$edges[[54]]$node$id
      [1] "C_kwDOIvtxstoAKDI2ZTVjMjM4NWQ5OWY0MDIyZTBkYWE1OTQ1OTk1NjViN2ZiZjRiMTE"
      
      $data$repository$defaultBranchRef$target$history$edges[[54]]$node$committed_date
      [1] "2023-02-06T10:51:19Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[54]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[54]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[54]]$node$additions
      [1] 34
      
      $data$repository$defaultBranchRef$target$history$edges[[54]]$node$deletions
      [1] 6
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[55]]
      $data$repository$defaultBranchRef$target$history$edges[[55]]$node
      $data$repository$defaultBranchRef$target$history$edges[[55]]$node$id
      [1] "C_kwDOIvtxstoAKGY1ZGZmODU1NjFjYzEyYjcyYmVkOWJlOTVkZjdjMzI0NmMzMWQxYjg"
      
      $data$repository$defaultBranchRef$target$history$edges[[55]]$node$committed_date
      [1] "2023-02-06T10:36:39Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[55]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[55]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[55]]$node$additions
      [1] 46
      
      $data$repository$defaultBranchRef$target$history$edges[[55]]$node$deletions
      [1] 15
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[56]]
      $data$repository$defaultBranchRef$target$history$edges[[56]]$node
      $data$repository$defaultBranchRef$target$history$edges[[56]]$node$id
      [1] "C_kwDOIvtxstoAKDA5OGJjMTQzMWQyNTEyMTU1MzAzN2Q5NWIwMWI2ZTA1MjM4ZTI1YjM"
      
      $data$repository$defaultBranchRef$target$history$edges[[56]]$node$committed_date
      [1] "2023-02-06T10:13:17Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[56]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[56]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[56]]$node$additions
      [1] 1
      
      $data$repository$defaultBranchRef$target$history$edges[[56]]$node$deletions
      [1] 1
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[57]]
      $data$repository$defaultBranchRef$target$history$edges[[57]]$node
      $data$repository$defaultBranchRef$target$history$edges[[57]]$node$id
      [1] "C_kwDOIvtxstoAKDRmODgwYmI0NzRhZDliMjFiNjgwOWYxYWFlMGY0MWUyZjI2NTM1YzI"
      
      $data$repository$defaultBranchRef$target$history$edges[[57]]$node$committed_date
      [1] "2023-02-06T09:24:23Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[57]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[57]]$node$author$name
      [1] "Maciej Banaś"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[57]]$node$additions
      [1] 80
      
      $data$repository$defaultBranchRef$target$history$edges[[57]]$node$deletions
      [1] 80
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[58]]
      $data$repository$defaultBranchRef$target$history$edges[[58]]$node
      $data$repository$defaultBranchRef$target$history$edges[[58]]$node$id
      [1] "C_kwDOIvtxstoAKGY2YTk4YjNhNDE1NjA1Mjc5MmI5ODNjMjI3MDEzMmE1NTAyNTZlMDY"
      
      $data$repository$defaultBranchRef$target$history$edges[[58]]$node$committed_date
      [1] "2023-02-06T09:23:23Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[58]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[58]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[58]]$node$additions
      [1] 80
      
      $data$repository$defaultBranchRef$target$history$edges[[58]]$node$deletions
      [1] 80
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[59]]
      $data$repository$defaultBranchRef$target$history$edges[[59]]$node
      $data$repository$defaultBranchRef$target$history$edges[[59]]$node$id
      [1] "C_kwDOIvtxstoAKGZhNWVjM2QyNjI0OTQwM2NhZDMwZjVkNzFmZDdhMjIxYjJkOTQ2ZWM"
      
      $data$repository$defaultBranchRef$target$history$edges[[59]]$node$committed_date
      [1] "2023-02-03T14:50:33Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[59]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[59]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[59]]$node$additions
      [1] 82
      
      $data$repository$defaultBranchRef$target$history$edges[[59]]$node$deletions
      [1] 82
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[60]]
      $data$repository$defaultBranchRef$target$history$edges[[60]]$node
      $data$repository$defaultBranchRef$target$history$edges[[60]]$node$id
      [1] "C_kwDOIvtxstoAKGYyZmE0Zjk3MzY3MDJkMjQwYmQ2NGRmNWIzNDliMmM2N2JjMmUxZmY"
      
      $data$repository$defaultBranchRef$target$history$edges[[60]]$node$committed_date
      [1] "2023-02-03T11:43:44Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[60]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[60]]$node$author$name
      [1] "Maciej Banaś"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[60]]$node$additions
      [1] 101
      
      $data$repository$defaultBranchRef$target$history$edges[[60]]$node$deletions
      [1] 38
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[61]]
      $data$repository$defaultBranchRef$target$history$edges[[61]]$node
      $data$repository$defaultBranchRef$target$history$edges[[61]]$node$id
      [1] "C_kwDOIvtxstoAKDcwMTEzMmU4MTc4OGZjZjkzNjdlMGQyYWZkZmExZjAyMTdjMTY0MTg"
      
      $data$repository$defaultBranchRef$target$history$edges[[61]]$node$committed_date
      [1] "2023-02-03T11:35:18Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[61]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[61]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[61]]$node$additions
      [1] 101
      
      $data$repository$defaultBranchRef$target$history$edges[[61]]$node$deletions
      [1] 38
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[62]]
      $data$repository$defaultBranchRef$target$history$edges[[62]]$node
      $data$repository$defaultBranchRef$target$history$edges[[62]]$node$id
      [1] "C_kwDOIvtxstoAKGQyYTJlMzhkN2FlYzI4N2Y2ZjljNGRiNmIyMmE4MzRjNTg1YmRiYzk"
      
      $data$repository$defaultBranchRef$target$history$edges[[62]]$node$committed_date
      [1] "2023-02-03T08:46:41Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[62]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[62]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[62]]$node$additions
      [1] 20
      
      $data$repository$defaultBranchRef$target$history$edges[[62]]$node$deletions
      [1] 9
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[63]]
      $data$repository$defaultBranchRef$target$history$edges[[63]]$node
      $data$repository$defaultBranchRef$target$history$edges[[63]]$node$id
      [1] "C_kwDOIvtxstoAKDZlMjNhYWYzNDEwNDI2Y2FmY2Y2YmQ2MTI1ZjkyYmEzOWVkYTZmMTU"
      
      $data$repository$defaultBranchRef$target$history$edges[[63]]$node$committed_date
      [1] "2023-02-02T15:14:43Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[63]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[63]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[63]]$node$additions
      [1] 65
      
      $data$repository$defaultBranchRef$target$history$edges[[63]]$node$deletions
      [1] 17
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[64]]
      $data$repository$defaultBranchRef$target$history$edges[[64]]$node
      $data$repository$defaultBranchRef$target$history$edges[[64]]$node$id
      [1] "C_kwDOIvtxstoAKDM5NTRhMDczMDRiOWNkYjZjODFkM2I0N2I5MWZhY2Q4ZmE5YzgxNzg"
      
      $data$repository$defaultBranchRef$target$history$edges[[64]]$node$committed_date
      [1] "2023-02-02T13:34:38Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[64]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[64]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[64]]$node$additions
      [1] 18
      
      $data$repository$defaultBranchRef$target$history$edges[[64]]$node$deletions
      [1] 10
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[65]]
      $data$repository$defaultBranchRef$target$history$edges[[65]]$node
      $data$repository$defaultBranchRef$target$history$edges[[65]]$node$id
      [1] "C_kwDOIvtxstoAKDhhODUzNzNlNGY0Njk3M2JjODFjYmU4MGRmODllMmEzYjRmMjZiZTU"
      
      $data$repository$defaultBranchRef$target$history$edges[[65]]$node$committed_date
      [1] "2023-02-02T13:31:26Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[65]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[65]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[65]]$node$additions
      [1] 214
      
      $data$repository$defaultBranchRef$target$history$edges[[65]]$node$deletions
      [1] 104
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[66]]
      $data$repository$defaultBranchRef$target$history$edges[[66]]$node
      $data$repository$defaultBranchRef$target$history$edges[[66]]$node$id
      [1] "C_kwDOIvtxstoAKGM4ODJkOGM0ZDY5ZDUzZjk5ZWZkMDA1OTZmNWYxZDJmODAyMjE4YmE"
      
      $data$repository$defaultBranchRef$target$history$edges[[66]]$node$committed_date
      [1] "2023-02-01T12:46:43Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[66]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[66]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[66]]$node$additions
      [1] 3
      
      $data$repository$defaultBranchRef$target$history$edges[[66]]$node$deletions
      [1] 1
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[67]]
      $data$repository$defaultBranchRef$target$history$edges[[67]]$node
      $data$repository$defaultBranchRef$target$history$edges[[67]]$node$id
      [1] "C_kwDOIvtxstoAKDgzNDRjOGZmYmM5YzRkZjkzODhmMzlkZWVjNzRlMzYyY2RiMjFjY2Q"
      
      $data$repository$defaultBranchRef$target$history$edges[[67]]$node$committed_date
      [1] "2023-02-01T12:44:49Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[67]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[67]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[67]]$node$additions
      [1] 88
      
      $data$repository$defaultBranchRef$target$history$edges[[67]]$node$deletions
      [1] 0
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[68]]
      $data$repository$defaultBranchRef$target$history$edges[[68]]$node
      $data$repository$defaultBranchRef$target$history$edges[[68]]$node$id
      [1] "C_kwDOIvtxstoAKGIwNTg5ZWIzOGE1OTA2MTBmMTI0MzRjNTRhMTNhYjczNGY5YmNhOGM"
      
      $data$repository$defaultBranchRef$target$history$edges[[68]]$node$committed_date
      [1] "2023-01-31T14:11:27Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[68]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[68]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[68]]$node$additions
      [1] 139
      
      $data$repository$defaultBranchRef$target$history$edges[[68]]$node$deletions
      [1] 11
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[69]]
      $data$repository$defaultBranchRef$target$history$edges[[69]]$node
      $data$repository$defaultBranchRef$target$history$edges[[69]]$node$id
      [1] "C_kwDOIvtxstoAKGYwMjVlMTRjZWJjMmE3MDEwNGRjZjMzNDA3YWIyZWMyNGUzYjAxMDM"
      
      $data$repository$defaultBranchRef$target$history$edges[[69]]$node$committed_date
      [1] "2023-01-31T12:59:28Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[69]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[69]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[69]]$node$additions
      [1] 65
      
      $data$repository$defaultBranchRef$target$history$edges[[69]]$node$deletions
      [1] 10
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[70]]
      $data$repository$defaultBranchRef$target$history$edges[[70]]$node
      $data$repository$defaultBranchRef$target$history$edges[[70]]$node$id
      [1] "C_kwDOIvtxstoAKDJkM2JiN2M5ZDE1OWUwZTA3MDZiMTk1NWM0NTE1MzQxOWVkNzM2YjU"
      
      $data$repository$defaultBranchRef$target$history$edges[[70]]$node$committed_date
      [1] "2023-01-31T11:22:09Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[70]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[70]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[70]]$node$additions
      [1] 20
      
      $data$repository$defaultBranchRef$target$history$edges[[70]]$node$deletions
      [1] 6
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[71]]
      $data$repository$defaultBranchRef$target$history$edges[[71]]$node
      $data$repository$defaultBranchRef$target$history$edges[[71]]$node$id
      [1] "C_kwDOIvtxstoAKDQ0NzRkZWI0ZjVkMTU2OTE3ZWJlODcyYjMwNjMwZmZlMWJhOTNkYWM"
      
      $data$repository$defaultBranchRef$target$history$edges[[71]]$node$committed_date
      [1] "2023-01-31T10:28:24Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[71]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[71]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[71]]$node$additions
      [1] 0
      
      $data$repository$defaultBranchRef$target$history$edges[[71]]$node$deletions
      [1] 12
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[72]]
      $data$repository$defaultBranchRef$target$history$edges[[72]]$node
      $data$repository$defaultBranchRef$target$history$edges[[72]]$node$id
      [1] "C_kwDOIvtxstoAKDBhNmIxMWM4YjAxZGI5OWYxNzRiMTdjZmY5NGU4MTVlMTAyMGEyYjk"
      
      $data$repository$defaultBranchRef$target$history$edges[[72]]$node$committed_date
      [1] "2023-01-31T10:28:07Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[72]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[72]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[72]]$node$additions
      [1] 164
      
      $data$repository$defaultBranchRef$target$history$edges[[72]]$node$deletions
      [1] 5
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[73]]
      $data$repository$defaultBranchRef$target$history$edges[[73]]$node
      $data$repository$defaultBranchRef$target$history$edges[[73]]$node$id
      [1] "C_kwDOIvtxstoAKDZkNGIyYTAyMTc1ODJjODhlNWE1ZDEzNmE0ZmM2NzQ4YzY4YzM0ODg"
      
      $data$repository$defaultBranchRef$target$history$edges[[73]]$node$committed_date
      [1] "2023-01-31T09:50:57Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[73]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[73]]$node$author$name
      [1] "Maciej Banaś"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[73]]$node$additions
      [1] 0
      
      $data$repository$defaultBranchRef$target$history$edges[[73]]$node$deletions
      [1] 12
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[74]]
      $data$repository$defaultBranchRef$target$history$edges[[74]]$node
      $data$repository$defaultBranchRef$target$history$edges[[74]]$node$id
      [1] "C_kwDOIvtxstoAKDg0OTEwYWQ5OWJiNDM1ZjMxYThmMTYzYjFkN2YyZmE5NGMyNmM4MTM"
      
      $data$repository$defaultBranchRef$target$history$edges[[74]]$node$committed_date
      [1] "2023-01-30T14:54:21Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[74]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[74]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[74]]$node$additions
      [1] 336
      
      $data$repository$defaultBranchRef$target$history$edges[[74]]$node$deletions
      [1] 89
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[75]]
      $data$repository$defaultBranchRef$target$history$edges[[75]]$node
      $data$repository$defaultBranchRef$target$history$edges[[75]]$node$id
      [1] "C_kwDOIvtxstoAKDJhNDM2ZGY2ZGVmZGJhNzhhMDAwNWQzNzE5MTM1YmVkZjg5MzQyOTc"
      
      $data$repository$defaultBranchRef$target$history$edges[[75]]$node$committed_date
      [1] "2023-01-30T12:07:15Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[75]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[75]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[75]]$node$additions
      [1] 4
      
      $data$repository$defaultBranchRef$target$history$edges[[75]]$node$deletions
      [1] 3
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[76]]
      $data$repository$defaultBranchRef$target$history$edges[[76]]$node
      $data$repository$defaultBranchRef$target$history$edges[[76]]$node$id
      [1] "C_kwDOIvtxstoAKDVmMTkxZDU3NjA3YzMzMjgzMTk0MWFkNDIzOTI0NDMzY2NhNGZjNzc"
      
      $data$repository$defaultBranchRef$target$history$edges[[76]]$node$committed_date
      [1] "2023-01-30T11:16:29Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[76]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[76]]$node$author$name
      [1] "Maciej Banaś"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[76]]$node$additions
      [1] 687
      
      $data$repository$defaultBranchRef$target$history$edges[[76]]$node$deletions
      [1] 185
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[77]]
      $data$repository$defaultBranchRef$target$history$edges[[77]]$node
      $data$repository$defaultBranchRef$target$history$edges[[77]]$node$id
      [1] "C_kwDOIvtxstoAKDllODIyNDVlMDlkMWJmZDljZDhlMDg4NmIwMjJjZGY5M2JiNzZkNWM"
      
      $data$repository$defaultBranchRef$target$history$edges[[77]]$node$committed_date
      [1] "2023-01-30T10:45:33Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[77]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[77]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[77]]$node$additions
      [1] 141
      
      $data$repository$defaultBranchRef$target$history$edges[[77]]$node$deletions
      [1] 96
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[78]]
      $data$repository$defaultBranchRef$target$history$edges[[78]]$node
      $data$repository$defaultBranchRef$target$history$edges[[78]]$node$id
      [1] "C_kwDOIvtxstoAKGEyMzQ3ZTAzMjJjMzI5OTY4ODJhYmRmZDM3YTYyNzBjYWIyNjc3Y2I"
      
      $data$repository$defaultBranchRef$target$history$edges[[78]]$node$committed_date
      [1] "2023-01-30T09:37:24Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[78]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[78]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[78]]$node$additions
      [1] 546
      
      $data$repository$defaultBranchRef$target$history$edges[[78]]$node$deletions
      [1] 89
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[79]]
      $data$repository$defaultBranchRef$target$history$edges[[79]]$node
      $data$repository$defaultBranchRef$target$history$edges[[79]]$node$id
      [1] "C_kwDOIvtxstoAKGRlODc4ZDhmY2Y2MzhkZTY2MDZkMTkyMjg4NmJkZmNhNjYyN2Q5Y2E"
      
      $data$repository$defaultBranchRef$target$history$edges[[79]]$node$committed_date
      [1] "2023-01-27T13:41:37Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[79]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[79]]$node$author$name
      [1] "Maciej Banaś"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[79]]$node$additions
      [1] 285
      
      $data$repository$defaultBranchRef$target$history$edges[[79]]$node$deletions
      [1] 81
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[80]]
      $data$repository$defaultBranchRef$target$history$edges[[80]]$node
      $data$repository$defaultBranchRef$target$history$edges[[80]]$node$id
      [1] "C_kwDOIvtxstoAKDcwY2ExODJiMjlkN2NhOTcwNjRlMDA5YWY1ZmM1NjU0MGNlZTQyM2U"
      
      $data$repository$defaultBranchRef$target$history$edges[[80]]$node$committed_date
      [1] "2023-01-27T13:40:00Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[80]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[80]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[80]]$node$additions
      [1] 285
      
      $data$repository$defaultBranchRef$target$history$edges[[80]]$node$deletions
      [1] 81
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[81]]
      $data$repository$defaultBranchRef$target$history$edges[[81]]$node
      $data$repository$defaultBranchRef$target$history$edges[[81]]$node$id
      [1] "C_kwDOIvtxstoAKGE3MWNhMGUyMjUxMDk1ZTcwMzRmZTZjZGRkNTA3NTM5NWExYTZiZDI"
      
      $data$repository$defaultBranchRef$target$history$edges[[81]]$node$committed_date
      [1] "2023-01-26T15:01:17Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[81]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[81]]$node$author$name
      [1] "Maciej Banaś"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[81]]$node$additions
      [1] 522
      
      $data$repository$defaultBranchRef$target$history$edges[[81]]$node$deletions
      [1] 43
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[82]]
      $data$repository$defaultBranchRef$target$history$edges[[82]]$node
      $data$repository$defaultBranchRef$target$history$edges[[82]]$node$id
      [1] "C_kwDOIvtxstoAKDQyNDEyNWRiMTE5M2Q2MDJjYTM0ZTM4ZjhlZjZhOTZhNjhjYTczYmM"
      
      $data$repository$defaultBranchRef$target$history$edges[[82]]$node$committed_date
      [1] "2023-01-26T12:03:04Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[82]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[82]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[82]]$node$additions
      [1] 17
      
      $data$repository$defaultBranchRef$target$history$edges[[82]]$node$deletions
      [1] 0
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[83]]
      $data$repository$defaultBranchRef$target$history$edges[[83]]$node
      $data$repository$defaultBranchRef$target$history$edges[[83]]$node$id
      [1] "C_kwDOIvtxstoAKDhiMjQ2MjEzMGE2YWRkYTUzYjFiZDIwZmRkZGRhNjM3NmZiMmE4ZjQ"
      
      $data$repository$defaultBranchRef$target$history$edges[[83]]$node$committed_date
      [1] "2023-01-26T11:37:52Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[83]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[83]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[83]]$node$additions
      [1] 7
      
      $data$repository$defaultBranchRef$target$history$edges[[83]]$node$deletions
      [1] 7
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[84]]
      $data$repository$defaultBranchRef$target$history$edges[[84]]$node
      $data$repository$defaultBranchRef$target$history$edges[[84]]$node$id
      [1] "C_kwDOIvtxstoAKGJjY2EwZDJlYzdjMGE5ZTFmN2ExY2ZkZGYyZWNiNTYzMDNjZTRhNmI"
      
      $data$repository$defaultBranchRef$target$history$edges[[84]]$node$committed_date
      [1] "2023-01-26T10:51:16Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[84]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[84]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[84]]$node$additions
      [1] 38
      
      $data$repository$defaultBranchRef$target$history$edges[[84]]$node$deletions
      [1] 29
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[85]]
      $data$repository$defaultBranchRef$target$history$edges[[85]]$node
      $data$repository$defaultBranchRef$target$history$edges[[85]]$node$id
      [1] "C_kwDOIvtxstoAKDVjMjk2ZmZiMmRhNTI2MjJjZWZlOWE2NGNkOWM5NTdlODJkN2JmY2Q"
      
      $data$repository$defaultBranchRef$target$history$edges[[85]]$node$committed_date
      [1] "2023-01-26T10:31:47Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[85]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[85]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[85]]$node$additions
      [1] 270
      
      $data$repository$defaultBranchRef$target$history$edges[[85]]$node$deletions
      [1] 8
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[86]]
      $data$repository$defaultBranchRef$target$history$edges[[86]]$node
      $data$repository$defaultBranchRef$target$history$edges[[86]]$node$id
      [1] "C_kwDOIvtxstoAKDU2YjA2MmYzOTQwZmU5MTZiYTkwNjg4YjBmMDkzOTdmOTIxNGRjM2Y"
      
      $data$repository$defaultBranchRef$target$history$edges[[86]]$node$committed_date
      [1] "2023-01-25T14:54:33Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[86]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[86]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[86]]$node$additions
      [1] 28
      
      $data$repository$defaultBranchRef$target$history$edges[[86]]$node$deletions
      [1] 5
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[87]]
      $data$repository$defaultBranchRef$target$history$edges[[87]]$node
      $data$repository$defaultBranchRef$target$history$edges[[87]]$node$id
      [1] "C_kwDOIvtxstoAKDM0MTJkNzdkNWFkOTBlMjUxOGY5ZWRiNmFkNTQzNTUzZWQ0MGI4NjU"
      
      $data$repository$defaultBranchRef$target$history$edges[[87]]$node$committed_date
      [1] "2023-01-25T14:40:59Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[87]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[87]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[87]]$node$additions
      [1] 0
      
      $data$repository$defaultBranchRef$target$history$edges[[87]]$node$deletions
      [1] 9
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[88]]
      $data$repository$defaultBranchRef$target$history$edges[[88]]$node
      $data$repository$defaultBranchRef$target$history$edges[[88]]$node$id
      [1] "C_kwDOIvtxstoAKDA4Y2MwMGMyYzgxOWUzYjc4ZTZmNWQ2NmU5MzUxOGU1OTAzZDkwMjM"
      
      $data$repository$defaultBranchRef$target$history$edges[[88]]$node$committed_date
      [1] "2023-01-25T14:37:07Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[88]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[88]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[88]]$node$additions
      [1] 88
      
      $data$repository$defaultBranchRef$target$history$edges[[88]]$node$deletions
      [1] 67
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[89]]
      $data$repository$defaultBranchRef$target$history$edges[[89]]$node
      $data$repository$defaultBranchRef$target$history$edges[[89]]$node$id
      [1] "C_kwDOIvtxstoAKDMyM2M2MWEzOGUxMjMzN2FhNTFjMjBjNDYyNWI1NzA0ZWE4NzRjYjg"
      
      $data$repository$defaultBranchRef$target$history$edges[[89]]$node$committed_date
      [1] "2023-01-25T14:23:43Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[89]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[89]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[89]]$node$additions
      [1] 14
      
      $data$repository$defaultBranchRef$target$history$edges[[89]]$node$deletions
      [1] 3
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[90]]
      $data$repository$defaultBranchRef$target$history$edges[[90]]$node
      $data$repository$defaultBranchRef$target$history$edges[[90]]$node$id
      [1] "C_kwDOIvtxstoAKGZkZWQ2MTE1YmUwNmJhNDFlMzY5NGViNzMwMDk0YTNkMmQwMGI2YzI"
      
      $data$repository$defaultBranchRef$target$history$edges[[90]]$node$committed_date
      [1] "2023-01-25T13:51:17Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[90]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[90]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[90]]$node$additions
      [1] 47
      
      $data$repository$defaultBranchRef$target$history$edges[[90]]$node$deletions
      [1] 94
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[91]]
      $data$repository$defaultBranchRef$target$history$edges[[91]]$node
      $data$repository$defaultBranchRef$target$history$edges[[91]]$node$id
      [1] "C_kwDOIvtxstoAKDc2ODA5NzQxMWI0Yjg1ZWM5ZTNlZmExMGM3MWZmMGIzM2VkMzVhOTc"
      
      $data$repository$defaultBranchRef$target$history$edges[[91]]$node$committed_date
      [1] "2023-01-25T13:09:15Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[91]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[91]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[91]]$node$additions
      [1] 11
      
      $data$repository$defaultBranchRef$target$history$edges[[91]]$node$deletions
      [1] 0
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[92]]
      $data$repository$defaultBranchRef$target$history$edges[[92]]$node
      $data$repository$defaultBranchRef$target$history$edges[[92]]$node$id
      [1] "C_kwDOIvtxstoAKDBkMjFjOWMwYTEzM2NkNzJlOTIwOGE1MDhjZWZjMDJlNWVkNGUxZjM"
      
      $data$repository$defaultBranchRef$target$history$edges[[92]]$node$committed_date
      [1] "2023-01-25T12:50:17Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[92]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[92]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[92]]$node$additions
      [1] 24
      
      $data$repository$defaultBranchRef$target$history$edges[[92]]$node$deletions
      [1] 15
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[93]]
      $data$repository$defaultBranchRef$target$history$edges[[93]]$node
      $data$repository$defaultBranchRef$target$history$edges[[93]]$node$id
      [1] "C_kwDOIvtxstoAKGYyYTc0NDBhYmQwNDdmOTQyNWU5NWI1ODY1ZGRkNGYwZTQyMzZjNWQ"
      
      $data$repository$defaultBranchRef$target$history$edges[[93]]$node$committed_date
      [1] "2023-01-25T12:19:15Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[93]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[93]]$node$author$name
      [1] "Maciej Banaś"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[93]]$node$additions
      [1] 165
      
      $data$repository$defaultBranchRef$target$history$edges[[93]]$node$deletions
      [1] 157
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[94]]
      $data$repository$defaultBranchRef$target$history$edges[[94]]$node
      $data$repository$defaultBranchRef$target$history$edges[[94]]$node$id
      [1] "C_kwDOIvtxstoAKDFjM2VmOWRlNTI5OGI1ZjI4NTUwZDllMDMzOGQxNDMwMWI1Mjk4MDU"
      
      $data$repository$defaultBranchRef$target$history$edges[[94]]$node$committed_date
      [1] "2023-01-25T11:55:46Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[94]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[94]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[94]]$node$additions
      [1] 167
      
      $data$repository$defaultBranchRef$target$history$edges[[94]]$node$deletions
      [1] 159
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[95]]
      $data$repository$defaultBranchRef$target$history$edges[[95]]$node
      $data$repository$defaultBranchRef$target$history$edges[[95]]$node$id
      [1] "C_kwDOIvtxstoAKGUzMTNmZjJjZThkZjAyN2Q4NGQyYjY4N2JlNGM1MmMwMTFjNTA4Mzc"
      
      $data$repository$defaultBranchRef$target$history$edges[[95]]$node$committed_date
      [1] "2023-01-25T11:46:06Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[95]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[95]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[95]]$node$additions
      [1] 2
      
      $data$repository$defaultBranchRef$target$history$edges[[95]]$node$deletions
      [1] 1
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[96]]
      $data$repository$defaultBranchRef$target$history$edges[[96]]$node
      $data$repository$defaultBranchRef$target$history$edges[[96]]$node$id
      [1] "C_kwDOIvtxstoAKGI5MjQ1ZGQ4ZGNhNjcxMDQ5MzhiNDQ5YTE3OTYwN2VjYzg3Mzc2ODU"
      
      $data$repository$defaultBranchRef$target$history$edges[[96]]$node$committed_date
      [1] "2023-01-25T11:28:26Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[96]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[96]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[96]]$node$additions
      [1] 7
      
      $data$repository$defaultBranchRef$target$history$edges[[96]]$node$deletions
      [1] 8
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[97]]
      $data$repository$defaultBranchRef$target$history$edges[[97]]$node
      $data$repository$defaultBranchRef$target$history$edges[[97]]$node$id
      [1] "C_kwDOIvtxstoAKDAxNTFlZjI4M2QzYThiODgyOTIxNjM4Y2ZkZWYzMTBhNmU2M2MyMGE"
      
      $data$repository$defaultBranchRef$target$history$edges[[97]]$node$committed_date
      [1] "2023-01-25T11:18:28Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[97]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[97]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[97]]$node$additions
      [1] 42
      
      $data$repository$defaultBranchRef$target$history$edges[[97]]$node$deletions
      [1] 41
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[98]]
      $data$repository$defaultBranchRef$target$history$edges[[98]]$node
      $data$repository$defaultBranchRef$target$history$edges[[98]]$node$id
      [1] "C_kwDOIvtxstoAKGI3MDJkNzE2NzM2YTRkNGI2M2Q4YmQ5NmY3YmMwN2YzOTU1NGUxMzE"
      
      $data$repository$defaultBranchRef$target$history$edges[[98]]$node$committed_date
      [1] "2023-01-25T10:35:36Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[98]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[98]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[98]]$node$additions
      [1] 5
      
      $data$repository$defaultBranchRef$target$history$edges[[98]]$node$deletions
      [1] 3
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[99]]
      $data$repository$defaultBranchRef$target$history$edges[[99]]$node
      $data$repository$defaultBranchRef$target$history$edges[[99]]$node$id
      [1] "C_kwDOIvtxstoAKDFlZTU5MTlmZmQxMzMxOGE4YTE0OTE5NDI3OGZlNTRlMzA3MTUwY2U"
      
      $data$repository$defaultBranchRef$target$history$edges[[99]]$node$committed_date
      [1] "2023-01-25T10:26:41Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[99]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[99]]$node$author$name
      [1] "maciekbanas"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[99]]$node$additions
      [1] 116
      
      $data$repository$defaultBranchRef$target$history$edges[[99]]$node$deletions
      [1] 111
      
      
      
      $data$repository$defaultBranchRef$target$history$edges[[100]]
      $data$repository$defaultBranchRef$target$history$edges[[100]]$node
      $data$repository$defaultBranchRef$target$history$edges[[100]]$node$id
      [1] "C_kwDOIvtxstoAKGMzNmMyNWRmNDFjNzBiNzU3OTc4MWQzMTdhYWEwZjhkODRlZWM2ZTY"
      
      $data$repository$defaultBranchRef$target$history$edges[[100]]$node$committed_date
      [1] "2023-01-25T08:52:01Z"
      
      $data$repository$defaultBranchRef$target$history$edges[[100]]$node$author
      $data$repository$defaultBranchRef$target$history$edges[[100]]$node$author$name
      [1] "Maciej Banaś"
      
      
      $data$repository$defaultBranchRef$target$history$edges[[100]]$node$additions
      [1] 2
      
      $data$repository$defaultBranchRef$target$history$edges[[100]]$node$deletions
      [1] 2
      
      
      
      
      
      
      
      
      

---

    Code
      repos_by_org_gql_response
    Output
      $data
      $data$repositoryOwner
      $data$repositoryOwner$repositories
      $data$repositoryOwner$repositories$totalCount
      [1] 8
      
      $data$repositoryOwner$repositories$pageInfo
      $data$repositoryOwner$repositories$pageInfo$endCursor
      [1] "Y3Vyc29yOnYyOpHOJWYrCA=="
      
      $data$repositoryOwner$repositories$pageInfo$hasNextPage
      [1] FALSE
      
      
      $data$repositoryOwner$repositories$nodes
      $data$repositoryOwner$repositories$nodes[[1]]
      $data$repositoryOwner$repositories$nodes[[1]]$id
      [1] "R_kgDOHNMr2w"
      
      $data$repositoryOwner$repositories$nodes[[1]]$name
      [1] "shinyGizmo"
      
      $data$repositoryOwner$repositories$nodes[[1]]$stars
      [1] 16
      
      $data$repositoryOwner$repositories$nodes[[1]]$forks
      [1] 0
      
      $data$repositoryOwner$repositories$nodes[[1]]$created_at
      [1] "2022-04-20T10:04:32Z"
      
      $data$repositoryOwner$repositories$nodes[[1]]$last_push
      [1] "2023-03-15T20:06:31Z"
      
      $data$repositoryOwner$repositories$nodes[[1]]$last_activity_at
      [1] "2023-04-01T04:41:59Z"
      
      $data$repositoryOwner$repositories$nodes[[1]]$languages
      $data$repositoryOwner$repositories$nodes[[1]]$languages$nodes
      $data$repositoryOwner$repositories$nodes[[1]]$languages$nodes[[1]]
      $data$repositoryOwner$repositories$nodes[[1]]$languages$nodes[[1]]$name
      [1] "R"
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$languages$nodes[[2]]
      $data$repositoryOwner$repositories$nodes[[1]]$languages$nodes[[2]]$name
      [1] "CSS"
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$languages$nodes[[3]]
      $data$repositoryOwner$repositories$nodes[[1]]$languages$nodes[[3]]$name
      [1] "JavaScript"
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$issues_open
      $data$repositoryOwner$repositories$nodes[[1]]$issues_open$totalCount
      [1] 5
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$issues_closed
      $data$repositoryOwner$repositories$nodes[[1]]$issues_closed$totalCount
      [1] 12
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$id
      [1] "C_kwDOHNMr29oAKDQ5MGQ3Yzc0MjVjYTYwMDc5YTJkMTA0MTQ2NWRlZGU2ZTI2YzA1YmI"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[1]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[1]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[1]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[1]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[2]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[2]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[2]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[2]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[2]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[2]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[3]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[3]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[3]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[3]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[4]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[4]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[4]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[4]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[4]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[4]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[5]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[5]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[5]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[5]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[5]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[5]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[6]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[6]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[6]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[6]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[6]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[6]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[7]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[7]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[7]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[7]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[7]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[7]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[8]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[8]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[8]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[8]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[9]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[9]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[9]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[9]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[9]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[9]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[10]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[10]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[10]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[10]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[10]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[10]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[11]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[11]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[11]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[11]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[11]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[11]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[12]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[12]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[12]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[12]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[12]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[12]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[13]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[13]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[13]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[13]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[13]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[13]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[14]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[14]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[14]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[14]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[14]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[14]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[15]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[15]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[15]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[15]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[15]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[15]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[16]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[16]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[16]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[16]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[16]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[16]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[17]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[17]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[17]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[17]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[17]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[17]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[18]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[18]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[18]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[18]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[18]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[18]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[19]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[19]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[19]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[19]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[19]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[19]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[20]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[20]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[20]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[20]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[21]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[21]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[21]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[21]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[21]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[21]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[22]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[22]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[22]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[22]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[22]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[22]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[23]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[23]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[23]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[23]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[24]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[24]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[24]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[24]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[24]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[24]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[25]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[25]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[25]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[25]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[25]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[25]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[26]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[26]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[26]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[26]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[27]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[27]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[27]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[27]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[27]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[27]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[28]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[28]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[28]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[28]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[28]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[28]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[29]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[29]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[29]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[29]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[29]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[29]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[30]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[30]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[30]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[30]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[31]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[31]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[31]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[31]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[31]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[31]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[32]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[32]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[32]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[32]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[32]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[32]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[33]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[33]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[33]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[33]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[33]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[33]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[34]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[34]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[34]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[34]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[35]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[35]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[35]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[35]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[35]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[35]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[36]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[36]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[36]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[36]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[36]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[36]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[37]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[37]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[37]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[37]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[37]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[37]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[38]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[38]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[38]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[38]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[38]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[38]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[39]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[39]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[39]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[39]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[39]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[39]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[40]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[40]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[40]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[40]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[40]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[40]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[41]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[41]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[41]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[41]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[41]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[41]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[42]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[42]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[42]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[42]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[42]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[42]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[43]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[43]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[43]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[43]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[43]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[43]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[44]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[44]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[44]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[44]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[45]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[45]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[45]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[45]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[45]]$node$committer$user$login
      [1] "stla"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[45]]$node$committer$user$id
      [1] "MDQ6VXNlcjQ0NjY1NDM="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[46]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[46]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[46]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[46]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[47]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[47]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[47]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[47]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[48]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[48]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[48]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[48]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[48]]$node$committer$user$login
      [1] "stlagsk"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[48]]$node$committer$user$id
      [1] "MDQ6VXNlcjg4NzY3MDM1"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[49]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[49]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[49]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[49]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[49]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[49]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[50]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[50]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[50]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[50]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[51]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[51]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[51]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[51]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[52]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[52]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[52]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[52]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[52]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[52]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[53]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[53]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[53]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[53]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[53]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[53]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[54]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[54]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[54]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[54]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[54]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[54]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[55]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[55]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[55]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[55]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[56]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[56]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[56]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[56]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[56]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[56]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[57]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[57]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[57]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[57]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[57]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[57]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[58]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[58]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[58]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[58]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[58]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[58]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[59]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[59]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[59]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[59]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[59]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[59]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[60]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[60]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[60]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[60]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[61]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[61]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[61]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[61]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[61]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[61]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[62]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[62]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[62]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[62]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[63]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[63]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[63]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[63]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[64]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[64]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[64]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[64]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[64]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[64]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[65]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[65]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[65]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[65]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[65]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[65]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[66]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[66]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[66]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[66]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[66]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[66]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[67]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[67]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[67]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[67]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[67]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[67]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[68]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[68]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[68]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[68]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[68]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[68]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[69]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[69]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[69]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[69]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[70]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[70]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[70]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[70]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[70]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[70]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[71]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[71]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[71]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[71]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[71]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[71]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[72]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[72]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[72]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[72]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[72]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[72]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[73]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[73]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[73]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[73]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[73]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[73]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[74]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[74]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[74]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[74]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[74]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[74]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[75]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[75]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[75]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[75]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[75]]$node$committer$user$login
      [1] "stla"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[75]]$node$committer$user$id
      [1] "MDQ6VXNlcjQ0NjY1NDM="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[76]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[76]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[76]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[76]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[77]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[77]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[77]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[77]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[77]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[77]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[78]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[78]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[78]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[78]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[78]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[78]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[79]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[79]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[79]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[79]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[79]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[79]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[80]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[80]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[80]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[80]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[81]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[81]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[81]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[81]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[81]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[81]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[82]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[82]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[82]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[82]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[82]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[82]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[83]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[83]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[83]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[83]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[83]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[83]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[84]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[84]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[84]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[84]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[84]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[84]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[85]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[85]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[85]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[85]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[85]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[85]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[86]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[86]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[86]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[86]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[86]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[86]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[87]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[87]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[87]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[87]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[87]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[87]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[88]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[88]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[88]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[88]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[89]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[89]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[89]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[89]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[90]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[90]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[90]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[90]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[90]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[90]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[91]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[91]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[91]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[91]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[91]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[91]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[92]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[92]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[92]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[92]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[92]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[92]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[93]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[93]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[93]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[93]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[93]]$node$committer$user$login
      [1] "galachad"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[93]]$node$committer$user$id
      [1] "MDQ6VXNlcjQyOTYzOTA="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[94]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[94]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[94]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[94]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[94]]$node$committer$user$login
      [1] "galachad"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[94]]$node$committer$user$id
      [1] "MDQ6VXNlcjQyOTYzOTA="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[95]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[95]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[95]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[95]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[95]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[95]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[96]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[96]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[96]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[96]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[96]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[96]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[97]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[97]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[97]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[97]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[97]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[97]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[98]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[98]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[98]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[98]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[98]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[98]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[99]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[99]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[99]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[99]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[100]]
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[100]]$node
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[100]]$node$committer
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[100]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[100]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[1]]$contributors$target$history$edges[[100]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[1]]$repo_url
      [1] "https://github.com/r-world-devs/shinyGizmo"
      
      
      $data$repositoryOwner$repositories$nodes[[2]]
      $data$repositoryOwner$repositories$nodes[[2]]$id
      [1] "R_kgDOHYNOFQ"
      
      $data$repositoryOwner$repositories$nodes[[2]]$name
      [1] "cohortBuilder"
      
      $data$repositoryOwner$repositories$nodes[[2]]$stars
      [1] 2
      
      $data$repositoryOwner$repositories$nodes[[2]]$forks
      [1] 1
      
      $data$repositoryOwner$repositories$nodes[[2]]$created_at
      [1] "2022-05-22T18:31:55Z"
      
      $data$repositoryOwner$repositories$nodes[[2]]$last_push
      [1] "2023-03-15T20:24:15Z"
      
      $data$repositoryOwner$repositories$nodes[[2]]$last_activity_at
      [1] "2023-03-17T14:57:40Z"
      
      $data$repositoryOwner$repositories$nodes[[2]]$languages
      $data$repositoryOwner$repositories$nodes[[2]]$languages$nodes
      $data$repositoryOwner$repositories$nodes[[2]]$languages$nodes[[1]]
      $data$repositoryOwner$repositories$nodes[[2]]$languages$nodes[[1]]$name
      [1] "R"
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$issues_open
      $data$repositoryOwner$repositories$nodes[[2]]$issues_open$totalCount
      [1] 22
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$issues_closed
      $data$repositoryOwner$repositories$nodes[[2]]$issues_closed$totalCount
      [1] 1
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$id
      [1] "C_kwDOHYNOFdoAKDhiMDg5NjE0NmIxMDI5ODgwMDI3NTg4YmUzMTEwNzliMjY2MzMxY2E"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[1]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[1]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[1]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[1]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[2]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[2]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[2]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[2]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[2]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[2]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[3]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[3]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[3]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[3]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[4]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[4]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[4]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[4]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[4]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[4]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[5]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[5]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[5]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[5]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[5]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[5]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[6]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[6]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[6]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[6]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[6]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[6]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[7]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[7]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[7]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[7]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[7]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[7]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[8]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[8]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[8]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[8]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[8]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[8]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[9]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[9]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[9]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[9]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[9]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[9]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[10]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[10]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[10]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[10]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[11]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[11]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[11]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[11]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[11]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[11]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[12]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[12]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[12]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[12]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[12]]$node$committer$user$login
      [1] "galachad"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[12]]$node$committer$user$id
      [1] "MDQ6VXNlcjQyOTYzOTA="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[13]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[13]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[13]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[13]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[13]]$node$committer$user$login
      [1] "galachad"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[13]]$node$committer$user$id
      [1] "MDQ6VXNlcjQyOTYzOTA="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[14]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[14]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[14]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[14]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[15]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[15]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[15]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[15]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[15]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[15]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[16]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[16]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[16]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[16]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[16]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[16]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[17]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[17]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[17]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[17]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[17]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[17]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[18]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[18]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[18]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[18]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[18]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[18]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[19]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[19]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[19]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[19]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[19]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[19]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[20]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[20]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[20]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[20]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[20]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[20]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[21]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[21]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[21]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[21]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[21]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[21]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[22]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[22]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[22]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[22]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[22]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[22]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[23]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[23]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[23]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[23]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[23]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[23]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[24]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[24]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[24]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[24]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[24]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[24]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[25]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[25]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[25]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[25]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[25]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[25]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[26]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[26]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[26]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[26]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[26]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[26]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[27]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[27]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[27]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[27]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[28]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[28]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[28]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[28]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[28]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[28]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[29]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[29]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[29]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[29]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[30]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[30]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[30]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[30]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[30]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[30]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[31]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[31]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[31]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[31]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[31]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[31]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[32]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[32]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[32]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[32]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[32]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[32]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[33]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[33]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[33]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[33]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[33]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[33]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[34]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[34]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[34]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[34]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[34]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[34]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[35]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[35]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[35]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[35]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[35]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[35]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[36]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[36]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[36]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[36]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[36]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[36]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[37]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[37]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[37]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[37]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[38]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[38]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[38]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[38]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[38]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[38]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[39]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[39]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[39]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[39]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[39]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[39]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[40]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[40]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[40]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[40]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[40]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[40]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[41]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[41]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[41]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[41]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[41]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[41]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[42]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[42]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[42]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[42]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[42]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[42]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[43]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[43]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[43]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[43]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[43]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[43]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[44]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[44]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[44]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[44]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[44]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[44]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[45]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[45]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[45]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[45]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[45]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[45]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[46]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[46]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[46]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[46]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[46]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[46]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[47]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[47]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[47]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[47]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[47]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[47]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[48]]
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[48]]$node
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[48]]$node$committer
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[48]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[48]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[2]]$contributors$target$history$edges[[48]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[2]]$repo_url
      [1] "https://github.com/r-world-devs/cohortBuilder"
      
      
      $data$repositoryOwner$repositories$nodes[[3]]
      $data$repositoryOwner$repositories$nodes[[3]]$id
      [1] "R_kgDOHYNrJw"
      
      $data$repositoryOwner$repositories$nodes[[3]]$name
      [1] "shinyCohortBuilder"
      
      $data$repositoryOwner$repositories$nodes[[3]]$stars
      [1] 4
      
      $data$repositoryOwner$repositories$nodes[[3]]$forks
      [1] 0
      
      $data$repositoryOwner$repositories$nodes[[3]]$created_at
      [1] "2022-05-22T19:04:12Z"
      
      $data$repositoryOwner$repositories$nodes[[3]]$last_push
      [1] "2023-03-15T20:54:41Z"
      
      $data$repositoryOwner$repositories$nodes[[3]]$last_activity_at
      [1] "2023-03-17T14:57:56Z"
      
      $data$repositoryOwner$repositories$nodes[[3]]$languages
      $data$repositoryOwner$repositories$nodes[[3]]$languages$nodes
      $data$repositoryOwner$repositories$nodes[[3]]$languages$nodes[[1]]
      $data$repositoryOwner$repositories$nodes[[3]]$languages$nodes[[1]]$name
      [1] "R"
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$languages$nodes[[2]]
      $data$repositoryOwner$repositories$nodes[[3]]$languages$nodes[[2]]$name
      [1] "CSS"
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$languages$nodes[[3]]
      $data$repositoryOwner$repositories$nodes[[3]]$languages$nodes[[3]]$name
      [1] "JavaScript"
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$languages$nodes[[4]]
      $data$repositoryOwner$repositories$nodes[[3]]$languages$nodes[[4]]$name
      [1] "SCSS"
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$issues_open
      $data$repositoryOwner$repositories$nodes[[3]]$issues_open$totalCount
      [1] 27
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$issues_closed
      $data$repositoryOwner$repositories$nodes[[3]]$issues_closed$totalCount
      [1] 4
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$id
      [1] "C_kwDOHYNrJ9oAKDNkNzFiZjQ0Mjc0ZDRkMzNiMDdlODUzNzVmYTBkZDdmYTdmNDRkNzI"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[1]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[1]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[1]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[1]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[1]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[1]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[2]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[2]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[2]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[2]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[3]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[3]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[3]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[3]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[3]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[3]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[4]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[4]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[4]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[4]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[4]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[4]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[5]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[5]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[5]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[5]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[5]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[5]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[6]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[6]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[6]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[6]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[6]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[6]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[7]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[7]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[7]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[7]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[8]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[8]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[8]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[8]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[8]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[8]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[9]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[9]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[9]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[9]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[9]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[9]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[10]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[10]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[10]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[10]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[10]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[10]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[11]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[11]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[11]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[11]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[12]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[12]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[12]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[12]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[12]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[12]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[13]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[13]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[13]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[13]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[13]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[13]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[14]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[14]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[14]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[14]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[14]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[14]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[15]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[15]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[15]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[15]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[15]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[15]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[16]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[16]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[16]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[16]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[16]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[16]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[17]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[17]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[17]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[17]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[18]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[18]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[18]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[18]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[18]]$node$committer$user$login
      [1] "galachad"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[18]]$node$committer$user$id
      [1] "MDQ6VXNlcjQyOTYzOTA="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[19]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[19]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[19]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[19]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[20]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[20]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[20]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[20]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[21]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[21]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[21]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[21]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[22]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[22]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[22]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[22]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[22]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[22]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[23]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[23]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[23]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[23]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[23]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[23]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[24]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[24]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[24]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[24]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[24]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[24]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[25]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[25]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[25]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[25]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[25]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[25]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[26]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[26]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[26]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[26]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[27]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[27]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[27]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[27]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[27]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[27]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[28]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[28]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[28]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[28]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[28]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[28]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[29]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[29]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[29]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[29]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[29]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[29]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[30]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[30]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[30]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[30]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[30]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[30]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[31]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[31]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[31]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[31]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[31]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[31]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[32]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[32]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[32]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[32]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[32]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[32]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[33]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[33]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[33]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[33]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[33]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[33]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[34]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[34]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[34]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[34]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[34]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[34]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[35]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[35]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[35]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[35]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[35]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[35]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[36]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[36]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[36]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[36]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[36]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[36]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[37]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[37]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[37]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[37]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[37]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[37]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[38]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[38]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[38]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[38]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[38]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[38]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[39]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[39]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[39]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[39]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[39]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[39]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[40]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[40]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[40]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[40]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[40]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[40]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[41]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[41]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[41]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[41]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[41]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[41]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[42]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[42]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[42]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[42]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[42]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[42]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[43]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[43]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[43]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[43]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[43]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[43]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[44]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[44]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[44]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[44]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[44]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[44]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[45]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[45]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[45]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[45]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[45]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[45]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[46]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[46]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[46]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[46]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[46]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[46]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[47]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[47]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[47]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[47]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[47]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[47]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[48]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[48]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[48]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[48]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[48]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[48]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[49]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[49]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[49]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[49]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[49]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[49]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[50]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[50]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[50]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[50]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[50]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[50]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[51]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[51]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[51]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[51]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[51]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[51]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[52]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[52]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[52]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[52]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[52]]$node$committer$user$login
      [1] "galachad"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[52]]$node$committer$user$id
      [1] "MDQ6VXNlcjQyOTYzOTA="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[53]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[53]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[53]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[53]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[54]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[54]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[54]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[54]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[54]]$node$committer$user$login
      [1] "galachad"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[54]]$node$committer$user$id
      [1] "MDQ6VXNlcjQyOTYzOTA="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[55]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[55]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[55]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[55]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[56]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[56]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[56]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[56]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[56]]$node$committer$user$login
      [1] "galachad"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[56]]$node$committer$user$id
      [1] "MDQ6VXNlcjQyOTYzOTA="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[57]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[57]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[57]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[57]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[57]]$node$committer$user$login
      [1] "galachad"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[57]]$node$committer$user$id
      [1] "MDQ6VXNlcjQyOTYzOTA="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[58]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[58]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[58]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[58]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[59]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[59]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[59]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[59]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[59]]$node$committer$user$login
      [1] "galachad"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[59]]$node$committer$user$id
      [1] "MDQ6VXNlcjQyOTYzOTA="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[60]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[60]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[60]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[60]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[60]]$node$committer$user$login
      [1] "galachad"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[60]]$node$committer$user$id
      [1] "MDQ6VXNlcjQyOTYzOTA="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[61]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[61]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[61]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[61]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[61]]$node$committer$user$login
      [1] "galachad"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[61]]$node$committer$user$id
      [1] "MDQ6VXNlcjQyOTYzOTA="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[62]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[62]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[62]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[62]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[62]]$node$committer$user$login
      [1] "galachad"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[62]]$node$committer$user$id
      [1] "MDQ6VXNlcjQyOTYzOTA="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[63]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[63]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[63]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[63]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[63]]$node$committer$user$login
      [1] "galachad"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[63]]$node$committer$user$id
      [1] "MDQ6VXNlcjQyOTYzOTA="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[64]]
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[64]]$node
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[64]]$node$committer
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[64]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[64]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[3]]$contributors$target$history$edges[[64]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[3]]$repo_url
      [1] "https://github.com/r-world-devs/shinyCohortBuilder"
      
      
      $data$repositoryOwner$repositories$nodes[[4]]
      $data$repositoryOwner$repositories$nodes[[4]]$id
      [1] "R_kgDOHYNxtw"
      
      $data$repositoryOwner$repositories$nodes[[4]]$name
      [1] "cohortBuilder.db"
      
      $data$repositoryOwner$repositories$nodes[[4]]$stars
      [1] 0
      
      $data$repositoryOwner$repositories$nodes[[4]]$forks
      [1] 0
      
      $data$repositoryOwner$repositories$nodes[[4]]$created_at
      [1] "2022-05-22T19:11:32Z"
      
      $data$repositoryOwner$repositories$nodes[[4]]$last_push
      [1] "2022-07-29T10:16:22Z"
      
      $data$repositoryOwner$repositories$nodes[[4]]$last_activity_at
      [1] "2022-05-22T19:13:25Z"
      
      $data$repositoryOwner$repositories$nodes[[4]]$languages
      $data$repositoryOwner$repositories$nodes[[4]]$languages$nodes
      $data$repositoryOwner$repositories$nodes[[4]]$languages$nodes[[1]]
      $data$repositoryOwner$repositories$nodes[[4]]$languages$nodes[[1]]$name
      [1] "R"
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[4]]$issues_open
      $data$repositoryOwner$repositories$nodes[[4]]$issues_open$totalCount
      [1] 3
      
      
      $data$repositoryOwner$repositories$nodes[[4]]$issues_closed
      $data$repositoryOwner$repositories$nodes[[4]]$issues_closed$totalCount
      [1] 0
      
      
      $data$repositoryOwner$repositories$nodes[[4]]$contributors
      $data$repositoryOwner$repositories$nodes[[4]]$contributors$target
      $data$repositoryOwner$repositories$nodes[[4]]$contributors$target$id
      [1] "C_kwDOHYNxt9oAKGQzYzY5NGM5Y2Q4NjY2ODhmNmQ0ODQzMTVjNzRlNDNjZGZiNGRlZTI"
      
      $data$repositoryOwner$repositories$nodes[[4]]$contributors$target$history
      $data$repositoryOwner$repositories$nodes[[4]]$contributors$target$history$edges
      $data$repositoryOwner$repositories$nodes[[4]]$contributors$target$history$edges[[1]]
      $data$repositoryOwner$repositories$nodes[[4]]$contributors$target$history$edges[[1]]$node
      $data$repositoryOwner$repositories$nodes[[4]]$contributors$target$history$edges[[1]]$node$committer
      $data$repositoryOwner$repositories$nodes[[4]]$contributors$target$history$edges[[1]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[4]]$contributors$target$history$edges[[1]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[4]]$contributors$target$history$edges[[1]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[4]]$repo_url
      [1] "https://github.com/r-world-devs/cohortBuilder.db"
      
      
      $data$repositoryOwner$repositories$nodes[[5]]
      $data$repositoryOwner$repositories$nodes[[5]]$id
      [1] "R_kgDOIvtxsg"
      
      $data$repositoryOwner$repositories$nodes[[5]]$name
      [1] "GitStats"
      
      $data$repositoryOwner$repositories$nodes[[5]]$stars
      [1] 1
      
      $data$repositoryOwner$repositories$nodes[[5]]$forks
      [1] 0
      
      $data$repositoryOwner$repositories$nodes[[5]]$created_at
      [1] "2023-01-09T14:02:20Z"
      
      $data$repositoryOwner$repositories$nodes[[5]]$last_push
      [1] "2023-04-13T15:13:01Z"
      
      $data$repositoryOwner$repositories$nodes[[5]]$last_activity_at
      [1] "2023-03-22T16:41:51Z"
      
      $data$repositoryOwner$repositories$nodes[[5]]$languages
      $data$repositoryOwner$repositories$nodes[[5]]$languages$nodes
      $data$repositoryOwner$repositories$nodes[[5]]$languages$nodes[[1]]
      $data$repositoryOwner$repositories$nodes[[5]]$languages$nodes[[1]]$name
      [1] "R"
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$issues_open
      $data$repositoryOwner$repositories$nodes[[5]]$issues_open$totalCount
      [1] 57
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$issues_closed
      $data$repositoryOwner$repositories$nodes[[5]]$issues_closed$totalCount
      [1] 69
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$id
      [1] "C_kwDOIvtxstoAKGVmMGViNzczNzFkMWM1MWE1NTcxOTgxNTE4YTI2MzAzY2IxMzYzZWU"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[1]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[1]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[1]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[1]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[2]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[2]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[2]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[2]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[2]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[2]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[3]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[3]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[3]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[3]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[3]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[3]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[4]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[4]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[4]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[4]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[4]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[4]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[5]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[5]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[5]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[5]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[5]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[5]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[6]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[6]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[6]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[6]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[7]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[7]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[7]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[7]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[7]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[7]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[8]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[8]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[8]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[8]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[9]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[9]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[9]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[9]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[10]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[10]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[10]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[10]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[10]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[10]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[11]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[11]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[11]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[11]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[11]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[11]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[12]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[12]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[12]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[12]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[13]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[13]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[13]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[13]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[13]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[13]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[14]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[14]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[14]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[14]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[14]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[14]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[15]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[15]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[15]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[15]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[15]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[15]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[16]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[16]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[16]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[16]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[16]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[16]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[17]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[17]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[17]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[17]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[17]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[17]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[18]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[18]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[18]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[18]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[18]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[18]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[19]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[19]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[19]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[19]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[19]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[19]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[20]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[20]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[20]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[20]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[21]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[21]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[21]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[21]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[21]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[21]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[22]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[22]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[22]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[22]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[22]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[22]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[23]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[23]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[23]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[23]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[23]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[23]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[24]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[24]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[24]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[24]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[24]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[24]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[25]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[25]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[25]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[25]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[26]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[26]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[26]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[26]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[26]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[26]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[27]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[27]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[27]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[27]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[28]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[28]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[28]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[28]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[28]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[28]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[29]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[29]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[29]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[29]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[29]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[29]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[30]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[30]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[30]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[30]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[31]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[31]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[31]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[31]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[31]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[31]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[32]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[32]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[32]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[32]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[32]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[32]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[33]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[33]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[33]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[33]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[33]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[33]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[34]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[34]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[34]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[34]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[34]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[34]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[35]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[35]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[35]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[35]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[35]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[35]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[36]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[36]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[36]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[36]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[36]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[36]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[37]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[37]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[37]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[37]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[37]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[37]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[38]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[38]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[38]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[38]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[38]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[38]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[39]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[39]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[39]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[39]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[39]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[39]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[40]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[40]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[40]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[40]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[40]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[40]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[41]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[41]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[41]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[41]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[41]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[41]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[42]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[42]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[42]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[42]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[42]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[42]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[43]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[43]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[43]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[43]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[43]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[43]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[44]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[44]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[44]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[44]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[44]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[44]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[45]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[45]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[45]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[45]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[46]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[46]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[46]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[46]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[47]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[47]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[47]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[47]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[48]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[48]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[48]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[48]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[48]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[48]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[49]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[49]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[49]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[49]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[50]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[50]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[50]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[50]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[50]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[50]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[51]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[51]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[51]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[51]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[52]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[52]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[52]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[52]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[52]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[52]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[53]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[53]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[53]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[53]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[53]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[53]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[54]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[54]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[54]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[54]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[55]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[55]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[55]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[55]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[55]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[55]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[56]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[56]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[56]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[56]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[56]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[56]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[57]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[57]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[57]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[57]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[57]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[57]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[58]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[58]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[58]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[58]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[59]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[59]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[59]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[59]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[59]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[59]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[60]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[60]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[60]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[60]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[60]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[60]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[61]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[61]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[61]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[61]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[62]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[62]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[62]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[62]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[62]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[62]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[63]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[63]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[63]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[63]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[63]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[63]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[64]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[64]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[64]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[64]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[65]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[65]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[65]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[65]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[65]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[65]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[66]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[66]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[66]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[66]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[66]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[66]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[67]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[67]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[67]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[67]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[67]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[67]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[68]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[68]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[68]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[68]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[68]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[68]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[69]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[69]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[69]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[69]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[69]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[69]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[70]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[70]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[70]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[70]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[70]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[70]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[71]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[71]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[71]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[71]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[71]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[71]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[72]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[72]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[72]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[72]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[73]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[73]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[73]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[73]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[73]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[73]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[74]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[74]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[74]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[74]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[74]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[74]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[75]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[75]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[75]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[75]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[75]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[75]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[76]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[76]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[76]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[76]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[76]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[76]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[77]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[77]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[77]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[77]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[77]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[77]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[78]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[78]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[78]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[78]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[78]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[78]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[79]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[79]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[79]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[79]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[79]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[79]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[80]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[80]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[80]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[80]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[80]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[80]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[81]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[81]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[81]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[81]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[82]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[82]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[82]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[82]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[82]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[82]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[83]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[83]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[83]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[83]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[83]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[83]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[84]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[84]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[84]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[84]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[84]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[84]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[85]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[85]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[85]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[85]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[85]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[85]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[86]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[86]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[86]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[86]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[87]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[87]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[87]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[87]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[87]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[87]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[88]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[88]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[88]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[88]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[88]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[88]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[89]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[89]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[89]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[89]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[89]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[89]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[90]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[90]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[90]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[90]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[90]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[90]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[91]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[91]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[91]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[91]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[91]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[91]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[92]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[92]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[92]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[92]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[93]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[93]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[93]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[93]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[93]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[93]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[94]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[94]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[94]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[94]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[94]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[94]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[95]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[95]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[95]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[95]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[95]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[95]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[96]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[96]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[96]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[96]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[96]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[96]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[97]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[97]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[97]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[97]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[97]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[97]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[98]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[98]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[98]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[98]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[98]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[98]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[99]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[99]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[99]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[99]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[99]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[99]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[100]]
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[100]]$node
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[100]]$node$committer
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[100]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[100]]$node$committer$user$login
      [1] "maciekbanas"
      
      $data$repositoryOwner$repositories$nodes[[5]]$contributors$target$history$edges[[100]]$node$committer$user$id
      [1] "MDQ6VXNlcjc0MjEyOTMz"
      
      
      
      
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[5]]$repo_url
      [1] "https://github.com/r-world-devs/GitStats"
      
      
      $data$repositoryOwner$repositories$nodes[[6]]
      $data$repositoryOwner$repositories$nodes[[6]]$id
      [1] "R_kgDOJAtHJA"
      
      $data$repositoryOwner$repositories$nodes[[6]]$name
      [1] "shinyTimelines"
      
      $data$repositoryOwner$repositories$nodes[[6]]$stars
      [1] 2
      
      $data$repositoryOwner$repositories$nodes[[6]]$forks
      [1] 0
      
      $data$repositoryOwner$repositories$nodes[[6]]$created_at
      [1] "2023-02-21T16:41:59Z"
      
      $data$repositoryOwner$repositories$nodes[[6]]$last_push
      [1] "2023-03-22T14:12:29Z"
      
      $data$repositoryOwner$repositories$nodes[[6]]$last_activity_at
      [1] "2023-03-17T14:58:07Z"
      
      $data$repositoryOwner$repositories$nodes[[6]]$languages
      $data$repositoryOwner$repositories$nodes[[6]]$languages$nodes
      $data$repositoryOwner$repositories$nodes[[6]]$languages$nodes[[1]]
      $data$repositoryOwner$repositories$nodes[[6]]$languages$nodes[[1]]$name
      [1] "R"
      
      
      $data$repositoryOwner$repositories$nodes[[6]]$languages$nodes[[2]]
      $data$repositoryOwner$repositories$nodes[[6]]$languages$nodes[[2]]$name
      [1] "CSS"
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[6]]$issues_open
      $data$repositoryOwner$repositories$nodes[[6]]$issues_open$totalCount
      [1] 0
      
      
      $data$repositoryOwner$repositories$nodes[[6]]$issues_closed
      $data$repositoryOwner$repositories$nodes[[6]]$issues_closed$totalCount
      [1] 0
      
      
      $data$repositoryOwner$repositories$nodes[[6]]$contributors
      $data$repositoryOwner$repositories$nodes[[6]]$contributors$target
      $data$repositoryOwner$repositories$nodes[[6]]$contributors$target$id
      [1] "C_kwDOJAtHJNoAKGU3MDJlMWYyNDQ4ZGI3YjI1YmFjOTdjNzg5MDQwMGM1MjUxY2VjZTU"
      
      $data$repositoryOwner$repositories$nodes[[6]]$contributors$target$history
      $data$repositoryOwner$repositories$nodes[[6]]$contributors$target$history$edges
      $data$repositoryOwner$repositories$nodes[[6]]$contributors$target$history$edges[[1]]
      $data$repositoryOwner$repositories$nodes[[6]]$contributors$target$history$edges[[1]]$node
      $data$repositoryOwner$repositories$nodes[[6]]$contributors$target$history$edges[[1]]$node$committer
      $data$repositoryOwner$repositories$nodes[[6]]$contributors$target$history$edges[[1]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[6]]$contributors$target$history$edges[[1]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[6]]$contributors$target$history$edges[[1]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[6]]$contributors$target$history$edges[[2]]
      $data$repositoryOwner$repositories$nodes[[6]]$contributors$target$history$edges[[2]]$node
      $data$repositoryOwner$repositories$nodes[[6]]$contributors$target$history$edges[[2]]$node$committer
      $data$repositoryOwner$repositories$nodes[[6]]$contributors$target$history$edges[[2]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[6]]$contributors$target$history$edges[[2]]$node$committer$user$login
      [1] "krystian8207"
      
      $data$repositoryOwner$repositories$nodes[[6]]$contributors$target$history$edges[[2]]$node$committer$user$id
      [1] "MDQ6VXNlcjIwNDU3MDQz"
      
      
      
      
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[6]]$repo_url
      [1] "https://github.com/r-world-devs/shinyTimelines"
      
      
      $data$repositoryOwner$repositories$nodes[[7]]
      $data$repositoryOwner$repositories$nodes[[7]]$id
      [1] "R_kgDOJKQ8Lg"
      
      $data$repositoryOwner$repositories$nodes[[7]]$name
      [1] "ROhdsiWebApi"
      
      $data$repositoryOwner$repositories$nodes[[7]]$stars
      [1] 0
      
      $data$repositoryOwner$repositories$nodes[[7]]$forks
      [1] 0
      
      $data$repositoryOwner$repositories$nodes[[7]]$created_at
      [1] "2023-03-16T08:21:20Z"
      
      $data$repositoryOwner$repositories$nodes[[7]]$last_push
      [1] "2023-03-16T08:40:16Z"
      
      $data$repositoryOwner$repositories$nodes[[7]]$last_activity_at
      [1] "2023-03-16T08:16:06Z"
      
      $data$repositoryOwner$repositories$nodes[[7]]$languages
      $data$repositoryOwner$repositories$nodes[[7]]$languages$nodes
      $data$repositoryOwner$repositories$nodes[[7]]$languages$nodes[[1]]
      $data$repositoryOwner$repositories$nodes[[7]]$languages$nodes[[1]]$name
      [1] "Shell"
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$languages$nodes[[2]]
      $data$repositoryOwner$repositories$nodes[[7]]$languages$nodes[[2]]$name
      [1] "Perl"
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$languages$nodes[[3]]
      $data$repositoryOwner$repositories$nodes[[7]]$languages$nodes[[3]]$name
      [1] "R"
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$issues_open
      $data$repositoryOwner$repositories$nodes[[7]]$issues_open$totalCount
      [1] 0
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$issues_closed
      $data$repositoryOwner$repositories$nodes[[7]]$issues_closed$totalCount
      [1] 0
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$id
      [1] "C_kwDOJKQ8LtoAKDQ1NWM4MTYzM2RlNmQ2OGRjZDY3NWRkYjMxZjQ3MWM2NmU4ZmEzMzI"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[1]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[1]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[1]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[1]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[2]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[2]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[2]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[2]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[3]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[3]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[3]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[3]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[4]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[4]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[4]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[4]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[5]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[5]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[5]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[5]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[6]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[6]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[6]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[6]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[7]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[7]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[7]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[7]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[8]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[8]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[8]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[8]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[9]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[9]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[9]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[9]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[10]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[10]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[10]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[10]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[10]]$node$committer$user$login
      [1] "gowthamrao"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[10]]$node$committer$user$id
      [1] "MDQ6VXNlcjEzOTM2NjAw"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[11]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[11]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[11]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[11]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[11]]$node$committer$user$login
      [1] "gowthamrao"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[11]]$node$committer$user$id
      [1] "MDQ6VXNlcjEzOTM2NjAw"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[12]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[12]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[12]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[12]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[12]]$node$committer$user$login
      [1] "gowthamrao"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[12]]$node$committer$user$id
      [1] "MDQ6VXNlcjEzOTM2NjAw"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[13]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[13]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[13]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[13]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[13]]$node$committer$user$login
      [1] "gowthamrao"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[13]]$node$committer$user$id
      [1] "MDQ6VXNlcjEzOTM2NjAw"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[14]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[14]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[14]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[14]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[15]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[15]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[15]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[15]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[16]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[16]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[16]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[16]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[17]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[17]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[17]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[17]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[18]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[18]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[18]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[18]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[19]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[19]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[19]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[19]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[20]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[20]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[20]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[20]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[21]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[21]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[21]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[21]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[21]]$node$committer$user$login
      [1] "azimov"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[21]]$node$committer$user$id
      [1] "MDQ6VXNlcjE4MDY1OQ=="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[22]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[22]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[22]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[22]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[22]]$node$committer$user$login
      [1] "azimov"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[22]]$node$committer$user$id
      [1] "MDQ6VXNlcjE4MDY1OQ=="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[23]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[23]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[23]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[23]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[23]]$node$committer$user$login
      [1] "azimov"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[23]]$node$committer$user$id
      [1] "MDQ6VXNlcjE4MDY1OQ=="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[24]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[24]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[24]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[24]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[24]]$node$committer$user$login
      [1] "azimov"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[24]]$node$committer$user$id
      [1] "MDQ6VXNlcjE4MDY1OQ=="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[25]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[25]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[25]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[25]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[25]]$node$committer$user$login
      [1] "azimov"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[25]]$node$committer$user$id
      [1] "MDQ6VXNlcjE4MDY1OQ=="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[26]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[26]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[26]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[26]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[26]]$node$committer$user$login
      [1] "azimov"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[26]]$node$committer$user$id
      [1] "MDQ6VXNlcjE4MDY1OQ=="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[27]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[27]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[27]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[27]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[27]]$node$committer$user$login
      [1] "gowthamrao"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[27]]$node$committer$user$id
      [1] "MDQ6VXNlcjEzOTM2NjAw"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[28]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[28]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[28]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[28]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[28]]$node$committer$user$login
      [1] "gowthamrao"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[28]]$node$committer$user$id
      [1] "MDQ6VXNlcjEzOTM2NjAw"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[29]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[29]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[29]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[29]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[29]]$node$committer$user$login
      [1] "gowthamrao"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[29]]$node$committer$user$id
      [1] "MDQ6VXNlcjEzOTM2NjAw"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[30]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[30]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[30]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[30]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[31]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[31]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[31]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[31]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[32]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[32]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[32]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[32]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[32]]$node$committer$user$login
      [1] "gowthamrao"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[32]]$node$committer$user$id
      [1] "MDQ6VXNlcjEzOTM2NjAw"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[33]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[33]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[33]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[33]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[34]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[34]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[34]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[34]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[35]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[35]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[35]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[35]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[35]]$node$committer$user$login
      [1] "azimov"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[35]]$node$committer$user$id
      [1] "MDQ6VXNlcjE4MDY1OQ=="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[36]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[36]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[36]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[36]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[36]]$node$committer$user$login
      [1] "azimov"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[36]]$node$committer$user$id
      [1] "MDQ6VXNlcjE4MDY1OQ=="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[37]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[37]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[37]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[37]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[37]]$node$committer$user$login
      [1] "azimov"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[37]]$node$committer$user$id
      [1] "MDQ6VXNlcjE4MDY1OQ=="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[38]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[38]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[38]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[38]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[38]]$node$committer$user$login
      [1] "gowthamrao"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[38]]$node$committer$user$id
      [1] "MDQ6VXNlcjEzOTM2NjAw"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[39]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[39]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[39]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[39]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[40]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[40]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[40]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[40]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[40]]$node$committer$user$login
      [1] "azimov"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[40]]$node$committer$user$id
      [1] "MDQ6VXNlcjE4MDY1OQ=="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[41]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[41]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[41]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[41]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[41]]$node$committer$user$login
      [1] "gowthamrao"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[41]]$node$committer$user$id
      [1] "MDQ6VXNlcjEzOTM2NjAw"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[42]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[42]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[42]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[42]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[42]]$node$committer$user$login
      [1] "gowthamrao"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[42]]$node$committer$user$id
      [1] "MDQ6VXNlcjEzOTM2NjAw"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[43]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[43]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[43]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[43]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[44]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[44]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[44]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[44]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[44]]$node$committer$user$login
      [1] "azimov"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[44]]$node$committer$user$id
      [1] "MDQ6VXNlcjE4MDY1OQ=="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[45]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[45]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[45]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[45]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[46]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[46]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[46]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[46]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[46]]$node$committer$user$login
      [1] "azimov"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[46]]$node$committer$user$id
      [1] "MDQ6VXNlcjE4MDY1OQ=="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[47]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[47]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[47]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[47]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[47]]$node$committer$user$login
      [1] "azimov"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[47]]$node$committer$user$id
      [1] "MDQ6VXNlcjE4MDY1OQ=="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[48]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[48]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[48]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[48]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[48]]$node$committer$user$login
      [1] "azimov"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[48]]$node$committer$user$id
      [1] "MDQ6VXNlcjE4MDY1OQ=="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[49]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[49]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[49]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[49]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[49]]$node$committer$user$login
      [1] "azimov"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[49]]$node$committer$user$id
      [1] "MDQ6VXNlcjE4MDY1OQ=="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[50]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[50]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[50]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[50]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[50]]$node$committer$user$login
      [1] "azimov"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[50]]$node$committer$user$id
      [1] "MDQ6VXNlcjE4MDY1OQ=="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[51]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[51]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[51]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[51]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[51]]$node$committer$user$login
      [1] "azimov"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[51]]$node$committer$user$id
      [1] "MDQ6VXNlcjE4MDY1OQ=="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[52]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[52]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[52]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[52]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[52]]$node$committer$user$login
      [1] "azimov"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[52]]$node$committer$user$id
      [1] "MDQ6VXNlcjE4MDY1OQ=="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[53]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[53]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[53]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[53]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[53]]$node$committer$user$login
      [1] "azimov"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[53]]$node$committer$user$id
      [1] "MDQ6VXNlcjE4MDY1OQ=="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[54]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[54]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[54]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[54]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[54]]$node$committer$user$login
      [1] "azimov"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[54]]$node$committer$user$id
      [1] "MDQ6VXNlcjE4MDY1OQ=="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[55]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[55]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[55]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[55]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[55]]$node$committer$user$login
      [1] "azimov"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[55]]$node$committer$user$id
      [1] "MDQ6VXNlcjE4MDY1OQ=="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[56]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[56]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[56]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[56]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[56]]$node$committer$user$login
      [1] "azimov"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[56]]$node$committer$user$id
      [1] "MDQ6VXNlcjE4MDY1OQ=="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[57]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[57]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[57]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[57]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[57]]$node$committer$user$login
      [1] "azimov"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[57]]$node$committer$user$id
      [1] "MDQ6VXNlcjE4MDY1OQ=="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[58]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[58]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[58]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[58]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[58]]$node$committer$user$login
      [1] "azimov"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[58]]$node$committer$user$id
      [1] "MDQ6VXNlcjE4MDY1OQ=="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[59]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[59]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[59]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[59]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[59]]$node$committer$user$login
      [1] "azimov"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[59]]$node$committer$user$id
      [1] "MDQ6VXNlcjE4MDY1OQ=="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[60]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[60]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[60]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[60]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[60]]$node$committer$user$login
      [1] "azimov"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[60]]$node$committer$user$id
      [1] "MDQ6VXNlcjE4MDY1OQ=="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[61]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[61]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[61]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[61]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[61]]$node$committer$user$login
      [1] "gowthamrao"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[61]]$node$committer$user$id
      [1] "MDQ6VXNlcjEzOTM2NjAw"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[62]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[62]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[62]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[62]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[62]]$node$committer$user$login
      [1] "gowthamrao"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[62]]$node$committer$user$id
      [1] "MDQ6VXNlcjEzOTM2NjAw"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[63]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[63]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[63]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[63]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[63]]$node$committer$user$login
      [1] "azimov"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[63]]$node$committer$user$id
      [1] "MDQ6VXNlcjE4MDY1OQ=="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[64]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[64]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[64]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[64]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[64]]$node$committer$user$login
      [1] "gowthamrao"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[64]]$node$committer$user$id
      [1] "MDQ6VXNlcjEzOTM2NjAw"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[65]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[65]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[65]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[65]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[65]]$node$committer$user$login
      [1] "gowthamrao"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[65]]$node$committer$user$id
      [1] "MDQ6VXNlcjEzOTM2NjAw"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[66]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[66]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[66]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[66]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[67]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[67]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[67]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[67]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[68]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[68]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[68]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[68]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[68]]$node$committer$user$login
      [1] "gowthamrao"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[68]]$node$committer$user$id
      [1] "MDQ6VXNlcjEzOTM2NjAw"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[69]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[69]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[69]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[69]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[69]]$node$committer$user$login
      [1] "azimov"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[69]]$node$committer$user$id
      [1] "MDQ6VXNlcjE4MDY1OQ=="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[70]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[70]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[70]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[70]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[70]]$node$committer$user$login
      [1] "azimov"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[70]]$node$committer$user$id
      [1] "MDQ6VXNlcjE4MDY1OQ=="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[71]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[71]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[71]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[71]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[71]]$node$committer$user$login
      [1] "azimov"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[71]]$node$committer$user$id
      [1] "MDQ6VXNlcjE4MDY1OQ=="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[72]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[72]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[72]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[72]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[72]]$node$committer$user$login
      [1] "azimov"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[72]]$node$committer$user$id
      [1] "MDQ6VXNlcjE4MDY1OQ=="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[73]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[73]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[73]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[73]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[73]]$node$committer$user$login
      [1] "azimov"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[73]]$node$committer$user$id
      [1] "MDQ6VXNlcjE4MDY1OQ=="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[74]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[74]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[74]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[74]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[74]]$node$committer$user$login
      [1] "gowthamrao"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[74]]$node$committer$user$id
      [1] "MDQ6VXNlcjEzOTM2NjAw"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[75]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[75]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[75]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[75]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[75]]$node$committer$user$login
      [1] "gowthamrao"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[75]]$node$committer$user$id
      [1] "MDQ6VXNlcjEzOTM2NjAw"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[76]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[76]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[76]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[76]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[76]]$node$committer$user$login
      [1] "gowthamrao"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[76]]$node$committer$user$id
      [1] "MDQ6VXNlcjEzOTM2NjAw"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[77]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[77]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[77]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[77]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[77]]$node$committer$user$login
      [1] "gowthamrao"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[77]]$node$committer$user$id
      [1] "MDQ6VXNlcjEzOTM2NjAw"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[78]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[78]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[78]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[78]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[79]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[79]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[79]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[79]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[79]]$node$committer$user$login
      [1] "ablack3"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[79]]$node$committer$user$id
      [1] "MDQ6VXNlcjEwMjI3NTIy"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[80]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[80]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[80]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[80]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[80]]$node$committer$user$login
      [1] "ablack3"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[80]]$node$committer$user$id
      [1] "MDQ6VXNlcjEwMjI3NTIy"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[81]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[81]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[81]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[81]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[81]]$node$committer$user$login
      [1] "gowthamrao"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[81]]$node$committer$user$id
      [1] "MDQ6VXNlcjEzOTM2NjAw"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[82]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[82]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[82]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[82]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[83]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[83]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[83]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[83]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[84]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[84]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[84]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[84]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[84]]$node$committer$user$login
      [1] "azimov"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[84]]$node$committer$user$id
      [1] "MDQ6VXNlcjE4MDY1OQ=="
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[85]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[85]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[85]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[85]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[85]]$node$committer$user$login
      [1] "gowthamrao"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[85]]$node$committer$user$id
      [1] "MDQ6VXNlcjEzOTM2NjAw"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[86]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[86]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[86]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[86]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[86]]$node$committer$user$login
      [1] "ablack3"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[86]]$node$committer$user$id
      [1] "MDQ6VXNlcjEwMjI3NTIy"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[87]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[87]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[87]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[87]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[88]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[88]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[88]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[88]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[89]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[89]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[89]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[89]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[89]]$node$committer$user$login
      [1] "gowthamrao"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[89]]$node$committer$user$id
      [1] "MDQ6VXNlcjEzOTM2NjAw"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[90]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[90]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[90]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[90]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[90]]$node$committer$user$login
      [1] "gowthamrao"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[90]]$node$committer$user$id
      [1] "MDQ6VXNlcjEzOTM2NjAw"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[91]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[91]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[91]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[91]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[91]]$node$committer$user$login
      [1] "ablack3"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[91]]$node$committer$user$id
      [1] "MDQ6VXNlcjEwMjI3NTIy"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[92]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[92]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[92]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[92]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[92]]$node$committer$user$login
      [1] "ablack3"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[92]]$node$committer$user$id
      [1] "MDQ6VXNlcjEwMjI3NTIy"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[93]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[93]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[93]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[93]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[93]]$node$committer$user$login
      [1] "ablack3"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[93]]$node$committer$user$id
      [1] "MDQ6VXNlcjEwMjI3NTIy"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[94]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[94]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[94]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[94]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[94]]$node$committer$user$login
      [1] "gowthamrao"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[94]]$node$committer$user$id
      [1] "MDQ6VXNlcjEzOTM2NjAw"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[95]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[95]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[95]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[95]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[95]]$node$committer$user$login
      [1] "ablack3"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[95]]$node$committer$user$id
      [1] "MDQ6VXNlcjEwMjI3NTIy"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[96]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[96]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[96]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[96]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[97]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[97]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[97]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[97]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[97]]$node$committer$user$login
      [1] "gowthamrao"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[97]]$node$committer$user$id
      [1] "MDQ6VXNlcjEzOTM2NjAw"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[98]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[98]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[98]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[98]]$node$committer$user
      NULL
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[99]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[99]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[99]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[99]]$node$committer$user
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[99]]$node$committer$user$login
      [1] "gowthamrao"
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[99]]$node$committer$user$id
      [1] "MDQ6VXNlcjEzOTM2NjAw"
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[100]]
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[100]]$node
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[100]]$node$committer
      $data$repositoryOwner$repositories$nodes[[7]]$contributors$target$history$edges[[100]]$node$committer$user
      NULL
      
      
      
      
      
      
      
      
      $data$repositoryOwner$repositories$nodes[[7]]$repo_url
      [1] "https://github.com/r-world-devs/ROhdsiWebApi"
      
      
      $data$repositoryOwner$repositories$nodes[[8]]
      $data$repositoryOwner$repositories$nodes[[8]]$id
      [1] "R_kgDOJWYrCA"
      
      $data$repositoryOwner$repositories$nodes[[8]]$name
      [1] "hypothesis"
      
      $data$repositoryOwner$repositories$nodes[[8]]$stars
      [1] 0
      
      $data$repositoryOwner$repositories$nodes[[8]]$forks
      [1] 0
      
      $data$repositoryOwner$repositories$nodes[[8]]$created_at
      [1] "2023-04-13T13:52:24Z"
      
      $data$repositoryOwner$repositories$nodes[[8]]$last_push
      [1] "2023-04-13T13:52:24Z"
      
      $data$repositoryOwner$repositories$nodes[[8]]$last_activity_at
      [1] "2023-04-13T13:52:24Z"
      
      $data$repositoryOwner$repositories$nodes[[8]]$languages
      $data$repositoryOwner$repositories$nodes[[8]]$languages$nodes
      list()
      
      
      $data$repositoryOwner$repositories$nodes[[8]]$issues_open
      $data$repositoryOwner$repositories$nodes[[8]]$issues_open$totalCount
      [1] 0
      
      
      $data$repositoryOwner$repositories$nodes[[8]]$issues_closed
      $data$repositoryOwner$repositories$nodes[[8]]$issues_closed$totalCount
      [1] 0
      
      
      $data$repositoryOwner$repositories$nodes[[8]]$contributors
      NULL
      
      $data$repositoryOwner$repositories$nodes[[8]]$repo_url
      [1] "https://github.com/r-world-devs/hypothesis"
      
      
      
      
      
      

