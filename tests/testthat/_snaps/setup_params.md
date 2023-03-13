# Setting up parameters to `team` throws warning when team is not defined

    Code
      setup_preferences(test_gitstats, search_param = "team")
    Message <cliMessage>
      v Your search preferences set to team.
      ! You did not define your team.

# Setting up parameters to `team` throws only success when team is defined

    Code
      setup_preferences(test_gitstats, search_param = "team", team = c("maciekbanas",
        "kalimu", "Cotau", "marcinkowskak", "galachad", "krystian8207"))
    Message <cliMessage>
      v Your search preferences set to team.

# Setting up parameters to `phrase` works correctly

    Code
      setup_preferences(test_gitstats, search_param = "phrase", phrase = "covid")
    Message <cliMessage>
      v Your search preferences set to phrase: covid.

