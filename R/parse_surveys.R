#' Parse a \code{wastd_api_response} of \code{surveys} to tbl_df
#'
#' \lifecycle{maturing}
#'
#' @param wastd_api_response A \code{wastd_api_response} of
#'  \code{surveys}, e.g. \code{get_wastd("surveys")}
#' @param payload The parameter `payload` for \code{wastd_parse}.
#' @template param-wastd_url
#' @return A \code{tbl_df} with columns:
#' \itemize{
#'   \item area_name (chr) The name of the Locality this Survey took place in.
#'   \item area_id (int) The ID of the Locality this Survey took place in.
#'   \item site_name (chr) The name of the Site this Survey took place in.
#'   \item site_id (int) The ID of the Site this Survey took place in.
#'   \item reporter (chr)
#'   \item reporter_username (chr)
#'   \item reporter_id (chr)
#'   \item start_time (dttm) The actual start time of the survey.
#'   \item end_time (dttm) The actual, automatically guessed (if 6h later), or
#'   human guessed end time.
#'   \item start_comments (chr) Comments at start plus QA messages from username
#'   guessing
#'   \item end_comments (chr) Comments at end plus QA messages from username
#'   guessing. A mismatch
#'         of original usernames can indicate an incorrectly picked Site Visit
#'         End point.
#'   \item turtle_date (dttm) The "turtle date" of the survey.
#'   \item season_week (int) The number of completed weeks since fiscal year
#'   start
#'   \item iso_week (int) The number of completed weeks since calendar year
#'   start
#'   \item season (int) The "turtle season" of the survey, rolling over with
#'   Fiscal Year.
#'   \item source (chr) Where this record was born.
#'   \item source_id (chr) The ODK record UID of the Site Visit Start.
#'   \item end_source_id (chr) The ODK record UID of the Site Visit End.
#'   \item status (chr) The QA status of the Survey. "Proofread" or "Curated"
#'   indicate human QA edits.
#'   \item device_id (chr) The unique ID of the device the Site Visit Start was
#'   captured on.
#'   \item end_device_id (chr) The unique ID of the device the Site Visit End
#'   was captured on.
#'   \item status (chr) QA status of the survey.
#'   \item id (int) WAStD ID of the survey.
#'   \item is_production (bool) Whether this survey is a real (production) or
#'     a training survey.
#'   \item absolute_admin_url (chr) The absolute URL path to edit the survey in
#'   WAStD. Append this to the base `WASTD_URL`.
#' }
#' @export
#' @family wastd
parse_surveys <- function(wastd_api_response,
                          wastd_url = wastdr::get_wastd_url(),
                          payload = "data") {
  wastd_api_response %>%
    magrittr::extract2(payload) %>%
    {
      tibble::tibble(
        area_name = map_chr_hack(., c("properties", "area", "name")),
        area_id = map_chr_hack(
          ., c("properties", "area", "pk")
        ) %>% as.integer(),
        site_name = map_chr_hack(., c("properties", "site", "name")),
        site_id = map_chr_hack(
          ., c("properties", "site", "pk")
        ) %>% as.integer(),
        reporter = map_chr_hack(., c("properties", "reporter", "name")),
        reporter_username = map_chr_hack(
          ., c("properties", "reporter", "username")
        ),
        reporter_id = map_chr_hack(., c("properties", "reporter", "pk")),
        start_time = purrr::map_chr(., c("properties", "start_time")) %>%
          httpdate_as_gmt08(),
        end_time = map_chr_hack(
          ., c("properties", "end_time")
        ) %>% httpdate_as_gmt08(),
        start_comments = map_chr_hack(., c("properties", "start_comments")),
        end_comments = map_chr_hack(., c("properties", "end_comments")),
        source = purrr::map_chr(., c("properties", "source")),
        source_id = map_chr_hack(., c("properties", "source_id")),
        end_source_id = map_chr_hack(., c("properties", "end_source_id")),
        device_id = map_chr_hack(., c("properties", "device_id")),
        end_device_id = map_chr_hack(., c("properties", "end_device_id")),
        status = map_chr_hack(., c("properties", "status")),
        id = purrr::map_int(., "id"),
        is_production = map_chr_hack(
          ., c("properties", "production")
        ) %>% as.logical(),
        absolute_admin_url = map_chr_hack(
          ., c("properties", "absolute_admin_url")
        )
        # transect, start_location, end_location, team
      )
    } %>%
    add_dates(date_col = "start_time", parse_date = FALSE) %>%
    dplyr::mutate(
      change_url = glue::glue(
        '<a href="{wastd_url}{absolute_admin_url}"
      target="_">Update Survey {id}</a>'
      ),
      duration_minutes = (
        lubridate::interval(start_time, end_time) %>%
          lubridate::as.period() %>%
          as.numeric()
      ) / 60 %>% round(digits = 2),
      duration_hours = duration_minutes / 60 %>% round(digits = 2)
    )
}

# usethis::use_test("parse_surveys")
