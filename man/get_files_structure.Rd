% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gitstats_functions.R
\name{get_files_structure}
\alias{get_files_structure}
\title{Get structure of files}
\usage{
get_files_structure(
  gitstats_object,
  pattern = NULL,
  depth = Inf,
  cache = TRUE,
  verbose = is_verbose(gitstats_object),
  progress = verbose
)
}
\arguments{
\item{gitstats_object}{A GitStats object.}

\item{pattern}{An optional regular expression. If defined, it pulls file
structure for a repository matching this pattern.}

\item{depth}{An optional integer. Defines level of directories to retrieve
files from. E.g. if set to \code{0}, it will pull files only from root, if \code{1},
will take data from \code{root} directory and directories visible in \code{root}
directory. If left with no argument, will pull files from all directories.}

\item{cache}{A logical, if set to \code{TRUE} GitStats will retrieve the last
result from its storage.}

\item{verbose}{A logical, \code{TRUE} by default. If \code{FALSE} messages and printing
output is switched off.}

\item{progress}{A logical, by default set to \code{verbose} value. If \code{FALSE} no
\code{cli} progress bar will be displayed.}
}
\value{
A list of vectors.
}
\description{
Pulls file structure for a given repository.
}
\examples{
\dontrun{
 my_gitstats <- create_gitstats() \%>\%
  set_github_host(
    token = Sys.getenv("GITHUB_PAT"),
    orgs = c("r-world-devs")
  ) \%>\%
  set_gitlab_host(
    token = Sys.getenv("GITLAB_PAT_PUBLIC"),
    orgs = "mbtests"
  )
 get_files_structure(
   gitstats_obj = my_gitstats,
   pattern = "\\\\.md"
 )
}
}
