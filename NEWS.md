# GitStats 1.0.0

## Breaking changes:

### New functions:

- added `get_*_stats` functions to prepare summary stats from pulled data: repositories and commits (I: #276),
- rename and refactor plot functions to one generic `gitstats_plot` which takes as an input `repos_stats` or `commits_stats` class objects (I: #276),

### New names for core functions:

- changed names of `get_*` to `pull_*` functions; `get_*` functions are now to retrieve already pulled data from GitStats object (I: #294),
- changed name of `setup` to `set_params` function (I: #294),
- set new name for `set_connection` function: `set_host` as it is more informative (and shorter) (I: #271),
- changed name of a function: `add_team_member` to `set_team_member` (I: #271).

## Major chagnes:

### New features:

- added setting tokens by default - if a user does have all the PATs set up in environment variables (as e.g. `GITHUB_PAT` or `GITLAB_PAT`), there is no need to pass them as an argument to `set_connection` (I: #120),
- added `pull_users()` function to pull information on users (I: #199),
- added possibility of scanning whole internal git platforms if no `orgs` are passed (I: #258),
- added `get_orgs()` function to print all organizations (I: #283),
- added resetting all settings to default with `reset()` function (I: #270)
- added resetting language in your search preferences with `reset_language()` or setting `language` parameter to `All` in `setup()` function (I: #231)

### Improving performance with REST and GraphQL APIs:

- added switching to REST engine in case GraphQL fails with 502 error (I: #225)
- added GraphQL engine for getting GitLab repos by organization (I: #218)
- removed `contributors` as basic stat when pulling `repos` by `org` and by `phrase` to improve speed of pulling repositories data. Added `pull_repos_contributors()` user function and `add_contributors` parameter to `pull_repos()` function to add conditionally information on contributors to repositories table (I: #235)

## Minor changes:

- handled errors with proper messages when tokens do not grant access (I: #242 #301),
- in repositories output set `api_url` column as an address to the repo, not the host (I: #201),
- fixed adding GitLab subgroups (I: #176),
- exported pipe operator (`%>%`) (I: #289).

# GitStats 0.1.0

This is the first release of GitStats with given features:

- `create_gitstats()` - creating GitStats object,
- `set_connection()` - adding hosts to GitStats object,
- `setup()` - setting search parameter to org, team or phrase, setting programming language of repositories,
- `get_repos()` - pulling repositories from GitHub and GitLab API in a standardized table,
- `get_commits()` - pulling commits from GitHub and GitLab API in a standardized table,
- `set_team_member()` - adding team members to GitStats object.
