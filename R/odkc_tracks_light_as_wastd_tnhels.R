#' Transform odkc_data$tracks into WAStD TurtleNestHatchlingEmergenceLightSources
#'
#' @param data A tibble of nest_lightsources,  e.g. \code{odkc_data$tracks_light}.
#' @return A tibble suitable to
#'   \code{\link{wastd_POST}("turtle-nest-hatchling-emergence-light-sources")}
#' @export
#' @examples
#' \dontrun{
#' data("odkc_data", package = "wastdr")
#' au <- Sys.getenv("WASTDR_API_DEV_URL")
#' at <- Sys.getenv("WASTDR_API_DEV_TOKEN")
#' x <- odkc_tracks_light_as_wastd_tnhels(odkc_ex$tracks_light)
#' x %>% wastd_POST("turtle-nest-hatchling-emergence-light-sources",
#'   api_url = au, api_token = at
#' )
#' }
odkc_tracks_light_as_wastd_tnhels <- function(data) {
  data %>%
    sf_as_tbl() %>%
    dplyr::transmute(
      source = 2,
      source_id = id,
      encounter_source="odk",
      encounter_source_id = submissions_id,
      bearing_light_degrees = light_bearing_manual,
      light_source_type = light_source_type,
      light_source_description = light_source_description
    ) %>%
    dplyr::filter_at(
      dplyr::vars(-source, -source_id, -encounter_source, -encounter_source_id),
      dplyr::any_vars(!is.na(.))
    )
}

# usethis::use_test("odkc_tracks_light_as_wastd_tnhels")
