#' Parse a \code{wastd_api_response} of Encounter observations to tbl_df
#'
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
#' @import magrittr
parse_encounterobservations <- function(wastd_api_response) {
    wastd_api_response %>%
        wastdr::wastd_parse() %>%
        dplyr::select(-"geometry", -"type", -"latitude", -"longitude") %>%
        tidyr::unnest_wider("encounter", names_repair = "universal") %>%
        tidyr::unnest_wider("properties", names_repair = "universal") %>%
        tidyr::unnest_wider("area", names_repair = "universal", names_sep =
                                "_") %>%
        tidyr::unnest_wider("site", names_repair = "universal", names_sep =
                                "_") %>%
        tidyr::unnest_wider("survey", names_repair = "universal", names_sep =
                                "_") %>%
        tidyr::unnest_wider("observer",
                            names_repair = "universal",
                            names_sep = "_") %>%
        tidyr::unnest_wider("reporter",
                            names_repair = "universal",
                            names_sep = "_") %>%
        dplyr::select(-"geometry",
                      -"type",
                      -"survey_site",
                      -"survey_reporter",
                      -"photographs") %>%
        dplyr::mutate(observation_start_time = httpdate_as_gmt08(when)) %>%
        wastdr::add_dates()

}
