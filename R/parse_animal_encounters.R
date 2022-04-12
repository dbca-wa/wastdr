#' Parse a \code{wastd_api_response} of \code{animal-encounters} to tbl_df
#'
#' \lifecycle{stable}
#'
#' @param wastd_api_response A \code{wastd_api_response} of
#' \code{animal-encounters}, e.g. \code{get_wastd("animal-encounters")}
#' @return A \code{tbl_df} with columns:
#' \itemize{
#'   \item area_name (chr)
#'   \item area_type (chr)
#'   \item area_id (int)
#'   \item site_name (chr)
#'   \item site_type (chr)
#'   \item site_id (int)
#'   \item survey_id (int)
#'   \item survey_start_time (dttm)
#'   \item survey_end_time (dttm)
#'   \item survey_start_comments (chr)
#'   \item survey_end_comments (chr)
#'   \item datetime (dttm)
#'   \item turtle_date (date)
#'   \item season (int)
#'   \item season_week (int) Number of completed weeks since fiscal year start
#'   \item iso_week (int) Number of completed weeks since calendar year start
#'   \item longitude (chr)
#'   \item latitude (chr)
#'   \item crs (chr)
#'   \item location_accuracy (dbl)
#'   \item name (chr)
#'   \item species (chr)
#'   \item health (chr)
#'   \item sex (chr)
#'   \item maturity (chr)
#'   \item behaviour (chr)
#'   \item habitat (chr)
#'   \item activity (chr)
#'   \item comments (chr)
#'   \item nesting_event (chr)
#'   \item checked_for_injuries (chr)
#'   \item scanned_for_pit_tags (chr)
#'   \item checked_for_flipper_tags (chr)
#'   \item cause_of_death (chr)
#'   \item cause_of_death_confidence (chr)
#'   \item absolute_admin_url (chr)
#'   \item obs (list)
#'   \item source (chr)
#'   \item source_id (chr)
#'   \item encounter_type (chr)
#'   \item status (chr)
#' }
#' @export
#' @family wastd
parse_animal_encounters <- function(wastd_api_response) {
  wastd_api_response %>%
    wastdr::wastd_parse() %>%
    dplyr::select(-"geometry") %>%
    tun("area") %>%
    tun("site") %>%
    tun("survey") %>%
    tun("survey_area") %>%
    tun("survey_site") %>%
    tun("survey_reporter") %>%
    tun("observer") %>%
    tun("reporter") %>%
    tun("site_of_first_sighting") %>%
    tun("site_of_last_sighting") %>%
    dplyr::select(
      -tidyr::contains("encounter_survey_area"),
      -tidyr::contains("encounter_survey_site"),
      -tidyr::contains("encounter_survey_reporter")
      # -tidyr::contains("encounter_photographs"),
      # -tidyr::contains("encounter_tx_logs")
    ) %>%
    wastdr::add_dates(date_col = "when")
}
