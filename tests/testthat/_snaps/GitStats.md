# GitStats prints empty fields.

    Code
      test_gitstats
    Output
      A <GitStats> object for 0 clients:
      Hosts: 
      Organisations: 
      Search preference: org
      Team: <not defined>
      Phrase: <not defined>
      Language: <not defined>
      Storage: <not defined>
      Storage On/Off: OFF

# GitStats prints the proper info when connections are added.

    Code
      test_gitstats
    Output
      A <GitStats> object for 2 clients:
      Hosts: https://api.github.com, https://gitlab.com/api/v4
      Organisations: r-world-devs, openpharma, mbtests
      Search preference: org
      Team: <not defined>
      Phrase: <not defined>
      Language: <not defined>
      Storage: <not defined>
      Storage On/Off: OFF

# GitStats prints team name when team is added.

    Code
      test_gitstats
    Output
      A <GitStats> object for 2 clients:
      Hosts: https://api.github.com, https://gitlab.com/api/v4
      Organisations: r-world-devs, openpharma, mbtests
      Search preference: team
      Team: RWD-IE (0 members)
      Phrase: <not defined>
      Language: <not defined>
      Storage: <not defined>
      Storage On/Off: OFF

