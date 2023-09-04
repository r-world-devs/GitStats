# `reset()` resets all settings

    Code
      reset(test_gitstats)
    Message <cliMessage>
      i Reset settings to default.
    Output
      A <GitStats> object for 2 hosts:
      Hosts: https://api.github.com, https://gitlab.com/api/v4
      Organisations: [3] r-world-devs, openpharma, mbtests
      Search preference: org
      Team: <not defined>
      Phrase: <not defined>
      Language: All
      Repositories output: <not defined>
      Commits output: <not defined>

---

    Code
      reset(test_gitstats)
    Message <cliMessage>
      i Reset settings to default.
    Output
      A <GitStats> object for 2 hosts:
      Hosts: https://api.github.com, https://gitlab.com/api/v4
      Organisations: [3] r-world-devs, openpharma, mbtests
      Search preference: org
      Team: <not defined>
      Phrase: <not defined>
      Language: All
      Repositories output: <not defined>
      Commits output: <not defined>

# `reset_language()` resets language settings to 'All'

    Code
      reset_language(test_gitstats)
    Message <cliMessage>
      i Setting language parameter to 'All'.
    Output
      A <GitStats> object for 2 hosts:
      Hosts: https://api.github.com, https://gitlab.com/api/v4
      Organisations: [3] r-world-devs, openpharma, mbtests
      Search preference: phrase
      Team: <not defined>
      Phrase: test-phrase
      Language: All
      Repositories output: <not defined>
      Commits output: <not defined>

