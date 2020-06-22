#' Transform odkc_data$tracks into WAStD TurtleNestEncounter
#'
#' @param data The tibble of parsed WAStD TurtleNestEncounters,
#'   e.g. \code{odkc_data$tracks}.
#' @return A tibble suitable to
#'   \code{\link{wastd_bulk_post}("turtle-nest-encounters")}
#' @export
#' @examples
#' \dontrun{
#' data("odkc_data", package = "wastdr")
#'
#' odkc_data$tracks %>%
#'   odkc_tracks_as_wastd_tne() %>%
#'   head(1) %>%
#'   jsonlite::toJSON()
#'
# odkc_data$tracks %>%
#   odkc_tracks_as_wastd_tne() %>%
#'   head() %>%
#'   wastd_bulk_post("turtle-nest-encounters",
#'     api_url = "http://localhost:8220/api/1/",
#'     api_token = Sys.getenv("WASTDR_API_DEV_TOKEN"))
#'
#' }
odkc_tracks_as_wastd_tne <- function(data) {
  data %>%
    sf_as_tbl() %>%
    dplyr::transmute(
      source = "odk",
      source_id = id,
      reporter_id = 4, # guess_user(name) > WAStD user PK
      observer_id = 4,
      comments = glue::glue("Device ID {device_id}"),
      where = glue::glue(
        "POINT ({details_observed_at_longitude}",
        " {details_observed_at_latitude})"
      ),
      location_accuracy = "10",
      location_accuracy_m = details_observed_at_accuracy,
      when = observation_start_time,
      nest_age = details_nest_age,
      nest_type = details_nest_type,
      species = details_species,
      habitat = nest_habitat %>% tidyr::replace_na("na"),
      disturbance = nest_disturbance %>% tidyr::replace_na("na"),
      nest_tagged = nest_nest_tagged %>% tidyr::replace_na("na"),
      logger_found = nest_logger_found %>% tidyr::replace_na("na"),
      eggs_counted = nest_eggs_counted %>% tidyr::replace_na("na"),
      hatchlings_measured = nest_hatchlings_measured %>% tidyr::replace_na("na"),
      fan_angles_measured = nest_fan_angles_measured %>% tidyr::replace_na("na")
    )
}


# usethis::use_test("odkc_tracks_as_wastd_tne")
