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
      [1] "C_kwDOIvtxstoAKGUyY2ZlNzQ0NTk1N2E2OTU1MzljOTAyM2M2YzljOTAwODFmMDhhY2Y"
      
      [[1]]$node$committed_date
      [1] "2023-02-27T10:46:57Z"
      
      [[1]]$node$author
      [[1]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[1]]$node$additions
      [1] 1
      
      [[1]]$node$deletions
      [1] 10
      
      
      
      [[2]]
      [[2]]$node
      [[2]]$node$id
      [1] "C_kwDOIvtxstoAKGVlZTZiZGQ4ZTEwODY3ZjU2ZWY4OWFiZDdkMzAwNzViMTc2ZDJiM2M"
      
      [[2]]$node$committed_date
      [1] "2023-02-27T10:14:37Z"
      
      [[2]]$node$author
      [[2]]$node$author$name
      [1] "maciekbanas"
      
      
      [[2]]$node$additions
      [1] 2
      
      [[2]]$node$deletions
      [1] 0
      
      
      
      [[3]]
      [[3]]$node
      [[3]]$node$id
      [1] "C_kwDOIvtxstoAKDYwOGVkOGEyZmViYWNmMzVkMzJmOWY3YzAzZWI0NzAzNzFjODlmZWM"
      
      [[3]]$node$committed_date
      [1] "2023-02-27T09:43:16Z"
      
      [[3]]$node$author
      [[3]]$node$author$name
      [1] "maciekbanas"
      
      
      [[3]]$node$additions
      [1] 0
      
      [[3]]$node$deletions
      [1] 2
      
      
      
      [[4]]
      [[4]]$node
      [[4]]$node$id
      [1] "C_kwDOIvtxstoAKDJiZjVjYWMwZDBiNjI5MjNkY2FhN2FjZGI4MjQ0Mzk4NjBlZWUzYWI"
      
      [[4]]$node$committed_date
      [1] "2023-02-24T13:25:14Z"
      
      [[4]]$node$author
      [[4]]$node$author$name
      [1] "maciekbanas"
      
      
      [[4]]$node$additions
      [1] 1
      
      [[4]]$node$deletions
      [1] 1
      
      
      
      [[5]]
      [[5]]$node
      [[5]]$node$id
      [1] "C_kwDOIvtxstoAKDllZjdiZGU1MmE4ZjMwZGM2OWU0OWIzZWExMzEyZGYxMDMyM2I1NzM"
      
      [[5]]$node$committed_date
      [1] "2023-02-24T13:16:10Z"
      
      [[5]]$node$author
      [[5]]$node$author$name
      [1] "maciekbanas"
      
      
      [[5]]$node$additions
      [1] 0
      
      [[5]]$node$deletions
      [1] 9
      
      
      
      [[6]]
      [[6]]$node
      [[6]]$node$id
      [1] "C_kwDOIvtxstoAKGRkYjA4OTJhN2I5YTQ2Mjk2ZDc5NWViMzA0ZmQxNTk1MmM5MjEyZTQ"
      
      [[6]]$node$committed_date
      [1] "2023-02-24T12:58:54Z"
      
      [[6]]$node$author
      [[6]]$node$author$name
      [1] "maciekbanas"
      
      
      [[6]]$node$additions
      [1] 2
      
      [[6]]$node$deletions
      [1] 0
      
      
      
      [[7]]
      [[7]]$node
      [[7]]$node$id
      [1] "C_kwDOIvtxstoAKDMwZDIwOTMzOTEyZTljZmE5MjQ4MDhhMzM0Y2Q3MDVmM2M2OWRhNzU"
      
      [[7]]$node$committed_date
      [1] "2023-02-24T11:04:03Z"
      
      [[7]]$node$author
      [[7]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[7]]$node$additions
      [1] 14
      
      [[7]]$node$deletions
      [1] 10
      
      
      
      [[8]]
      [[8]]$node
      [[8]]$node$id
      [1] "C_kwDOIvtxstoAKDdjMmM1YTU3YTI1MDIxOGY2MzM4Njg2OWFjM2E0MmEwNDkzYWViMzI"
      
      [[8]]$node$committed_date
      [1] "2023-02-24T10:37:42Z"
      
      [[8]]$node$author
      [[8]]$node$author$name
      [1] "maciekbanas"
      
      
      [[8]]$node$additions
      [1] 0
      
      [[8]]$node$deletions
      [1] 0
      
      
      
      [[9]]
      [[9]]$node
      [[9]]$node$id
      [1] "C_kwDOIvtxstoAKDU0MTc0ZjdlMzFhMjk1OThjMjc0ZmM1MjkyMWNjNWM0ODIyNmRmMWU"
      
      [[9]]$node$committed_date
      [1] "2023-02-24T10:24:27Z"
      
      [[9]]$node$author
      [[9]]$node$author$name
      [1] "maciekbanas"
      
      
      [[9]]$node$additions
      [1] 6
      
      [[9]]$node$deletions
      [1] 1
      
      
      
      [[10]]
      [[10]]$node
      [[10]]$node$id
      [1] "C_kwDOIvtxstoAKGU4NmRjZjNmM2IzZDgyMDg2YWE5MTMyOTY5NWY5NTM4NjY5ODhmN2Q"
      
      [[10]]$node$committed_date
      [1] "2023-02-24T09:30:17Z"
      
      [[10]]$node$author
      [[10]]$node$author$name
      [1] "maciekbanas"
      
      
      [[10]]$node$additions
      [1] 8
      
      [[10]]$node$deletions
      [1] 9
      
      
      
      [[11]]
      [[11]]$node
      [[11]]$node$id
      [1] "C_kwDOIvtxstoAKGJmNTRhNDNhZWY1NDhkNWE5ZTcwNDQ1ZTBhMGQ3NGE5MzhjNTZlMWU"
      
      [[11]]$node$committed_date
      [1] "2023-02-24T08:56:32Z"
      
      [[11]]$node$author
      [[11]]$node$author$name
      [1] "maciekbanas"
      
      
      [[11]]$node$additions
      [1] 2
      
      [[11]]$node$deletions
      [1] 0
      
      
      
      [[12]]
      [[12]]$node
      [[12]]$node$id
      [1] "C_kwDOIvtxstoAKDc4Mzc2NTk1OGY3YWMxZDFhNjU0M2Y5ZjA2MTEwOWI1NzA4NmY3NDU"
      
      [[12]]$node$committed_date
      [1] "2023-02-23T15:17:12Z"
      
      [[12]]$node$author
      [[12]]$node$author$name
      [1] "maciekbanas"
      
      
      [[12]]$node$additions
      [1] 60
      
      [[12]]$node$deletions
      [1] 2
      
      
      
      [[13]]
      [[13]]$node
      [[13]]$node$id
      [1] "C_kwDOIvtxstoAKDI2NDYxYzA5NzczNzM4NzhmMTE3NmI1MzhmZTM5ZjNkYmNhMDVjMmI"
      
      [[13]]$node$committed_date
      [1] "2023-02-21T15:19:10Z"
      
      [[13]]$node$author
      [[13]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[13]]$node$additions
      [1] 5334
      
      [[13]]$node$deletions
      [1] 2488
      
      
      
      [[14]]
      [[14]]$node
      [[14]]$node$id
      [1] "C_kwDOIvtxstoAKDhhNGE5MzMxMzA3NzU5M2RiNjEzY2I2NjAxMzNjMWI4NTM5YWQzMjk"
      
      [[14]]$node$committed_date
      [1] "2023-02-20T14:57:36Z"
      
      [[14]]$node$author
      [[14]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[14]]$node$additions
      [1] 56
      
      [[14]]$node$deletions
      [1] 17
      
      
      
      [[15]]
      [[15]]$node
      [[15]]$node$id
      [1] "C_kwDOIvtxstoAKGEzMjhlMjQwZDBlMWNhZmYxNzBlNDE3MjRkMmQ5N2RmNmRkOWJkMmE"
      
      [[15]]$node$committed_date
      [1] "2023-02-20T10:38:14Z"
      
      [[15]]$node$author
      [[15]]$node$author$name
      [1] "maciekbanas"
      
      
      [[15]]$node$additions
      [1] 39
      
      [[15]]$node$deletions
      [1] 1
      
      
      
      [[16]]
      [[16]]$node
      [[16]]$node$id
      [1] "C_kwDOIvtxstoAKGIyOWYyYjMzYzE1YjhkOWNiM2Y5ZjA1Mjg0MzllZjhhYzY3ZGIzOTQ"
      
      [[16]]$node$committed_date
      [1] "2023-02-20T08:55:54Z"
      
      [[16]]$node$author
      [[16]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[16]]$node$additions
      [1] 17
      
      [[16]]$node$deletions
      [1] 16
      
      
      
      [[17]]
      [[17]]$node
      [[17]]$node$id
      [1] "C_kwDOIvtxstoAKGNkMzJlNDRkYjY3ZTlhOTc4YjMzNTVmOTYzOTQxNTZlMGYyOWUwYmM"
      
      [[17]]$node$committed_date
      [1] "2023-02-20T08:54:45Z"
      
      [[17]]$node$author
      [[17]]$node$author$name
      [1] "maciekbanas"
      
      
      [[17]]$node$additions
      [1] 17
      
      [[17]]$node$deletions
      [1] 16
      
      
      
      [[18]]
      [[18]]$node
      [[18]]$node$id
      [1] "C_kwDOIvtxstoAKDk3OTE0NjQ5MjY4NGRhODRlNzkxODFiZDQ3N2Q4N2MzZjZiNDIyNjk"
      
      [[18]]$node$committed_date
      [1] "2023-02-17T09:19:20Z"
      
      [[18]]$node$author
      [[18]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[18]]$node$additions
      [1] 69
      
      [[18]]$node$deletions
      [1] 38
      
      
      
      [[19]]
      [[19]]$node
      [[19]]$node$id
      [1] "C_kwDOIvtxstoAKDcxOWU1NjQ0NDc5YjJkYjI1MGE3NDc0NDBiNzQ5NGRiZWFiYjI4YmM"
      
      [[19]]$node$committed_date
      [1] "2023-02-17T09:18:06Z"
      
      [[19]]$node$author
      [[19]]$node$author$name
      [1] "maciekbanas"
      
      
      [[19]]$node$additions
      [1] 69
      
      [[19]]$node$deletions
      [1] 38
      
      
      
      [[20]]
      [[20]]$node
      [[20]]$node$id
      [1] "C_kwDOIvtxstoAKDdlNzQ2Njg4MDNlZmFmYjM1MWNiZjhjZjA4OTQ2Njk2NmRkZWVhODI"
      
      [[20]]$node$committed_date
      [1] "2023-02-16T15:25:16Z"
      
      [[20]]$node$author
      [[20]]$node$author$name
      [1] "maciekbanas"
      
      
      [[20]]$node$additions
      [1] 10
      
      [[20]]$node$deletions
      [1] 9
      
      
      
      [[21]]
      [[21]]$node
      [[21]]$node$id
      [1] "C_kwDOIvtxstoAKGM5NzI5OTdkOWFkNTJiOTM1OGMyMTNlM2ZiMDU2M2RlOGI1MzU0M2E"
      
      [[21]]$node$committed_date
      [1] "2023-02-16T15:09:23Z"
      
      [[21]]$node$author
      [[21]]$node$author$name
      [1] "maciekbanas"
      
      
      [[21]]$node$additions
      [1] 12
      
      [[21]]$node$deletions
      [1] 0
      
      
      
      [[22]]
      [[22]]$node
      [[22]]$node$id
      [1] "C_kwDOIvtxstoAKGRmZDgyZjFhNjllNTdhMjAyYmQwZGE0Yjg2OTlmNTIwMDA5YTkxYjg"
      
      [[22]]$node$committed_date
      [1] "2023-02-16T13:52:25Z"
      
      [[22]]$node$author
      [[22]]$node$author$name
      [1] "maciekbanas"
      
      
      [[22]]$node$additions
      [1] 1
      
      [[22]]$node$deletions
      [1] 0
      
      
      
      [[23]]
      [[23]]$node
      [[23]]$node$id
      [1] "C_kwDOIvtxstoAKDUxNTMyN2FjZDk0YTQ5ZTk1ZGRkMjZiYzQxZmE0MTM5YWU4ZjcyYjc"
      
      [[23]]$node$committed_date
      [1] "2023-02-16T13:07:06Z"
      
      [[23]]$node$author
      [[23]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[23]]$node$additions
      [1] 182
      
      [[23]]$node$deletions
      [1] 45
      
      
      
      [[24]]
      [[24]]$node
      [[24]]$node$id
      [1] "C_kwDOIvtxstoAKDEwNWI4OTk3ZDRmM2ViMjBhNTAwNWUzN2FhMDJlM2E2NDI1ZmVlYjU"
      
      [[24]]$node$committed_date
      [1] "2023-02-16T13:02:10Z"
      
      [[24]]$node$author
      [[24]]$node$author$name
      [1] "maciekbanas"
      
      
      [[24]]$node$additions
      [1] 26
      
      [[24]]$node$deletions
      [1] 9
      
      
      
      [[25]]
      [[25]]$node
      [[25]]$node$id
      [1] "C_kwDOIvtxstoAKDM0YWIzMWQ3MTUwOTU1Mjk3YzU1MDQ2NjNkYWZjODU3MWE2MWYwOGQ"
      
      [[25]]$node$committed_date
      [1] "2023-02-16T12:12:45Z"
      
      [[25]]$node$author
      [[25]]$node$author$name
      [1] "maciekbanas"
      
      
      [[25]]$node$additions
      [1] 14
      
      [[25]]$node$deletions
      [1] 0
      
      
      
      [[26]]
      [[26]]$node
      [[26]]$node$id
      [1] "C_kwDOIvtxstoAKDEzZDUzMTcyOGFkNzgyMmViYTdlMzEyZDQyN2E0MjIzZjhiYWE3NGI"
      
      [[26]]$node$committed_date
      [1] "2023-02-16T12:07:26Z"
      
      [[26]]$node$author
      [[26]]$node$author$name
      [1] "maciekbanas"
      
      
      [[26]]$node$additions
      [1] 112
      
      [[26]]$node$deletions
      [1] 36
      
      
      
      [[27]]
      [[27]]$node
      [[27]]$node$id
      [1] "C_kwDOIvtxstoAKGVjYTE4YTJkNzhlZDJlODg2ODljYzQwMDFlYjVlYjA3OTAzYTJhNTY"
      
      [[27]]$node$committed_date
      [1] "2023-02-16T11:17:00Z"
      
      [[27]]$node$author
      [[27]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[27]]$node$additions
      [1] 673
      
      [[27]]$node$deletions
      [1] 521
      
      
      
      [[28]]
      [[28]]$node
      [[28]]$node$id
      [1] "C_kwDOIvtxstoAKGU3ZjhmODk5OGM3ZTU3N2ZkNTUxNjQ3NDVmYmE3ZTVhMjE4OTk5MjE"
      
      [[28]]$node$committed_date
      [1] "2023-02-16T09:37:11Z"
      
      [[28]]$node$author
      [[28]]$node$author$name
      [1] "maciekbanas"
      
      
      [[28]]$node$additions
      [1] 34
      
      [[28]]$node$deletions
      [1] 4
      
      
      
      [[29]]
      [[29]]$node
      [[29]]$node$id
      [1] "C_kwDOIvtxstoAKGU1MWUyMWQ0M2I0ZGIxMWRhM2U1MDQ5OTYxOGY2NTlmNzYwZTc4YTY"
      
      [[29]]$node$committed_date
      [1] "2023-02-10T14:51:00Z"
      
      [[29]]$node$author
      [[29]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[29]]$node$additions
      [1] 673
      
      [[29]]$node$deletions
      [1] 521
      
      
      
      [[30]]
      [[30]]$node
      [[30]]$node$id
      [1] "C_kwDOIvtxstoAKDI0NjMyZTQ3MWE1ZGJhMjNkNmVkYzFkNTUyMzNiN2VmZWFjNDhhZmY"
      
      [[30]]$node$committed_date
      [1] "2023-02-10T14:27:55Z"
      
      [[30]]$node$author
      [[30]]$node$author$name
      [1] "maciekbanas"
      
      
      [[30]]$node$additions
      [1] 111
      
      [[30]]$node$deletions
      [1] 177
      
      
      
      [[31]]
      [[31]]$node
      [[31]]$node$id
      [1] "C_kwDOIvtxstoAKDA0MTk1NTkzYmMxMjkzMzFhNWI0NDA1OGU1Yjc2MGJkN2M0NzU2NjE"
      
      [[31]]$node$committed_date
      [1] "2023-02-10T14:02:41Z"
      
      [[31]]$node$author
      [[31]]$node$author$name
      [1] "maciekbanas"
      
      
      [[31]]$node$additions
      [1] 76
      
      [[31]]$node$deletions
      [1] 27
      
      
      
      [[32]]
      [[32]]$node
      [[32]]$node$id
      [1] "C_kwDOIvtxstoAKGNkZTQ4ZmZlMmZkNDU2ZWYwNjc2ZjE2NGMzZDhkMmM1NjI4Zjk5N2Q"
      
      [[32]]$node$committed_date
      [1] "2023-02-10T12:49:45Z"
      
      [[32]]$node$author
      [[32]]$node$author$name
      [1] "maciekbanas"
      
      
      [[32]]$node$additions
      [1] 42
      
      [[32]]$node$deletions
      [1] 0
      
      
      
      [[33]]
      [[33]]$node
      [[33]]$node$id
      [1] "C_kwDOIvtxstoAKDE3NWViMGM1NWIwZTY2ZTM4M2MyODg4OGZiMTIxYWMwYzBmNzJhZDg"
      
      [[33]]$node$committed_date
      [1] "2023-02-10T12:49:17Z"
      
      [[33]]$node$author
      [[33]]$node$author$name
      [1] "maciekbanas"
      
      
      [[33]]$node$additions
      [1] 88
      
      [[33]]$node$deletions
      [1] 0
      
      
      
      [[34]]
      [[34]]$node
      [[34]]$node$id
      [1] "C_kwDOIvtxstoAKDFhNzg1OGQwNTM0NDZmNmNkODZhMzRlODA0OGEyNzk0ODE1YzY5NDU"
      
      [[34]]$node$committed_date
      [1] "2023-02-10T12:48:51Z"
      
      [[34]]$node$author
      [[34]]$node$author$name
      [1] "maciekbanas"
      
      
      [[34]]$node$additions
      [1] 3
      
      [[34]]$node$deletions
      [1] 90
      
      
      
      [[35]]
      [[35]]$node
      [[35]]$node$id
      [1] "C_kwDOIvtxstoAKDMzYjBiM2U4ZTQxZWExZmU0NmZjYzQ3ZmQ1ZjA4ZGFlNTUzNWE1NzI"
      
      [[35]]$node$committed_date
      [1] "2023-02-10T11:55:50Z"
      
      [[35]]$node$author
      [[35]]$node$author$name
      [1] "maciekbanas"
      
      
      [[35]]$node$additions
      [1] 383
      
      [[35]]$node$deletions
      [1] 257
      
      
      
      [[36]]
      [[36]]$node
      [[36]]$node$id
      [1] "C_kwDOIvtxstoAKDBiOTAwMTYxNzJhMWMyYmRjOWM0ZjBhMTI3NDJkYzU2MzlkMGRjOTg"
      
      [[36]]$node$committed_date
      [1] "2023-02-08T09:22:27Z"
      
      [[36]]$node$author
      [[36]]$node$author$name
      [1] "maciekbanas"
      
      
      [[36]]$node$additions
      [1] 15
      
      [[36]]$node$deletions
      [1] 51
      
      
      
      [[37]]
      [[37]]$node
      [[37]]$node$id
      [1] "C_kwDOIvtxstoAKDdhNTE3OTA2ZmJkYzAxYzMzZDEzNzA4YTJjNGJmZTc5ZTJmNjJjYmQ"
      
      [[37]]$node$committed_date
      [1] "2023-02-08T09:17:57Z"
      
      [[37]]$node$author
      [[37]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[37]]$node$additions
      [1] 60
      
      [[37]]$node$deletions
      [1] 45
      
      
      
      [[38]]
      [[38]]$node
      [[38]]$node$id
      [1] "C_kwDOIvtxstoAKDc2MWJlMjU5OTBkMzBkMzE2MjNiNzY1YTgxNGMyZmEyYWNlZWRlNmQ"
      
      [[38]]$node$committed_date
      [1] "2023-02-08T09:14:56Z"
      
      [[38]]$node$author
      [[38]]$node$author$name
      [1] "maciekbanas"
      
      
      [[38]]$node$additions
      [1] 60
      
      [[38]]$node$deletions
      [1] 45
      
      
      
      [[39]]
      [[39]]$node
      [[39]]$node$id
      [1] "C_kwDOIvtxstoAKGQ0OThkMGE3YWY4NGFjM2MxMzgyZTQ4OTIyNDkzOGZkNTYxY2ExOWU"
      
      [[39]]$node$committed_date
      [1] "2023-02-07T13:54:01Z"
      
      [[39]]$node$author
      [[39]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[39]]$node$additions
      [1] 1766
      
      [[39]]$node$deletions
      [1] 578
      
      
      
      [[40]]
      [[40]]$node
      [[40]]$node$id
      [1] "C_kwDOIvtxstoAKDljYTI1M2EyNjFjZDQ4ZWUwMDRkOTkzODc2OWVkNjg1ZWNiY2JhODE"
      
      [[40]]$node$committed_date
      [1] "2023-02-07T13:53:46Z"
      
      [[40]]$node$author
      [[40]]$node$author$name
      [1] "maciekbanas"
      
      
      [[40]]$node$additions
      [1] 1
      
      [[40]]$node$deletions
      [1] 1
      
      
      
      [[41]]
      [[41]]$node
      [[41]]$node$id
      [1] "C_kwDOIvtxstoAKDJmMDMyMWI1Y2IyMzlkNWQ1YzgzNmRkNmQ2OTVmZDFjYjFmYmMyZjE"
      
      [[41]]$node$committed_date
      [1] "2023-02-07T13:15:59Z"
      
      [[41]]$node$author
      [[41]]$node$author$name
      [1] "maciekbanas"
      
      
      [[41]]$node$additions
      [1] 358
      
      [[41]]$node$deletions
      [1] 338
      
      
      
      [[42]]
      [[42]]$node
      [[42]]$node$id
      [1] "C_kwDOIvtxstoAKGZiNTQ3OTZiOWRmODc3OWRkZTJjNzAzZDQwYjBlOWVhN2Q2NjA5NGI"
      
      [[42]]$node$committed_date
      [1] "2023-02-07T13:06:23Z"
      
      [[42]]$node$author
      [[42]]$node$author$name
      [1] "maciekbanas"
      
      
      [[42]]$node$additions
      [1] 5
      
      [[42]]$node$deletions
      [1] 0
      
      
      
      [[43]]
      [[43]]$node
      [[43]]$node$id
      [1] "C_kwDOIvtxstoAKDJkOTE1YTE4N2JlYTc0MGRiMzNlZTJlMDhjMzcwNDJlZTE4ZGUwMzQ"
      
      [[43]]$node$committed_date
      [1] "2023-02-07T12:36:00Z"
      
      [[43]]$node$author
      [[43]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[43]]$node$additions
      [1] 517
      
      [[43]]$node$deletions
      [1] 287
      
      
      
      [[44]]
      [[44]]$node
      [[44]]$node$id
      [1] "C_kwDOIvtxstoAKDQ1YjY0YWM1OGQ0NGE3ZjIyMjZkZDlkMTU2NmJhOTZjY2Q4OWEzYjM"
      
      [[44]]$node$committed_date
      [1] "2023-02-07T12:16:25Z"
      
      [[44]]$node$author
      [[44]]$node$author$name
      [1] "maciekbanas"
      
      
      [[44]]$node$additions
      [1] 2
      
      [[44]]$node$deletions
      [1] 0
      
      
      
      [[45]]
      [[45]]$node
      [[45]]$node$id
      [1] "C_kwDOIvtxstoAKGFiY2M3MzQzZDcyNWNjNTI2ZDNjOGQ0MTdlM2YzMGY0NzkzM2QyMTk"
      
      [[45]]$node$committed_date
      [1] "2023-02-07T11:03:01Z"
      
      [[45]]$node$author
      [[45]]$node$author$name
      [1] "maciekbanas"
      
      
      [[45]]$node$additions
      [1] 0
      
      [[45]]$node$deletions
      [1] 0
      
      
      
      [[46]]
      [[46]]$node
      [[46]]$node$id
      [1] "C_kwDOIvtxstoAKGVhMWU1MTYxYTgyY2VkNzNkOTY5NmU4Y2MwOWY0MTczZDkwYTUxNzI"
      
      [[46]]$node$committed_date
      [1] "2023-02-07T10:56:56Z"
      
      [[46]]$node$author
      [[46]]$node$author$name
      [1] "maciekbanas"
      
      
      [[46]]$node$additions
      [1] 77
      
      [[46]]$node$deletions
      [1] 27
      
      
      
      [[47]]
      [[47]]$node
      [[47]]$node$id
      [1] "C_kwDOIvtxstoAKDBmNWZlYzQ4OGMyYTkwNGRlYTNlMGRkODEwYjZkOGI4N2ZiOGM4YmI"
      
      [[47]]$node$committed_date
      [1] "2023-02-07T10:08:50Z"
      
      [[47]]$node$author
      [[47]]$node$author$name
      [1] "maciekbanas"
      
      
      [[47]]$node$additions
      [1] 108
      
      [[47]]$node$deletions
      [1] 29
      
      
      
      [[48]]
      [[48]]$node
      [[48]]$node$id
      [1] "C_kwDOIvtxstoAKDNkMzYxM2RmNjc0M2JiZGVmMmEwNGM2Y2UxYTYwOWU4YzJkODFkOTU"
      
      [[48]]$node$committed_date
      [1] "2023-02-07T09:14:17Z"
      
      [[48]]$node$author
      [[48]]$node$author$name
      [1] "maciekbanas"
      
      
      [[48]]$node$additions
      [1] 94
      
      [[48]]$node$deletions
      [1] 29
      
      
      
      [[49]]
      [[49]]$node
      [[49]]$node$id
      [1] "C_kwDOIvtxstoAKGIwYmJkMmRhODg1OTlmZmJmYmQ5MjYwZGIxZTBmZTNlNzM2NTVlYzk"
      
      [[49]]$node$committed_date
      [1] "2023-02-06T12:42:07Z"
      
      [[49]]$node$author
      [[49]]$node$author$name
      [1] "maciekbanas"
      
      
      [[49]]$node$additions
      [1] 4
      
      [[49]]$node$deletions
      [1] 4
      
      
      
      [[50]]
      [[50]]$node
      [[50]]$node$id
      [1] "C_kwDOIvtxstoAKDNjMmNjZGQ0MGUwODk4YzBjNDA1NTczMmUxMGZiNzhkNzQ5ZWUyMjI"
      
      [[50]]$node$committed_date
      [1] "2023-02-06T12:04:09Z"
      
      [[50]]$node$author
      [[50]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[50]]$node$additions
      [1] 59
      
      [[50]]$node$deletions
      [1] 84
      
      
      
      [[51]]
      [[51]]$node
      [[51]]$node$id
      [1] "C_kwDOIvtxstoAKGUwNGI2NmE5YmYwNDM0ZWFmM2JhMjY2MDVjNjgyNDhlNDVmOTAyZjI"
      
      [[51]]$node$committed_date
      [1] "2023-02-06T11:55:50Z"
      
      [[51]]$node$author
      [[51]]$node$author$name
      [1] "maciekbanas"
      
      
      [[51]]$node$additions
      [1] 16
      
      [[51]]$node$deletions
      [1] 10
      
      
      
      [[52]]
      [[52]]$node
      [[52]]$node$id
      [1] "C_kwDOIvtxstoAKDZmMTEzODY1NTAxZmVlZmVkYzJiNjUyOTUwZDU0YTMzNGM4ZjFmYTY"
      
      [[52]]$node$committed_date
      [1] "2023-02-06T11:54:26Z"
      
      [[52]]$node$author
      [[52]]$node$author$name
      [1] "maciekbanas"
      
      
      [[52]]$node$additions
      [1] 43
      
      [[52]]$node$deletions
      [1] 74
      
      
      
      [[53]]
      [[53]]$node
      [[53]]$node$id
      [1] "C_kwDOIvtxstoAKDAzZGQzMDU5MzdiZjhjMjZhM2FkODk2YTE5OWEzMzMxZjMyMjdjYzA"
      
      [[53]]$node$committed_date
      [1] "2023-02-06T10:52:24Z"
      
      [[53]]$node$author
      [[53]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[53]]$node$additions
      [1] 78
      
      [[53]]$node$deletions
      [1] 19
      
      
      
      [[54]]
      [[54]]$node
      [[54]]$node$id
      [1] "C_kwDOIvtxstoAKDI2ZTVjMjM4NWQ5OWY0MDIyZTBkYWE1OTQ1OTk1NjViN2ZiZjRiMTE"
      
      [[54]]$node$committed_date
      [1] "2023-02-06T10:51:19Z"
      
      [[54]]$node$author
      [[54]]$node$author$name
      [1] "maciekbanas"
      
      
      [[54]]$node$additions
      [1] 34
      
      [[54]]$node$deletions
      [1] 6
      
      
      
      [[55]]
      [[55]]$node
      [[55]]$node$id
      [1] "C_kwDOIvtxstoAKGY1ZGZmODU1NjFjYzEyYjcyYmVkOWJlOTVkZjdjMzI0NmMzMWQxYjg"
      
      [[55]]$node$committed_date
      [1] "2023-02-06T10:36:39Z"
      
      [[55]]$node$author
      [[55]]$node$author$name
      [1] "maciekbanas"
      
      
      [[55]]$node$additions
      [1] 46
      
      [[55]]$node$deletions
      [1] 15
      
      
      
      [[56]]
      [[56]]$node
      [[56]]$node$id
      [1] "C_kwDOIvtxstoAKDA5OGJjMTQzMWQyNTEyMTU1MzAzN2Q5NWIwMWI2ZTA1MjM4ZTI1YjM"
      
      [[56]]$node$committed_date
      [1] "2023-02-06T10:13:17Z"
      
      [[56]]$node$author
      [[56]]$node$author$name
      [1] "maciekbanas"
      
      
      [[56]]$node$additions
      [1] 1
      
      [[56]]$node$deletions
      [1] 1
      
      
      
      [[57]]
      [[57]]$node
      [[57]]$node$id
      [1] "C_kwDOIvtxstoAKDRmODgwYmI0NzRhZDliMjFiNjgwOWYxYWFlMGY0MWUyZjI2NTM1YzI"
      
      [[57]]$node$committed_date
      [1] "2023-02-06T09:24:23Z"
      
      [[57]]$node$author
      [[57]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[57]]$node$additions
      [1] 80
      
      [[57]]$node$deletions
      [1] 80
      
      
      
      [[58]]
      [[58]]$node
      [[58]]$node$id
      [1] "C_kwDOIvtxstoAKGY2YTk4YjNhNDE1NjA1Mjc5MmI5ODNjMjI3MDEzMmE1NTAyNTZlMDY"
      
      [[58]]$node$committed_date
      [1] "2023-02-06T09:23:23Z"
      
      [[58]]$node$author
      [[58]]$node$author$name
      [1] "maciekbanas"
      
      
      [[58]]$node$additions
      [1] 80
      
      [[58]]$node$deletions
      [1] 80
      
      
      
      [[59]]
      [[59]]$node
      [[59]]$node$id
      [1] "C_kwDOIvtxstoAKGZhNWVjM2QyNjI0OTQwM2NhZDMwZjVkNzFmZDdhMjIxYjJkOTQ2ZWM"
      
      [[59]]$node$committed_date
      [1] "2023-02-03T14:50:33Z"
      
      [[59]]$node$author
      [[59]]$node$author$name
      [1] "maciekbanas"
      
      
      [[59]]$node$additions
      [1] 82
      
      [[59]]$node$deletions
      [1] 82
      
      
      
      [[60]]
      [[60]]$node
      [[60]]$node$id
      [1] "C_kwDOIvtxstoAKGYyZmE0Zjk3MzY3MDJkMjQwYmQ2NGRmNWIzNDliMmM2N2JjMmUxZmY"
      
      [[60]]$node$committed_date
      [1] "2023-02-03T11:43:44Z"
      
      [[60]]$node$author
      [[60]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[60]]$node$additions
      [1] 101
      
      [[60]]$node$deletions
      [1] 38
      
      
      
      [[61]]
      [[61]]$node
      [[61]]$node$id
      [1] "C_kwDOIvtxstoAKDcwMTEzMmU4MTc4OGZjZjkzNjdlMGQyYWZkZmExZjAyMTdjMTY0MTg"
      
      [[61]]$node$committed_date
      [1] "2023-02-03T11:35:18Z"
      
      [[61]]$node$author
      [[61]]$node$author$name
      [1] "maciekbanas"
      
      
      [[61]]$node$additions
      [1] 101
      
      [[61]]$node$deletions
      [1] 38
      
      
      
      [[62]]
      [[62]]$node
      [[62]]$node$id
      [1] "C_kwDOIvtxstoAKGQyYTJlMzhkN2FlYzI4N2Y2ZjljNGRiNmIyMmE4MzRjNTg1YmRiYzk"
      
      [[62]]$node$committed_date
      [1] "2023-02-03T08:46:41Z"
      
      [[62]]$node$author
      [[62]]$node$author$name
      [1] "maciekbanas"
      
      
      [[62]]$node$additions
      [1] 20
      
      [[62]]$node$deletions
      [1] 9
      
      
      
      [[63]]
      [[63]]$node
      [[63]]$node$id
      [1] "C_kwDOIvtxstoAKDZlMjNhYWYzNDEwNDI2Y2FmY2Y2YmQ2MTI1ZjkyYmEzOWVkYTZmMTU"
      
      [[63]]$node$committed_date
      [1] "2023-02-02T15:14:43Z"
      
      [[63]]$node$author
      [[63]]$node$author$name
      [1] "maciekbanas"
      
      
      [[63]]$node$additions
      [1] 65
      
      [[63]]$node$deletions
      [1] 17
      
      
      
      [[64]]
      [[64]]$node
      [[64]]$node$id
      [1] "C_kwDOIvtxstoAKDM5NTRhMDczMDRiOWNkYjZjODFkM2I0N2I5MWZhY2Q4ZmE5YzgxNzg"
      
      [[64]]$node$committed_date
      [1] "2023-02-02T13:34:38Z"
      
      [[64]]$node$author
      [[64]]$node$author$name
      [1] "maciekbanas"
      
      
      [[64]]$node$additions
      [1] 18
      
      [[64]]$node$deletions
      [1] 10
      
      
      
      [[65]]
      [[65]]$node
      [[65]]$node$id
      [1] "C_kwDOIvtxstoAKDhhODUzNzNlNGY0Njk3M2JjODFjYmU4MGRmODllMmEzYjRmMjZiZTU"
      
      [[65]]$node$committed_date
      [1] "2023-02-02T13:31:26Z"
      
      [[65]]$node$author
      [[65]]$node$author$name
      [1] "maciekbanas"
      
      
      [[65]]$node$additions
      [1] 214
      
      [[65]]$node$deletions
      [1] 104
      
      
      
      [[66]]
      [[66]]$node
      [[66]]$node$id
      [1] "C_kwDOIvtxstoAKGM4ODJkOGM0ZDY5ZDUzZjk5ZWZkMDA1OTZmNWYxZDJmODAyMjE4YmE"
      
      [[66]]$node$committed_date
      [1] "2023-02-01T12:46:43Z"
      
      [[66]]$node$author
      [[66]]$node$author$name
      [1] "maciekbanas"
      
      
      [[66]]$node$additions
      [1] 3
      
      [[66]]$node$deletions
      [1] 1
      
      
      
      [[67]]
      [[67]]$node
      [[67]]$node$id
      [1] "C_kwDOIvtxstoAKDgzNDRjOGZmYmM5YzRkZjkzODhmMzlkZWVjNzRlMzYyY2RiMjFjY2Q"
      
      [[67]]$node$committed_date
      [1] "2023-02-01T12:44:49Z"
      
      [[67]]$node$author
      [[67]]$node$author$name
      [1] "maciekbanas"
      
      
      [[67]]$node$additions
      [1] 88
      
      [[67]]$node$deletions
      [1] 0
      
      
      
      [[68]]
      [[68]]$node
      [[68]]$node$id
      [1] "C_kwDOIvtxstoAKGIwNTg5ZWIzOGE1OTA2MTBmMTI0MzRjNTRhMTNhYjczNGY5YmNhOGM"
      
      [[68]]$node$committed_date
      [1] "2023-01-31T14:11:27Z"
      
      [[68]]$node$author
      [[68]]$node$author$name
      [1] "maciekbanas"
      
      
      [[68]]$node$additions
      [1] 139
      
      [[68]]$node$deletions
      [1] 11
      
      
      
      [[69]]
      [[69]]$node
      [[69]]$node$id
      [1] "C_kwDOIvtxstoAKGYwMjVlMTRjZWJjMmE3MDEwNGRjZjMzNDA3YWIyZWMyNGUzYjAxMDM"
      
      [[69]]$node$committed_date
      [1] "2023-01-31T12:59:28Z"
      
      [[69]]$node$author
      [[69]]$node$author$name
      [1] "maciekbanas"
      
      
      [[69]]$node$additions
      [1] 65
      
      [[69]]$node$deletions
      [1] 10
      
      
      
      [[70]]
      [[70]]$node
      [[70]]$node$id
      [1] "C_kwDOIvtxstoAKDJkM2JiN2M5ZDE1OWUwZTA3MDZiMTk1NWM0NTE1MzQxOWVkNzM2YjU"
      
      [[70]]$node$committed_date
      [1] "2023-01-31T11:22:09Z"
      
      [[70]]$node$author
      [[70]]$node$author$name
      [1] "maciekbanas"
      
      
      [[70]]$node$additions
      [1] 20
      
      [[70]]$node$deletions
      [1] 6
      
      
      
      [[71]]
      [[71]]$node
      [[71]]$node$id
      [1] "C_kwDOIvtxstoAKDQ0NzRkZWI0ZjVkMTU2OTE3ZWJlODcyYjMwNjMwZmZlMWJhOTNkYWM"
      
      [[71]]$node$committed_date
      [1] "2023-01-31T10:28:24Z"
      
      [[71]]$node$author
      [[71]]$node$author$name
      [1] "maciekbanas"
      
      
      [[71]]$node$additions
      [1] 0
      
      [[71]]$node$deletions
      [1] 12
      
      
      
      [[72]]
      [[72]]$node
      [[72]]$node$id
      [1] "C_kwDOIvtxstoAKDBhNmIxMWM4YjAxZGI5OWYxNzRiMTdjZmY5NGU4MTVlMTAyMGEyYjk"
      
      [[72]]$node$committed_date
      [1] "2023-01-31T10:28:07Z"
      
      [[72]]$node$author
      [[72]]$node$author$name
      [1] "maciekbanas"
      
      
      [[72]]$node$additions
      [1] 164
      
      [[72]]$node$deletions
      [1] 5
      
      
      
      [[73]]
      [[73]]$node
      [[73]]$node$id
      [1] "C_kwDOIvtxstoAKDZkNGIyYTAyMTc1ODJjODhlNWE1ZDEzNmE0ZmM2NzQ4YzY4YzM0ODg"
      
      [[73]]$node$committed_date
      [1] "2023-01-31T09:50:57Z"
      
      [[73]]$node$author
      [[73]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[73]]$node$additions
      [1] 0
      
      [[73]]$node$deletions
      [1] 12
      
      
      
      [[74]]
      [[74]]$node
      [[74]]$node$id
      [1] "C_kwDOIvtxstoAKDg0OTEwYWQ5OWJiNDM1ZjMxYThmMTYzYjFkN2YyZmE5NGMyNmM4MTM"
      
      [[74]]$node$committed_date
      [1] "2023-01-30T14:54:21Z"
      
      [[74]]$node$author
      [[74]]$node$author$name
      [1] "maciekbanas"
      
      
      [[74]]$node$additions
      [1] 336
      
      [[74]]$node$deletions
      [1] 89
      
      
      
      [[75]]
      [[75]]$node
      [[75]]$node$id
      [1] "C_kwDOIvtxstoAKDJhNDM2ZGY2ZGVmZGJhNzhhMDAwNWQzNzE5MTM1YmVkZjg5MzQyOTc"
      
      [[75]]$node$committed_date
      [1] "2023-01-30T12:07:15Z"
      
      [[75]]$node$author
      [[75]]$node$author$name
      [1] "maciekbanas"
      
      
      [[75]]$node$additions
      [1] 4
      
      [[75]]$node$deletions
      [1] 3
      
      
      
      [[76]]
      [[76]]$node
      [[76]]$node$id
      [1] "C_kwDOIvtxstoAKDVmMTkxZDU3NjA3YzMzMjgzMTk0MWFkNDIzOTI0NDMzY2NhNGZjNzc"
      
      [[76]]$node$committed_date
      [1] "2023-01-30T11:16:29Z"
      
      [[76]]$node$author
      [[76]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[76]]$node$additions
      [1] 687
      
      [[76]]$node$deletions
      [1] 185
      
      
      
      [[77]]
      [[77]]$node
      [[77]]$node$id
      [1] "C_kwDOIvtxstoAKDllODIyNDVlMDlkMWJmZDljZDhlMDg4NmIwMjJjZGY5M2JiNzZkNWM"
      
      [[77]]$node$committed_date
      [1] "2023-01-30T10:45:33Z"
      
      [[77]]$node$author
      [[77]]$node$author$name
      [1] "maciekbanas"
      
      
      [[77]]$node$additions
      [1] 141
      
      [[77]]$node$deletions
      [1] 96
      
      
      
      [[78]]
      [[78]]$node
      [[78]]$node$id
      [1] "C_kwDOIvtxstoAKGEyMzQ3ZTAzMjJjMzI5OTY4ODJhYmRmZDM3YTYyNzBjYWIyNjc3Y2I"
      
      [[78]]$node$committed_date
      [1] "2023-01-30T09:37:24Z"
      
      [[78]]$node$author
      [[78]]$node$author$name
      [1] "maciekbanas"
      
      
      [[78]]$node$additions
      [1] 546
      
      [[78]]$node$deletions
      [1] 89
      
      
      
      [[79]]
      [[79]]$node
      [[79]]$node$id
      [1] "C_kwDOIvtxstoAKGRlODc4ZDhmY2Y2MzhkZTY2MDZkMTkyMjg4NmJkZmNhNjYyN2Q5Y2E"
      
      [[79]]$node$committed_date
      [1] "2023-01-27T13:41:37Z"
      
      [[79]]$node$author
      [[79]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[79]]$node$additions
      [1] 285
      
      [[79]]$node$deletions
      [1] 81
      
      
      
      [[80]]
      [[80]]$node
      [[80]]$node$id
      [1] "C_kwDOIvtxstoAKDcwY2ExODJiMjlkN2NhOTcwNjRlMDA5YWY1ZmM1NjU0MGNlZTQyM2U"
      
      [[80]]$node$committed_date
      [1] "2023-01-27T13:40:00Z"
      
      [[80]]$node$author
      [[80]]$node$author$name
      [1] "maciekbanas"
      
      
      [[80]]$node$additions
      [1] 285
      
      [[80]]$node$deletions
      [1] 81
      
      
      
      [[81]]
      [[81]]$node
      [[81]]$node$id
      [1] "C_kwDOIvtxstoAKGE3MWNhMGUyMjUxMDk1ZTcwMzRmZTZjZGRkNTA3NTM5NWExYTZiZDI"
      
      [[81]]$node$committed_date
      [1] "2023-01-26T15:01:17Z"
      
      [[81]]$node$author
      [[81]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[81]]$node$additions
      [1] 522
      
      [[81]]$node$deletions
      [1] 43
      
      
      
      [[82]]
      [[82]]$node
      [[82]]$node$id
      [1] "C_kwDOIvtxstoAKDQyNDEyNWRiMTE5M2Q2MDJjYTM0ZTM4ZjhlZjZhOTZhNjhjYTczYmM"
      
      [[82]]$node$committed_date
      [1] "2023-01-26T12:03:04Z"
      
      [[82]]$node$author
      [[82]]$node$author$name
      [1] "maciekbanas"
      
      
      [[82]]$node$additions
      [1] 17
      
      [[82]]$node$deletions
      [1] 0
      
      
      
      [[83]]
      [[83]]$node
      [[83]]$node$id
      [1] "C_kwDOIvtxstoAKDhiMjQ2MjEzMGE2YWRkYTUzYjFiZDIwZmRkZGRhNjM3NmZiMmE4ZjQ"
      
      [[83]]$node$committed_date
      [1] "2023-01-26T11:37:52Z"
      
      [[83]]$node$author
      [[83]]$node$author$name
      [1] "maciekbanas"
      
      
      [[83]]$node$additions
      [1] 7
      
      [[83]]$node$deletions
      [1] 7
      
      
      
      [[84]]
      [[84]]$node
      [[84]]$node$id
      [1] "C_kwDOIvtxstoAKGJjY2EwZDJlYzdjMGE5ZTFmN2ExY2ZkZGYyZWNiNTYzMDNjZTRhNmI"
      
      [[84]]$node$committed_date
      [1] "2023-01-26T10:51:16Z"
      
      [[84]]$node$author
      [[84]]$node$author$name
      [1] "maciekbanas"
      
      
      [[84]]$node$additions
      [1] 38
      
      [[84]]$node$deletions
      [1] 29
      
      
      
      [[85]]
      [[85]]$node
      [[85]]$node$id
      [1] "C_kwDOIvtxstoAKDVjMjk2ZmZiMmRhNTI2MjJjZWZlOWE2NGNkOWM5NTdlODJkN2JmY2Q"
      
      [[85]]$node$committed_date
      [1] "2023-01-26T10:31:47Z"
      
      [[85]]$node$author
      [[85]]$node$author$name
      [1] "maciekbanas"
      
      
      [[85]]$node$additions
      [1] 270
      
      [[85]]$node$deletions
      [1] 8
      
      
      
      [[86]]
      [[86]]$node
      [[86]]$node$id
      [1] "C_kwDOIvtxstoAKDU2YjA2MmYzOTQwZmU5MTZiYTkwNjg4YjBmMDkzOTdmOTIxNGRjM2Y"
      
      [[86]]$node$committed_date
      [1] "2023-01-25T14:54:33Z"
      
      [[86]]$node$author
      [[86]]$node$author$name
      [1] "maciekbanas"
      
      
      [[86]]$node$additions
      [1] 28
      
      [[86]]$node$deletions
      [1] 5
      
      
      
      [[87]]
      [[87]]$node
      [[87]]$node$id
      [1] "C_kwDOIvtxstoAKDM0MTJkNzdkNWFkOTBlMjUxOGY5ZWRiNmFkNTQzNTUzZWQ0MGI4NjU"
      
      [[87]]$node$committed_date
      [1] "2023-01-25T14:40:59Z"
      
      [[87]]$node$author
      [[87]]$node$author$name
      [1] "maciekbanas"
      
      
      [[87]]$node$additions
      [1] 0
      
      [[87]]$node$deletions
      [1] 9
      
      
      
      [[88]]
      [[88]]$node
      [[88]]$node$id
      [1] "C_kwDOIvtxstoAKDA4Y2MwMGMyYzgxOWUzYjc4ZTZmNWQ2NmU5MzUxOGU1OTAzZDkwMjM"
      
      [[88]]$node$committed_date
      [1] "2023-01-25T14:37:07Z"
      
      [[88]]$node$author
      [[88]]$node$author$name
      [1] "maciekbanas"
      
      
      [[88]]$node$additions
      [1] 88
      
      [[88]]$node$deletions
      [1] 67
      
      
      
      [[89]]
      [[89]]$node
      [[89]]$node$id
      [1] "C_kwDOIvtxstoAKDMyM2M2MWEzOGUxMjMzN2FhNTFjMjBjNDYyNWI1NzA0ZWE4NzRjYjg"
      
      [[89]]$node$committed_date
      [1] "2023-01-25T14:23:43Z"
      
      [[89]]$node$author
      [[89]]$node$author$name
      [1] "maciekbanas"
      
      
      [[89]]$node$additions
      [1] 14
      
      [[89]]$node$deletions
      [1] 3
      
      
      
      [[90]]
      [[90]]$node
      [[90]]$node$id
      [1] "C_kwDOIvtxstoAKGZkZWQ2MTE1YmUwNmJhNDFlMzY5NGViNzMwMDk0YTNkMmQwMGI2YzI"
      
      [[90]]$node$committed_date
      [1] "2023-01-25T13:51:17Z"
      
      [[90]]$node$author
      [[90]]$node$author$name
      [1] "maciekbanas"
      
      
      [[90]]$node$additions
      [1] 47
      
      [[90]]$node$deletions
      [1] 94
      
      
      
      [[91]]
      [[91]]$node
      [[91]]$node$id
      [1] "C_kwDOIvtxstoAKDc2ODA5NzQxMWI0Yjg1ZWM5ZTNlZmExMGM3MWZmMGIzM2VkMzVhOTc"
      
      [[91]]$node$committed_date
      [1] "2023-01-25T13:09:15Z"
      
      [[91]]$node$author
      [[91]]$node$author$name
      [1] "maciekbanas"
      
      
      [[91]]$node$additions
      [1] 11
      
      [[91]]$node$deletions
      [1] 0
      
      
      
      [[92]]
      [[92]]$node
      [[92]]$node$id
      [1] "C_kwDOIvtxstoAKDBkMjFjOWMwYTEzM2NkNzJlOTIwOGE1MDhjZWZjMDJlNWVkNGUxZjM"
      
      [[92]]$node$committed_date
      [1] "2023-01-25T12:50:17Z"
      
      [[92]]$node$author
      [[92]]$node$author$name
      [1] "maciekbanas"
      
      
      [[92]]$node$additions
      [1] 24
      
      [[92]]$node$deletions
      [1] 15
      
      
      
      [[93]]
      [[93]]$node
      [[93]]$node$id
      [1] "C_kwDOIvtxstoAKGYyYTc0NDBhYmQwNDdmOTQyNWU5NWI1ODY1ZGRkNGYwZTQyMzZjNWQ"
      
      [[93]]$node$committed_date
      [1] "2023-01-25T12:19:15Z"
      
      [[93]]$node$author
      [[93]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[93]]$node$additions
      [1] 165
      
      [[93]]$node$deletions
      [1] 157
      
      
      
      [[94]]
      [[94]]$node
      [[94]]$node$id
      [1] "C_kwDOIvtxstoAKDFjM2VmOWRlNTI5OGI1ZjI4NTUwZDllMDMzOGQxNDMwMWI1Mjk4MDU"
      
      [[94]]$node$committed_date
      [1] "2023-01-25T11:55:46Z"
      
      [[94]]$node$author
      [[94]]$node$author$name
      [1] "maciekbanas"
      
      
      [[94]]$node$additions
      [1] 167
      
      [[94]]$node$deletions
      [1] 159
      
      
      
      [[95]]
      [[95]]$node
      [[95]]$node$id
      [1] "C_kwDOIvtxstoAKGUzMTNmZjJjZThkZjAyN2Q4NGQyYjY4N2JlNGM1MmMwMTFjNTA4Mzc"
      
      [[95]]$node$committed_date
      [1] "2023-01-25T11:46:06Z"
      
      [[95]]$node$author
      [[95]]$node$author$name
      [1] "maciekbanas"
      
      
      [[95]]$node$additions
      [1] 2
      
      [[95]]$node$deletions
      [1] 1
      
      
      
      [[96]]
      [[96]]$node
      [[96]]$node$id
      [1] "C_kwDOIvtxstoAKGI5MjQ1ZGQ4ZGNhNjcxMDQ5MzhiNDQ5YTE3OTYwN2VjYzg3Mzc2ODU"
      
      [[96]]$node$committed_date
      [1] "2023-01-25T11:28:26Z"
      
      [[96]]$node$author
      [[96]]$node$author$name
      [1] "maciekbanas"
      
      
      [[96]]$node$additions
      [1] 7
      
      [[96]]$node$deletions
      [1] 8
      
      
      
      [[97]]
      [[97]]$node
      [[97]]$node$id
      [1] "C_kwDOIvtxstoAKDAxNTFlZjI4M2QzYThiODgyOTIxNjM4Y2ZkZWYzMTBhNmU2M2MyMGE"
      
      [[97]]$node$committed_date
      [1] "2023-01-25T11:18:28Z"
      
      [[97]]$node$author
      [[97]]$node$author$name
      [1] "maciekbanas"
      
      
      [[97]]$node$additions
      [1] 42
      
      [[97]]$node$deletions
      [1] 41
      
      
      
      [[98]]
      [[98]]$node
      [[98]]$node$id
      [1] "C_kwDOIvtxstoAKGI3MDJkNzE2NzM2YTRkNGI2M2Q4YmQ5NmY3YmMwN2YzOTU1NGUxMzE"
      
      [[98]]$node$committed_date
      [1] "2023-01-25T10:35:36Z"
      
      [[98]]$node$author
      [[98]]$node$author$name
      [1] "maciekbanas"
      
      
      [[98]]$node$additions
      [1] 5
      
      [[98]]$node$deletions
      [1] 3
      
      
      
      [[99]]
      [[99]]$node
      [[99]]$node$id
      [1] "C_kwDOIvtxstoAKDFlZTU5MTlmZmQxMzMxOGE4YTE0OTE5NDI3OGZlNTRlMzA3MTUwY2U"
      
      [[99]]$node$committed_date
      [1] "2023-01-25T10:26:41Z"
      
      [[99]]$node$author
      [[99]]$node$author$name
      [1] "maciekbanas"
      
      
      [[99]]$node$additions
      [1] 116
      
      [[99]]$node$deletions
      [1] 111
      
      
      
      [[100]]
      [[100]]$node
      [[100]]$node$id
      [1] "C_kwDOIvtxstoAKGMzNmMyNWRmNDFjNzBiNzU3OTc4MWQzMTdhYWEwZjhkODRlZWM2ZTY"
      
      [[100]]$node$committed_date
      [1] "2023-01-25T08:52:01Z"
      
      [[100]]$node$author
      [[100]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[100]]$node$additions
      [1] 2
      
      [[100]]$node$deletions
      [1] 2
      
      
      

# `pull_commits_from_repos()` pulls commits from repos

    Code
      commits_from_repos
    Output
      [[1]]
      [[1]][[1]]
      [[1]][[1]]$node
      [[1]][[1]]$node$id
      [1] "C_kwDOIvtxstoAKGUyY2ZlNzQ0NTk1N2E2OTU1MzljOTAyM2M2YzljOTAwODFmMDhhY2Y"
      
      [[1]][[1]]$node$committed_date
      [1] "2023-02-27T10:46:57Z"
      
      [[1]][[1]]$node$author
      [[1]][[1]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[1]][[1]]$node$additions
      [1] 1
      
      [[1]][[1]]$node$deletions
      [1] 10
      
      
      
      [[1]][[2]]
      [[1]][[2]]$node
      [[1]][[2]]$node$id
      [1] "C_kwDOIvtxstoAKGVlZTZiZGQ4ZTEwODY3ZjU2ZWY4OWFiZDdkMzAwNzViMTc2ZDJiM2M"
      
      [[1]][[2]]$node$committed_date
      [1] "2023-02-27T10:14:37Z"
      
      [[1]][[2]]$node$author
      [[1]][[2]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[2]]$node$additions
      [1] 2
      
      [[1]][[2]]$node$deletions
      [1] 0
      
      
      
      [[1]][[3]]
      [[1]][[3]]$node
      [[1]][[3]]$node$id
      [1] "C_kwDOIvtxstoAKDYwOGVkOGEyZmViYWNmMzVkMzJmOWY3YzAzZWI0NzAzNzFjODlmZWM"
      
      [[1]][[3]]$node$committed_date
      [1] "2023-02-27T09:43:16Z"
      
      [[1]][[3]]$node$author
      [[1]][[3]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[3]]$node$additions
      [1] 0
      
      [[1]][[3]]$node$deletions
      [1] 2
      
      
      
      [[1]][[4]]
      [[1]][[4]]$node
      [[1]][[4]]$node$id
      [1] "C_kwDOIvtxstoAKDJiZjVjYWMwZDBiNjI5MjNkY2FhN2FjZGI4MjQ0Mzk4NjBlZWUzYWI"
      
      [[1]][[4]]$node$committed_date
      [1] "2023-02-24T13:25:14Z"
      
      [[1]][[4]]$node$author
      [[1]][[4]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[4]]$node$additions
      [1] 1
      
      [[1]][[4]]$node$deletions
      [1] 1
      
      
      
      [[1]][[5]]
      [[1]][[5]]$node
      [[1]][[5]]$node$id
      [1] "C_kwDOIvtxstoAKDllZjdiZGU1MmE4ZjMwZGM2OWU0OWIzZWExMzEyZGYxMDMyM2I1NzM"
      
      [[1]][[5]]$node$committed_date
      [1] "2023-02-24T13:16:10Z"
      
      [[1]][[5]]$node$author
      [[1]][[5]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[5]]$node$additions
      [1] 0
      
      [[1]][[5]]$node$deletions
      [1] 9
      
      
      
      [[1]][[6]]
      [[1]][[6]]$node
      [[1]][[6]]$node$id
      [1] "C_kwDOIvtxstoAKGRkYjA4OTJhN2I5YTQ2Mjk2ZDc5NWViMzA0ZmQxNTk1MmM5MjEyZTQ"
      
      [[1]][[6]]$node$committed_date
      [1] "2023-02-24T12:58:54Z"
      
      [[1]][[6]]$node$author
      [[1]][[6]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[6]]$node$additions
      [1] 2
      
      [[1]][[6]]$node$deletions
      [1] 0
      
      
      
      [[1]][[7]]
      [[1]][[7]]$node
      [[1]][[7]]$node$id
      [1] "C_kwDOIvtxstoAKDMwZDIwOTMzOTEyZTljZmE5MjQ4MDhhMzM0Y2Q3MDVmM2M2OWRhNzU"
      
      [[1]][[7]]$node$committed_date
      [1] "2023-02-24T11:04:03Z"
      
      [[1]][[7]]$node$author
      [[1]][[7]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[1]][[7]]$node$additions
      [1] 14
      
      [[1]][[7]]$node$deletions
      [1] 10
      
      
      
      [[1]][[8]]
      [[1]][[8]]$node
      [[1]][[8]]$node$id
      [1] "C_kwDOIvtxstoAKDdjMmM1YTU3YTI1MDIxOGY2MzM4Njg2OWFjM2E0MmEwNDkzYWViMzI"
      
      [[1]][[8]]$node$committed_date
      [1] "2023-02-24T10:37:42Z"
      
      [[1]][[8]]$node$author
      [[1]][[8]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[8]]$node$additions
      [1] 0
      
      [[1]][[8]]$node$deletions
      [1] 0
      
      
      
      [[1]][[9]]
      [[1]][[9]]$node
      [[1]][[9]]$node$id
      [1] "C_kwDOIvtxstoAKDU0MTc0ZjdlMzFhMjk1OThjMjc0ZmM1MjkyMWNjNWM0ODIyNmRmMWU"
      
      [[1]][[9]]$node$committed_date
      [1] "2023-02-24T10:24:27Z"
      
      [[1]][[9]]$node$author
      [[1]][[9]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[9]]$node$additions
      [1] 6
      
      [[1]][[9]]$node$deletions
      [1] 1
      
      
      
      [[1]][[10]]
      [[1]][[10]]$node
      [[1]][[10]]$node$id
      [1] "C_kwDOIvtxstoAKGU4NmRjZjNmM2IzZDgyMDg2YWE5MTMyOTY5NWY5NTM4NjY5ODhmN2Q"
      
      [[1]][[10]]$node$committed_date
      [1] "2023-02-24T09:30:17Z"
      
      [[1]][[10]]$node$author
      [[1]][[10]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[10]]$node$additions
      [1] 8
      
      [[1]][[10]]$node$deletions
      [1] 9
      
      
      
      [[1]][[11]]
      [[1]][[11]]$node
      [[1]][[11]]$node$id
      [1] "C_kwDOIvtxstoAKGJmNTRhNDNhZWY1NDhkNWE5ZTcwNDQ1ZTBhMGQ3NGE5MzhjNTZlMWU"
      
      [[1]][[11]]$node$committed_date
      [1] "2023-02-24T08:56:32Z"
      
      [[1]][[11]]$node$author
      [[1]][[11]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[11]]$node$additions
      [1] 2
      
      [[1]][[11]]$node$deletions
      [1] 0
      
      
      
      [[1]][[12]]
      [[1]][[12]]$node
      [[1]][[12]]$node$id
      [1] "C_kwDOIvtxstoAKDc4Mzc2NTk1OGY3YWMxZDFhNjU0M2Y5ZjA2MTEwOWI1NzA4NmY3NDU"
      
      [[1]][[12]]$node$committed_date
      [1] "2023-02-23T15:17:12Z"
      
      [[1]][[12]]$node$author
      [[1]][[12]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[12]]$node$additions
      [1] 60
      
      [[1]][[12]]$node$deletions
      [1] 2
      
      
      
      [[1]][[13]]
      [[1]][[13]]$node
      [[1]][[13]]$node$id
      [1] "C_kwDOIvtxstoAKDI2NDYxYzA5NzczNzM4NzhmMTE3NmI1MzhmZTM5ZjNkYmNhMDVjMmI"
      
      [[1]][[13]]$node$committed_date
      [1] "2023-02-21T15:19:10Z"
      
      [[1]][[13]]$node$author
      [[1]][[13]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[1]][[13]]$node$additions
      [1] 5334
      
      [[1]][[13]]$node$deletions
      [1] 2488
      
      
      
      [[1]][[14]]
      [[1]][[14]]$node
      [[1]][[14]]$node$id
      [1] "C_kwDOIvtxstoAKDhhNGE5MzMxMzA3NzU5M2RiNjEzY2I2NjAxMzNjMWI4NTM5YWQzMjk"
      
      [[1]][[14]]$node$committed_date
      [1] "2023-02-20T14:57:36Z"
      
      [[1]][[14]]$node$author
      [[1]][[14]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[1]][[14]]$node$additions
      [1] 56
      
      [[1]][[14]]$node$deletions
      [1] 17
      
      
      
      [[1]][[15]]
      [[1]][[15]]$node
      [[1]][[15]]$node$id
      [1] "C_kwDOIvtxstoAKGEzMjhlMjQwZDBlMWNhZmYxNzBlNDE3MjRkMmQ5N2RmNmRkOWJkMmE"
      
      [[1]][[15]]$node$committed_date
      [1] "2023-02-20T10:38:14Z"
      
      [[1]][[15]]$node$author
      [[1]][[15]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[15]]$node$additions
      [1] 39
      
      [[1]][[15]]$node$deletions
      [1] 1
      
      
      
      [[1]][[16]]
      [[1]][[16]]$node
      [[1]][[16]]$node$id
      [1] "C_kwDOIvtxstoAKGIyOWYyYjMzYzE1YjhkOWNiM2Y5ZjA1Mjg0MzllZjhhYzY3ZGIzOTQ"
      
      [[1]][[16]]$node$committed_date
      [1] "2023-02-20T08:55:54Z"
      
      [[1]][[16]]$node$author
      [[1]][[16]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[1]][[16]]$node$additions
      [1] 17
      
      [[1]][[16]]$node$deletions
      [1] 16
      
      
      
      [[1]][[17]]
      [[1]][[17]]$node
      [[1]][[17]]$node$id
      [1] "C_kwDOIvtxstoAKGNkMzJlNDRkYjY3ZTlhOTc4YjMzNTVmOTYzOTQxNTZlMGYyOWUwYmM"
      
      [[1]][[17]]$node$committed_date
      [1] "2023-02-20T08:54:45Z"
      
      [[1]][[17]]$node$author
      [[1]][[17]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[17]]$node$additions
      [1] 17
      
      [[1]][[17]]$node$deletions
      [1] 16
      
      
      
      [[1]][[18]]
      [[1]][[18]]$node
      [[1]][[18]]$node$id
      [1] "C_kwDOIvtxstoAKDk3OTE0NjQ5MjY4NGRhODRlNzkxODFiZDQ3N2Q4N2MzZjZiNDIyNjk"
      
      [[1]][[18]]$node$committed_date
      [1] "2023-02-17T09:19:20Z"
      
      [[1]][[18]]$node$author
      [[1]][[18]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[1]][[18]]$node$additions
      [1] 69
      
      [[1]][[18]]$node$deletions
      [1] 38
      
      
      
      [[1]][[19]]
      [[1]][[19]]$node
      [[1]][[19]]$node$id
      [1] "C_kwDOIvtxstoAKDcxOWU1NjQ0NDc5YjJkYjI1MGE3NDc0NDBiNzQ5NGRiZWFiYjI4YmM"
      
      [[1]][[19]]$node$committed_date
      [1] "2023-02-17T09:18:06Z"
      
      [[1]][[19]]$node$author
      [[1]][[19]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[19]]$node$additions
      [1] 69
      
      [[1]][[19]]$node$deletions
      [1] 38
      
      
      
      [[1]][[20]]
      [[1]][[20]]$node
      [[1]][[20]]$node$id
      [1] "C_kwDOIvtxstoAKDdlNzQ2Njg4MDNlZmFmYjM1MWNiZjhjZjA4OTQ2Njk2NmRkZWVhODI"
      
      [[1]][[20]]$node$committed_date
      [1] "2023-02-16T15:25:16Z"
      
      [[1]][[20]]$node$author
      [[1]][[20]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[20]]$node$additions
      [1] 10
      
      [[1]][[20]]$node$deletions
      [1] 9
      
      
      
      [[1]][[21]]
      [[1]][[21]]$node
      [[1]][[21]]$node$id
      [1] "C_kwDOIvtxstoAKGM5NzI5OTdkOWFkNTJiOTM1OGMyMTNlM2ZiMDU2M2RlOGI1MzU0M2E"
      
      [[1]][[21]]$node$committed_date
      [1] "2023-02-16T15:09:23Z"
      
      [[1]][[21]]$node$author
      [[1]][[21]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[21]]$node$additions
      [1] 12
      
      [[1]][[21]]$node$deletions
      [1] 0
      
      
      
      [[1]][[22]]
      [[1]][[22]]$node
      [[1]][[22]]$node$id
      [1] "C_kwDOIvtxstoAKGRmZDgyZjFhNjllNTdhMjAyYmQwZGE0Yjg2OTlmNTIwMDA5YTkxYjg"
      
      [[1]][[22]]$node$committed_date
      [1] "2023-02-16T13:52:25Z"
      
      [[1]][[22]]$node$author
      [[1]][[22]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[22]]$node$additions
      [1] 1
      
      [[1]][[22]]$node$deletions
      [1] 0
      
      
      
      [[1]][[23]]
      [[1]][[23]]$node
      [[1]][[23]]$node$id
      [1] "C_kwDOIvtxstoAKDUxNTMyN2FjZDk0YTQ5ZTk1ZGRkMjZiYzQxZmE0MTM5YWU4ZjcyYjc"
      
      [[1]][[23]]$node$committed_date
      [1] "2023-02-16T13:07:06Z"
      
      [[1]][[23]]$node$author
      [[1]][[23]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[1]][[23]]$node$additions
      [1] 182
      
      [[1]][[23]]$node$deletions
      [1] 45
      
      
      
      [[1]][[24]]
      [[1]][[24]]$node
      [[1]][[24]]$node$id
      [1] "C_kwDOIvtxstoAKDEwNWI4OTk3ZDRmM2ViMjBhNTAwNWUzN2FhMDJlM2E2NDI1ZmVlYjU"
      
      [[1]][[24]]$node$committed_date
      [1] "2023-02-16T13:02:10Z"
      
      [[1]][[24]]$node$author
      [[1]][[24]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[24]]$node$additions
      [1] 26
      
      [[1]][[24]]$node$deletions
      [1] 9
      
      
      
      [[1]][[25]]
      [[1]][[25]]$node
      [[1]][[25]]$node$id
      [1] "C_kwDOIvtxstoAKDM0YWIzMWQ3MTUwOTU1Mjk3YzU1MDQ2NjNkYWZjODU3MWE2MWYwOGQ"
      
      [[1]][[25]]$node$committed_date
      [1] "2023-02-16T12:12:45Z"
      
      [[1]][[25]]$node$author
      [[1]][[25]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[25]]$node$additions
      [1] 14
      
      [[1]][[25]]$node$deletions
      [1] 0
      
      
      
      [[1]][[26]]
      [[1]][[26]]$node
      [[1]][[26]]$node$id
      [1] "C_kwDOIvtxstoAKDEzZDUzMTcyOGFkNzgyMmViYTdlMzEyZDQyN2E0MjIzZjhiYWE3NGI"
      
      [[1]][[26]]$node$committed_date
      [1] "2023-02-16T12:07:26Z"
      
      [[1]][[26]]$node$author
      [[1]][[26]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[26]]$node$additions
      [1] 112
      
      [[1]][[26]]$node$deletions
      [1] 36
      
      
      
      [[1]][[27]]
      [[1]][[27]]$node
      [[1]][[27]]$node$id
      [1] "C_kwDOIvtxstoAKGVjYTE4YTJkNzhlZDJlODg2ODljYzQwMDFlYjVlYjA3OTAzYTJhNTY"
      
      [[1]][[27]]$node$committed_date
      [1] "2023-02-16T11:17:00Z"
      
      [[1]][[27]]$node$author
      [[1]][[27]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[1]][[27]]$node$additions
      [1] 673
      
      [[1]][[27]]$node$deletions
      [1] 521
      
      
      
      [[1]][[28]]
      [[1]][[28]]$node
      [[1]][[28]]$node$id
      [1] "C_kwDOIvtxstoAKGU3ZjhmODk5OGM3ZTU3N2ZkNTUxNjQ3NDVmYmE3ZTVhMjE4OTk5MjE"
      
      [[1]][[28]]$node$committed_date
      [1] "2023-02-16T09:37:11Z"
      
      [[1]][[28]]$node$author
      [[1]][[28]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[28]]$node$additions
      [1] 34
      
      [[1]][[28]]$node$deletions
      [1] 4
      
      
      
      [[1]][[29]]
      [[1]][[29]]$node
      [[1]][[29]]$node$id
      [1] "C_kwDOIvtxstoAKGU1MWUyMWQ0M2I0ZGIxMWRhM2U1MDQ5OTYxOGY2NTlmNzYwZTc4YTY"
      
      [[1]][[29]]$node$committed_date
      [1] "2023-02-10T14:51:00Z"
      
      [[1]][[29]]$node$author
      [[1]][[29]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[1]][[29]]$node$additions
      [1] 673
      
      [[1]][[29]]$node$deletions
      [1] 521
      
      
      
      [[1]][[30]]
      [[1]][[30]]$node
      [[1]][[30]]$node$id
      [1] "C_kwDOIvtxstoAKDI0NjMyZTQ3MWE1ZGJhMjNkNmVkYzFkNTUyMzNiN2VmZWFjNDhhZmY"
      
      [[1]][[30]]$node$committed_date
      [1] "2023-02-10T14:27:55Z"
      
      [[1]][[30]]$node$author
      [[1]][[30]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[30]]$node$additions
      [1] 111
      
      [[1]][[30]]$node$deletions
      [1] 177
      
      
      
      [[1]][[31]]
      [[1]][[31]]$node
      [[1]][[31]]$node$id
      [1] "C_kwDOIvtxstoAKDA0MTk1NTkzYmMxMjkzMzFhNWI0NDA1OGU1Yjc2MGJkN2M0NzU2NjE"
      
      [[1]][[31]]$node$committed_date
      [1] "2023-02-10T14:02:41Z"
      
      [[1]][[31]]$node$author
      [[1]][[31]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[31]]$node$additions
      [1] 76
      
      [[1]][[31]]$node$deletions
      [1] 27
      
      
      
      [[1]][[32]]
      [[1]][[32]]$node
      [[1]][[32]]$node$id
      [1] "C_kwDOIvtxstoAKGNkZTQ4ZmZlMmZkNDU2ZWYwNjc2ZjE2NGMzZDhkMmM1NjI4Zjk5N2Q"
      
      [[1]][[32]]$node$committed_date
      [1] "2023-02-10T12:49:45Z"
      
      [[1]][[32]]$node$author
      [[1]][[32]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[32]]$node$additions
      [1] 42
      
      [[1]][[32]]$node$deletions
      [1] 0
      
      
      
      [[1]][[33]]
      [[1]][[33]]$node
      [[1]][[33]]$node$id
      [1] "C_kwDOIvtxstoAKDE3NWViMGM1NWIwZTY2ZTM4M2MyODg4OGZiMTIxYWMwYzBmNzJhZDg"
      
      [[1]][[33]]$node$committed_date
      [1] "2023-02-10T12:49:17Z"
      
      [[1]][[33]]$node$author
      [[1]][[33]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[33]]$node$additions
      [1] 88
      
      [[1]][[33]]$node$deletions
      [1] 0
      
      
      
      [[1]][[34]]
      [[1]][[34]]$node
      [[1]][[34]]$node$id
      [1] "C_kwDOIvtxstoAKDFhNzg1OGQwNTM0NDZmNmNkODZhMzRlODA0OGEyNzk0ODE1YzY5NDU"
      
      [[1]][[34]]$node$committed_date
      [1] "2023-02-10T12:48:51Z"
      
      [[1]][[34]]$node$author
      [[1]][[34]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[34]]$node$additions
      [1] 3
      
      [[1]][[34]]$node$deletions
      [1] 90
      
      
      
      [[1]][[35]]
      [[1]][[35]]$node
      [[1]][[35]]$node$id
      [1] "C_kwDOIvtxstoAKDMzYjBiM2U4ZTQxZWExZmU0NmZjYzQ3ZmQ1ZjA4ZGFlNTUzNWE1NzI"
      
      [[1]][[35]]$node$committed_date
      [1] "2023-02-10T11:55:50Z"
      
      [[1]][[35]]$node$author
      [[1]][[35]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[35]]$node$additions
      [1] 383
      
      [[1]][[35]]$node$deletions
      [1] 257
      
      
      
      [[1]][[36]]
      [[1]][[36]]$node
      [[1]][[36]]$node$id
      [1] "C_kwDOIvtxstoAKDBiOTAwMTYxNzJhMWMyYmRjOWM0ZjBhMTI3NDJkYzU2MzlkMGRjOTg"
      
      [[1]][[36]]$node$committed_date
      [1] "2023-02-08T09:22:27Z"
      
      [[1]][[36]]$node$author
      [[1]][[36]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[36]]$node$additions
      [1] 15
      
      [[1]][[36]]$node$deletions
      [1] 51
      
      
      
      [[1]][[37]]
      [[1]][[37]]$node
      [[1]][[37]]$node$id
      [1] "C_kwDOIvtxstoAKDdhNTE3OTA2ZmJkYzAxYzMzZDEzNzA4YTJjNGJmZTc5ZTJmNjJjYmQ"
      
      [[1]][[37]]$node$committed_date
      [1] "2023-02-08T09:17:57Z"
      
      [[1]][[37]]$node$author
      [[1]][[37]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[1]][[37]]$node$additions
      [1] 60
      
      [[1]][[37]]$node$deletions
      [1] 45
      
      
      
      [[1]][[38]]
      [[1]][[38]]$node
      [[1]][[38]]$node$id
      [1] "C_kwDOIvtxstoAKDc2MWJlMjU5OTBkMzBkMzE2MjNiNzY1YTgxNGMyZmEyYWNlZWRlNmQ"
      
      [[1]][[38]]$node$committed_date
      [1] "2023-02-08T09:14:56Z"
      
      [[1]][[38]]$node$author
      [[1]][[38]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[38]]$node$additions
      [1] 60
      
      [[1]][[38]]$node$deletions
      [1] 45
      
      
      
      [[1]][[39]]
      [[1]][[39]]$node
      [[1]][[39]]$node$id
      [1] "C_kwDOIvtxstoAKGQ0OThkMGE3YWY4NGFjM2MxMzgyZTQ4OTIyNDkzOGZkNTYxY2ExOWU"
      
      [[1]][[39]]$node$committed_date
      [1] "2023-02-07T13:54:01Z"
      
      [[1]][[39]]$node$author
      [[1]][[39]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[1]][[39]]$node$additions
      [1] 1766
      
      [[1]][[39]]$node$deletions
      [1] 578
      
      
      
      [[1]][[40]]
      [[1]][[40]]$node
      [[1]][[40]]$node$id
      [1] "C_kwDOIvtxstoAKDljYTI1M2EyNjFjZDQ4ZWUwMDRkOTkzODc2OWVkNjg1ZWNiY2JhODE"
      
      [[1]][[40]]$node$committed_date
      [1] "2023-02-07T13:53:46Z"
      
      [[1]][[40]]$node$author
      [[1]][[40]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[40]]$node$additions
      [1] 1
      
      [[1]][[40]]$node$deletions
      [1] 1
      
      
      
      [[1]][[41]]
      [[1]][[41]]$node
      [[1]][[41]]$node$id
      [1] "C_kwDOIvtxstoAKDJmMDMyMWI1Y2IyMzlkNWQ1YzgzNmRkNmQ2OTVmZDFjYjFmYmMyZjE"
      
      [[1]][[41]]$node$committed_date
      [1] "2023-02-07T13:15:59Z"
      
      [[1]][[41]]$node$author
      [[1]][[41]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[41]]$node$additions
      [1] 358
      
      [[1]][[41]]$node$deletions
      [1] 338
      
      
      
      [[1]][[42]]
      [[1]][[42]]$node
      [[1]][[42]]$node$id
      [1] "C_kwDOIvtxstoAKGZiNTQ3OTZiOWRmODc3OWRkZTJjNzAzZDQwYjBlOWVhN2Q2NjA5NGI"
      
      [[1]][[42]]$node$committed_date
      [1] "2023-02-07T13:06:23Z"
      
      [[1]][[42]]$node$author
      [[1]][[42]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[42]]$node$additions
      [1] 5
      
      [[1]][[42]]$node$deletions
      [1] 0
      
      
      
      [[1]][[43]]
      [[1]][[43]]$node
      [[1]][[43]]$node$id
      [1] "C_kwDOIvtxstoAKDJkOTE1YTE4N2JlYTc0MGRiMzNlZTJlMDhjMzcwNDJlZTE4ZGUwMzQ"
      
      [[1]][[43]]$node$committed_date
      [1] "2023-02-07T12:36:00Z"
      
      [[1]][[43]]$node$author
      [[1]][[43]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[1]][[43]]$node$additions
      [1] 517
      
      [[1]][[43]]$node$deletions
      [1] 287
      
      
      
      [[1]][[44]]
      [[1]][[44]]$node
      [[1]][[44]]$node$id
      [1] "C_kwDOIvtxstoAKDQ1YjY0YWM1OGQ0NGE3ZjIyMjZkZDlkMTU2NmJhOTZjY2Q4OWEzYjM"
      
      [[1]][[44]]$node$committed_date
      [1] "2023-02-07T12:16:25Z"
      
      [[1]][[44]]$node$author
      [[1]][[44]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[44]]$node$additions
      [1] 2
      
      [[1]][[44]]$node$deletions
      [1] 0
      
      
      
      [[1]][[45]]
      [[1]][[45]]$node
      [[1]][[45]]$node$id
      [1] "C_kwDOIvtxstoAKGFiY2M3MzQzZDcyNWNjNTI2ZDNjOGQ0MTdlM2YzMGY0NzkzM2QyMTk"
      
      [[1]][[45]]$node$committed_date
      [1] "2023-02-07T11:03:01Z"
      
      [[1]][[45]]$node$author
      [[1]][[45]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[45]]$node$additions
      [1] 0
      
      [[1]][[45]]$node$deletions
      [1] 0
      
      
      
      [[1]][[46]]
      [[1]][[46]]$node
      [[1]][[46]]$node$id
      [1] "C_kwDOIvtxstoAKGVhMWU1MTYxYTgyY2VkNzNkOTY5NmU4Y2MwOWY0MTczZDkwYTUxNzI"
      
      [[1]][[46]]$node$committed_date
      [1] "2023-02-07T10:56:56Z"
      
      [[1]][[46]]$node$author
      [[1]][[46]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[46]]$node$additions
      [1] 77
      
      [[1]][[46]]$node$deletions
      [1] 27
      
      
      
      [[1]][[47]]
      [[1]][[47]]$node
      [[1]][[47]]$node$id
      [1] "C_kwDOIvtxstoAKDBmNWZlYzQ4OGMyYTkwNGRlYTNlMGRkODEwYjZkOGI4N2ZiOGM4YmI"
      
      [[1]][[47]]$node$committed_date
      [1] "2023-02-07T10:08:50Z"
      
      [[1]][[47]]$node$author
      [[1]][[47]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[47]]$node$additions
      [1] 108
      
      [[1]][[47]]$node$deletions
      [1] 29
      
      
      
      [[1]][[48]]
      [[1]][[48]]$node
      [[1]][[48]]$node$id
      [1] "C_kwDOIvtxstoAKDNkMzYxM2RmNjc0M2JiZGVmMmEwNGM2Y2UxYTYwOWU4YzJkODFkOTU"
      
      [[1]][[48]]$node$committed_date
      [1] "2023-02-07T09:14:17Z"
      
      [[1]][[48]]$node$author
      [[1]][[48]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[48]]$node$additions
      [1] 94
      
      [[1]][[48]]$node$deletions
      [1] 29
      
      
      
      [[1]][[49]]
      [[1]][[49]]$node
      [[1]][[49]]$node$id
      [1] "C_kwDOIvtxstoAKGIwYmJkMmRhODg1OTlmZmJmYmQ5MjYwZGIxZTBmZTNlNzM2NTVlYzk"
      
      [[1]][[49]]$node$committed_date
      [1] "2023-02-06T12:42:07Z"
      
      [[1]][[49]]$node$author
      [[1]][[49]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[49]]$node$additions
      [1] 4
      
      [[1]][[49]]$node$deletions
      [1] 4
      
      
      
      [[1]][[50]]
      [[1]][[50]]$node
      [[1]][[50]]$node$id
      [1] "C_kwDOIvtxstoAKDNjMmNjZGQ0MGUwODk4YzBjNDA1NTczMmUxMGZiNzhkNzQ5ZWUyMjI"
      
      [[1]][[50]]$node$committed_date
      [1] "2023-02-06T12:04:09Z"
      
      [[1]][[50]]$node$author
      [[1]][[50]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[1]][[50]]$node$additions
      [1] 59
      
      [[1]][[50]]$node$deletions
      [1] 84
      
      
      
      [[1]][[51]]
      [[1]][[51]]$node
      [[1]][[51]]$node$id
      [1] "C_kwDOIvtxstoAKGUwNGI2NmE5YmYwNDM0ZWFmM2JhMjY2MDVjNjgyNDhlNDVmOTAyZjI"
      
      [[1]][[51]]$node$committed_date
      [1] "2023-02-06T11:55:50Z"
      
      [[1]][[51]]$node$author
      [[1]][[51]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[51]]$node$additions
      [1] 16
      
      [[1]][[51]]$node$deletions
      [1] 10
      
      
      
      [[1]][[52]]
      [[1]][[52]]$node
      [[1]][[52]]$node$id
      [1] "C_kwDOIvtxstoAKDZmMTEzODY1NTAxZmVlZmVkYzJiNjUyOTUwZDU0YTMzNGM4ZjFmYTY"
      
      [[1]][[52]]$node$committed_date
      [1] "2023-02-06T11:54:26Z"
      
      [[1]][[52]]$node$author
      [[1]][[52]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[52]]$node$additions
      [1] 43
      
      [[1]][[52]]$node$deletions
      [1] 74
      
      
      
      [[1]][[53]]
      [[1]][[53]]$node
      [[1]][[53]]$node$id
      [1] "C_kwDOIvtxstoAKDAzZGQzMDU5MzdiZjhjMjZhM2FkODk2YTE5OWEzMzMxZjMyMjdjYzA"
      
      [[1]][[53]]$node$committed_date
      [1] "2023-02-06T10:52:24Z"
      
      [[1]][[53]]$node$author
      [[1]][[53]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[1]][[53]]$node$additions
      [1] 78
      
      [[1]][[53]]$node$deletions
      [1] 19
      
      
      
      [[1]][[54]]
      [[1]][[54]]$node
      [[1]][[54]]$node$id
      [1] "C_kwDOIvtxstoAKDI2ZTVjMjM4NWQ5OWY0MDIyZTBkYWE1OTQ1OTk1NjViN2ZiZjRiMTE"
      
      [[1]][[54]]$node$committed_date
      [1] "2023-02-06T10:51:19Z"
      
      [[1]][[54]]$node$author
      [[1]][[54]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[54]]$node$additions
      [1] 34
      
      [[1]][[54]]$node$deletions
      [1] 6
      
      
      
      [[1]][[55]]
      [[1]][[55]]$node
      [[1]][[55]]$node$id
      [1] "C_kwDOIvtxstoAKGY1ZGZmODU1NjFjYzEyYjcyYmVkOWJlOTVkZjdjMzI0NmMzMWQxYjg"
      
      [[1]][[55]]$node$committed_date
      [1] "2023-02-06T10:36:39Z"
      
      [[1]][[55]]$node$author
      [[1]][[55]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[55]]$node$additions
      [1] 46
      
      [[1]][[55]]$node$deletions
      [1] 15
      
      
      
      [[1]][[56]]
      [[1]][[56]]$node
      [[1]][[56]]$node$id
      [1] "C_kwDOIvtxstoAKDA5OGJjMTQzMWQyNTEyMTU1MzAzN2Q5NWIwMWI2ZTA1MjM4ZTI1YjM"
      
      [[1]][[56]]$node$committed_date
      [1] "2023-02-06T10:13:17Z"
      
      [[1]][[56]]$node$author
      [[1]][[56]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[56]]$node$additions
      [1] 1
      
      [[1]][[56]]$node$deletions
      [1] 1
      
      
      
      [[1]][[57]]
      [[1]][[57]]$node
      [[1]][[57]]$node$id
      [1] "C_kwDOIvtxstoAKDRmODgwYmI0NzRhZDliMjFiNjgwOWYxYWFlMGY0MWUyZjI2NTM1YzI"
      
      [[1]][[57]]$node$committed_date
      [1] "2023-02-06T09:24:23Z"
      
      [[1]][[57]]$node$author
      [[1]][[57]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[1]][[57]]$node$additions
      [1] 80
      
      [[1]][[57]]$node$deletions
      [1] 80
      
      
      
      [[1]][[58]]
      [[1]][[58]]$node
      [[1]][[58]]$node$id
      [1] "C_kwDOIvtxstoAKGY2YTk4YjNhNDE1NjA1Mjc5MmI5ODNjMjI3MDEzMmE1NTAyNTZlMDY"
      
      [[1]][[58]]$node$committed_date
      [1] "2023-02-06T09:23:23Z"
      
      [[1]][[58]]$node$author
      [[1]][[58]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[58]]$node$additions
      [1] 80
      
      [[1]][[58]]$node$deletions
      [1] 80
      
      
      
      [[1]][[59]]
      [[1]][[59]]$node
      [[1]][[59]]$node$id
      [1] "C_kwDOIvtxstoAKGZhNWVjM2QyNjI0OTQwM2NhZDMwZjVkNzFmZDdhMjIxYjJkOTQ2ZWM"
      
      [[1]][[59]]$node$committed_date
      [1] "2023-02-03T14:50:33Z"
      
      [[1]][[59]]$node$author
      [[1]][[59]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[59]]$node$additions
      [1] 82
      
      [[1]][[59]]$node$deletions
      [1] 82
      
      
      
      [[1]][[60]]
      [[1]][[60]]$node
      [[1]][[60]]$node$id
      [1] "C_kwDOIvtxstoAKGYyZmE0Zjk3MzY3MDJkMjQwYmQ2NGRmNWIzNDliMmM2N2JjMmUxZmY"
      
      [[1]][[60]]$node$committed_date
      [1] "2023-02-03T11:43:44Z"
      
      [[1]][[60]]$node$author
      [[1]][[60]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[1]][[60]]$node$additions
      [1] 101
      
      [[1]][[60]]$node$deletions
      [1] 38
      
      
      
      [[1]][[61]]
      [[1]][[61]]$node
      [[1]][[61]]$node$id
      [1] "C_kwDOIvtxstoAKDcwMTEzMmU4MTc4OGZjZjkzNjdlMGQyYWZkZmExZjAyMTdjMTY0MTg"
      
      [[1]][[61]]$node$committed_date
      [1] "2023-02-03T11:35:18Z"
      
      [[1]][[61]]$node$author
      [[1]][[61]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[61]]$node$additions
      [1] 101
      
      [[1]][[61]]$node$deletions
      [1] 38
      
      
      
      [[1]][[62]]
      [[1]][[62]]$node
      [[1]][[62]]$node$id
      [1] "C_kwDOIvtxstoAKGQyYTJlMzhkN2FlYzI4N2Y2ZjljNGRiNmIyMmE4MzRjNTg1YmRiYzk"
      
      [[1]][[62]]$node$committed_date
      [1] "2023-02-03T08:46:41Z"
      
      [[1]][[62]]$node$author
      [[1]][[62]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[62]]$node$additions
      [1] 20
      
      [[1]][[62]]$node$deletions
      [1] 9
      
      
      
      [[1]][[63]]
      [[1]][[63]]$node
      [[1]][[63]]$node$id
      [1] "C_kwDOIvtxstoAKDZlMjNhYWYzNDEwNDI2Y2FmY2Y2YmQ2MTI1ZjkyYmEzOWVkYTZmMTU"
      
      [[1]][[63]]$node$committed_date
      [1] "2023-02-02T15:14:43Z"
      
      [[1]][[63]]$node$author
      [[1]][[63]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[63]]$node$additions
      [1] 65
      
      [[1]][[63]]$node$deletions
      [1] 17
      
      
      
      [[1]][[64]]
      [[1]][[64]]$node
      [[1]][[64]]$node$id
      [1] "C_kwDOIvtxstoAKDM5NTRhMDczMDRiOWNkYjZjODFkM2I0N2I5MWZhY2Q4ZmE5YzgxNzg"
      
      [[1]][[64]]$node$committed_date
      [1] "2023-02-02T13:34:38Z"
      
      [[1]][[64]]$node$author
      [[1]][[64]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[64]]$node$additions
      [1] 18
      
      [[1]][[64]]$node$deletions
      [1] 10
      
      
      
      [[1]][[65]]
      [[1]][[65]]$node
      [[1]][[65]]$node$id
      [1] "C_kwDOIvtxstoAKDhhODUzNzNlNGY0Njk3M2JjODFjYmU4MGRmODllMmEzYjRmMjZiZTU"
      
      [[1]][[65]]$node$committed_date
      [1] "2023-02-02T13:31:26Z"
      
      [[1]][[65]]$node$author
      [[1]][[65]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[65]]$node$additions
      [1] 214
      
      [[1]][[65]]$node$deletions
      [1] 104
      
      
      
      [[1]][[66]]
      [[1]][[66]]$node
      [[1]][[66]]$node$id
      [1] "C_kwDOIvtxstoAKGM4ODJkOGM0ZDY5ZDUzZjk5ZWZkMDA1OTZmNWYxZDJmODAyMjE4YmE"
      
      [[1]][[66]]$node$committed_date
      [1] "2023-02-01T12:46:43Z"
      
      [[1]][[66]]$node$author
      [[1]][[66]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[66]]$node$additions
      [1] 3
      
      [[1]][[66]]$node$deletions
      [1] 1
      
      
      
      [[1]][[67]]
      [[1]][[67]]$node
      [[1]][[67]]$node$id
      [1] "C_kwDOIvtxstoAKDgzNDRjOGZmYmM5YzRkZjkzODhmMzlkZWVjNzRlMzYyY2RiMjFjY2Q"
      
      [[1]][[67]]$node$committed_date
      [1] "2023-02-01T12:44:49Z"
      
      [[1]][[67]]$node$author
      [[1]][[67]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[67]]$node$additions
      [1] 88
      
      [[1]][[67]]$node$deletions
      [1] 0
      
      
      
      [[1]][[68]]
      [[1]][[68]]$node
      [[1]][[68]]$node$id
      [1] "C_kwDOIvtxstoAKGIwNTg5ZWIzOGE1OTA2MTBmMTI0MzRjNTRhMTNhYjczNGY5YmNhOGM"
      
      [[1]][[68]]$node$committed_date
      [1] "2023-01-31T14:11:27Z"
      
      [[1]][[68]]$node$author
      [[1]][[68]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[68]]$node$additions
      [1] 139
      
      [[1]][[68]]$node$deletions
      [1] 11
      
      
      
      [[1]][[69]]
      [[1]][[69]]$node
      [[1]][[69]]$node$id
      [1] "C_kwDOIvtxstoAKGYwMjVlMTRjZWJjMmE3MDEwNGRjZjMzNDA3YWIyZWMyNGUzYjAxMDM"
      
      [[1]][[69]]$node$committed_date
      [1] "2023-01-31T12:59:28Z"
      
      [[1]][[69]]$node$author
      [[1]][[69]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[69]]$node$additions
      [1] 65
      
      [[1]][[69]]$node$deletions
      [1] 10
      
      
      
      [[1]][[70]]
      [[1]][[70]]$node
      [[1]][[70]]$node$id
      [1] "C_kwDOIvtxstoAKDJkM2JiN2M5ZDE1OWUwZTA3MDZiMTk1NWM0NTE1MzQxOWVkNzM2YjU"
      
      [[1]][[70]]$node$committed_date
      [1] "2023-01-31T11:22:09Z"
      
      [[1]][[70]]$node$author
      [[1]][[70]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[70]]$node$additions
      [1] 20
      
      [[1]][[70]]$node$deletions
      [1] 6
      
      
      
      [[1]][[71]]
      [[1]][[71]]$node
      [[1]][[71]]$node$id
      [1] "C_kwDOIvtxstoAKDQ0NzRkZWI0ZjVkMTU2OTE3ZWJlODcyYjMwNjMwZmZlMWJhOTNkYWM"
      
      [[1]][[71]]$node$committed_date
      [1] "2023-01-31T10:28:24Z"
      
      [[1]][[71]]$node$author
      [[1]][[71]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[71]]$node$additions
      [1] 0
      
      [[1]][[71]]$node$deletions
      [1] 12
      
      
      
      [[1]][[72]]
      [[1]][[72]]$node
      [[1]][[72]]$node$id
      [1] "C_kwDOIvtxstoAKDBhNmIxMWM4YjAxZGI5OWYxNzRiMTdjZmY5NGU4MTVlMTAyMGEyYjk"
      
      [[1]][[72]]$node$committed_date
      [1] "2023-01-31T10:28:07Z"
      
      [[1]][[72]]$node$author
      [[1]][[72]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[72]]$node$additions
      [1] 164
      
      [[1]][[72]]$node$deletions
      [1] 5
      
      
      
      [[1]][[73]]
      [[1]][[73]]$node
      [[1]][[73]]$node$id
      [1] "C_kwDOIvtxstoAKDZkNGIyYTAyMTc1ODJjODhlNWE1ZDEzNmE0ZmM2NzQ4YzY4YzM0ODg"
      
      [[1]][[73]]$node$committed_date
      [1] "2023-01-31T09:50:57Z"
      
      [[1]][[73]]$node$author
      [[1]][[73]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[1]][[73]]$node$additions
      [1] 0
      
      [[1]][[73]]$node$deletions
      [1] 12
      
      
      
      [[1]][[74]]
      [[1]][[74]]$node
      [[1]][[74]]$node$id
      [1] "C_kwDOIvtxstoAKDg0OTEwYWQ5OWJiNDM1ZjMxYThmMTYzYjFkN2YyZmE5NGMyNmM4MTM"
      
      [[1]][[74]]$node$committed_date
      [1] "2023-01-30T14:54:21Z"
      
      [[1]][[74]]$node$author
      [[1]][[74]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[74]]$node$additions
      [1] 336
      
      [[1]][[74]]$node$deletions
      [1] 89
      
      
      
      [[1]][[75]]
      [[1]][[75]]$node
      [[1]][[75]]$node$id
      [1] "C_kwDOIvtxstoAKDJhNDM2ZGY2ZGVmZGJhNzhhMDAwNWQzNzE5MTM1YmVkZjg5MzQyOTc"
      
      [[1]][[75]]$node$committed_date
      [1] "2023-01-30T12:07:15Z"
      
      [[1]][[75]]$node$author
      [[1]][[75]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[75]]$node$additions
      [1] 4
      
      [[1]][[75]]$node$deletions
      [1] 3
      
      
      
      [[1]][[76]]
      [[1]][[76]]$node
      [[1]][[76]]$node$id
      [1] "C_kwDOIvtxstoAKDVmMTkxZDU3NjA3YzMzMjgzMTk0MWFkNDIzOTI0NDMzY2NhNGZjNzc"
      
      [[1]][[76]]$node$committed_date
      [1] "2023-01-30T11:16:29Z"
      
      [[1]][[76]]$node$author
      [[1]][[76]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[1]][[76]]$node$additions
      [1] 687
      
      [[1]][[76]]$node$deletions
      [1] 185
      
      
      
      [[1]][[77]]
      [[1]][[77]]$node
      [[1]][[77]]$node$id
      [1] "C_kwDOIvtxstoAKDllODIyNDVlMDlkMWJmZDljZDhlMDg4NmIwMjJjZGY5M2JiNzZkNWM"
      
      [[1]][[77]]$node$committed_date
      [1] "2023-01-30T10:45:33Z"
      
      [[1]][[77]]$node$author
      [[1]][[77]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[77]]$node$additions
      [1] 141
      
      [[1]][[77]]$node$deletions
      [1] 96
      
      
      
      [[1]][[78]]
      [[1]][[78]]$node
      [[1]][[78]]$node$id
      [1] "C_kwDOIvtxstoAKGEyMzQ3ZTAzMjJjMzI5OTY4ODJhYmRmZDM3YTYyNzBjYWIyNjc3Y2I"
      
      [[1]][[78]]$node$committed_date
      [1] "2023-01-30T09:37:24Z"
      
      [[1]][[78]]$node$author
      [[1]][[78]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[78]]$node$additions
      [1] 546
      
      [[1]][[78]]$node$deletions
      [1] 89
      
      
      
      [[1]][[79]]
      [[1]][[79]]$node
      [[1]][[79]]$node$id
      [1] "C_kwDOIvtxstoAKGRlODc4ZDhmY2Y2MzhkZTY2MDZkMTkyMjg4NmJkZmNhNjYyN2Q5Y2E"
      
      [[1]][[79]]$node$committed_date
      [1] "2023-01-27T13:41:37Z"
      
      [[1]][[79]]$node$author
      [[1]][[79]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[1]][[79]]$node$additions
      [1] 285
      
      [[1]][[79]]$node$deletions
      [1] 81
      
      
      
      [[1]][[80]]
      [[1]][[80]]$node
      [[1]][[80]]$node$id
      [1] "C_kwDOIvtxstoAKDcwY2ExODJiMjlkN2NhOTcwNjRlMDA5YWY1ZmM1NjU0MGNlZTQyM2U"
      
      [[1]][[80]]$node$committed_date
      [1] "2023-01-27T13:40:00Z"
      
      [[1]][[80]]$node$author
      [[1]][[80]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[80]]$node$additions
      [1] 285
      
      [[1]][[80]]$node$deletions
      [1] 81
      
      
      
      [[1]][[81]]
      [[1]][[81]]$node
      [[1]][[81]]$node$id
      [1] "C_kwDOIvtxstoAKGE3MWNhMGUyMjUxMDk1ZTcwMzRmZTZjZGRkNTA3NTM5NWExYTZiZDI"
      
      [[1]][[81]]$node$committed_date
      [1] "2023-01-26T15:01:17Z"
      
      [[1]][[81]]$node$author
      [[1]][[81]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[1]][[81]]$node$additions
      [1] 522
      
      [[1]][[81]]$node$deletions
      [1] 43
      
      
      
      [[1]][[82]]
      [[1]][[82]]$node
      [[1]][[82]]$node$id
      [1] "C_kwDOIvtxstoAKDQyNDEyNWRiMTE5M2Q2MDJjYTM0ZTM4ZjhlZjZhOTZhNjhjYTczYmM"
      
      [[1]][[82]]$node$committed_date
      [1] "2023-01-26T12:03:04Z"
      
      [[1]][[82]]$node$author
      [[1]][[82]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[82]]$node$additions
      [1] 17
      
      [[1]][[82]]$node$deletions
      [1] 0
      
      
      
      [[1]][[83]]
      [[1]][[83]]$node
      [[1]][[83]]$node$id
      [1] "C_kwDOIvtxstoAKDhiMjQ2MjEzMGE2YWRkYTUzYjFiZDIwZmRkZGRhNjM3NmZiMmE4ZjQ"
      
      [[1]][[83]]$node$committed_date
      [1] "2023-01-26T11:37:52Z"
      
      [[1]][[83]]$node$author
      [[1]][[83]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[83]]$node$additions
      [1] 7
      
      [[1]][[83]]$node$deletions
      [1] 7
      
      
      
      [[1]][[84]]
      [[1]][[84]]$node
      [[1]][[84]]$node$id
      [1] "C_kwDOIvtxstoAKGJjY2EwZDJlYzdjMGE5ZTFmN2ExY2ZkZGYyZWNiNTYzMDNjZTRhNmI"
      
      [[1]][[84]]$node$committed_date
      [1] "2023-01-26T10:51:16Z"
      
      [[1]][[84]]$node$author
      [[1]][[84]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[84]]$node$additions
      [1] 38
      
      [[1]][[84]]$node$deletions
      [1] 29
      
      
      
      [[1]][[85]]
      [[1]][[85]]$node
      [[1]][[85]]$node$id
      [1] "C_kwDOIvtxstoAKDVjMjk2ZmZiMmRhNTI2MjJjZWZlOWE2NGNkOWM5NTdlODJkN2JmY2Q"
      
      [[1]][[85]]$node$committed_date
      [1] "2023-01-26T10:31:47Z"
      
      [[1]][[85]]$node$author
      [[1]][[85]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[85]]$node$additions
      [1] 270
      
      [[1]][[85]]$node$deletions
      [1] 8
      
      
      
      [[1]][[86]]
      [[1]][[86]]$node
      [[1]][[86]]$node$id
      [1] "C_kwDOIvtxstoAKDU2YjA2MmYzOTQwZmU5MTZiYTkwNjg4YjBmMDkzOTdmOTIxNGRjM2Y"
      
      [[1]][[86]]$node$committed_date
      [1] "2023-01-25T14:54:33Z"
      
      [[1]][[86]]$node$author
      [[1]][[86]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[86]]$node$additions
      [1] 28
      
      [[1]][[86]]$node$deletions
      [1] 5
      
      
      
      [[1]][[87]]
      [[1]][[87]]$node
      [[1]][[87]]$node$id
      [1] "C_kwDOIvtxstoAKDM0MTJkNzdkNWFkOTBlMjUxOGY5ZWRiNmFkNTQzNTUzZWQ0MGI4NjU"
      
      [[1]][[87]]$node$committed_date
      [1] "2023-01-25T14:40:59Z"
      
      [[1]][[87]]$node$author
      [[1]][[87]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[87]]$node$additions
      [1] 0
      
      [[1]][[87]]$node$deletions
      [1] 9
      
      
      
      [[1]][[88]]
      [[1]][[88]]$node
      [[1]][[88]]$node$id
      [1] "C_kwDOIvtxstoAKDA4Y2MwMGMyYzgxOWUzYjc4ZTZmNWQ2NmU5MzUxOGU1OTAzZDkwMjM"
      
      [[1]][[88]]$node$committed_date
      [1] "2023-01-25T14:37:07Z"
      
      [[1]][[88]]$node$author
      [[1]][[88]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[88]]$node$additions
      [1] 88
      
      [[1]][[88]]$node$deletions
      [1] 67
      
      
      
      [[1]][[89]]
      [[1]][[89]]$node
      [[1]][[89]]$node$id
      [1] "C_kwDOIvtxstoAKDMyM2M2MWEzOGUxMjMzN2FhNTFjMjBjNDYyNWI1NzA0ZWE4NzRjYjg"
      
      [[1]][[89]]$node$committed_date
      [1] "2023-01-25T14:23:43Z"
      
      [[1]][[89]]$node$author
      [[1]][[89]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[89]]$node$additions
      [1] 14
      
      [[1]][[89]]$node$deletions
      [1] 3
      
      
      
      [[1]][[90]]
      [[1]][[90]]$node
      [[1]][[90]]$node$id
      [1] "C_kwDOIvtxstoAKGZkZWQ2MTE1YmUwNmJhNDFlMzY5NGViNzMwMDk0YTNkMmQwMGI2YzI"
      
      [[1]][[90]]$node$committed_date
      [1] "2023-01-25T13:51:17Z"
      
      [[1]][[90]]$node$author
      [[1]][[90]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[90]]$node$additions
      [1] 47
      
      [[1]][[90]]$node$deletions
      [1] 94
      
      
      
      [[1]][[91]]
      [[1]][[91]]$node
      [[1]][[91]]$node$id
      [1] "C_kwDOIvtxstoAKDc2ODA5NzQxMWI0Yjg1ZWM5ZTNlZmExMGM3MWZmMGIzM2VkMzVhOTc"
      
      [[1]][[91]]$node$committed_date
      [1] "2023-01-25T13:09:15Z"
      
      [[1]][[91]]$node$author
      [[1]][[91]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[91]]$node$additions
      [1] 11
      
      [[1]][[91]]$node$deletions
      [1] 0
      
      
      
      [[1]][[92]]
      [[1]][[92]]$node
      [[1]][[92]]$node$id
      [1] "C_kwDOIvtxstoAKDBkMjFjOWMwYTEzM2NkNzJlOTIwOGE1MDhjZWZjMDJlNWVkNGUxZjM"
      
      [[1]][[92]]$node$committed_date
      [1] "2023-01-25T12:50:17Z"
      
      [[1]][[92]]$node$author
      [[1]][[92]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[92]]$node$additions
      [1] 24
      
      [[1]][[92]]$node$deletions
      [1] 15
      
      
      
      [[1]][[93]]
      [[1]][[93]]$node
      [[1]][[93]]$node$id
      [1] "C_kwDOIvtxstoAKGYyYTc0NDBhYmQwNDdmOTQyNWU5NWI1ODY1ZGRkNGYwZTQyMzZjNWQ"
      
      [[1]][[93]]$node$committed_date
      [1] "2023-01-25T12:19:15Z"
      
      [[1]][[93]]$node$author
      [[1]][[93]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[1]][[93]]$node$additions
      [1] 165
      
      [[1]][[93]]$node$deletions
      [1] 157
      
      
      
      [[1]][[94]]
      [[1]][[94]]$node
      [[1]][[94]]$node$id
      [1] "C_kwDOIvtxstoAKDFjM2VmOWRlNTI5OGI1ZjI4NTUwZDllMDMzOGQxNDMwMWI1Mjk4MDU"
      
      [[1]][[94]]$node$committed_date
      [1] "2023-01-25T11:55:46Z"
      
      [[1]][[94]]$node$author
      [[1]][[94]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[94]]$node$additions
      [1] 167
      
      [[1]][[94]]$node$deletions
      [1] 159
      
      
      
      [[1]][[95]]
      [[1]][[95]]$node
      [[1]][[95]]$node$id
      [1] "C_kwDOIvtxstoAKGUzMTNmZjJjZThkZjAyN2Q4NGQyYjY4N2JlNGM1MmMwMTFjNTA4Mzc"
      
      [[1]][[95]]$node$committed_date
      [1] "2023-01-25T11:46:06Z"
      
      [[1]][[95]]$node$author
      [[1]][[95]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[95]]$node$additions
      [1] 2
      
      [[1]][[95]]$node$deletions
      [1] 1
      
      
      
      [[1]][[96]]
      [[1]][[96]]$node
      [[1]][[96]]$node$id
      [1] "C_kwDOIvtxstoAKGI5MjQ1ZGQ4ZGNhNjcxMDQ5MzhiNDQ5YTE3OTYwN2VjYzg3Mzc2ODU"
      
      [[1]][[96]]$node$committed_date
      [1] "2023-01-25T11:28:26Z"
      
      [[1]][[96]]$node$author
      [[1]][[96]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[96]]$node$additions
      [1] 7
      
      [[1]][[96]]$node$deletions
      [1] 8
      
      
      
      [[1]][[97]]
      [[1]][[97]]$node
      [[1]][[97]]$node$id
      [1] "C_kwDOIvtxstoAKDAxNTFlZjI4M2QzYThiODgyOTIxNjM4Y2ZkZWYzMTBhNmU2M2MyMGE"
      
      [[1]][[97]]$node$committed_date
      [1] "2023-01-25T11:18:28Z"
      
      [[1]][[97]]$node$author
      [[1]][[97]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[97]]$node$additions
      [1] 42
      
      [[1]][[97]]$node$deletions
      [1] 41
      
      
      
      [[1]][[98]]
      [[1]][[98]]$node
      [[1]][[98]]$node$id
      [1] "C_kwDOIvtxstoAKGI3MDJkNzE2NzM2YTRkNGI2M2Q4YmQ5NmY3YmMwN2YzOTU1NGUxMzE"
      
      [[1]][[98]]$node$committed_date
      [1] "2023-01-25T10:35:36Z"
      
      [[1]][[98]]$node$author
      [[1]][[98]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[98]]$node$additions
      [1] 5
      
      [[1]][[98]]$node$deletions
      [1] 3
      
      
      
      [[1]][[99]]
      [[1]][[99]]$node
      [[1]][[99]]$node$id
      [1] "C_kwDOIvtxstoAKDFlZTU5MTlmZmQxMzMxOGE4YTE0OTE5NDI3OGZlNTRlMzA3MTUwY2U"
      
      [[1]][[99]]$node$committed_date
      [1] "2023-01-25T10:26:41Z"
      
      [[1]][[99]]$node$author
      [[1]][[99]]$node$author$name
      [1] "maciekbanas"
      
      
      [[1]][[99]]$node$additions
      [1] 116
      
      [[1]][[99]]$node$deletions
      [1] 111
      
      
      
      [[1]][[100]]
      [[1]][[100]]$node
      [[1]][[100]]$node$id
      [1] "C_kwDOIvtxstoAKGMzNmMyNWRmNDFjNzBiNzU3OTc4MWQzMTdhYWEwZjhkODRlZWM2ZTY"
      
      [[1]][[100]]$node$committed_date
      [1] "2023-01-25T08:52:01Z"
      
      [[1]][[100]]$node$author
      [[1]][[100]]$node$author$name
      [1] "Maciej Banaś"
      
      
      [[1]][[100]]$node$additions
      [1] 2
      
      [[1]][[100]]$node$deletions
      [1] 2
      
      
      
      

# `pull_repos()` works as expected

    Code
      gh_repos_org <- test_gql_gh$pull_repos(org = "r-world-devs", settings = settings)
    Message
      i [GitHub][Engine:GraphQL][org:r-world-devs] Pulling repositories...

---

    Code
      gh_repos_team <- test_gql_gh$pull_repos(org = "r-world-devs", settings = settings)
    Message
      i [GitHub][Engine:GraphQL][org:r-world-devs][team:] Pulling repositories...

# `pull_commits()` retrieves commits in the table format

    Code
      commits_table <- test_gql_gh$pull_commits(org = "r-world-devs", date_from = "2023-01-01",
        date_until = "2023-02-28", settings = settings)
    Message
      i [GitHub][Engine:GraphQL][org:r-world-devs] Pulling commits...

