#' Transform odkc_data$dist into WAStD Encounters.
#'
#' Related TurtleNestDisturbanceObservations are generated with
#' \code{\link{odkc_dist_as_tndo}}.
#'
#' @param data A tibble of parsed ODKC Disturbance encounters,
#'   e.g. \code{odkc_data$dist}.
#' @param user_mapping .
#' @return A tibble suitable to
#'   \code{\link{wastd_POST}("encounters")}
#' @export
#' @examples
#' \dontrun{
#' data("odkc_data", package = "wastdr")
#' user_mapping <- NULL # see odkc_plan for actual user mapping
#'
#' odkc_data$tracks %>%
#'   odkc_dist_as_distenc(user_mapping) %>%
#'   head(1) %>%
#'   jsonlite::toJSON()
#' }
odkc_dist_as_distenc <- function(data, user_mapping) {
  wastd_reporters <- user_mapping %>%
    dplyr::transmute(reporter = odkc_username, reporter_id = pk)

  wastd_observers <- user_mapping %>%
    dplyr::transmute(observer = odkc_username, observer_id = pk)

  data %>%
    sf_as_tbl() %>%
    dplyr::transmute(
      source = "odk", # wastd.observations.models.SOURCE_CHOICES
      source_id = id,
      reporter = reporter,
      observer = reporter,
      where = glue::glue(
        "POINT ({disturbanceobservation_location_longitude}",
        " {disturbanceobservation_location_latitude})"
      ),
      location_accuracy = "10",
      location_accuracy_m = disturbanceobservation_location_accuracy,
      when = lubridate::format_ISO8601(observation_start_time, usetz = TRUE)
    ) %>%
    dplyr::left_join(wastd_reporters, by = "reporter") %>% # TSC User PK
    dplyr::left_join(wastd_observers, by = "observer") %>% # TSC User PK
    dplyr::select(-reporter, -observer) # drop odkc_username
}

# usethis::use_test("odkc_dist_as_distenc")
