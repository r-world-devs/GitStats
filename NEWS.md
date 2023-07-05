GitStats 0.1.0.9000

- added switching to REST engine in case GraphQL fails with 502 error (I: #225 PR for repos: #227)
- added GraphQL engine for getting GitLab repos by organization (I: #218 PR: #233)
- added `get_users()` function to pull information on users (I: #199 PR: #238)
- removed `contributors` as basic stat when pulling `repos` and added `add_repos_contributors()` user function and `add_contributors` parameter to `get_repos()` function to add conditionally information on contributors to repositories table (I: #235 PR: #243)
- OOP optimization: moved method on adding issues do repository table via REST to privates (I: #235 PR: #243)

GitStats 0.1.0

This is the first release of GitStats with given features:

- `create_gitstats()` - creating GitStats object,
- `set_connection()` - adding hosts to GitStats object,
- `setup()` - setting search parameter to org, team or phrase, setting programming language of repositories,
- `get_repos()` - pulling repositories from GitHub and GitLab API in a standardized table,
- `get_commits()` - pulling commits from GitHub and GitLab API in a standardized table,
- `add_team_member()` - adding team members to GitStats object.
