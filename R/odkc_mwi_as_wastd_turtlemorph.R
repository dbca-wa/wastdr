#' Transform odkc_data$mwi into WAStD TurtleMorphometricObservations.
#'
#' @param data The tibble of Marine Wildlife Incidents,
#'   e.g. \code{odkc_data$mwi}.
#' @param user_mapping .
#' @return A tibble suitable to
#'   \code{\link{wastd_POST}("turtle-morphometrics")}
#' @export
#' @examples
#' \dontrun{
#' data("odkc_data", package = "wastdr")
#' user_mapping = NULL # see odkc_plan for actual user mapping
#' tmorph <- odkc_mwi_as_wastd_turtlemorph(odkc_ex$mwi, user_mapping)
#'
#' tmorph %>%
#'   wastd_POST("turtle-morphometrics",
#'     api_url = Sys.getenv("WASTDR_API_DEV_URL"),
#'     api_token = Sys.getenv("WASTDR_API_DEV_TOKEN"))
#' }
odkc_mwi_as_wastd_turtlemorph <- function(data, user_mapping) {
    tsc_handlers <- user_mapping %>%
        dplyr::transmute(handler = odkc_username,
                         handler_id = pk)

    tsc_recorders <- user_mapping %>%
        dplyr::transmute(recorder = odkc_username,
                         recorder_id = pk)

    data %>%
        sf_as_tbl() %>%
        dplyr::transmute(
            source = "odk",
            source_id = id,
            handler = reporter,
            recorder = reporter,
            comments = glue::glue("Device ID {device_id}\n"),
            # WAStD TurtleMorphometrics has more fields, but MWI only captures:
            curved_carapace_length_mm = morphometrics_curved_carapace_length_mm,
            curved_carapace_length_accuracy = morphometrics_curved_carapace_length_accuracy,
            curved_carapace_width_mm = morphometrics_curved_carapace_width_mm,
            curved_carapace_width_accuracy = morphometrics_curved_carapace_width_accuracy,
            tail_length_carapace_mm = morphometrics_tail_length_carapace_mm,
            tail_length_carapace_accuracy = morphometrics_tail_length_carapace_accuracy,
            maximum_head_width_mm = morphometrics_maximum_head_width_mm,
            maximum_head_width_accuracy = morphometrics_maximum_head_width_accuracy
        ) %>%
        dplyr::left_join(tsc_handlers, by = "handler") %>% # TSC User PK
        dplyr::left_join(tsc_recorders, by = "recorder") %>% # TSC User PK
        dplyr::select(-handler,-recorder) %>% # drop odkc_username
        tidyr::drop_na(
            tidyselect::all_of(
                c(
                    "curved_carapace_length_mm",
                    "curved_carapace_width_mm",
                    "tail_length_carapace_mm",
                    "maximum_head_width_mm"
                )
            )
        )
}
