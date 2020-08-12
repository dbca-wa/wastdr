

#' Transform odkc_data$tracks_dist into WAStD TurtleNestDisturbanceObservations.
#'
#' @param data A tibble of tracks_dist,  e.g. \code{odkc_data$tracks_dist}.
#' @return A tibble suitable to
#'   \code{\link{wastd_POST}("turtle-nest-disturbance-observations")}
#' @export
#' @examples
#' \dontrun{
#' data("odkc_data", package = "wastdr")
#' au <- Sys.getenv("WASTDR_API_DEV_URL")
#' at <- Sys.getenv("WASTDR_API_DEV_TOKEN")
#' x <- odkc_tracks_dist_as_wastd_tndistobs(odkc_ex$tracks_dist)
#' x %>% wastd_POST("turtle-nest-disturbance-observations",
#'   api_url = au, api_token = at
#' )
#' }
odkc_tracks_dist_as_wastd_tndistobs <- function(data) {
  data %>%
    sf_as_tbl() %>%
    dplyr::transmute(
      source = 2,
      source_id = id,
      encounter_source="odk",
      encounter_source_id = submissions_id,
      disturbance_cause = disturbance_cause,
      disturbance_cause_confidence = disturbance_cause_confidence,
      disturbance_severity = disturbance_severity,
      comments = comments
    ) %>%
    dplyr::filter_at(
      dplyr::vars(-source, -source_id, -encounter_source, -encounter_source_id),
      dplyr::any_vars(!is.na(.))
    )
}

# usethis::use_test("odkc_tracks_dist_as_wastd_tndistobs")
