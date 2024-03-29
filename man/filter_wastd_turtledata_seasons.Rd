% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/filter_wastd_turtledata.R
\name{filter_wastd_turtledata_seasons}
\alias{filter_wastd_turtledata_seasons}
\title{Filter WAStD turtledata to a season range}
\usage{
filter_wastd_turtledata_seasons(
  x,
  seasons = NULL,
  verbose = wastdr::get_wastdr_verbose()
)
}
\arguments{
\item{x}{An object of class \code{wastd_data} as returned by
\code{\link{download_wastd_turtledata}}.}

\item{seasons}{(list of int) A list of seasons to filter the data by.
\itemize{
\item NULL (default): return data from all seasons.
\item list of numbers: return data from given seasons.
E.g. \code{c(2017, 2018, 2019)} or \code{2017:2019} returns data from seasons
2017-18 through to 2019-20.
}}

\item{verbose}{Whether to show debug messages.
Default: wastdr::get_wastdr_verbose()}
}
\value{
An object of class \code{wastd_data} filtered to records within
\code{area_name} and the list of \code{seasons}.
}
\description{
Filter WAStD turtledata to a season range
}
\examples{
\dontrun{
data(wastd_data)
first_season <- wastd_data$areas$season[[1]]
wastd_data_filtered <- wastd_data \%>\%
  filter_wastd_turtledata_seasons(first_season)
wastd_data
wastd_data_filtered
unique(wastd_data_filtered$areas$season)
}
}
\seealso{
Other api: 
\code{\link{build_auth}()},
\code{\link{download_minimal_wastd_turtledata}()},
\code{\link{download_wastd_sites}()},
\code{\link{download_wastd_turtledata}()},
\code{\link{download_wastd_users}()},
\code{\link{export_wastd_turtledata}()},
\code{\link{filter_wastd_turtledata_area}()},
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
