# GitStats 1.2.0

## New features:

- Add `pull_release_logs()` ([#356](https://github.com/r-world-devs/GitStats/issues/356)).
- Replace all `get_*()` functions with one `get_table()`, where user passes the name of the object he wants to retrieve (e.g. `repos`, `commits`, `package_usage`) to the `table` parameter.
- Commits response consists now of two new columns: `author_login` and `author_name` ([#332](https://github.com/r-world-devs/GitStats/issues/332)). This is due to the mix of github/gitlab handles and display names in the `author` column (the original author `name` field in commits API response).
- Use stored repositories when pulling commits or files ([#159](https://github.com/r-world-devs/GitStats/issues/159)).
- Improve printing `GitStats` object - now when you return `GitStats` object in console, it prints `GitStats` data divided into sections to give more readable information to user: `scanning scope` (organizations, repositories and files), `search settings` (searched phrase, language, team name) and `storage` (the output tables stored in `GitStats` with basic information on dimensions) ([#329](https://github.com/r-world-devs/GitStats/issues/329)).

## Bug fixes:

- Pagination was introduced to `contributors` response ([#331](https://github.com/r-world-devs/GitStats/issues/331)).

# GitStats 1.1.0

## New features:

- `pull_R_package_usage()` with `get_R_package_usage()` functions to pull repositories where package name is found in DESCRIPTION or NAMESPACE files or code blobs with phrases related to using an R package (`library(package)`, `require(package)`) ([#326](https://github.com/r-world-devs/GitStats/issues/326), [#341](https://github.com/r-world-devs/GitStats/issues/341)),
- `pull_files()` with `get_files()` to pull content of text files ([#200](https://github.com/r-world-devs/GitStats/issues/200)).
- possibility to pass specific repositories to `GitStats` with `set_host()` function by using `repos` parameter instead of `orgs` ([#330](https://github.com/r-world-devs/GitStats/issues/330)).

## Bug fixes:

- fixed pulling responses when GitLab groups have private or empty content ([#314](https://github.com/r-world-devs/GitStats/issues/314)),
- fixed pulling users when pulling from multiple hosts ([#312](https://github.com/r-world-devs/GitStats/issues/312)),
- improved search API error handling.

## Minor changes and features:

- rename column names for repository output - `id` to `repo_id` and `name` to `repo_name`,
- added a `default_branch` column to repositories output as a consequence of [#200](https://github.com/r-world-devs/GitStats/issues/200).

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
