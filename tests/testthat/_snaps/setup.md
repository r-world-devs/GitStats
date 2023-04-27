# Setting up settings to `team` throws error when team_name is not defined

    You need to define your `team_name`.

# Setting up settings to `phrase` works correctly

    Code
      setup(test_gitstats, search_param = "phrase", phrase = "covid")
    Message <cliMessage>
      v Your search preferences set to phrase: covid.
    Output
      A <GitStats> object for 0 hosts:
      Hosts: 
      Organisations: 
      Search preference: phrase
      Team: RWD-IE (0 members)
      Phrase: covid
      Language: <not defined>
      Repositories output: <not defined>
      Commits output: <not defined>

# Setting language works correctly

    Code
      setup(test_gitstats, language = "Python")
    Message <cliMessage>
      v Your programming language is set to <Python>.
    Output
      A <GitStats> object for 0 hosts:
      Hosts: 
      Organisations: 
      Search preference: org
      Team: RWD-IE (0 members)
      Phrase: covid
      Language: Python
      Repositories output: <not defined>
      Commits output: <not defined>
