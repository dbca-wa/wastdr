% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/datetime_as_seasonweek.R
\name{datetime_as_seasonweek}
\alias{datetime_as_seasonweek}
\title{Calculate the isoweek from a given datetime}
\usage{
datetime_as_seasonweek(datetime)
}
\arguments{
\item{datetime}{(dttm) A datetime}
}
\value{
The ISO week as int, e.g. 26
}
\description{
\lifecycle{stable}
}
\details{
Return the isoweek of a given datetime.

The isoweek is useful as a grouping variable for weekly summaries.
}
\examples{
# These datetimes are turtle season 2017:
datetime_as_seasonweek(httpdate_as_gmt08("2017-07-02T15:59:59Z")) # 0
datetime_as_seasonweek(httpdate_as_gmt08("2017-07-02T16:00:00Z")) # 1
datetime_as_seasonweek(httpdate_as_gmt08("2017-08-30T06:38:43Z")) # 9
datetime_as_seasonweek(httpdate_as_gmt08("2017-11-01T22:00:00Z")) # 18
datetime_as_seasonweek(httpdate_as_gmt08("2018-11-01T22:00:00Z")) # 18
}
\seealso{
Other helpers: 
\code{\link{absolute_angle}()},
\code{\link{add_dates}()},
\code{\link{datetime_as_isoweek}()},
\code{\link{datetime_as_season}()},
\code{\link{datetime_as_turtle_date}()},
\code{\link{exclude_training_species}()},
\code{\link{exclude_training_surveys}()},
\code{\link{extract_possibly}()},
\code{\link{fdate_as_tdate}()},
\code{\link{filter_missing_site}()},
\code{\link{filter_missing_survey}()},
\code{\link{filter_surveys_missing_end}()},
\code{\link{filter_surveys_requiring_qa}()},
\code{\link{filter_wastd_season}()},
\code{\link{get_more}()},
\code{\link{gj_linestring_to_st_linestring}()},
\code{\link{httpdate_as_gmt08_turtle_date}()},
\code{\link{httpdate_as_gmt08}()},
\code{\link{httpdate_as_season}()},
\code{\link{humanize}()},
\code{\link{join_tsc_sites}()},
\code{\link{leaflet_basemap}()},
\code{\link{map_chr_hack}()},
\code{\link{mean_bearing}()},
\code{\link{mis_bearing}()},
\code{\link{odkc_works}()},
\code{\link{read_table}()},
\code{\link{sentencecase}()},
\code{\link{sf_as_tbl}()},
\code{\link{tdate_as_fdate}()},
\code{\link{tracks_as_geojson}()},
\code{\link{tun}()},
\code{\link{urlize}()},
\code{\link{verify_odkc_turtledata}()},
\code{\link{verify_wamtram_data}()},
\code{\link{verify_wastd_data}()},
\code{\link{wastd_works}()},
\code{\link{wastdr_msg_abort}()},
\code{\link{wastdr_msg_info}()},
\code{\link{wastdr_msg_noop}()},
\code{\link{wastdr_msg_success}()},
\code{\link{wastdr_msg_warn}()},
\code{\link{wastdr_settings}()},
\code{\link{wastdr_setup}()}
}
\concept{helpers}
