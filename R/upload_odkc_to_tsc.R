#' Top level helper to upload all Turtle Nesting Census data to TSC
#'
#' Encounters and their related observations are uploaded to TSC:
#'
#' * New encounters will be created
#' * Existing but unchanged (status=new) encounters will be updated
#'   if `update_existing=TRUE`, else skipped.
#' * Existing and value-added encounters (status > new) will be skipped.s
#'
#' @param odkc_prep ODKC data transformed into TSC format.
#' @param tsc_data Minimal TSC data to inform skip logic.
#' @param update_existing Whether to update existing but unchanged records in
#'   TSC. Default: FALSE.
#' @return A list of results from the various uploads.
#'   Each result is a `wastd_api_response`.
#' @export
upload_odkc_to_tsc <-
  function(odkc_prep, tsc_data, update_existing = FALSE) {
    tne_res_update <- NULL
    tne_res_create <- NULL

    # Existing and unchanged encounters can be updated without losing edits in TSC
    enc_update <- tsc_data$enc %>% dplyr::filter(status == "new")

    # Existing and value-added data should never be overwritten
    enc_skip <- tsc_data$enc %>% dplyr::filter(status != "new")

    # TNE with source_id occurring in enc_update are candidates for updates
    tne_update <- odkc_prep$tne %>%
      dplyr::semi_join(enc_update, by = "source_id")

    # TNE with source_id not in TSC at all are candidates for creates
    tne_create <- odkc_prep$tne %>%
      dplyr::anti_join(tsc_data$enc, by = "source_id")

    # TNE with source_id in enc_skip are candidates for skipping
    tne_skip <- odkc_prep$tne %>%
      dplyr::semi_join(enc_skip, by = "source_id")


    if (nrow(tne_create) > 0) {
    "Uploading {nrow(tne_create)} new TurtleNestEncounters to WAStD"%>%
      glue::glue() %>% wastdr_msg_info()

      tne_res_create <- tne_create %>%
        # patched for local dev: some users don't exist yet
        # dplyr::mutate(reporter_id = 4, observer_id = 4) %>%
        wastd_POST(
          "turtle-nest-encounters",
          api_url = Sys.getenv("WASTDR_API_DEV_URL"),
          api_token = Sys.getenv("WASTDR_API_DEV_TOKEN"),
          verbose = TRUE
        )

      "Uploaded {nrow(tne_create)} new TurtleNestEncounters to WAStD"%>%
        glue::glue() %>% wastdr_msg_info()
    } else {
      "All caught up on TurtleNestEncounters to WAStD" %>% wastdr_msg_info()
    }
    if (update_existing == TRUE) {
      "Updating {nrow(tne_update)} existing TurtleNestEncounters to WAStD" %>%
        glue::glue() %>% wastdr_msg_info()

      tne_res_update <- tne_update %>%
        # patched for local dev: some users don't exist yet
        # dplyr::mutate(reporter_id = 4, observer_id = 4) %>%
        wastd_POST(
          "turtle-nest-encounters",
          api_url = Sys.getenv("WASTDR_API_DEV_URL"),
          api_token = Sys.getenv("WASTDR_API_DEV_TOKEN"),
          verbose = TRUE
        )

      "Updated {nrow(tne_update)} TurtleNestEncounters in WAStD" %>%
        glue::glue() %>% wastdr_msg_info()
    }

    list(
      tne_created = tne_res_create,
      tne_updated = tne_res_update,
      tne_skipped = tne_skip
      )
  }
