#' Transform odkc_data$tracks into WAStD TNHE Outliers.
#'
#' @param data A tibble of tracks,  e.g. \code{odkc_data$tracks_fan_outlier}.
#' @return A tibble suitable to
#'   \code{\link{wastd_POST}("turtle-nest-hatchling-emergence-outliers")}
#' @export
#' @examples
#' \dontrun{
#' data("odkc_data", package = "wastdr")
#' au <- Sys.getenv("WASTDR_API_DEV_URL")
#' at <- Sys.getenv("WASTDR_API_DEV_TOKEN")
#' x <- odkc_tracks_fan_outlier_as_tnheo(odkc_ex$tracks_fan_outlier)
#' x %>% wastd_POST("turtle-nest-hatchling-emergence-outliers",
#'   api_url = au, api_token = at
#' )
#' }
odkc_tracks_fan_outlier_as_tnheo <- function(data) {
  data %>%
    sf_as_tbl() %>%
    dplyr::transmute(
      source = 2,
      source_id = id,
      encounter_source="odk",
      encounter_source_id = submissions_id,
      bearing_outlier_track_degrees = outlier_track_bearing_manual,
      outlier_group_size = outlier_group_size,
      outlier_track_comment = outlier_track_comment
    ) %>%
    dplyr::filter_at(
      dplyr::vars(-source, -source_id, -encounter_source, -encounter_source_id),
      dplyr::any_vars(!is.na(.))
    )
}

# usethis::use_test("odkc_tracks_fan_outlier_as_tnheo")
