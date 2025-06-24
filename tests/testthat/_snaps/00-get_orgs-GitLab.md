# groups GitLab query is built properly

    Code
      gl_orgs_query
    Output
      [1] "query GetGroups($groupCursor: String!) {\n            groups (after: $groupCursor) {\n              pageInfo {\n                endCursor\n                hasNextPage\n              }\n              edges {\n                node {\n      name\n      description\n      fullPath\n      webUrl\n      projectsCount\n      groupMembersCount\n      avatarUrl\n    }\n              }\n            }\n        }"

# group GitLab query is built properly

    Code
      gl_org_query
    Output
      [1] "\n      query GetGroup($org: ID!) {\n        group(fullPath: $org) {\n      name\n      description\n      fullPath\n      webUrl\n      projectsCount\n      groupMembersCount\n      avatarUrl\n    }\n      }\n    "

# get_orgs_count prints message

    Code
      orgs_count <- test_rest_gitlab$get_orgs_count(verbose = TRUE)
    Message
      > [Host:GitLab][Engine:REST] Pulling number of all organizations...

# get_orgs prints message

    Code
      gl_orgs_full_response <- test_graphql_gitlab$get_orgs(orgs_count = 3L, output = "full_table",
        verbose = TRUE, progress = FALSE)
    Message
      > [Host:GitLab][Engine:GraphQL] Pulling organizations...

# if get_orgs runs into GraphQL error, it prints warning

    Code
      gl_orgs_error_response <- test_graphql_gitlab$get_orgs(orgs_count = 3L, output = "full_table",
        verbose = TRUE, progress = FALSE)
    Message
      > [Host:GitLab][Engine:GraphQL] Pulling organizations...
      x GraphQL returned errors.
      i Your GraphQL does not recognize [groups] field.
      ! Check version of your GitLab.

# get_org prints proper message

    Code
      gl_org_response <- test_graphql_gitlab$get_org(org = org, verbose = TRUE)
    Message
      > [Host:GitLab][Engine:GraphQL] Pulling test_org organization...

---

    Code
      gl_org_response <- test_rest_gitlab$get_org(org = org, verbose = TRUE)
    Message
      > [Host:GitLab][Engine:REST] Pulling test_org organization...

# REST method prints message

    Code
      gl_orgs_rest_list <- test_rest_gitlab$get_orgs(orgs_count = 300L, verbose = TRUE,
        progress = FALSE)
    Message
      > [Host:GitLab][Engine:REST] Pulling organizations...

# if get_orgs_from_host runs into GraphQL error, it switches to REST API

    Code
      gitlab_orgs_vec <- gitlab_test_host_priv_2$get_orgs_from_host(output = "only_names",
        verbose = TRUE)
    Message
      > [Host:GitLab][Engine:REST] Pulling number of all organizations...
      i  organizations found.
      i Switching to REST API

---

    Code
      gitlab_orgs_table <- gitlab_test_host_priv_2$get_orgs_from_host(output = "full_table",
        verbose = TRUE)
    Message
      > [Host:GitLab][Engine:REST] Pulling number of all organizations...
      i  organizations found.
      i Switching to REST API

# get_orgs_from_host prints message on number of organizations

    Code
      gitlab_orgs_table <- gitlab_testhost_priv$get_orgs_from_host(output = "full_table",
        verbose = TRUE)
    Message
      i 3 organizations found.

# get_orgs_from_orgs_and_repos prints message when turning to REST engine

    Code
      gitlab_orgs_from_orgs_table <- gitlab_testhost_priv$
      get_orgs_from_orgs_and_repos(verbose = TRUE)
    Message
      i Switching to REST API
      i Switching to REST API
      i Switching to REST API
      i Switching to REST API
      i Switching to REST API
      i Switching to REST API

# get_orgs_from_host returns error when GitHost is public

    This feature is not applicable for public hosts.

