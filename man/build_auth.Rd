% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/build_auth.R
\name{build_auth}
\alias{build_auth}
\title{Build token or basic authentication based on given credentials}
\usage{
build_auth(
  api_token = get_wastdr_api_token(),
  api_un = get_wastdr_api_un(),
  api_pw = get_wastdr_api_pw(),
  api_url = get_wastdr_api_url(),
  verbose = get_wastdr_verbose()
)
}
\arguments{
\item{api_token}{(character) The WAStD API token,
default \code{\link{get_wastdr_api_token}}, see \code{\link{wastdr_setup}}}

\item{api_un}{(character) A WAStD API username,
default \code{\link{get_wastdr_api_un}}, see \code{\link{wastdr_setup}}}

\item{api_pw}{(character) A WAStD API password,
default \code{\link{get_wastdr_api_pw}}, see \code{\link{wastdr_setup}}}

\item{api_url}{(character) The WAStD API URL,
default \code{\link{get_wastdr_api_url}}, see \code{\link{wastdr_setup}}}

\item{verbose}{Whether to show debug messages.
Default: wastdr::get_wastdr_verbose()}
}
\value{
httr::authenticate() for Basicauth or httr::add_headers for TokenAuth
}
\description{
Build token or basic authentication based on given credentials
}
