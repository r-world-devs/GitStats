# `GitStats$check_storage()` finds tables in db

    Code
      test_gitstats_priv$check_storage("test_table")
    Message <simpleMessage>
      `test_table` is stored in your local database.
    Message <cliMessage>
      ! No clients found in database table.
    Message <simpleMessage>
      All commits will be pulled from API.
    Output
      NULL

# `GitStats$check_storage()` does not find table in db

    Code
      test_gitstats_priv$check_storage("test_table_non_existent")
    Message <simpleMessage>
      `test_table_non_existent` not found in local database. All commits will be pulled from API.
    Output
      NULL

# `GitStats$check_storage_clients()` finds clients (api urls) in db

    Code
      test_gitstats_priv$check_storage_clients(test_table)
    Message <cliMessage>
      v Clients already in database table.
    Output
        id organisation repository                api_url
      1  1 r-world-devs       Test https://api.github.com
      2  2 r-world-devs       Test https://api.github.com
      3  3 r-world-devs       Test https://api.github.com

# `GitStats$check_storage_clients()` does not find all clients (api urls) in db

    Code
      test_gitstats_priv$check_storage_clients(test_table)
    Message <cliMessage>
      ! Not all clients found in database table.
    Output
      NULL

# `GitStats$check_storage_clients()` finds none of clients (api urls) in db

    Code
      test_gitstats_priv$check_storage_clients(test_table)
    Message <cliMessage>
      ! No clients found in database table.
    Output
      NULL

# `GitStats$check_storage()` finds table, but does not find clients

    Code
      test_gitstats_priv$check_storage("test_table")
    Message <simpleMessage>
      `test_table` is stored in your local database.
    Message <cliMessage>
      ! No clients found in database table.
    Message <simpleMessage>
      All commits will be pulled from API.
    Output
      NULL

# `GitStats$check_storage_orgs()` finds organizations in db

    Code
      test_gitstats_priv$check_storage_orgs(test_table)
    Message <cliMessage>
      v Organizations already in database table.
    Output
        id organisation repository                api_url
      1  1 r-world-devs       Test https://api.github.com
      2  2 r-world-devs       Test https://api.github.com
      3  3 r-world-devs       Test https://api.github.com

# `GitStats$check_storage_orgs()` does not find all organizations in db

    Code
      test_gitstats_priv$check_storage_orgs(test_table)
    Message <cliMessage>
      ! Not all organizations found in database table.
    Output
      NULL

# `GitStats$check_storage_orgs()` finds none of organizations in db

    Code
      test_gitstats_priv$check_storage_orgs(test_table)
    Message <cliMessage>
      ! No organizations found in database table.
    Output
      NULL

# `GitStats$check_storage()` finds table, but does not find orgs

    Code
      test_gitstats_priv$check_storage("test_table")
    Message <simpleMessage>
      `test_table` is stored in your local database.
    Message <cliMessage>
      v Clients already in database table.
      ! No organizations found in database table.
    Message <simpleMessage>
      All commits will be pulled from API.
    Output
      NULL

