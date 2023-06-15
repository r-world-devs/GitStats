GitStats 0.2.0

- added switching to REST engine in case GraphQL fails with 502 error (for repos #227)
- added GraphQL engine for getting GitLab repos by organization (#233)
- add getting user feature via GraphQL engine for GitHub and GitLab

GitStats 0.1.0

This is the first release of GitStats with given features:

- `create_gitstats()` - creating GitStats object,
- `set_connection()` - adding hosts to GitStats object,
- `setup()` - setting search parameter to org, team or phrase, setting programming language of repositories,
- `get_repos()` - pulling repositories from GitHub and GitLab API in a standardized table,
- `get_commits()` - pulling commits from GitHub and GitLab API in a standardized table,
- `add_team_member()` - adding team members to GitStats object.
