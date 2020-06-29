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
#'
#' @export
#' @examples
#' \dontrun{
#'
#' # Step 1: New users (username, name, phone, email, role)
#' # 400 for existing, 201 for new
#' Append new users to spreadsheet: username, name, email, phone, role
#' users <- here::here("users.csv") %>%
#'   readr::read_csv(col_types = "ccccc") %>%
#'   wastdr::wastd_bulk_post("users")
#'
#' users_dev <- here::here("users.csv") %>%
#'   readr::read_csv(col_types = "ccccc") %>%
#'   wastdr::wastd_bulk_post("users",
#'   api_url = Sys.getenv("WASTDR_API_DEV_URL"),
#'   api_token = Sys.getenv("WASTDR_API_DEV_TOKEN"),
#'   verbose = TRUE)
#'
#' # save point for debug
#' save(atkn, aurl, vbse, updt, odkc_ex, odkc_tf, odkc_up, tsc_data, tsc_users, user_mapping, file="odkc_import.RData")
#' load("odkc_import.RData")
#'
#' wastdr::odkc_plan()
#' drake::vis_drake_graph(odkc_plan())
#' drake::clean()
#' drake::make(odkc_plan())
#' }
odkc_plan <- function() {
  drake::drake_plan(
    # ------------------------------------------------------------------------ #
    # SETUP
    #
    # api_url = wastdr::get_wastdr_api_url(),
    # api_token = wastdr::get_wastdr_api_token(),
    aurl = Sys.getenv("WASTDR_API_DEV_URL"),
    atkn = Sys.getenv("WASTDR_API_DEV_TOKEN"),
    vbse = wastdr::get_wastdr_verbose(),
    updt = FALSE,

    # ------------------------------------------------------------------------ #
    # EXTRACT
    #
    # Source data extracted from source DB
    # TODO there are duplicates due to overlapping sites, e.g. CBB overlap/gap
    odkc_ex = download_odkc_turtledata_2019(download = FALSE),
    # QA Reports: data collection problems?
    # https://github.com/dbca-wa/wastdr/issues/21

    # ------------------------------------------------------------------------ #
    # TRANSFORM
    #
    # User mapping
    tsc_users = download_tsc_users(
      api_url = aurl, api_token = atkn, verbose = vbse),
    user_mapping = make_user_mapping(odkc_ex, tsc_users),
    # QA Reports: inspect user mappings - flag dissimilar matches
    # https://github.com/dbca-wa/wastdr/issues/21
    # Source data transformed into target format
    odkc_tf = odkc_as_tsc(odkc_ex, user_mapping),

    # ------------------------------------------------------------------------ #
    # LOAD
    #
    # Existing data in target DB
    tsc_data = download_minimal_tsc_turtledata(
      year = 2019, api_url = aurl, api_token = atkn, verbose = vbse),
    # Skip logic
    odkc_up = split_create_update_skip(odkc_tf, tsc_data, verbose = vbse),
    # Upload
    upload_to_tsc = upload_odkc_to_tsc(
      odkc_up, update_existing = updt,
      api_url = aurl, api_token = atkn, verbose = vbse)
    # QA Reports: inspect API responses for any trouble uploading
    # https://github.com/dbca-wa/wastdr/issues/21
  )
}
