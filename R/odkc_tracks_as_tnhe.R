#' Transform odkc_data$tracks into WAStD TurtleNestHatchlingEmergences.
#'
#' @param data A tibble of tracks,  e.g. \code{odkc_data$tracks}.
#' @return A tibble suitable to
#'   \code{\link{wastd_POST}("turtle-nest-hatchling-emergences")}
#' @export
#' @examples
#' \dontrun{
#' data("odkc_data", package = "wastdr")
#' au <- Sys.getenv("WASTDR_API_DEV_URL")
#' at <- Sys.getenv("WASTDR_API_DEV_TOKEN")
#' x <- odkc_tracks_as_tnhe(odkc_ex$tracks)
#' x %>% wastd_POST(
#'   serializer = "turtle-nest-hatchling-emergences",
#'   api_url = au, api_token = at
#' )
#' }
odkc_tracks_as_tnhe <- function(data) {
  data %>%
    sf_as_tbl() %>%
    dplyr::transmute(
      source = 2,
      source_id = id,
      encounter_source="odk",
      encounter_source_id = id,
      # might need replace_na
      bearing_to_water_degrees = fan_angles_bearing_to_water_manual,
      bearing_leftmost_track_degrees = fan_angles_leftmost_track_manual,
      bearing_rightmost_track_degrees = fan_angles_rightmost_track_manual,
      no_tracks_main_group = fan_angles_no_tracks_main_group,
      no_tracks_main_group_min = fan_angles_no_tracks_main_group_min,
      no_tracks_main_group_max = fan_angles_no_tracks_main_group_max,
      outlier_tracks_present = fan_angles_outlier_tracks_present,
      path_to_sea_comments = fan_angles_path_to_sea_comments,
      hatchling_emergence_time_known = fan_angles_hatchling_emergence_time_known,
      light_sources_present = fan_angles_light_sources_present,
      hatchling_emergence_time = hatchling_emergence_time_group_hatchling_emergence_time,
      hatchling_emergence_time_accuracy = hatchling_emergence_time_group_hatchling_emergence_time_source,
      cloud_cover_at_emergence = emergence_climate_cloud_cover_at_emergence
    ) %>%
    dplyr::filter_at(
      dplyr::vars(-source, -source_id, -encounter_source, -encounter_source_id),
      dplyr::any_vars(!is.na(.))
    )
}
# usethis::use_test("odkc_tracks_as_tnhe")
