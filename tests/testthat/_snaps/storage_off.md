# Switch storage on and off works

    Code
      test_gitstats %>% set_storage(type = "SQLite", dbname = "storage/test_db.sqlite") %>%
        storage_off()
    Message <simpleMessage>
      Storage will not be used.

