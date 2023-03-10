% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/GitStats.R
\name{set_connection}
\alias{set_connection}
\title{Setting connections}
\usage{
set_connection(gitstats_obj, api_url, token, orgs = NULL, set_org_limit = 1000)
}
\arguments{
\item{gitstats_obj}{A GitStats object.}

\item{api_url}{A character, url address of API.}

\item{token}{A token.}

\item{orgs}{A character vector of organisations (owners of repositories
in case of GitHub and groups of projects in case of GitLab).}

\item{set_org_limit}{An integer defining how many orgs API may pull.}
}
\value{
A \code{GitStats} class object with added information on connection
(\verb{$clients} field).
}
\description{
Setting connections
}
\examples{
\dontrun{
my_gitstats <- create_gitstats() \%>\%
  set_connection(
    api_url = "https://api.github.com",
    token = Sys.getenv("GITHUB_PAT"),
    orgs = c("r-world-devs", "openpharma", "pharmaverse")
  ) \%>\%
  set_connection(
    api_url = "https://gitlab.com/api/v4",
    token = Sys.getenv("GITLAB_PAT"),
    orgs = "erasmusmc-public-health"
  )
}
}
