#' @title Get statistics on repositories
#' @name get_repos_stats
#' @description Prepare statistics from the pulled repositories data.
#' @param gitstats_obj A GitStats class object.
#' @return A table of `repos_stats` class.
#' @export
get_repos_stats <- function(gitstats_obj){
  repos_data <- data.table::copy(get_repos(gitstats_obj))
  repos_stats <- repos_data %>%
    dplyr::mutate(
      fullname = paste0(organization, "/", name)
    ) %>%
    dplyr::mutate(
      last_activity = difftime(
        Sys.time(),
        last_activity_at,
        units = "days"
      ) %>% round(2),
      repository = fullname,
      platform = retrieve_platform(api_url)
    )
  if ("contributors" %in% colnames(repos_data)) {
    repos_stats <- dplyr::mutate(
      repos_stats,
      contributors_n = purrr::map_vec(contributors, function(contributors_string) {
        length(stringr::str_split(contributors_string[1], ", ")[[1]])
      })
    )
  } else {
    repos_stats <- dplyr::mutate(
      repos_stats,
      contributors_n = NA
    )
  }
  repos_stats <- dplyr::select(
    repos_stats,
    repository, platform, created_at, last_activity, stars, forks,
    languages, issues_open, issues_closed, contributors_n
  )
  class(repos_stats) <- append(class(repos_stats), "repos_stats")
  return(repos_stats)
}

#' @title Get statistics on commits
#' @name get_commits_stats
#' @description Prepare statistics from the pulled commits data.
#' @param gitstats_obj A GitStats class object.
#' @param time_interval A character, specifying time interval to show statistics.
#' @return A table of `commits_stats` class.
#' @export
get_commits_stats <- function(gitstats_obj,
                              time_interval = c("month", "day", "week")){
  commits_data <- data.table::copy(get_commits(gitstats_obj))
  time_interval <- match.arg(time_interval)

  commits_stats <- commits_data %>%
    dplyr::mutate(
      stats_date = lubridate::floor_date(
        committed_date,
        unit = time_interval
      ),
      platform = retrieve_platform(api_url)
    ) %>%
    dplyr::group_by(stats_date, platform, organization) %>%
    dplyr::summarise(
      commits_n = dplyr::n()
    ) %>%
    dplyr::arrange(
      stats_date
    )
  commits_stats <- commits_stats(
    object = commits_stats,
    time_interval = time_interval
  )
  return(commits_stats)
}

#' @noRd
#' @description A constructor for `commits_stats` class
commits_stats <- function(object, time_interval) {
  stopifnot(inherits(object, "grouped_df"))
  object <- dplyr::ungroup(object)
  class(object) = append(class(object), "commits_stats")
  attr(object, "time_interval") <- time_interval
  object
}
