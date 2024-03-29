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
\seealso{
Other api: 
\code{\link{download_minimal_wastd_turtledata}()},
\code{\link{download_wastd_sites}()},
\code{\link{download_wastd_turtledata}()},
\code{\link{download_wastd_users}()},
\code{\link{export_wastd_turtledata}()},
\code{\link{filter_wastd_turtledata_area}()},
\code{\link{filter_wastd_turtledata_seasons}()},
\code{\link{filter_wastd_turtledata}()},
\code{\link{handle_http_status}()},
\code{\link{wastd_GET}()},
\code{\link{wastd_POST}()},
\code{\link{wastd_bulk_post}()},
\code{\link{wastd_chunk_post}()},
\code{\link{wastd_create_update_skip}()},
\code{\link{wastd_parse}()},
\code{\link{wastd_post_one}()}
}
\concept{api}
