#' Top-level Turtle Nesting Census data import Drake Plan
#'
#' * Download all ODKC data including attachments
#' * Load existing nesting records from TSC: load only a minimal set of
#'   source, source ID, QA status to determine later what to
#'   create / update / skip:
#'   * does not exist in TSC: create (POST)
#'   * exists in TSC with status "new": update (PATCH)
#'   * exists in TSC with status higher than "new": skip (and message)
#'   * Make (transform) ODKC to WAStD data
#'   * Load transformed data into WAStD's API (create/update/skip)
#'   * No QA
#' @export
#' @examples
#' \dontrun{
#'
#' # Step 1: New users (username, name, phone, email, role)
#' # 400 for existing, 201 for new
#' users <- here::here("users.csv") %>%
#'   readr::read_csv(col_types = "ccccc") %>%
#'   wastdr::wastd_bulk_post("users")
#'
#' # save point for debug
#' save(odkc_data, tsc_data, user_mapping, file="odkc_import.RData")
#' load("odkc_import.RData")
#'
#' wastdr::odkc_plan()
#' drake::vis_drake_graph(odkc_plan())
#' drake::clean()
#' drake::make(odkc_plan())
#' }
odkc_plan <- function() {
  drake::drake_plan(
    odkc_data = download_odkc_turtledata_2019(download = FALSE),
    tsc_data = download_minimal_tsc_turtledata(year = 2019),
    user_mapping = make_user_mapping(odkc_data, tsc_data),
    odkc_prep = odkc_as_tsc(odkc_data, user_mapping),
    upload_to_tsc = upload_odkc_to_tsc(odkc_prep, tsc_data)
  )
}

# save(odkc_data, tsc_data, user_mapping, file="odkc_import.RData")


# Append new users to spreadsheet: username, name, email, phone, role

