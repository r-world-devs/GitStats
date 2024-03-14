# When token is empty throw error

    Code
      test_rest_priv$check_token("")
    Condition
      Error in `test_rest_priv$check_token()`:
      i No token provided.

# check_endpoint returns warning and NULL if they are not correct

    Code
      object <- test_rest_priv$check_endpoint(repo = "r-worlddevs/GitStats")
    Message
      x Repository you provided does not exist or its name was passed in a wrong way: https://api.github.com/repos/r-worlddevs/GitStats
      ! Please type your repository name as you see it in `url`.
      i E.g. do not use spaces. Repository names as you see on the page may differ from their 'address' name.
      HTTP 404 No such address

# check_organizations returns NULL if orgs are wrong

    Code
      org <- test_rest$check_organizations("does_not_exist")
    Message
      x Organization you provided does not exist or its name was passed in a wrong way: https://gitlab.com/api/v4/groups/does_not_exist
      ! Please type your organization name as you see it in `url`.
      i E.g. do not use spaces. Organization names as you see on the page may differ from their 'address' name.
      HTTP 404 No such address

