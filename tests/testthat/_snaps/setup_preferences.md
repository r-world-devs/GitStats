# Setting up parameters to `team` throws error when team_name is not defined

    You need to define your `team_name`.

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
      Team: RWD-IE (0 members)
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
      Team: RWD-IE (0 members)
      Phrase: covid
      Language: Python
      Storage: <not defined>
      Storage On/Off: OFF

