#' @description \code{\link{wastdr}} is an R Client for the ODK Central API.
#' The 'WA Sea Turtle Database' 'WAStD' is a 'Django' web app with a 'RESTful'
#' 'API' returning 'GeoJSON' 'FeatureCollections'.
#' \code{\link{wastdr}} provides helpers to retrieve data from the 'API',
#' and to turn the received 'GeoJSON' into R 'tibbles'.
#' \code{\link{wastdr}} will grow alongside implemented
#' use cases of retrieving and analysing 'WAStD' data.
#'
#'   Please see the `wastdr` website for full documentation:
#'   * <https://dbca-wa.github.io/wastdr/>
#'
#'   `ruODK` is "pipe-friendly" and re-exports `%>%`, but does not
#'   require their use.
#'
#' @keywords internal
"_PACKAGE"


#' Pipe operator
#'
#' See \code{magrittr::\link[magrittr]{\%>\%}} for details.
#'
#' @name %>%
#' @rdname pipe
#' @family utilities
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL

# Silence lifecycle warnings
if (FALSE) lifecycle::deprecate_soft()

# CMD check silencer
utils::globalVariables(c(".",
                         "aes",
                         "area_type",
                         "calendar_date_awst",
                         "datetime",
                         "days",
                         "dist_extra",
                         "dist_prod",
                         "disturbance_cause",
                         "disturbanceobservation_disturbance_cause",
                         "duration_hours",
                         "duration_minutes",
                         "encounter_when",
                         "end_time",
                         "health",
                         "hours_surveyed",
                         "layersControlOptions",
                         "markerClusterOptions",
                         "mwi_dmg_prod",
                         "mwi_extra",
                         "mwi_prod",
                         "mwi_tag_prod",
                         "n",
                         "name",
                         "obs",
                         "observation_start_time",
                         "pk",
                         "properties",
                         "season",
                         "site_name",
                         "status_health",
                         "start",
                         "start_time",
                         "sve_extra",
                         "sve_prod",
                         "svs_extra",
                         "svs_prod",
                         "tracks_dist_extra",
                         "tracks_dist_prod",
                         "tracks_egg_prod",
                         "tracks_extra",
                         "tracks_fan_outlier_prod",
                         "tracks_hatch_prod",
                         "tracks_log_prod",
                         "tracks_prod",
                         "turtle_date",
                         "when",
                         "Year"
                         ))
