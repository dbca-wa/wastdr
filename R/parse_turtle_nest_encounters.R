#' Parse a \code{wastd_api_response} of \code{turtle-nest-encounters} to tbl_df
#'
#' \lifecycle{maturing}
#'
#' @param wastd_api_response A \code{wastd_api_response} of
#' \code{turtle-nest-encounters}, e.g.
#' \code{wastd_GET("turtle-nest-encounters")}
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
#'   \item longitude (dbl)
#'   \item latitude (dbl)
#'   \item crs (chr)
#'   \item location_accuracy (dbl)
#'   \item species (chr)
#'   \item nest_age (chr)
#'   \item nest_type (chr)
#'   \item name (chr)
#'   \item habitat (chr)
#'   \item disturbance (chr)
#'   \item comments (chr)
#'   \item absolute_admin_url (chr)
#'   \item obs (list)
#'   \item photos (list)
#'   \item hatching_success (dbl)
#'   \item emergence_success (dbl)
#'   \item clutch_size (dbl) The calculated clutch size reconstructed from
#'   excavated eggs.
#'   \item egg_count (dbl) The directly observed clutch size during tagging.
#'   \item source (chr)
#'   \item source_id (chr)
#'   \item encounter_type (chr)
#'   \item status (chr)
#'   \item observer (chr)
#'   \item reporter (chr)
#' }
#' @export
#' @family wastd
parse_turtle_nest_encounters <- function(wastd_api_response) {
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
    dplyr::select(
      -tidyr::contains("encounter_survey_area"),
      -tidyr::contains("encounter_survey_site"),
      -tidyr::contains("encounter_survey_reporter"),
      # -tidyr::contains("encounter_photographs"),
      #   -tidyr::contains("encounter_tx_logs")
    ) %>%
    wastdr::add_dates(date_col = "when") %>%
    wastdr::add_nest_labels()
}

# usethis::use_test("parse_turtle_nest_encounters")
