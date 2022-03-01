#' Filter odkc_data to a given area_name.
#'
#' @param data (list) The output of data("odkc_data"), a list of tibbles and sf
#' @param area_name (chr) The name of the area to filter the data by. Options:
#'   * NULL (default): do not filter data, return unfiltered data.
#'   * "All turtle programs": do not filter data, return unfiltered data.
#'   * "Other": Filter data to area_name NA.
#'   * Any name in `unique(odkc_data$areas$area_name)`: return data filtered to
#'     this area_name.
#' @param username (chr) The ODK Collect username to filter the data by.
#'   This is handy to investigate where and when a particular name was used.
#'   Default: NULL
#' @template param-verbose
#' @return (list) The input data, optionally filtered to a subset of records.
#' @export
#' @family odkc
#' @examples
#' data(odkc_data)
#'
#' # All data
#' data_all <- filter_odkc_turtledata(odkc_data)
#' nrow(data_all$tracks)
#'
#' # One area
#' area_names <- unique(odkc_data$areas$area_name)
#' area_names
#' data_area_1 <- filter_odkc_turtledata(odkc_data, area_name = "Cape Dommett")
#' nrow(data_area_1$tracks)
#' data_area_2 <- filter_odkc_turtledata(odkc_data, area_name = area_names[[2]])
#' nrow(data_area_2$tracks)
#'
#'
#' # Orphans
#' data_orphans <- filter_odkc_turtledata(odkc_data, area_name = "Other")
#' nrow(data_orphans)
filter_odkc_turtledata <- function(data,
                                   area_name = NULL,
                                   username = NULL,
                                   verbose = wastdr::get_wastdr_verbose()) {
  requireNamespace("sf") # overrides dplyr::filter with spatial equivalents

  # Error handling
  if (class(data) != "odkc_turtledata") {
    wastdr_msg_abort(
      glue::glue(
        "The first argument needs to be an object of class \"odkc_turtledata\", ",
        "e.g. the output of wastdr::download_odkc_turtledata_2020()."
      )
    )
  }

  if (is.null(area_name)) {
    "No area_name name given, returning data without spatial filtering." %>%
      wastdr::wastdr_msg_success(verbose = verbose)
      geo_filter <- . %>% identity(.)
  } else if (area_name == "All turtle programs") {
    "All areas requested, returning data without spatial filtering." %>%
      wastdr::wastdr_msg_success(verbose = verbose)
      geo_filter <- . %>% identity(.)
  } else if (area_name == "Other") {
    "Orphaned areas requested, returning data outside known areas." %>%
      wastdr::wastdr_msg_success(verbose = verbose)
      geo_filter <- . %>% dplyr::filter(is.na(area_name))
  } else {
    "Area {area_name} requested, returning filtered data." %>%
      glue::glue() %>%
      wastdr::wastdr_msg_success(verbose = verbose)
      geo_filter <- . %>% dplyr::filter(area_name == !!area_name)
  }

  if (!is.null(username)) {
      "Username {username} requested, returning data from {username}." %>%
          glue::glue() %>%
          wastdr::wastdr_msg_success(verbose = verbose)

      # Most odkc_data have a reporter
      user_filter <- . %>%
          dplyr::filter(grepl(!!username, reporter, ignore.case = TRUE))

      # Turtle Tagging has a default handler and fields prepopulated from
      # that handler but possibly changed during data entry
      user_filter_tt <- . %>% dplyr::filter(
          grepl(!!username, reporter, ignore.case = TRUE) |
              grepl(!!username, encounter_handler, ignore.case = TRUE)|
              grepl(!!username, ft1_ft1_handled_by, ignore.case = TRUE)|
              grepl(!!username, ft2_ft2_handled_by, ignore.case = TRUE)|
              grepl(!!username, ft3_ft3_handled_by, ignore.case = TRUE)|
              grepl(!!username, morphometrics_morphometrics_handled_by,
                    ignore.case = TRUE)
      )

      # TT tags are "handled by" a possibly different person from the reporter
      user_filter_tt_tag <- . %>% dplyr::filter(
          grepl(!!username, tag_handled_by, ignore.case = TRUE))
  } else {
      user_filter <- . %>% identity(.)
      user_filter_tt <- . %>% identity(.)
      user_filter_tt_tag <- . %>% identity(.)
  }

  structure(
    list(
      downloaded_on = data$downloaded_on,
      tracks = data$tracks %>% geo_filter() %>% user_filter(),
      # tracks_gj = data$tracks %>% my_filter() %>% ts_gj(),
      tracks_dist = data$tracks_dist %>% geo_filter() %>% user_filter(),
      tracks_egg = data$tracks_egg %>% geo_filter() %>% user_filter(),
      tracks_log = data$tracks_log %>% geo_filter() %>% user_filter(),
      tracks_hatch = data$tracks_hatch %>% geo_filter() %>% user_filter(),
      tracks_fan_outlier = data$tracks_fan_outlier %>% geo_filter() %>% user_filter(),
      tracks_light = data$tracks_light %>% geo_filter() %>% user_filter(),
      track_tally = data$track_tally %>% geo_filter() %>% user_filter(),
      track_tally_dist = data$track_tally_dist %>% geo_filter() %>% user_filter(),
      dist = data$dist %>% geo_filter() %>% user_filter(),
      mwi = data$mwi %>% geo_filter() %>% user_filter(),
      mwi_dmg = data$mwi_dmg %>% geo_filter() %>% user_filter(),
      mwi_tag = data$mwi_tag %>% geo_filter() %>% user_filter(),
      tsi = data$tsi %>% geo_filter() %>% user_filter(),
      tt = data$tt %>% geo_filter() %>% user_filter_tt(),
      tt_dmg = data$tt_dmg %>% geo_filter(),
      tt_tag = data$tt_tag %>% geo_filter() %>% user_filter_tt_tag(),
      tt_log = data$tt_log %>% geo_filter(),
      svs = data$svs %>% geo_filter() %>% user_filter(),
      sve = data$sve %>% geo_filter() %>% user_filter(),
      sites = data$sites %>% geo_filter(),
      areas = data$areas
    ),
    class = "odkc_turtledata"
  )
}

# usethis::use_test("filter_odkc_turtledata")
