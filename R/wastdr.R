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
#' @family helpers
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @importFrom rlang %||%
#' @usage lhs \%>\% rhs
NULL

# Silence R CMD CHECK warning: Use lifecycle somewhere in package
lifecycle::deprecate_soft

# CMD check silencer
utils::globalVariables(
  c(
    ".",
    "absolute_admin_url",
    "aes",
    "area_name",
    "area_type",
    "calendar_date_awst",
    "change_url",
    "datetime",
    "days",
    "desc",
    "details_nest_age",
    "details_nest_type",
    "details_species",
    "disturbance",
    "dist_extra",
    "dist_prod",
    "disturbance_cause",
    "disturbanceobservation_disturbance_cause",
    "duration_hours",
    "duration_minutes",
    "encounter_type",
    "encounter_when",
    "encounter_encounter_type",
    "end_comments",
    "end_time",
    "egg_count",
    "egg_count_calculated",
    "eggs_counted",
    "emergence_success",
    "encounter_area_name",
    "encounter_site_name",
    "existing_tsc_tne",
    "fan_angles_measured",
    "first_day",
    "health",
    "hours_surveyed",
    "hatching_success",
    "habitat",
    "hatchlings_measured",
    "id",
    "is_production",
    "iso_week",
    "layersControlOptions",
    "last_day",
    "logger_found",
    "markerClusterOptions",
    "mwi_dmg_prod",
    "mwi_extra",
    "mwi_prod",
    "mwi_tag_prod",
    "n",
    "name",
    "nest_age",
    "nest_disturbance",
    "nest_eggs_counted",
    "nest_fan_angles_measured",
    "nest_habitat",
    "nest_hatchlings_measured",
    "nest_logger_found",
    "nest_nest_tagged",
    "nest_tagged",
    "nest_type",
    "odkc_data",
    "obs",
    "observation_start_time",
    "pk",
    "properties",
    "reporter",
    "season",
    "season_week",
    "site_id",
    "site_name",
    "species",
    "status_health",
    "start",
    "start_comments",
    "start_time",
    "status",
    "source_id",
    "successful",
    "surveys",
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
    "user_mapping",
    "value",
    "vars",
    "wastd_data",
    "when",
    "Year"
  )
)
