#' Transform odkc_data$mwi into WAStD AnimalEncounters.
#'
#' @param data The tibble of Marine Wildlife Incidents,
#'   e.g. \code{odkc_data$mwi}.
#' @param user_mapping .
#' @return A tibble suitable to
#'   \code{\link{wastd_POST}("animal-encounters")}
#' @export
#' @examples
#' \dontrun{
#' data("odkc_data", package = "wastdr")
#' user_mapping <- NULL # see odkc_plan for actual user mapping
#' ae <- odkc_mwi_as_wastd_ae(odkc_ex$mwi, user_mapping)
#'
#' ae %>%
#'   wastd_POST("animal-encounters",
#'     api_url = Sys.getenv("WASTDR_API_DEV_URL"),
#'     api_token = Sys.getenv("WASTDR_API_DEV_TOKEN")
#'   )
#' }
odkc_mwi_as_wastd_ae <- function(data, user_mapping) {
  wastd_reporters <- user_mapping %>%
    dplyr::transmute(reporter = odkc_username, reporter_id = pk)

  wastd_observers <- user_mapping %>%
    dplyr::transmute(observer = odkc_username, observer_id = pk)

  data %>%
    sf_as_tbl() %>%
    dplyr::transmute(
      source = "odk", # wastd.observations.models.SOURCE_CHOICES
      source_id = id,
      observer = reporter,
      reporter = reporter, # user_mapping$odkc_username
      comments = glue::glue(
        "Device ID {device_id}\n",
        "Samples taken : {checks_samples_taken}\n",
        "Animal fate: {animal_fate_animal_fate_comment}\n",
        "Form filled in from {observation_start_time} to ",
        "{observation_end_time}\n"
      ),
      # TODO: prefer incident_observed_at_manual if given
      where = glue::glue(
        "POINT ({incident_observed_at_longitude}",
        " {incident_observed_at_latitude})"
      ),
      location_accuracy = "10",
      location_accuracy_m = ifelse(
        is.na(incident_observed_at_manual_accuracy),
        incident_observed_at_accuracy,
        incident_observed_at_manual_accuracy
      ),
      when = lubridate::format_ISO8601(incident_incident_time, usetz = TRUE),
      taxon = details_taxon %>% tidyr::replace_na("na"),
      species = details_species %>% tidyr::replace_na("na"),
      health = status_health %>% tidyr::replace_na("na"),
      sex = details_sex %>% tidyr::replace_na("na"),
      maturity = details_maturity %>% tidyr::replace_na("na"),
      behaviour = status_behaviour %>% tidyr::replace_na("na"),
      habitat = incident_habitat %>% tidyr::replace_na("na"),
      activity = status_activity %>% tidyr::replace_na("na"),
      nesting_event = "absent",
      checked_for_injuries = checks_checked_for_injuries %>%
        tidyr::replace_na("na"),
      scanned_for_pit_tags = checks_scanned_for_pit_tags %>%
        tidyr::replace_na("na"),
      checked_for_flipper_tags = checks_checked_for_flipper_tags %>%
        tidyr::replace_na("na"),
      cause_of_death = death_cause_of_death,
      cause_of_death_confidence = death_cause_of_death_confidence
    ) %>%
    dplyr::left_join(wastd_reporters, by = "reporter") %>% # TSC User PK
    dplyr::left_join(wastd_observers, by = "observer") %>% # TSC User PK
    dplyr::select(-reporter, -observer) %>%
    invisible()
}

# usethis::use_test("odkc_mwi_as_wastd_ae")
