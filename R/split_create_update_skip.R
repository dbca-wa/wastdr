#' Top level helper to split all Turtle Nesting Census data per skip logic
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
#' @template param-auth
#' @template param-verbose
#' @return A list of results from the various uploads.
#'   Each result is a `wastd_api_response`.
#' @export
split_create_update_skip <-
    function(odkc_prep,
             tsc_data,
             verbose = wastdr::get_wastdr_verbose())
        ) {
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

            list(
                tne_update = tne_update,
                tne_create = tne_create,
                tne_skip = tne_skip
            )
        }
