# add_team_member() adds team member in `GitStats` object

    Code
      add_team_member(test_gitstats, "John Test")
    Message <cliMessage>
      v John Test successfully added to team.

---

    Code
      test_gitstats$team
    Output
      $`John Test`
      $`John Test`$name
      [1] "John Test"
      
      $`John Test`$logins
      NULL
      
      

---

    Code
      add_team_member(test_gitstats, "George Test", "george_test")
    Message <cliMessage>
      v George Test successfully added to team.

---

    Code
      test_gitstats$team
    Output
      $`John Test`
      $`John Test`$name
      [1] "John Test"
      
      $`John Test`$logins
      NULL
      
      
      $`George Test`
      $`George Test`$name
      [1] "George Test"
      
      $`George Test`$logins
      [1] "george_test"
      
      

