#' Top-level Turtle Nesting Census data import Drake Plan
#'
#' * Download all ODKC data including attachments
#' * Load existing nesting records from TSC: load only a minimal set of
#'   source, source ID, QA status to determine later what to create / update / skip:
#'   * does not exist in TSC: create (POST)
#'   * exists in TSC with status "new": update (PATCH)
#'   * exists in TSC with status higher than "new": skip (and message)
#'   * Make (transform) ODKC to WAStD data
#'   * Load transformed data into WAStD's API (create/update/skip)
#'   * No QA
#' @export
#' @examples
#' \dontrun{
#' odkc_plan()
#' drake::vis_drake_graph(odkc_plan())
#' make(odkc_plan())
#' }
odkc_plan <- function(){
    drake::drake_plan(
        odkc_data = download_odkc_turtledata_2019(download = F),
        user_mapping = make_user_mapping(odkc_data),
        odkc_as_tsc = odkc_as_tsc(odkc_data, user_mapping),
        existing_tsc_tne = wastd_GET("turtle-nest-encounters") %>%
            parse_turtle_nest_encounters() %>%
            dplyr::select(source, source_id, status),
        upload_to_tsc = upload_odkc_to_tsc(odkc_as_tsc, existing_tsc_tne)
    )
}
