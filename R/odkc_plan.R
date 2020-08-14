#' Top-level Turtle Nesting Census data import Drake Plan
#'
#' * Download all ODKC data including attachments
#' * Load existing nesting records from WAStD: load only a minimal set of
#'   source, source ID, QA status to determine later what to
#'   create / update / skip:
#'   * does not exist in WAStD: create (POST)
#'   * exists in WAStD with status "new": update (PATCH)
#'   * exists in WAStD with status higher than "new": skip (and message)
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
#'   wastdr::wastd_bulk_post("users",
#'   #api_url = Sys.getenv("WASTDR_API_DEV_URL"),
#'   #api_token = Sys.getenv("WASTDR_API_DEV_TOKEN"),
#'   verbose = TRUE)
#'
#' users_dev <- here::here("users.csv") %>%
#'   readr::read_csv(col_types = "ccccc") %>%
#'   wastdr::wastd_bulk_post("users",
#'   api_url = Sys.getenv("WASTDR_API_DEV_URL"),
#'   api_token = Sys.getenv("WASTDR_API_DEV_TOKEN"),
#'   verbose = TRUE)
#'
#' # save point for debug
#' save(atkn, aurl, vbse, updt, odkc_ex, odkc_tf, odkc_up,
#' wastd_data, wastd_users, user_mapping, file="odkc_import.RData")
#' load("odkc_import.RData")
#'
#' wastdr::wastdr_setup(api_url = Sys.getenv("WASTDR_API_DEV_URL"),
#'                      api_token = Sys.getenv("WASTDR_API_DEV_TOKEN"))
#' wastdr::wastdr_setup(api_url = Sys.getenv("WASTDR_API_TEST_URL"),
#'                      api_token = Sys.getenv("WASTDR_API_TEST_TOKEN"))
#' Sys.setenv(ODKC_IMPORT_UPDATE_EXISTING=TRUE)
#' wastdr::odkc_plan()
#' drake::vis_drake_graph(wastdr::odkc_plan())
#' drake::clean()
#' drake::clean("user_qa") # after updating WAStD user aliases
#' drake::make(odkc_plan(), lock_envir = FALSE)
#' }
odkc_plan <- function() {
  drake::drake_plan(
    # ------------------------------------------------------------------------ #
    # SETUP
    dl_odkc = FALSE,
    wastd_data_yr = 2019L,
    up_ex = Sys.getenv("ODKC_IMPORT_UPDATE_EXISTING", unset = FALSE),

    # ------------------------------------------------------------------------ #
    # EXTRACT
    #
    # Source data extracted from source DB
    # TODO there are duplicates due to overlapping sites, e.g. CBB overlap/gap
    #
    # Development: skip the download step and use cached data
    # data(odkc, package = "turtleviewer")
    # odkc_ex <- odkc
    #
    odkc_ex = download_odkc_turtledata_2019(download = dl_odkc),
    # QA Reports: data collection problems?
    # https://github.com/dbca-wa/wastdr/issues/21

    # ------------------------------------------------------------------------ #
    # TRANSFORM
    #
    # User mapping
    wastd_users = download_wastd_users(),
    user_mapping = make_user_mapping(odkc_ex, wastd_users),
    # QA Reports: inspect user mappings - flag dissimilar matches
    # https://github.com/dbca-wa/wastdr/issues/21
    user_qa  = rmarkdown::render(
      input = drake::knitr_in("vignettes/wastd_user_mapping_qa.Rmd"),
      quiet = TRUE
    ),
    # Source data transformed into target format
    odkc_tf = odkc_as_wastd(odkc_ex, user_mapping),

    # ------------------------------------------------------------------------ #
    # LOAD
    #
    # Existing data in target DB
    wastd_data = download_minimal_wastd_turtledata(year = wastd_data_yr),
    # Skip logic
    odkc_up = split_create_update_skip(odkc_tf, wastd_data)
    # Upload
    # upload_to_wastd = upload_odkc_to_wastd(odkc_up, update_existing = up_ex),
    # QA Reports: inspect API responses for any trouble uploading
    # # https://github.com/dbca-wa/wastdr/issues/21
    # wastd_data_full = download_wastd_turtledata()
  )
}
