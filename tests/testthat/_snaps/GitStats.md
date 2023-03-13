# GitStats prints the proper info.

    Code
      test_gitstats
    Output
      A <GitStats> object for 2 clients:
      Clients: https://api.github.com, https://gitlab.com/api/v4
      Organisations: r-world-devs, openpharma, mbtests
      Search preference: <not defined>
      Team: <not defined>
      Storage: <not defined>
      Storage On/Off: OFF

# GitStats prints team name when team is added.

    Code
      test_gitstats
    Output
      A <GitStats> object for 2 clients:
      Clients: https://api.github.com, https://gitlab.com/api/v4
      Organisations: r-world-devs, openpharma, mbtests
      Search preference: <not defined>
      Team: RWD-IE
      Storage: <not defined>
      Storage On/Off: OFF

# GitStats prints storage properly.

    Code
      test_gitstats
    Output
      A <GitStats> object for 2 clients:
      Clients: https://api.github.com, https://gitlab.com/api/v4
      Organisations: r-world-devs, openpharma, mbtests
      Search preference: <not defined>
      Team: RWD-IE
      Storage: SQLiteConnection
      Storage On/Off: ON

