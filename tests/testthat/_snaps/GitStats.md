# GitStats prints empty fields.

    Code
      test_gitstats
    Output
      A <GitStats> object for 0 hosts:
      Hosts: 
      Organisations: 
      Search preference: org
      Team: <not defined>
      Phrase: <not defined>
      Language: <not defined>
      Repositories output: <not defined>
      Commits output: <not defined>

# GitStats prints the proper info when connections are added.

    Code
      test_gitstats
    Output
      A <GitStats> object for 2 hosts:
      Hosts: https://api.github.com, https://gitlab.com/api/v4
      Organisations: r-world-devs, openpharma, mbtests
      Search preference: org
      Team: <not defined>
      Phrase: <not defined>
      Language: <not defined>
      Repositories output: <not defined>
      Commits output: <not defined>

# GitStats prints team name when team is added.

    Code
      test_gitstats
    Output
      A <GitStats> object for 2 hosts:
      Hosts: https://api.github.com, https://gitlab.com/api/v4
      Organisations: r-world-devs, openpharma, mbtests
      Search preference: team
      Team: RWD-IE (0 members)
      Phrase: <not defined>
      Language: <not defined>
      Repositories output: <not defined>
      Commits output: <not defined>

# check_for_host works

    Add first your hosts with `set_connection()`.

