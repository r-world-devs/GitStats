# When token is empty throw error and do not pass connection

    Code
      test_rest_priv$check_token("")
    Error <rlang_error>
      i No token provided.
      x Host will not be passed to `GitStats` object.

