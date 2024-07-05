# GitStats (development version)

- Added new `get_repos_urls()` function to fetch repository URLS (either web or API - choose with `type` parameter). It may return also only these repository URLS that consist of a given file or files (with passing argument to `with_files` parameter) or a text in code blobs (`with_code` parameter). This is a minimalist version of `get_repos()`, which takes out all the process of parsing (search response into repositories one) and adding statistics on repositories. This makes it poorer with content but faster. ([#425](https://github.com/r-world-devs/GitStats/issues/425)).
- Added `with_files` parameter to `get_repos()` function, which makes it possible to search for repositories with a given file or files and return full output for repositories.
- It is also possible now to pass multiple code phrases to `with_code` parameter (as a character vector) in `get_repos()` and `get_repos_urls()` ([282](https://github.com/r-world-devs/GitStats/issues/282))
- Removed `dplyr::glimpse()` from `get_*()` functions, so there is printing to console only if `get_*()` function is not assigned to the object ([#426](https://github.com/r-world-devs/GitStats/issues/426)).

# GitStats 2.0.1

This is a patch release with some hot issues that needed to be addressed, notably covering `set_*_host()` functions with `verbose` control, tweaking a bit `verbose` feature in general, fixing pulling data for GitLab subgroups and speeding up `get_files()` function.

## Features:

- Getting files feature has been speeded up when `GitStats` is set to scan whole hosts, with switching to `Search API` instead of pulling files via `GraphQL` (with iteration over organizations and repositories) ([#411](https://github.com/r-world-devs/GitStats/issues/411)).
- When setting hosts to be scanned in whole (without specifying `orgs` or `repos`) GitStats does not pull no more all organizations. Pulling all organizations from host is triggered only when user decides to pull repositories from organizations. If he decides, e.g. to pull repositories by code, there is no need to pull all organizations (which may be a time consuming process), as GitStats uses then `Search API` ([#393](https://github.com/r-world-devs/GitStats/issues/393)).
- It is now possible to mute messages also from `set_*_host()` functions with `verbose_off()` or `verbose` parameter ([#413](https://github.com/r-world-devs/GitStats/issues/413)).
- Setting `verbose` to `FALSE` does not lead to hiding output of the `get_*()` functions - i.e. a glimpse of table will always appear after pulling data, even if the `verbose` is switched off. `verbose` parameter serves now only the purpose to show and hide messages to user ([#423](https://github.com/r-world-devs/GitStats/issues/423)).

## Fixes:

- Pulling repositories from GitLab subgroups was fixed. It did not work, as the URL of a group (org) was passed to GraphQL API the same way as to REST API, i.e. with URL sign ("%2F", instead of "/").
- GitStats returns now proper error, when you pass wrong host URL to `set_*_host()` function ([#415](https://github.com/r-world-devs/GitStats/issues/415))

# GitStats 2.0.0

This is a major release with general changes in workflow (simplifying it), changes in setting `GitStats` hosts, deprecation of some not very useful features (like plots, setting parameters separately) and new `get_release_logs()` function.

## Setting hosts:

- `set_host()` function is replaced with more explicit `set_github_host()` and `set_gitlab_host()`([#373](https://github.com/r-world-devs/GitStats/issues/373)). If you wish to connect to public host (e.g. `api.github.com`), you do not need to pass argument to `host` parameter. 

## Simplifying workflow:

- GitStats workflow is now simplified. To pull data on `repositories`, `commits`, `R_package_usage` or other you should use directly corresponding `get_*()` functions instead of `pull_*()` which are deprecated. These `get_*()` functions pull data from API, parse it into table, add some goodies (additional columns) if needed and return table instead of `GitStats` object, which in our opinion is more intuitive and user-friendly ([#345]((https://github.com/r-world-devs/GitStats/issues/345))). That means you do not need to run in pipe two or three additional function calls as before, e.g. `pull_repos(gitstats_object) %>% get_repos() %>% get_repos_stats()`, but you just run
`get_repos(gitstats_object)` to get data you need.
- Moreover, if you run for the second time `get_*()` function `GitStats` will pull the data from its storage and not from API as for the first time, unless you change parameters for the function (e.g. starting date with `since` in `get_commits()`) or change directly the `cache` parameter in the function. ([#333](https://github.com/r-world-devs/GitStats/issues/333))
- `pull_repos_contributors()` as a separate function is deprecated. The parameter `add_contributors` is now set by  default to `TRUE` in `get_repos()` which seems more reasonable as user gets all the data.
- In `get_commits()` old parameters (`date_from` and `date_until`) were replaced with new, more concise (`since` and `until`).

## Changes to setting parameters and pulling repositories by code:

- `set_params()` function is removed. ([#386](https://github.com/r-world-devs/GitStats/issues/386)) Now the logic is moved straight to `get_*()` functions. For example, if you want to pull repositories with specific `code blob`, you do not need to define anything with `set_params()` (as previously with `search_mode` and `phrase` parameter) but you just simply run `get_repos(with_code = 'your_code')`. ([#333](https://github.com/r-world-devs/GitStats/issues/333))
- New logical parameter `verbose` have been introduced for limiting messages to user when pulling data - this parameter can be set in all `get_*()` functions. You can also turn the verbose mode on/off globally with `verbose_on()`/`verbose_off()` functions.

## Deprecate:

- `get_repos_stats()` function was deprecated as its role was unclear - unlike `get_commit_stats()` it did not aggregate repositories data into new stats table, but added only some new numeric columns, like number of contributors (`contributors_n`) or last activity in `difftime` format, which is now done within `get_repos()` function.
- Pulling by `team` and filtering by `language` is no longer supported - these features where quite heavy for the package performance and did not bring much added value. If user needs, he can always filter the output (formatted responses pulled from API) by contributors or language. ([#384](https://github.com/r-world-devs/GitStats/issues/384))
- Plot functions are no longer feature of `GitStats`, they have been deprecated as the package is meant to be basically for back end purposes and this is the field where developer's effort should now go ([#381](https://github.com/r-world-devs/GitStats/issues/381)). If needed and requested, plot functions may be brought up once more in next releases.

## New features:

- Added `get_release_logs()` ([#356](https://github.com/r-world-devs/GitStats/issues/356)).
- `get_orgs()` is renamed to `show_orgs()` to reflect that it does not pull data from API, but only shows what is in `GitStats` object.
- Commits response consists now of two new columns: `author_login` and `author_name` ([#332](https://github.com/r-world-devs/GitStats/issues/332)). This is due to the mix of GitHub/GitLab handles and display names in the `author` column (the original author `name` field in commits API response).
- Improve printing `GitStats` object - now when you return `GitStats` object in console, it prints `GitStats` data divided into sections to give more readable information to user: `scanning scope` (organizations and repositories), and `storage` (the output tables stored in `GitStats` with basic information on dimensions) ([#329](https://github.com/r-world-devs/GitStats/issues/329)).

## Bug fixes:

- Pagination was introduced to `contributors` response ([#331](https://github.com/r-world-devs/GitStats/issues/331)).
- Fixed handler of dates parameters when pulling commits. Wrong and complex construction of `gts_to_posixt()` helper which took dependencies on `stringr` was a cause for some users of passing empty value to `since` parameter to commits endpoint which ended in Bad Request Error (400) and infinite loop of retrying the response ([#360](https://github.com/r-world-devs/GitStats/issues/360)).

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
