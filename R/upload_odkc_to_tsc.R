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
                               update_existing = FALSE,
                               api_url = wastdr::get_wastdr_api_url(),
                               api_token = wastdr::get_wastdr_api_token(),
                               api_un = wastdr::get_wastdr_api_un(),
                               api_pw = wastdr::get_wastdr_api_pw(),
                               verbose = wastdr::get_wastdr_verbose()) {
  # -------------------------------------------------------------------------- #
  # TNE
  if (nrow(data$tne_create) > 0) {
    "Uploading {nrow(data$tne_create)} new TurtleNestEncounters" %>%
      glue::glue() %>% wastdr_msg_info()

    tne_res_create <- data$tne_create %>%
      wastd_POST(
        "turtle-nest-encounters",
        api_url = api_url,
        api_token = api_token,
        verbose = TRUE
      )

    "Uploaded {nrow(data$tne_create)} new TurtleNestEncounters" %>%
      glue::glue() %>% wastdr_msg_info()
  } else {
    "No new TurtleNestEncounters to create" %>% wastdr_msg_info()
    tne_res_create <- NULL
  }

  if (nrow(data$tne_update) > 0) {
    if (update_existing == TRUE) {
      "Updating {nrow(data$tne_update)} existing and uncurated TurtleNestEncounters" %>%
        glue::glue() %>% wastdr_msg_info()

      tne_res_update <- data$tne_update %>%
        wastd_POST(
          "turtle-nest-encounters",
          api_url = api_url,
          api_token = api_token,
          verbose = TRUE
        )

      "Updated {nrow(data$tne_update)} TurtleNestEncounters" %>%
        glue::glue() %>% wastdr_msg_info()
    }
    else {
      "Skipped {nrow(data$tne_update)} existing and uncurated TurtleNestEncounters" %>%
        glue::glue() %>% wastdr_msg_info()
      tne_res_update <- NULL
    }
  } else {
    "No existing TurtleNestEncounters to update" %>% wastdr_msg_info()
    tne_res_update <- NULL
  }

  if (nrow(data$tne_skip) > 0) {
    "Skipping {nrow(data$tne_skip)} existing and curated TurtleNestEncounters" %>%
      glue::glue() %>% wastdr_msg_info()
  }

  # -------------------------------------------------------------------------- #
  # AE
  if (nrow(data$ae_mwi_create) > 0) {
    "Uploading {nrow(data$ae_mwi_create)} new AnimalEncounters (strandings)" %>%
      glue::glue() %>% wastdr_msg_info()

    ae_mwi_res_create <- data$ae_mwi_create %>%
      wastd_POST(
        "animal-encounters",
        api_url = api_url,
        api_token = api_token,
        verbose = TRUE
      )

    "Uploaded {nrow(data$ae_mwi_create)} new AnimalEncounters" %>%
      glue::glue() %>% wastdr_msg_info()
  } else {
    "No new AnimalEncounters to create" %>% wastdr_msg_info()
    ae_mwi_res_create <- NULL
  }

  if (nrow(data$ae_mwi_update) > 0) {
    if (update_existing == TRUE) {
      "Updating {nrow(data$ae_mwi_update)} existing and uncurated AnimalEncounters" %>%
        glue::glue() %>% wastdr_msg_info()

      ae_mwi_res_update <- data$ae_mwi_update %>%
        wastd_POST(
          "animal-encounters",
          api_url = api_url,
          api_token = api_token,
          verbose = TRUE
        )

      "Updated {nrow(data$ae_mwi_update)} AnimalEncounters" %>%
        glue::glue() %>% wastdr_msg_info()
    }
    else {
      "Skipped {nrow(data$ae_mwi_update)} existing and uncurated AnimalEncounters" %>%
        glue::glue() %>% wastdr_msg_info()
      ae_mwi_res_update <- NULL
    }
  } else {
    "No existing AnimalEncounters to update" %>% wastdr_msg_info()
    ae_mwi_res_update <- NULL
  }

  if (nrow(data$ae_mwi_skip) > 0) {
    "Skipping {nrow(data$ae_mwi_skip)} existing and curated AnimalEncounters" %>%
      glue::glue() %>% wastdr_msg_info()
  }
  #
  # -------------------------------------------------------------------------- #
  # Enc
  #
  # others
  list(
    # TNE from tracks
    tne_created = tne_res_create,
    tne_updated = tne_res_update,
    tne_skipped = data$tne_skip,

    # AE frmo mwi
    ae_mwi_created = ae_mwi_res_create,
    ae_mwi_updated = ae_mwi_res_update,
    ae_mwi_skipped = data$ae_mwi_skip

  )
}
