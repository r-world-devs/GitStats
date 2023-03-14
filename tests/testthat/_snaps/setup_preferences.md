# Setting up parameters to `team` throws warning when team is not defined

    Code
      setup_preferences(test_gitstats, search_param = "team")
    Message <cliMessage>
      v Your search preferences set to team.
      ! You did not define your team.
    Output
      A <GitStats> object for 0 clients:
      Clients: 
      Organisations: 
      Search preference: team
      Team: <not defined>
      Phrase: <not defined>
      Language: <not defined>
      Storage: <not defined>
      Storage On/Off: OFF

# Setting up parameters to `team` throws only success when team is defined

    Code
      setup_preferences(test_gitstats, search_param = "team", team = c("maciekbanas",
        "kalimu", "Cotau", "marcinkowskak", "galachad", "krystian8207"))
    Message <cliMessage>
      v Your search preferences set to team.
    Output
      A <GitStats> object for 0 clients:
      Clients: 
      Organisations: 
      Search preference: team
      Team: <not defined>
      Phrase: <not defined>
      Language: <not defined>
      Storage: <not defined>
      Storage On/Off: OFF

# Setting up parameters to `phrase` works correctly

    Code
      setup_preferences(test_gitstats, search_param = "phrase", phrase = "covid")
    Message <cliMessage>
      v Your search preferences set to phrase: covid.
    Output
      A <GitStats> object for 0 clients:
      Clients: 
      Organisations: 
      Search preference: phrase
      Team: <not defined>
      Phrase: covid
      Language: <not defined>
      Storage: <not defined>
      Storage On/Off: OFF

# Setting language works correctly

    Code
      setup_preferences(test_gitstats, language = "Python")
    Message <cliMessage>
      v Your language is set to <Python>.
    Output
      A <GitStats> object for 0 clients:
      Clients: 
      Organisations: 
      Search preference: org
      Team: <not defined>
      Phrase: covid
      Language: Python
      Storage: <not defined>
      Storage On/Off: OFF

