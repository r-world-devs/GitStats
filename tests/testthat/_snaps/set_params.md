# Setting up settings to `team` throws error when team_name is not defined

    You need to define your `team_name`.

# Setting up settings to `phrase` works correctly

    Code
      set_params(test_gitstats, search_param = "phrase", phrase = "covid")
    Message
      v Your search preferences set to phrase: covid.
    Output
      A <GitStats> object for 0 hosts:
      Hosts: 
      Organisations: [0] 
      Repositories: [0] 
      Search parameter: phrase
      Team: RWD-IE (0 members)
      Phrase: covid
      Language: All
      Repositories output: <not defined>
      Commits output: <not defined>

# Setting language works correctly

    Code
      set_params(test_gitstats, language = "Python")
    Message
      v Your programming language is set to Python.
    Output
      A <GitStats> object for 0 hosts:
      Hosts: 
      Organisations: [0] 
      Repositories: [0] 
      Search parameter: org
      Team: RWD-IE (0 members)
      Phrase: covid
      Language: Python
      Repositories output: <not defined>
      Commits output: <not defined>

# Setting language to 'All' resets language settings

    Code
      set_params(test_gitstats, language = "All")
    Output
      A <GitStats> object for 0 hosts:
      Hosts: 
      Organisations: [0] 
      Repositories: [0] 
      Search parameter: org
      Team: RWD-IE (0 members)
      Phrase: covid
      Language: All
      Repositories output: <not defined>
      Commits output: <not defined>

