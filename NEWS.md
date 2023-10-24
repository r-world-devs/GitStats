# GitStats 1.0.1

- adjusted to CRAN release - complete function docs with examples.

# GitStats 1.0.0

## Breaking changes:

### New functions:

- added `get_*_stats()` functions to prepare summary stats from pulled data: repositories and commits ([#276](https://github.com/r-world-devs/GitStats/issues/276)),
- rename and refactor plot functions to one generic `gitstats_plot()` which takes as an input `repos_stats` or `commits_stats` class objects ([#276](https://github.com/r-world-devs/GitStats/issues/276)),

### New names for core functions:

- changed names from `get_*` to `pull_*`; `get_*` functions are now to retrieve already pulled data from GitStats object ([#294](https://github.com/r-world-devs/GitStats/issues/294)),
- changed name from `setup()` to `set_params()` ([#294](https://github.com/r-world-devs/GitStats/issues/294)),
- changed name from `set_connection()` to `set_host()` ([#271](https://github.com/r-world-devs/GitStats/issues/271)),
- changed name from `add_team_member()` to `set_team_member()` ([#271](https://github.com/r-world-devs/GitStats/issues/271)).

## Major changes:

### New features:

- added setting tokens by default - if the user does have all the PATs set up in environment variables (as e.g. `GITHUB_PAT` or `GITLAB_PAT`), there is no need to pass them as an argument to `set_host()` ([#120](https://github.com/r-world-devs/GitStats/issues/120)),
- added `pull_users()` function to pull information on users ([#199](https://github.com/r-world-devs/GitStats/issues/199)),
- added possibility of scanning whole internal git platforms if no `orgs` are passed ([#258](https://github.com/r-world-devs/GitStats/issues/258)),
- added `get_orgs()` function to print all organizations ([#283](https://github.com/r-world-devs/GitStats/issues/283)),
- added resetting all settings to default with `reset()` function ([#270](https://github.com/r-world-devs/GitStats/issues/270))
- added resetting language in your search preferences with `reset_language()` or setting `language` parameter to `All` in `setup()` function ([#231](https://github.com/r-world-devs/GitStats/issues/231))

### Improving performance with REST and GraphQL APIs:

- added switching to REST engine in case GraphQL fails with 502 error ([#225](https://github.com/r-world-devs/GitStats/issues/225))
- added GraphQL engine for getting GitLab repositories by organization ([#218](https://github.com/r-world-devs/GitStats/issues/218))
- removed `contributors` as basic stat when pulling `repos` by `org` and by `phrase` to improve speed of pulling repositories data. Added `pull_repos_contributors()` user function and `add_contributors` parameter to `pull_repos()` function to add conditionally information on contributors to repositories table ([#235](https://github.com/r-world-devs/GitStats/issues/235))

## Minor changes:

- handled errors with proper messages when tokens do not grant access ([#242](https://github.com/r-world-devs/GitStats/issues/242) [#301](https://github.com/r-world-devs/GitStats/issues/301)),
- in repositories output set `api_url` column as an address to the repository, not the host ([#201](https://github.com/r-world-devs/GitStats/issues/201)),
- fixed adding GitLab subgroups ([#176](https://github.com/r-world-devs/GitStats/issues/176)),
- exported pipe operator (`%>%`) ([#289](https://github.com/r-world-devs/GitStats/issues/289)).

# GitStats 0.1.0

This is the first release of GitStats with given features:

- `create_gitstats()` - creating GitStats object,
- `set_connection()` - adding hosts to GitStats object,
- `setup()` - setting search parameter to org, team or phrase, setting programming language of repositories,
- `get_repos()` - pulling repositories from GitHub and GitLab API in a standardized table,
- `get_commits()` - pulling commits from GitHub and GitLab API in a standardized table,
- `set_team_member()` - adding team members to GitStats object.
