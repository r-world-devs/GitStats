test_error_fixtures <- list()

test_error_fixtures$graphql_error_no_groups <- list(
  "errors" = list(
    list(
      "message" = "Field 'groups' doesn't exist on type 'Query'",
      "locations" = list(
        list(
          "line" = 2L,
          "column" = 13L
        )
      ),
      "path" = list(
        "query GetGroups",
        "groups"
      ),
      "extensions" = list(
        "code" = "undefinedField",
        "typeName" = "Query",
        "fieldName" = "groups"
      )
    ),
    list(
      "message" = "Variable $groupCursor is declared by GetGroups but not used",
      "locations" = list(
        list(
          "line" = 1L,
          "column" = 1L
        )
      ),
      "path" = list(
        "query GetGroups"
      ),
      "extensions" = list(
        "code" = "variableNotUsed",
        "variableName" = "groupCursor"
      )
    )
  )
)

test_error_fixtures$graphql_error_no_count_languages <- list(
  "errors" = list(
    list(
      "message" = "Field 'count' doesn't exist on type 'ProjectConnection'",
      "locations" = list(
        list(
          "line" = 6L,
          "column" = 7L
        )
      ),
      "path" = list(
        "query GetReposByOrg",
        "group",
        "projects",
        "count"
      ),
      "extensions" = list(
        "code" = "undefinedField",
        "typeName" = "ProjectConnection",
        "fieldName" = "count"
      )
    ),
    list(
      "message" = "Field 'languages' doesn't exist on type 'Project'",
      "locations" = list(
        list(
          "line" = 25L,
          "column" = 11L
        )
      ),
      "path" = list(
        "query GetReposByOrg",
        "group",
        "projects",
        "edges",
        "node",
        "languages"
      ),
      "extensions" = list(
        "code" = "undefinedField",
        "typeName" = "Project",
        "fieldName" = "languages"
      )
    )
  )
)
