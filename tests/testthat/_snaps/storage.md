# `GitStats$save_storage()` saves table to db

    Code
      test_gitstats_priv$save_storage(test_commits, "test_commits")
    Message <cliMessage>
      v `test_commits` saved to local database.

---

    Code
      test_gitstats_priv$save_storage(commits_before, "commits_by_org")
    Message <cliMessage>
      v `commits_by_org` saved to local database.

# `GitStats$save_storage()` appends table to db

    Code
      test_gitstats_priv$save_storage(test_commits_new, "test_commits", append = TRUE)
    Message <cliMessage>
      v `test_commits` appended to local database.

# `GitStats$check_storage()` finds tables in db

    Code
      test_gitstats_priv$check_storage("test_commits")
    Message <cliMessage>
      i `test_commits` is stored in your local database.
      ! No clients found in database table.
      i All commits will be pulled from API.
    Output
      NULL

# `GitStats$check_storage()` does not find table in db

    Code
      test_gitstats_priv$check_storage("test_table_non_existent")
    Message <cliMessage>
      i `test_table_non_existent` not found in local database. All commits will be pulled from API.
    Output
      NULL

# `GitStats$check_storage_clients()` finds clients (api urls) in db and returns output (table)

    Code
      test_gitstats_priv$check_storage_clients(test_commits)
    Message <cliMessage>
      v Clients already in database table.
    Output
        id organisation repository committed_date additions deletions
      1  1 r-world-devs       Test     2022-03-01        12        20
      2  2 r-world-devs       Test     2022-10-05        12        20
      3  3 r-world-devs       Test     2022-12-31        12        20
                       api_url
      1 https://api.github.com
      2 https://api.github.com
      3 https://api.github.com

# `GitStats$check_storage_clients()` does not find all clients (api urls) in db

    Code
      test_gitstats_priv$check_storage_clients(test_commits)
    Message <cliMessage>
      ! Not all clients found in database table.
    Output
      NULL

# `GitStats$check_storage_clients()` finds none of clients (api urls) in db

    Code
      test_gitstats_priv$check_storage_clients(test_commits)
    Message <cliMessage>
      ! No clients found in database table.
    Output
      NULL

# `GitStats$check_storage()` finds table, but does not find clients

    Code
      test_gitstats_priv$check_storage("test_commits")
    Message <cliMessage>
      i `test_commits` is stored in your local database.
      ! No clients found in database table.
      i All commits will be pulled from API.
    Output
      NULL

# `GitStats$check_storage_orgs()` finds organizations in db and returns output (table)

    Code
      test_gitstats_priv$check_storage_orgs(test_commits)
    Message <cliMessage>
      v Organizations already in database table.
    Output
        id organisation repository committed_date additions deletions
      1  1 r-world-devs       Test     2022-03-01        12        20
      2  2 r-world-devs       Test     2022-10-05        12        20
      3  3 r-world-devs       Test     2022-12-31        12        20
                       api_url
      1 https://api.github.com
      2 https://api.github.com
      3 https://api.github.com

# `GitStats$check_storage_orgs()` does not find all organizations in db

    Code
      test_gitstats_priv$check_storage_orgs(test_commits)
    Message <cliMessage>
      ! Not all organizations found in database table.
    Output
      NULL

# `GitStats$check_storage_orgs()` finds none of organizations in db

    Code
      test_gitstats_priv$check_storage_orgs(test_commits)
    Message <cliMessage>
      ! No organizations found in database table.
    Output
      NULL

# `GitStats$check_storage()` finds table, but does not find orgs

    Code
      test_gitstats_priv$check_storage("test_commits")
    Message <cliMessage>
      i `test_commits` is stored in your local database.
      v Clients already in database table.
      ! No organizations found in database table.
      i All commits will be pulled from API.
    Output
      NULL

# When storage is set, `GitStats` saves pulled repos to database

    Code
      test_gitstats %>% get_repos(print_out = FALSE)
    Message <cliMessage>
      > [GitHub] Pulling repositories by org...
      v `repos_by_org` saved to local database.

# Switching storage on and off works

    Code
      test_gitstats %>% storage_off()
    Message <simpleMessage>
      Storage will not be used.

