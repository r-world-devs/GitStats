% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/class_gitlab.R
\name{GitLab}
\alias{GitLab}
\title{A GitLab API Client class}
\description{
An object with methods to derive information form GitLab API.
}
\section{Super class}{
\code{\link[GitStats:GitService]{GitStats::GitService}} -> \code{GitLab}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-get_repos}{\code{GitLab$get_repos()}}
\item \href{#method-get_repos_by_codephrase}{\code{GitLab$get_repos_by_codephrase()}}
\item \href{#method-get_commits}{\code{GitLab$get_commits()}}
\item \href{#method-print}{\code{GitLab$print()}}
}
}
\if{html}{
\out{<details open ><summary>Inherited methods</summary>}
\itemize{
\item \out{<span class="pkg-link" data-pkg="GitStats" data-topic="GitService" data-id="initialize">}\href{../../GitStats/html/GitService.html#method-initialize}{\code{GitStats::GitService$initialize()}}\out{</span>}
}
\out{</details>}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-get_repos"></a>}}
\if{latex}{\out{\hypertarget{method-get_repos}{}}}
\subsection{Method \code{get_repos()}}{
A method to list all repositories for an organization or for
a team.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{GitLab$get_repos(orgs = self$orgs, by, team)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{orgs}}{A character vector of organisations (project groups).}

\item{\code{by}}{A character, to choose between: \itemize{
\item{org}{Organizations - groups of projects} \item(team){A team}}}

\item{\code{team}}{A list of team members. Specified by \code{set_team()} method
of GitStats class object.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
A data.frame of repositories
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-get_repos_by_codephrase"></a>}}
\if{latex}{\out{\hypertarget{method-get_repos_by_codephrase}{}}}
\subsection{Method \code{get_repos_by_codephrase()}}{
A method to find repositories with given phrase in code lines.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{GitLab$get_repos_by_codephrase(phrase, language = "R")}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{phrase}}{A phrase to look for in codelines.}

\item{\code{language}}{A character specifying language used in repositories.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
A data.frame of repositories
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-get_commits"></a>}}
\if{latex}{\out{\hypertarget{method-get_commits}{}}}
\subsection{Method \code{get_commits()}}{
A method to get information on commits.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{GitLab$get_commits(
  orgs = self$orgs,
  date_from,
  date_until = Sys.time(),
  by,
  team
)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{orgs}}{A character vector of organisations (project groups).}

\item{\code{date_from}}{A starting date to look commits for}

\item{\code{date_until}}{An end date to look commits for}

\item{\code{by}}{A character, to choose between: \itemize{
\item{org}{Organizations - groups of projects} \item(team){A team}}}

\item{\code{team}}{A list of team members. Specified by \code{set_team()} method
of GitStats class object.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
A data.frame of commits
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-print"></a>}}
\if{latex}{\out{\hypertarget{method-print}{}}}
\subsection{Method \code{print()}}{
A print method for a GitLab object
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{GitLab$print()}\if{html}{\out{</div>}}
}

}
}