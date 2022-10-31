#' Parse a \code{wastd_api_response} of Encounter observations to tbl_df
#'
#' \lifecycle{stable}
#'
#' WAStD provides all subclasses of `wastd.observations.observation` together
#' with their encounter (survey, site, area, reporter, observer) via its API
#' as GeoJSON FeatureCollections.
#'
#' This function acts as a generic parser for
#'
#' * "turtle-nest-hatchling-emergences"
#' * "turtle-nest-hatchling-emergence-outliers"
#' * "turtle-nest-hatchling-emergence-light-sources"
#' * "turtle-nest-excavations"
#' * "turtle-nest-tag-observations"
#' * "turtle-nest-disturbance-observations"
#'
#' @param wastd_api_response A \code{wastd_api_response} of
#' \code{turtle-nest-*}, e.g.
#' \code{wastd_GET("turtle-nest-encounters")}
#' @param payload The parameter `payload` for \code{wastd_parse}.
#' @return A \code{tbl_df} with non-repetitive columns of:
#' \itemize{
#'   \item Encounter
#'   \item Survey
#'   \item Area
#'   \item Site
#'   \item Observation
#' }
#' @export
#' @family wastd
parse_encounterobservations <- function(wastd_api_response, payload = "data") {
  wastd_api_response %>%
    wastdr::wastd_parse(payload = payload) %>%
    tidyr::unnest_wider("encounter", names_repair = "universal") %>%
    dplyr::select(-"geometry", -"type") %>%
    dplyr::rename(encounter = properties, encounter_id = id) %>%
    tun("encounter") %>%
    tun("encounter_area") %>%
    tun("encounter_site") %>%
    tun("encounter_survey") %>%
    tun("encounter_observer") %>%
    tun("encounter_reporter") %>%
    tun("handler") %>%
    tun("recorder") %>%
    dplyr::select(
      -tidyr::contains("encounter_survey_area"),
      -tidyr::contains("encounter_survey_site"),
      -tidyr::contains("encounter_survey_reporter"),
      -tidyr::contains("encounter_photographs"),
      -tidyr::contains("encounter_tx_logs")
    ) %>%
    wastdr::add_dates(date_col = "encounter_when")
}

# usethis::use_test("parse_encounterobservations")
