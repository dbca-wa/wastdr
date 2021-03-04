#' Filter WAStD turtledata to an area_name
#'
#' @param x An object of class `wastd_data` as returned by
#'   \code{\link{download_wastd_turtledata}}. This data can be filtered to
#'   an area_name (WAStD Area of type Locality).
#' @param area_name (chr) The name of the area to filter the data by. Options:
#'   * NULL (default): do not filter data, return unfiltered data.
#'   * "All turtle programs": do not filter data, return unfiltered data.
#'   * "Other": Filter data to area_name NA.
#'   * Any name in `unique(wastd_data$areas$area_name)`: return data filtered to
#'     this area_name.
#' @template param-verbose
#' @return An object of class `wastd_data` filtered to records within
#'   `area_name`.
#' @export
#' @family api
#' @examples
#' \dontrun{
#' data(wastd_data)
#' first_area <- wastd_data$areas$area_name[[1]]
#' wastd_data_filtered <- wastd_data %>% filter_wastd_turtledata(first_area)
#' wastd_data
#' wastd_data_filtered
#' unique(wastd_data_filtered$areas$area_name)
#' }
filter_wastd_turtledata <- function(x,
                                    area_name = NULL,
                                    verbose = wastdr::get_wastdr_verbose()) {
  requireNamespace("sf") # overrides dplyr::filter with spatial equivalents

  # Error handling
  if (class(x) != "wastd_data") {
    wastdr_msg_abort(
      glue::glue(
        "The first argument needs to be an object of class \"wastd_data\", ",
        "e.g. the output of wastdr::download_wastd_turtledata."
      )
    )
  }

  if (is.null(area_name)) {
    if (verbose == TRUE) {
      wastdr::wastdr_msg_success(
        "No area_name name given, returning all data."
      )
    }
    return(x)
  }
  if (area_name == "All turtle programs") {
    if (verbose == TRUE) {
      wastdr::wastdr_msg_success(
        "All areas requested, returning all data."
      )
    }
    return(x)
  }

  if (area_name == "Other") {
    if (verbose == TRUE) {
      wastdr::wastdr_msg_success(
        "Orphaned areas requested, returning data outside known areas."
      )
    }
    my_filter <- . %>% dplyr::filter(is.na(area_name))
    obs_filter <- . %>% dplyr::filter(is.na(area_name))
  } else {
    if (verbose == TRUE) {
      wastdr::wastdr_msg_success(
        glue::glue(
          "Area {area_name} requested, returning filtered data."
        )
      )
    }
    my_filter <- . %>% dplyr::filter(area_name == !!area_name)
    obs_filter <- . %>% dplyr::filter(encounter_area_name == !!area_name)
  }

  # Return filtered data
  structure(
    list(
      downloaded_on = x$downloaded_on,

      areas = x$areas,
      sites = x$sites %>% my_filter(),
      surveys = x$surveys %>%
        dplyr::left_join(
          x$sites,
          by = c("area_id", "area_name", "site_id", "site_name")
        ) %>%
        my_filter(),

      animals = x$animals %>% my_filter(),
      turtle_dmg = x$turtle_dmg %>% obs_filter(),
      turtle_tags = x$turtle_tags %>% obs_filter(),
      turtle_morph = x$turtle_morph %>% obs_filter(),

      tracks = x$tracks %>% my_filter(),
      nest_dist = x$nest_dist %>% obs_filter(),
      nest_tags = x$nest_tags %>% obs_filter(),
      nest_excavations = x$nest_excavations %>% obs_filter(),
      hatchling_morph = x$hatchling_morph %>% obs_filter(),
      nest_fans = x$nest_fans %>% obs_filter(),
      nest_fan_outliers = x$nest_fan_outliers %>% obs_filter(),
      nest_lightsources = x$nest_lightsources %>% obs_filter(),
      nest_loggers = x$nest_loggers %>% obs_filter(),

      linetx = x$linetx %>% my_filter(), # TODO: filter doesn't work yet
      track_tally = x$track_tally %>% obs_filter(),
      disturbance_tally = x$disturbance_tally %>% obs_filter(),

      loggers = x$loggers %>% my_filter()
    ),
    class = "wastd_data"
  )
}

# usethis::use_test("filter_wastd_turtledata")
