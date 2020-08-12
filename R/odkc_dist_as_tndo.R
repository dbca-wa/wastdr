#' Transform odkc_data$dist into WAStD TurtleNestDisturbanceObservations.
#'
#' The corresponding Encounters are created through
#' \code{\link{odkc_dist_as_distenc}}.
#'
#' @param data A tibble of dist,  e.g. \code{odkc_data$dist}.
#' @return A tibble suitable to
#'   \code{\link{wastd_POST}("turtle-nest-disturbance-observations")}
#' @export
#' @examples
#' \dontrun{
#' data("odkc_data", package = "wastdr")
#' au <- Sys.getenv("WASTDR_API_DEV_URL")
#' at <- Sys.getenv("WASTDR_API_DEV_TOKEN")
#' x <- odkc_dist_as_tndo(odkc_ex$tracks_dist)
#' x %>% wastd_POST("turtle-nest-disturbance-observations",
#'   api_url = au, api_token = at
#' )
#' }
odkc_dist_as_tndo <- function(data) {
  data %>%
    sf_as_tbl() %>%
    dplyr::transmute(
      source = 2,
      source_id = id,
      encounter_source="odk",
      encounter_source_id = id,
      disturbance_cause = disturbanceobservation_disturbance_cause,
      disturbance_cause_confidence = disturbanceobservation_disturbance_cause_confidence,
      # # general dist obs have no related nest and thus no severity:
      # disturbance_severity = NA,
      comments = disturbanceobservation_comments
    ) %>%
    dplyr::filter_at(
      dplyr::vars(-source, -source_id, -encounter_source, -encounter_source_id),
      dplyr::any_vars(!is.na(.))
    )
}

# usethis::use_test("odkc_dist_as_tndo")
