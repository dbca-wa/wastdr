#' Transform odkc_data$tracks into WAStD NestTagObservations.
#'
#' @param data A tibble of tracks,  e.g. \code{odkc_data$tracks_hatch}.
#' @return A tibble suitable to
#'   \code{\link{wastd_POST}("turtle-hatchling-morphometrics")}
#' @export
#' @examples
#' \dontrun{
#' data("odkc_data", package = "wastdr")
#' au <- Sys.getenv("WASTDR_API_DEV_URL")
#' at <- Sys.getenv("WASTDR_API_DEV_TOKEN")
#' x <- odkc_tracks_as_wastd_nesttagobs(odkc_ex$tracks_hatch)
#' x %>%
#'   wastd_POST("turtle-hatchling-morphometrics", api_url = au, api_token = at)
#' }
odkc_tracks_hatch_as_wastd_thmorph <- function(data) {
  data %>%
    sf_as_tbl() %>%
    dplyr::transmute(
      source = 2,
      source_id = id,
      encounter_source="odk",
      encounter_source_id = submissions_id,
      straight_carapace_length_mm = straight_carapace_length_mm,
      straight_carapace_width_mm = straight_carapace_width_mm,
      body_weight_g = body_weight_g
    ) %>%
    dplyr::filter_at(
      dplyr::vars(-source, -source_id, -encounter_source, -encounter_source_id),
      dplyr::any_vars(!is.na(.))
    )
}


# usethis::use_test("odkc_tracks_hatch_as_wastd_thmorph")
