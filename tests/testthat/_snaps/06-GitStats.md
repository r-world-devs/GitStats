# GitStats prints empty fields.

    Code
      test_gitstats
    Output
      A <GitStats> object for 0 hosts:
      Hosts: 
      Organisations: [0] 
      Search preference: org
      Team: <not defined>
      Phrase: <not defined>
      Language: All
      Repositories output: <not defined>
      Commits output: <not defined>

# GitStats prints the proper info when connections are added.

    Code
      test_gitstats
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

# GitStats prints team name when team is added.

    Code
      test_gitstats
    Output
      A <GitStats> object for 2 hosts:
      Hosts: https://api.github.com, https://gitlab.com/api/v4
      Organisations: [3] r-world-devs, openpharma, mbtests
      Search preference: team
      Team: RWD-IE (0 members)
      Phrase: <not defined>
      Language: All
      Repositories output: <not defined>
      Commits output: <not defined>

# check_for_host works

    Add first your hosts with `set_host()`.

# GitStats throws error when pull_repos_contributors is run with empty repos field

    You need to pull repos first with `pull_repos()`.

# Add_repos_contributors adds repos contributors to repos table

    Code
      test_gitstats$pull_repos_contributors()
    Message
      i [GitHub][Engine:REST] Pulling contributors...
      i [GitLab][Engine:REST] Pulling contributors...

# subgroups are cleanly printed in GitStats

    Code
      test_gitstats
    Output
      A <GitStats> object for 1 hosts:
      Hosts: https://gitlab.com/api/v4
      Organisations: [1] mbtests/subgroup
      Search preference: org
      Team: <not defined>
      Phrase: <not defined>
      Language: All
      Repositories output: <not defined>
      Commits output: <not defined>

