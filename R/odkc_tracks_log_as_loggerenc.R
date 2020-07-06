#' Transform odkc_data$tracks into WAStD TurtleNestEncounters.
#'
#' @param data A tibble of parsed ODKC Logger encounters,
#'   e.g. \code{odkc_data$tracks_log}.
#' @param user_mapping .
#' @return A tibble suitable to
#'   \code{\link{wastd_POST}("logger-encounters")}
#' @export
#' @examples
#' \dontrun{
#' data("odkc_data", package = "wastdr")
#' user_mapping <- NULL # see odkc_plan for actual user mapping
#'
#' odkc_data$tracks %>%
#'   odkc_tracks_log_as_loggerenc(user_mapping) %>%
#'   head(1) %>%
#'   jsonlite::toJSON()
#' }
odkc_tracks_log_as_loggerenc <- function(data, user_mapping) {
  tsc_reporters <- user_mapping %>%
    dplyr::transmute(reporter = odkc_username, reporter_id = pk)

  tsc_observers <- user_mapping %>%
    dplyr::transmute(observer = odkc_username, observer_id = pk)

  data %>%
    sf_as_tbl() %>%
    dplyr::transmute(
      source = "odk",
      source_id = id,
      reporter = reporter,
      observer = reporter,
      where = glue::glue(
        "POINT ({details_observed_at_longitude}",
        " {details_observed_at_latitude})"
      ),
      location_accuracy = "10",
      location_accuracy_m = details_observed_at_accuracy,
      when = lubridate::format_ISO8601(observation_start_time, usetz = TRUE),
      logger_type = "temperature-logger",
      deployment_status = "resighted",
      logger_id = logger_id
    ) %>%
    dplyr::left_join(tsc_reporters, by = "reporter") %>% # TSC User PK
    dplyr::left_join(tsc_observers, by = "observer") %>% # TSC User PK
    dplyr::select(-reporter, -observer) # drop odkc_username
}

# usethis::use_test("odkc_tracks_log_as_loggerenc")
