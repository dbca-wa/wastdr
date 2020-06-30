#' Transform odkc_data$tracks into WAStD NestTagObservations.
#'
#' @param data A tibble of tracks,  e.g. \code{odkc_data$tracks}.
#' @template param-usermapping
#' @return A tibble suitable to
#'   \code{\link{wastd_POST}("nest-tag-observations")}
#' @export
#' @examples
#' \dontrun{
#' data("odkc_data", package = "wastdr")
#' au <- Sys.getenv("WASTDR_API_DEV_URL")
#' at <- Sys.getenv("WASTDR_API_DEV_TOKEN")
#' user_mapping <- NULL # see odkc_plan for actual user mapping
#' x <- odkc_tracks_as_wastd_nesttagobs(odkc_ex$tracks, user_mapping)
#' x %>% wastd_POST("nest-tag-observations", api_url = au, api_token = at)
#' }
odkc_tracks_as_wastd_nesttagobs <- function(data, user_mapping) {
    tsc_handlers <- user_mapping %>%
        dplyr::transmute(handler = odkc_username, handler_id = pk)

    tsc_recorders <- user_mapping %>%
        dplyr::transmute(recorder = odkc_username, recorder_id = pk)

    data %>%
        sf_as_tbl() %>%
        dplyr::transmute(
            source = "odk",
            source_id = id,
            handler = reporter,
            recorder = reporter,

        ) %>%
        dplyr::left_join(tsc_handlers, by = "handler") %>% # TSC User PK
        dplyr::left_join(tsc_recorders, by = "recorder") %>% # TSC User PK
        dplyr::select(-handler,-recorder) %>% # drop odkc_username
        tidyr::drop_na(tidyselect::all_of(
            c(
                "curved_carapace_length_mm",
                "curved_carapace_width_mm",
                "tail_length_carapace_mm",
                "maximum_head_width_mm"
            )
        ))
}
