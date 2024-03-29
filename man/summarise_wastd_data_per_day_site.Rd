% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/summarise_wastd_data.R
\name{summarise_wastd_data_per_day_site}
\alias{summarise_wastd_data_per_day_site}
\title{Summarise WAStD data per day and site}
\usage{
summarise_wastd_data_per_day_site(x)
}
\arguments{
\item{x}{An object of S3 class \code{wastd_data}, e.g. the output of
\code{wastdr::download_wastd_turtledata()}, optionally filtered to a locality
by \code{wastdr::filter_wastd_turtledata(area_name="Thevenard Island")}.}
}
\value{
A tibble, grouped and ordered by area, site, and date, with counts of
surveys, tracks (by nest type), nest and general disturbances, live
sightings and mortalities.
The columns returned are:

Grouping variables
\itemize{
\item \code{area_name} The WAStD locality, e.g. Thevenard Island. This is only
useful if the summary combines several localities.
\item \code{site_name} The WAStD site, e.g. a nesting beach. This is useful to
filter an interactive table to one site.
\item \code{calendar_date_awst}	The calendar date (NOT the "turtle date"). This one
should be kind of self-explanatory.
}

Tally variables
\itemize{
\item \code{no_surveys}	The number of "production" surveys on that site and date.
In almost all cases, there will be no more than one production survey
for any given site and date. Two and more indicate a need to QA and
merge these potential duplicate surveys in WAStD.
\item \code{body_pit} The number of body pits found.
\item \code{false_crawl} The number of "tracks without nest". These are confirmed
"no nest" tracks. The total
number of "tracks without nest" can be higher, in that some might have
been missed by the observer, and others might have been ambiguous
(track unsure) or not closer inspected (track not assessed).
\item \code{hatched_nest} The number of freshly hatched nests. These could have been
recorded as "track with nest" after the initial laying night.
\item \code{nest} The number of incubating nests, neither freshly made
(successful crawl), nor hatched (hatched nest). The only reason to record
these is to record a resighting of a nest tag marking that nest.
\item \code{successful_crawl} The number of confirmed "tracks with nest". The total
number of successfully made nests can be higher, in that some might have
been missed by the observer, and others might have been ambiguous
(track unsure) or not closer inspected (track not assessed).
\item \code{track_not_assessed} Tracks which have not been further assessed for
the presence of a nest. This can happen when tracks are convoluted,
covered, vanish in the dunes, or when the observer is under time
pressure.
\item \code{track_unsure} Tracks where the observer is not sure whether a nest
exists or not. Some of these records come with photos, and some of those
with photos can be reasonably determined by an experienced QA operator.
There will always remain a number of "track, assessed for nest, unsure if
nest" records, and it is up to the analyst how to determine their nesting
success, i.e. whether to count those as nest or not.
\item \code{disturbed_nests} The total number of disturbed or predated nests. The
primary presence of these nests is also included in the nest count from
earlier columns.
\item \code{general_dist} The total number of general signs of disturbance or
predator presence. These signs are not linked to any nest in particular.
\item \code{live_sightings} The total number of encounters with animals with an alive
outcome. This includes tagged turtles, rescued turtles, turtles
encountered in-water. Note that turtle tagging is currently recorded
in the Turtle Tagging database, a legacy system pending sunsetting.
\item \code{mortalities} The total number of encounters with dead animals. This
includes strandings and other incidents where the animal is dead at the
time of encounter or soon after.
\item \code{track_tallies} The total number of line transects, during which tallies
of turtle tracks and disturbance or predation may be recorded.
}
}
\description{
Summarise WAStD data per day and site
}
\examples{
\dontrun{
data("wastd_data", package = "wastdr")
x <- wastd_data \%>\%
  wastdr::filter_wastd_turtledata(area_name = "Thevenard Island") \%>\%
  summarise_wastd_data_per_day_site()

x <- wastd_data \%>\%
  wastdr::filter_wastd_turtledata(area_name = "Troughton Island") \%>\%
  summarise_wastd_data_per_day_site()

x <- wastd_data \%>\%
  wastdr::filter_wastd_turtledata(area_name = "Eco Beach") \%>\%
  summarise_wastd_data_per_day_site()
}
}
\seealso{
Other wastd: 
\code{\link{add_nest_labels}()},
\code{\link{disturbance_by_season}()},
\code{\link{filter_alive}()},
\code{\link{filter_dead}()},
\code{\link{filter_disturbance}()},
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
\code{\link{total_emergences_per_area_season_species}()},
\code{\link{total_emergences_per_site_season_species}()},
\code{\link{track_success_by_species}()},
\code{\link{track_success}()},
\code{\link{tracks_ts}()}
}
\concept{wastd}
