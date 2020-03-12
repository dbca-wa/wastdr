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
parse_encounterobservations <- function(wastd_api_response) {
  wastd_api_response %>%
      wastdr::wastd_parse() %>%
      dplyr::select(
        -"geometry",
        -"type",
        -dplyr::ends_with("latitude"),
        -dplyr::ends_with("longitude")
      ) %>%
      tidyr::unnest_wider("encounter",
                          names_repair = "universal") %>%
      dplyr::select(-"geometry", -"type") %>%
      dplyr::rename(encounter = properties) %>%
      tidyr::unnest_wider("encounter",
                          names_repair = "universal",
                          names_sep = "_") %>%
      {
        if ("encounter_area" %in% colnames(.))
          tidyr::unnest_wider(.,
                              "encounter_area",
                              names_repair = "universal",
                              names_sep = "_")
        else
          .
      } %>%
      {
        if ("encounter_area" %in% colnames(.))
          tidyr::unnest_wider(.,
                              "encounter_site",
                              names_repair = "universal",
                              names_sep = "_")
        else
          .
      } %>% {
        if ("encounter_area" %in% colnames(.))
          tidyr::unnest_wider(.,
                              "encounter_survey",
                              names_repair = "universal",
                              names_sep = "_")
        else
          .
      } %>%
      tidyr::unnest_wider("encounter_observer",
                          names_repair = "universal",
                          names_sep = "_") %>%
      tidyr::unnest_wider("encounter_reporter",
                          names_repair = "universal",
                          names_sep = "_") %>%
      dplyr::select(
        -tidyr::contains("encounter_survey_site"),
        -tidyr::contains("encounter_survey_reporter"),
        -tidyr::contains("encounter_photographs"),
        -tidyr::contains("encounter_tx_logs")
      ) %>%
      dplyr::mutate(
        observation_start_time = httpdate_as_gmt08(encounter_when)
      ) %>%
      wastdr::add_dates()
}

# usethis::use_test("parse_encounterobservations")
