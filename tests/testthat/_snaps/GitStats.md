# GitStats prints empty fields.

    Code
      test_gitstats
    Output
      A <GitStats> object for 0 clients:
      Clients: 
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
      Clients: https://api.github.com, https://gitlab.com/api/v4
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
      Clients: https://api.github.com, https://gitlab.com/api/v4
      Organisations: r-world-devs, openpharma, mbtests
      Search preference: org
      Team: RWD-IE
      Phrase: <not defined>
      Language: <not defined>
      Storage: <not defined>
      Storage On/Off: OFF

# GitStats prints storage properly.

    Code
      test_gitstats
    Output
      A <GitStats> object for 2 clients:
      Clients: https://api.github.com, https://gitlab.com/api/v4
      Organisations: r-world-devs, openpharma, mbtests
      Search preference: org
      Team: RWD-IE
      Phrase: <not defined>
      Language: <not defined>
      Storage: SQLiteConnection
      Storage On/Off: ON
