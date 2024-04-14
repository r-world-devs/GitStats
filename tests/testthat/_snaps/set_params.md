# Setting up settings to `orgs` works correctly

    Code
      set_params(test_gitstats, search_mode = "org")
    Message
      v Your search mode set to org.
    Output
      A GitStats object for 0 hosts: 
      Hosts: 
      Scanning scope: 
       Organizations: [0] 
       Repositories: [0] 
       Files: <not defined>
      Search mode: org
      Verbose: TRUE
      Use storage: TRUE
      Storage: <no tables in storage>

# Setting up settings to `code` works correctly

    Code
      set_params(test_gitstats, search_mode = "code")
    Message
      v Your search mode set to code.
    Output
      A GitStats object for 0 hosts: 
      Hosts: 
      Scanning scope: 
       Organizations: [0] 
       Repositories: [0] 
       Files: <not defined>
      Search mode: code
      Verbose: TRUE
      Use storage: TRUE
      Storage: <no tables in storage>

# Setting up `files` works correctly

    Code
      set_params(test_gitstats, files = c("DESCRIPTION", "NAMESPACE"))
    Message
      i Set files DESCRIPTION and NAMESPACE to scan.
    Output
      A GitStats object for 0 hosts: 
      Hosts: 
      Scanning scope: 
       Organizations: [0] 
       Repositories: [0] 
       Files: [2] DESCRIPTION, NAMESPACE
      Search mode: code
      Verbose: TRUE
      Use storage: TRUE
      Storage: <no tables in storage>

