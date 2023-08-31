# When token is empty throw error

    Code
      test_rest_priv$check_token("")
    Error <rlang_error>
      i No token provided.

# check_organizations returns NULL if orgs are wrong

    Code
      orgs <- test_rest$check_organizations("does_not_exist")
    Message <cliMessage>
      x Organization you provided does not exist or its name was passed in a wrong way: does_not_exist
      ! Please type your organization name as you see it in `url`.
      i E.g. do not use spaces. Organization names as you see on the page may differ from their 'address' name.
    Message <simpleMessage>
      HTTP 404 No such address

