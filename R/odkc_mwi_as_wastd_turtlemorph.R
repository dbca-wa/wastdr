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
#' user_mapping <- NULL # see odkc_plan for actual user mapping
#' tmorph <- odkc_mwi_as_wastd_turtlemorph(odkc_ex$mwi, user_mapping)
#'
#' tmorph %>%
#'   wastd_POST("turtle-morphometrics",
#'     api_url = Sys.getenv("WASTDR_API_DEV_URL"),
#'     api_token = Sys.getenv("WASTDR_API_DEV_TOKEN")
#'   )
#' }
odkc_mwi_as_wastd_turtlemorph <- function(data, user_mapping) {
  wastd_handlers <- user_mapping %>%
    dplyr::transmute(handler = odkc_username, handler_id = pk)

  wastd_recorders <- user_mapping %>%
    dplyr::transmute(recorder = odkc_username, recorder_id = pk)

  data %>%
    sf_as_tbl() %>%
    dplyr::transmute(
      source = 2,
      source_id = id,
      encounter_source="odk",
      encounter_source_id = id,
      handler = reporter,
      recorder = reporter,
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
    dplyr::left_join(wastd_handlers, by = "handler") %>% # wastd User PK
    dplyr::left_join(wastd_recorders, by = "recorder") %>% # wastd User PK
    dplyr::select(-handler, -recorder) %>% # drop odkc_username
    dplyr::filter_at(
      dplyr::vars(-source, -source_id, -encounter_source, -encounter_source_id),
      dplyr::any_vars(!is.na(.))
    )
}

# usethis::use_test("odkc_mwi_as_wastd_turtlemorph")
