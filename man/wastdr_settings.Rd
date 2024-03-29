% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/wastdr_settings.R
\name{wastdr_settings}
\alias{wastdr_settings}
\alias{get_wastd_url}
\alias{get_wastdr_api_url}
\alias{get_wastdr_api_token}
\alias{get_wastdr_api_un}
\alias{get_wastdr_api_pw}
\alias{get_wastdr_verbose}
\title{Get or set wastdr WAStD settings}
\usage{
wastdr_settings()

get_wastd_url()

get_wastdr_api_url()

get_wastdr_api_token()

get_wastdr_api_un()

get_wastdr_api_pw()

get_wastdr_verbose()
}
\value{
\code{wastdr_settings} prints your base url and WAStD API key.
\code{wastdr_setup} sets your production and test settings, while
}
\description{
Get or set wastdr WAStD settings
}
\seealso{
\code{\link{wastdr_setup}},
\code{\link{get_wastd_url}},
\code{\link{get_wastdr_api_url}},
\code{\link{get_wastdr_api_token}},
\code{\link{get_wastdr_api_un}}, and
\code{\link{get_wastdr_api_pw}}.

Other helpers: 
\code{\link{absolute_angle}()},
\code{\link{add_dates}()},
\code{\link{datetime_as_isoweek}()},
\code{\link{datetime_as_seasonweek}()},
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
\code{\link{wastdr_setup}()}
}
\concept{helpers}
