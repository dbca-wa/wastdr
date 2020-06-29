#' Create, update, skip records to a WAStD serializer.
#'
#' Handles empty data, verbose notifications.
#'
#' @param data_create Records to create.
#' @param data_update Records to update.
#' @param data_skip Records to skip.
#' @param update_existing Whether to update existing but unchanged records in
#'   WAStD. Default: FALSE.
#' @param label The model label for verbose messages, default: `records`.
#' @param serializer The WAStD API serializer, default: `encounters`.
#' @template param-auth
#' @template param-verbose
#' @return A list of three objects:
#'
#' * `created` The WAStD API response for all created records
#' * `updated` The WAStD API response for all updated records
#' * `skipped` The original records for all skipped records
wastd_create_update_skip <- function(
    data_create,
    data_update,
    data_skip,
    update_existing = FALSE,
    label = "records",
    serializer="encounters",
    api_url = wastdr::get_wastdr_api_url(),
    api_token = wastdr::get_wastdr_api_token(),
    api_un = wastdr::get_wastdr_api_un(),
    api_pw = wastdr::get_wastdr_api_pw(),
    verbose = wastdr::get_wastdr_verbose()
){
    if (nrow(data_create) > 0) {
        "Uploading {nrow(data_create)} new {label}" %>%
            glue::glue() %>% wastdr_msg_info()

        created <- data_create %>%
            wastd_POST(
                serializer,
                api_url = api_url,
                api_token = api_token,
                verbose = TRUE
            )

        "Uploaded {nrow(data_create)} new {label}" %>%
            glue::glue() %>% wastdr_msg_success()
    } else {
        "No new {label} to create" %>%
            glue::glue() %>% wastdr_msg_noop()
        created <- NULL
    }

    if (nrow(data_update) > 0) {
        if (update_existing == TRUE) {
            "Updating {nrow(data_update)} existing and uncurated {label}" %>%
                glue::glue() %>% wastdr_msg_info()

            updated <- data_update %>%
                wastd_POST(
                    serializer,
                    api_url = api_url,
                    api_token = api_token,
                    verbose = TRUE
                )

            "Updated {nrow(data_update)} {label}" %>%
                glue::glue() %>% wastdr_msg_success()
        }
        else {
            "Retained {nrow(data_update)} existing and uncurated {label}" %>%
                glue::glue() %>% wastdr_msg_noop()
            updated <- NULL
        }
    } else {
        "No existing {label} to update" %>%
            glue::glue() %>% wastdr_msg_noop()
        updated <- NULL
    }

    if (nrow(data_skip) > 0) {
        "Skipping {nrow(data_skip)} existing and curated {label}" %>%
            glue::glue() %>% wastdr_msg_noop()
    }

    list(
        created = created,
        updated = updated,
        skipped = data_skip
    )
}
