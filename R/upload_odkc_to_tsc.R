#' Top level helper to upload all Turtle Nesting Census data to TSC
#'
#' @param odkc_prep ODKC data transformed into TSC format.
#' @param tsc_data Minimal TSC data to inform skip logic.
#' @return A list of results from the various uploads.
#'   Each result is a `wastd_api_response`.
#' @export
upload_odkc_to_tsc <-
  function(odkc_prep, tsc_data, update_existing = FALSE) {
    tne_res_update <- NULL
    tne_res_create <- NULL

    tne_update <-
      dplyr::semi_join(odkc_prep$tne, tsc_data$enc, by = "source_id")
    tne_create <-
      dplyr::anti_join(odkc_prep$tne, tsc_data$enc, by = "source_id")

    "Uploading {nrow(tne_create)} new TurtleNestEncounters to WAStD"%>%
      glue::glue() %>% wastdr_msg_info()

    tne_res_create <- tne_create %>%
      # patched for local dev: some users don't exist yet
      dplyr::mutate(reporter_id = 4, observer_id = 4) %>%
      wastd_POST(
        "turtle-nest-encounters",
        api_url = Sys.getenv("WASTDR_API_DEV_URL"),
        api_token = Sys.getenv("WASTDR_API_DEV_TOKEN"),
        verbose = TRUE
      )

    "Uploaded {nrow(tne_create)} new TurtleNestEncounters to WAStD"%>%
      glue::glue() %>% wastdr_msg_info()

    if (update_existing == TRUE) {
      "Updating {nrow(tne_update)} existing TurtleNestEncounters to WAStD" %>%
        glue::glue() %>% wastdr_msg_info()

      tne_res_update <- tne_update %>%
        # patched for local dev: some users don't exist yet
        dplyr::mutate(reporter_id = 4, observer_id = 4) %>%
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
      tne_updated = tne_res_update
      )
  }
