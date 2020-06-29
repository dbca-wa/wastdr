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
#'   Each result is a `wastd_api_response` or a tibble of data (`_skip`).
#' @export
split_create_update_skip <- function(odkc_prep,
                                     tsc_data,
                                     verbose = wastdr::get_wastdr_verbose()) {
    # WAStD Encounters are considered unchanged if QA status is "new" and
    # can be updated without losing edits applied in WAStD.
    enc_update <- tsc_data$enc %>% dplyr::filter(status == "new")

    # TSC Encounters are considered changed if QA status is not "new" and
    # should never be overwritten, as that would overwrite edits.
    enc_skip <- tsc_data$enc %>% dplyr::filter(status != "new")

    list(
        # Tracks > TNE
        tne_create = odkc_prep$tne %>%
            dplyr::anti_join(tsc_data$enc, by = "source_id"),
        tne_update = odkc_prep$tne %>%
            dplyr::semi_join(enc_update, by = "source_id"),
        tne_skip = odkc_prep$tne %>%
            dplyr::semi_join(enc_skip, by = "source_id"),

        # MWI > AE
        ae_mwi_create = odkc_prep$ae_mwi %>%
            dplyr::anti_join(tsc_data$enc, by = "source_id"),
        ae_mwi_update = odkc_prep$ae_mwi %>%
            dplyr::semi_join(enc_update, by = "source_id"),
        ae_mwi_skip =  odkc_prep$ae_mwi %>%
            dplyr::semi_join(enc_skip, by = "source_id"),

        # MWI > obs turtlemorph
        obs_turtlemorph_create = odkc_prep$obs_turtlemorph %>%
            dplyr::anti_join(tsc_data$enc, by = "source_id"),
        obs_turtlemorph_update = odkc_prep$obs_turtlemorph %>%
            dplyr::semi_join(enc_update, by = "source_id"),
        obs_turtlemorph_skip = odkc_prep$obs_turtlemorph %>%
            dplyr::semi_join(enc_skip, by = "source_id")
    )
}
