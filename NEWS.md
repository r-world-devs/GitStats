# GitStats 2.3.2

- Added `get_repos_trees()` function (#614).
- Fixed errors when pulling data on repositories with code (#634).

# GitStats 2.3.1

A patch release with hot fixes to functions pulling repositories with code.

- Fixed pulling GitLab repositories with no issues ([#616](https://github.com/r-world-devs/GitStats/issues/616)).
- Handled `GraphQL` errors due to old GitLab version with switching to `REST` engine ([#615](https://github.com/r-world-devs/GitStats/issues/615), @ThomUK).
- Removed switching to iterating over organizations after large GitLab response error (over 10 thousand responses) ([#618](https://github.com/r-world-devs/GitStats/issues/618)), as the process takes very long.

# GitStats 2.3.0

This release introduces the new functions to get data on organizations and issues, alongside several important fixes and optimizations, such as handling GitLab API limits more efficiently.  Additional enhancements include renamed function, added time usage information and shortened data-pulling messages.

- Added `get_orgs()` function ([#599](https://github.com/r-world-devs/GitStats/issues/599)).
- Added `get_issues()` and `get_issues_stats()` functions ([#569](https://github.com/r-world-devs/GitStats/issues/569)).

## Fixes:

- Fixed `get_files()` function when pattern is not defined ([#605](https://github.com/r-world-devs/GitStats/issues/605)). Before, function call resulted with empty response or error.
- Optimized pulling repositories with code by:
  - handling limits of 10 thousand responses on GitLab API ([#607](https://github.com/r-world-devs/GitStats/issues/607)),
  - switching to `GraphQL API` methods for parsing search responses (still gathered via `REST`) into repositories output.

## Other:

- Renamed `get_R_package_usage()` to `get_repos_with_R_package()` as the output resembles the one from `get_repos()`.
- Added information on time used for pulling the data ([#603](https://github.com/r-world-devs/GitStats/issues/603)).
- Shortened messages when pulling data from repositories ([#587](https://github.com/r-world-devs/GitStats/issues/587)).

# GitStats 2.2.2

- Fixed pulling repositories URLS by code when `GitStats` is set to scan whole hosts ([#589](https://github.com/r-world-devs/GitStats/issues/589)). Set `type` parameter to `api` by default. Setting `type` to `web` results in parsing GitLab `api` URLs which may be time consuming and it should not be a default option.

# GitStats 2.2.1

- Fixed pulling repositories by code when `GitStats` is set to scan whole hosts ([#583](https://github.com/r-world-devs/GitStats/issues/583)).

# GitStats 2.2.0

This release brings some substantial improvements with making it possible to scan whole organizations and particular repositories for one host at the same time, boosting function to prepare commits statistics and simplifying workflow for getting files.

## Features:

- From now on it is possible to pass `orgs` and `repos` in `set_*_host()` functions ([#400](https://github.com/r-world-devs/GitStats/issues/400)).
- Improved `get_commits_stats()` function ([#556](https://github.com/r-world-devs/GitStats/issues/556), [#557](https://github.com/r-world-devs/GitStats/issues/557)) with:
  - giving possibility to customize grouping variable by passing it with the `group_var` parameter,
  - changing name of the `time_interval` parameter to `time_aggregation`,
  - adding `yearly` aggregation to `time_aggregation` parameter,
  - changing basic input from `GitStats` to `commits_data` object which allows to build workflow in one pipeline (`create_gitstats() |> set_*_host() |> get_commits() |> get_commits_stats()`).
- Merged two functions `get_files_content()` and `get_files_structure()` into one `get_files()` ([#564](https://github.com/r-world-devs/GitStats/issues/564)).
- Add `.error` parameter to the `set_*_host()` functions to control if error should pop up when wrong input is passed ([#547](https://github.com/r-world-devs/GitStats/issues/547)).

## Fixes:

- Fixed pulling commits for GitLab subgroups when repositories are set as scope to scan ([#551](https://github.com/r-world-devs/GitStats/issues/551)).
- Filled more information on `author_name` and `author_login` if it was missing in `commits_table` ([#550](https://github.com/r-world-devs/GitStats/issues/550)).
- Handled a `GraphQL` response error when pulling repositories with R error. Earlier, `GitStats` just returned empty table with no clue on what has happened, as errors from `GraphQL` are returned as list outputs (they do not break code).
- Fixed getting R package usage when repositories are set ([#548](https://github.com/r-world-devs/GitStats/issues/548)).
- Added possibility to pass GitHub users to `orgs` parameter in `set_github_host()` ([#562](https://github.com/r-world-devs/GitStats/issues/562)).

# GitStats 2.1.2

This is a patch release which introduces some hot fixes and new data in `get_commits()` output.

- Added `repo_url` column to output of `get_commits()` function ([#535](https://github.com/r-world-devs/GitStats/issues/535)).
- Fixed setting default tokens when `verbose` mode is set to `FALSE` ([#525](https://github.com/r-world-devs/GitStats/issues/525)) and fixed checking token scopes for GitLab ([#526](https://github.com/r-world-devs/GitStats/issues/526)).
- Fixed `get_repos_urls()` output when individual repositories are set in `set_*_host()`([#529](https://github.com/r-world-devs/GitStats/issues/529)). Earlier the function pulled all repositories for an organization, even though, repositories were defined for the host, not whole organizations. This is similar to the solved earlier ([#439](https://github.com/r-world-devs/GitStats/issues/439)).
- Fixed getting GitLab subgroups as organizations in repositories table output when pulling repositories with code ([#531](https://github.com/r-world-devs/GitStats/issues/531)).

# GitStats 2.1.1

This is a patch release which introduces some improvements in `get_R_package_usage()` on speed and possibility to pull at once data on multiple R packages, new `get_storage()` function and some fixes for checking token scopes and setting hosts.

## Features:

- Optimized `get_R_package_usage()` function: 
  - it is now possible to pass a vector of packages names (new `packages` parameter replacing old `package_name`) ([#494](https://github.com/r-world-devs/GitStats/issues/494)),
  - on the other hand, output of the function has been limited to contain only most necessary data (removing all repository stats), making thus process of obtaining package usage faster ([#474](https://github.com/r-world-devs/GitStats/issues/474)).
  - new `split_output` parameter has been added - when set to `TRUE` a `list` with `tibbles` (every element of the `list` for every package) instead of one `tibble` is returned.
- Added possibility to get repositories for individual users with `get_repos()` ([#492](https://github.com/r-world-devs/GitStats/issues/492)). Earlier this was only possible for GitHub organizations and GitLab groups.
- Added new `get_storage()` function to retrieve data from `GitStats` object - whole or particular datasets (e.g. `commits`, `repositories` or `R_package_usage`) ([#509](https://github.com/r-world-devs/GitStats/issues/509)).

## Fixes:

- Fixed getting large search responses for GitHub ([#491](https://github.com/r-world-devs/GitStats/issues/491)).
- Fixed checking token scopes ([#501](https://github.com/r-world-devs/GitStats/issues/501)). If token scopes are insufficient error is returned and `GitHost` is not passed to `GitStats`. This also applies to situation when `GitStats` looks for default tokens (not defined by user). Earlier, if tests for token failed, an empty token was passed and `GitStats` was created, which was misleading for the user.
- It is now possible to pass public GitHub host name (`github.com` or `https://github.com`) to `set_github_host()` ([#475](https://github.com/r-world-devs/GitStats/issues/475)).
- It is also possible to pass hosts in more flexible way than before (e.g. `{host_url}`, `http://{host_url}` or `https://{host_url}`) to `host` parameter in `set_*_host() function ([#399](https://github.com/r-world-devs/GitStats/issues/399)).

# GitStats 2.1.0

This minor release comes up with new `get_files_structure()` function and adjustments to `get_files_content()` so user can pull custom (by defining pattern of files and depth of directories) files tree from repository and pull their content.

## New features:

- Added new `get_files_structure()` function to pull files structure for a given repository with possibility to control level of directories (`depth` parameter) and to limit output to files matching regex argument passed to `pattern` parameter ([#338](https://github.com/r-world-devs/GitStats/issues/338)). Together with that, `get_files()` function was renamed to `get_files_content()` to better reflect its purpose.
- Adjusted `get_files_content()` so it can make use of `files_structure` pulled to `GitStats` storage with `get_files_structure()` function - if `file_path` is set to `NULL` and `use_files_structure()` parameter to `TRUE` (both are by default)([#467](https://github.com/r-world-devs/GitStats/issues/467)).
- Added `progress` parameter to user functions to control showing of `cli` progress bar separately from messages (which are controlled with `verbose`) ([#465](https://github.com/r-world-devs/GitStats/issues/465)).

## Other:

- Changed message when searching scope is set to scan whole git host (no `orgs` nor `repos` specified) from warning to info ([#456](https://github.com/r-world-devs/GitStats/issues/456)).
- Added new CI/CD jobs: deploy to `gh-pages`, lint and check for bumping version.
- Mocked extensively API responses to improve tests and checks progress ([#481](https://github.com/r-world-devs/GitStats/issues/481)].

# GitStats 2.0.2

This is a patch release with substantial improvements to some functions (`get_repos()`, `get_files()` and `get_R_package_usage()`), adding `with_files` and `in_files` parameters, fixing `cache` feature and introducing new `get_repos_urls()` function, a minimalist version of `get_repos()`:

- Added new `get_repos_urls()` function to fetch repository URLs (either web or API - choose with `type` parameter). It may return also only these repository URLs that consist of a given file or files (with passing argument to `with_files` parameter) or a text in code blobs (`with_code` parameter). This is a minimalist version of `get_repos()`, which takes out all the process of parsing (search response into repositories one) and adding statistics on repositories. This makes it poorer with content but faster. ([#425](https://github.com/r-world-devs/GitStats/issues/425)).
- Added `with_files` parameter to `get_repos()` function, which makes it possible to search for repositories with a given file or files and return full output for repositories.
- It is also possible now to pass multiple code phrases to `with_code` parameter (as a character vector) in `get_repos()` and `get_repos_urls()` ([282](https://github.com/r-world-devs/GitStats/issues/282)).
- Added `in_files` parameter to `get_repos()` which works with `with_code` parameter. When both are defined, `GitStats` searches code blobs only in given files.
- Removed `dplyr::glimpse()` from `get_*()` functions, so there is printing to console only if `get_*()` function is not assigned to the object ([#426](https://github.com/r-world-devs/GitStats/issues/426)).
- Output table of `get_R_package_usage()` consists now also of repository full name ([#438](https://github.com/r-world-devs/GitStats/issues/438)).
- Improved `get_R_package_usage()` with optimizing search of package names in `DESCRIPTION` and `NAMESPACE` files by removing filtering method and replacing it with `filename:` filter directly in search endpoint query ([#428](https://github.com/r-world-devs/GitStats/issues/428)).
- Fixed `get_files()` when scanning scope is set to `repositories`. Earlier, it pulled given files from whole organizations, even if scanning scope was set to `repos` with `set_*_host()`. Now it shows only files for the given repositories ([#439](https://github.com/r-world-devs/GitStats/issues/439)).
- Improved cache feature ([#436](https://github.com/r-world-devs/GitStats/issues/436)).
- `verbose` parameter controls now showing of the progress bars ([#453](https://github.com/r-world-devs/GitStats/issues/453)).

# GitStats 2.0.1

This is a patch release with some hot issues that needed to be addressed, notably covering `set_*_host()` functions with `verbose` control, tweaking a bit `verbose` feature in general, fixing pulling data for GitLab subgroups and speeding up `get_files()` function.

## Features:

- Getting files feature has been sped up when `GitStats` is set to scan whole hosts, with switching to `Search API` instead of pulling files via `GraphQL` (with iteration over organizations and repositories) ([#411](https://github.com/r-world-devs/GitStats/issues/411)).
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

- GitStats workflow is now simplified. To pull data on `repositories`, `commits`, `R_package_usage` or other you should use directly corresponding `get_*()` functions instead of `pull_*()` which are deprecated. These `get_*()` functions pull data from API, parse it into table, add some goodies (additional columns) if needed and return table instead of `GitStats` object, which in our opinion is more intuitive and user-friendly ([#345](https://github.com/r-world-devs/GitStats/issues/345)). That means you do not need to run in pipe two or three additional function calls as before, e.g. `pull_repos(gitstats_object) %>% get_repos() %>% get_repos_stats()`, but you just run
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
