% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/summarise_dist.R
\name{filter_disturbance}
\alias{filter_disturbance}
\title{Filter disturbance data to disturbances}
\usage{
filter_disturbance(data)
}
\arguments{
\item{data}{A dataframe with column "disturbance_cause", e.g. the ouput of
\code{
  \link{wastd_GET}("turtle-nest-disturbance-observations") %>%
  \link{parse_encounterobservations}()
  } or \code{data("wastd_data"); wastd_data$nest_dist}}
}
\value{
The dataframe with rows matching disturbance causes.
}
\description{
\lifecycle{stable}
}
\examples{
data("wastd_data")
wastd_data$nest_dist \%>\%
  filter_disturbance() \%>\%
  head()

data("odkc_data")
odkc_data$tracks_dist \%>\%
  sf_as_tbl() \%>\%
  filter_disturbance() \%>\%
  head()

odkc_data$dist \%>\%
  sf_as_tbl() \%>\%
  filter_disturbance() \%>\%
  head()
}
\seealso{
Other wastd: 
\code{\link{add_nest_labels}()},
\code{\link{disturbance_by_season}()},
\code{\link{filter_alive}()},
\code{\link{filter_dead}()},
\code{\link{filter_predation}()},
\code{\link{ggplot_disturbance_by_season}()},
\code{\link{ggplot_emergence_success}()},
\code{\link{ggplot_hatching_success}()},
\code{\link{ggplot_hatchling_misorientation}()},
\code{\link{ggplot_nesting_success_per_area_season_species_pct}()},
\code{\link{ggplot_nesting_success_per_area_season_species}()},
\code{\link{ggplot_sighting_status_per_area_season_species}()},
\code{\link{ggplot_total_emergences_per_area_season_species}()},
\code{\link{ggplot_track_success_by_date}()},
\code{\link{ggplot_track_successrate_by_date}()},
\code{\link{hatching_emergence_success_area}()},
\code{\link{hatching_emergence_success_site}()},
\code{\link{hatching_emergence_success}()},
\code{\link{map_dist}()},
\code{\link{map_fanangles}()},
\code{\link{map_mwi}()},
\code{\link{map_nests}()},
\code{\link{map_tracks}()},
\code{\link{map_wastd_wamtram_sites}()},
\code{\link{map_wastd}()},
\code{\link{nesting_success_per_area_day_species}()},
\code{\link{nesting_success_per_area_season_species}()},
\code{\link{nesting_type_by_area_season_age_species}()},
\code{\link{nesting_type_by_area_season_species}()},
\code{\link{nesting_type_by_season_age_species}()},
\code{\link{nesting_type_by_season_calendarday_age_species}()},
\code{\link{nesting_type_by_season_calendarday_species}()},
\code{\link{nesting_type_by_season_day_species}()},
\code{\link{nesting_type_by_season_species}()},
\code{\link{nesting_type_by_season_week_age_species}()},
\code{\link{nesting_type_by_season_week_site_species}()},
\code{\link{nesting_type_by_season_week_species}()},
\code{\link{nesting_type_by_site_season_age_species}()},
\code{\link{nesting_type_by_site_season_species}()},
\code{\link{parse_animal_encounters}()},
\code{\link{parse_area_sf}()},
\code{\link{parse_area}()},
\code{\link{parse_encounterobservations}()},
\code{\link{parse_surveys}()},
\code{\link{parse_turtle_nest_encounters}()},
\code{\link{print.wastd_api_response}()},
\code{\link{sighting_status_per_area_season_species}()},
\code{\link{sighting_status_per_site_season_species}()},
\code{\link{summarise_hatching_and_emergence_success}()},
\code{\link{summarise_wastd_data_per_day_site}()},
\code{\link{total_emergences_per_area_season_species}()},
\code{\link{total_emergences_per_site_season_species}()},
\code{\link{track_success_by_species}()},
\code{\link{track_success}()},
\code{\link{tracks_ts}()}
}
\concept{wastd}
