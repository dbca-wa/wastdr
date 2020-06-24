#' Top level helper to upload all Turtle Nesting Census data to TSC
#'
#' Encounters and their related observations are uploaded to TSC:
#'
#' * New encounters will be created
#' * Existing but unchanged (status=new) encounters will be updated
#'   if `update_existing=TRUE`, else skipped.
#' * Existing and value-added encounters (status > new) will be skipped.s
#'
#' @param data ODKC data transformed into TSC format and split into create,
#'   update, skip.
#' @param update_existing Whether to update existing but unchanged records in
#'   TSC. Default: FALSE.
#' @template param-auth
#' @template param-verbose
#' @return A list of results from the various uploads.
#'   Each result is a `wastd_api_response`.
#' @export
upload_odkc_to_tsc <- function(data,
                               api_url = wastdr::get_wastdr_api_url(),
                               api_token = wastdr::get_wastdr_api_token(),
                               api_un = wastdr::get_wastdr_api_un(),
                               api_pw = wastdr::get_wastdr_api_pw(),
                               verbose = wastdr::get_wastdr_verbose()) {
  if (nrow(data$tne_create) > 0) {
    "Uploading {nrow(data$tne_create)} new TurtleNestEncounters to WAStD" %>%
      glue::glue() %>% wastdr_msg_info()

    tne_res_create <- data$tne_create %>%
      # patched for local dev: some users don't exist yet
      # dplyr::mutate(reporter_id = 4, observer_id = 4) %>%
      wastd_POST(
        "turtle-nest-encounters",
        api_url = Sys.getenv("WASTDR_API_DEV_URL"),
        api_token = Sys.getenv("WASTDR_API_DEV_TOKEN"),
        verbose = TRUE
      )

    "Uploaded {nrow(data$tne_create)} new TurtleNestEncounters to WAStD" %>%
      glue::glue() %>% wastdr_msg_info()
  } else {
    "All caught up on TurtleNestEncounters to WAStD" %>% wastdr_msg_info()
  }
  if (update_existing == TRUE) {
    "Updating {nrow(data$tne_update)} existing TurtleNestEncounters to WAStD" %>%
      glue::glue() %>% wastdr_msg_info()

    tne_res_update <- data$tne_update %>%
      # patched for local dev: some users don't exist yet
      # dplyr::mutate(reporter_id = 4, observer_id = 4) %>%
      wastd_POST(
        "turtle-nest-encounters",
        api_url = Sys.getenv("WASTDR_API_DEV_URL"),
        api_token = Sys.getenv("WASTDR_API_DEV_TOKEN"),
        verbose = TRUE
      )

    "Updated {nrow(data$tne_update)} TurtleNestEncounters in WAStD" %>%
      glue::glue() %>% wastdr_msg_info()
  }

  list(
    tne_created = tne_res_create,
    tne_updated = tne_res_update,
    tne_skipped = tne_skip
  )
}
