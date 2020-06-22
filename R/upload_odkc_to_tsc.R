#' Top level helper to upload all Turtle Nesting Census data to TSC
#'
#' @param odkc_as_tsc ODKC data transformed into TSC format.
#' @param tsc_data Minimal TSC data to inform skip logic.
#' @return A list of results from the various uploads.
#'   Each result is a `wastd_api_response`.
#' @export
upload_odkc_to_tsc <- function(odkc_as_tsc, tsc_data) {

  wastdr_msg_info(
    glue::glue("Upload {nrow(odkc_as_tsc$tne)} TurtleNestEncounters to WAStD")
  )
  tne_res <- odkc_as_tsc$tne %>%
      # patched for local dev
    dplyr::mutate(reporter_id=4, observer_id=4) %>%
    wastd_POST("turtle-nest-encounters",
      api_url = Sys.getenv("WASTDR_API_DEV_URL"),
      api_token = Sys.getenv("WASTDR_API_DEV_TOKEN"),
      verbose = TRUE
     )
  wastdr_msg_success("Uploaded TurtleNestEncounters to WAStD")

  list(
      tne = tne_res
  )
}
