# `reset()` resets all settings

    Code
      reset(test_gitstats)
    Message
      i Reset settings to default.
    Output
      A GitStats object for 2 hosts: 
      Hosts: https://api.github.com, https://gitlab.com/api/v4
      Scanning scope: 
       Organizations: [3] r-world-devs, openpharma, mbtests
       Repositories: [0] 
       Files: <not defined>
      Search settings: 
       Search parameter: org
       Phrase: <not defined>
       Language: All
       Team: <not defined>
      Storage: <no tables in storage>

---

    Code
      reset(test_gitstats)
    Message
      i Reset settings to default.
    Output
      A GitStats object for 2 hosts: 
      Hosts: https://api.github.com, https://gitlab.com/api/v4
      Scanning scope: 
       Organizations: [3] r-world-devs, openpharma, mbtests
       Repositories: [0] 
       Files: <not defined>
      Search settings: 
       Search parameter: org
       Phrase: <not defined>
       Language: All
       Team: <not defined>
      Storage: <no tables in storage>

# `reset_language()` resets language settings to 'All'

    Code
      reset_language(test_gitstats)
    Message
      i Setting language parameter to 'All'.
    Output
      A GitStats object for 2 hosts: 
      Hosts: https://api.github.com, https://gitlab.com/api/v4
      Scanning scope: 
       Organizations: [3] r-world-devs, openpharma, mbtests
       Repositories: [0] 
       Files: <not defined>
      Search settings: 
       Search parameter: phrase
       Phrase: test-phrase
       Language: All
       Team: <not defined>
      Storage: <no tables in storage>

