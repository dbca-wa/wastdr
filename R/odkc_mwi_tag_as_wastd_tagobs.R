#' Transform odkc_data$mwi_tag into WAStD TagObservations.
#'
#' @param data A tibble of tags, e.g. \code{odkc_data$mwi_tag}.
#' @template param-usermapping
#' @return A tibble suitable to
#'   \code{\link{wastd_POST}("tag-observations")}
#' @export
#' @examples
#' \dontrun{
#' data("odkc_data", package = "wastdr")
#' au <- Sys.getenv("WASTDR_API_DEV_URL")
#' at <- Sys.getenv("WASTDR_API_DEV_TOKEN")
#' user_mapping <- NULL # see odkc_plan for actual user mapping
#' x <- odkc_mwi_tag_as_wastd_tagobs(odkc_ex$mwi_tag, user_mapping)
#' x %>% wastd_POST("tag-observations", api_url = au, api_token = at)
#' }
odkc_mwi_tag_as_wastd_tagobs <- function(data, user_mapping) {
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
      encounter_source_id = submissions_id,
      handler = reporter,
      recorder = reporter,
      tag_type = tag_type,
      name = name,
      tag_location = tag_location,
      status = tag_status,
      comments = tag_comments
    ) %>%
    dplyr::left_join(wastd_handlers, by = "handler") %>% # wastd User PK
    dplyr::left_join(wastd_recorders, by = "recorder") %>% # wastd User PK
    dplyr::select(-handler, -recorder) %>% # drop odkc_username
    # If data == tracks or mwi, drop all NA subgroups
    # If data == tracks_*, there are only non-NA records
    dplyr::filter_at(
      dplyr::vars(-source, -source_id, -encounter_source, -encounter_source_id),
      dplyr::any_vars(!is.na(.))
    )
}

# usethis::use_test("odkc_mwi_tag_as_wastd_tagobs")
