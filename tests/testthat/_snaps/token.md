# When token is empty throw error and do not pass connection

    Code
      test_host$check_token("")
    Error <rlang_error>
      i No token provided.
      x Host will not be passed to `GitStats` object.

# Warning shows up, when token is invalid

    Code
      test_host$check_token("INVALID_TOKEN")
    Error <rlang_error>
      i Token provided for ... is invalid.
      x Host will not be passed to `GitStats` object.

