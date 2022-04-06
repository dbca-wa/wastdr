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
#'   `area_name` and the list of `seasons`.
#' @export
#' @family api
#' @examples
#' \dontrun{
#' data(wastd_data)
#' first_area <- wastd_data$areas$area_name[[1]]
#' wastd_data_filtered <- wastd_data %>%
#'   filter_wastd_turtledata_arera(area_name = first_area)
#' wastd_data
#' wastd_data_filtered
#' unique(wastd_data_filtered$areas$area_name)
#' }
filter_wastd_turtledata_area <- function(x,
                                         area_name = NULL,
                                         verbose = wastdr::get_wastdr_verbose()) {
  requireNamespace("sf", quietly = TRUE) # override dplyr::filter with spatial fns

  # Gate checks ---------------------------------------------------------------#
  if (class(x) != "wastd_data") {
    wastdr_msg_abort(
      glue::glue(
        "The first argument needs to be an object of class \"wastd_data\", ",
        "e.g. the output of wastdr::download_wastd_turtledata."
      )
    )
  }

  if (is.null(area_name)) {
    "No area_name name given, returning all data." %>%
      glue::glue() %>%
      wastdr_msg_success(verbose = verbose)
    return(x)
  }
  if (area_name == "All turtle programs") {
    "All areas requested, returning all data." %>%
      glue::glue() %>%
      wastdr_msg_success(verbose = verbose)
    return(x)
  }

  if (area_name == "Other") {
    "Orphaned areas requested, returning data outside known areas." %>%
      glue::glue() %>%
      wastdr_msg_success(verbose = verbose)
    my_filter <- . %>% dplyr::filter(is.na(area_name))
    obs_filter <- . %>% dplyr::filter(is.na(area_name))
  } else {
    "Area {area_name} requested, returning filtered data." %>%
      glue::glue() %>%
      wastdr_msg_success(verbose = verbose)
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


#' Filter WAStD turtledata to a season range
#'
#' @param x An object of class `wastd_data` as returned by
#'   \code{\link{download_wastd_turtledata}}.
#' @param seasons (list of int) A list of seasons to filter the data by.
#'   * NULL (default): return data from all seasons.
#'   * list of numbers: return data from given seasons.
#'     E.g. `c(2017, 2018, 2019)` or `2017:2019` returns data from seasons
#'     2017-18 through to 2019-20.
#' @template param-verbose
#' @return An object of class `wastd_data` filtered to records within
#'   `area_name` and the list of `seasons`.
#' @export
#' @family api
#' @examples
#' \dontrun{
#' data(wastd_data)
#' first_season <- wastd_data$areas$season[[1]]
#' wastd_data_filtered <- wastd_data %>%
#'   filter_wastd_turtledata_seasons(first_season)
#' wastd_data
#' wastd_data_filtered
#' unique(wastd_data_filtered$areas$season)
#' }
filter_wastd_turtledata_seasons <- function(x,
                                            seasons = NULL,
                                            verbose = wastdr::get_wastdr_verbose()) {
  requireNamespace("sf", quietly = TRUE) # override dplyr::filter with spatial fns

  # Gate checks ---------------------------------------------------------------#
  verify_wastd_data(x)

  if (is.null(seasons)) {
    "No seasons given, returning all data." %>%
      glue::glue() %>%
      wastdr_msg_success(verbose = verbose)
    return(x)
  }

  # Filter --------------------------------------------------------------------#
  season_filter <- . %>% dplyr::filter(season %in% seasons)

  # Return filtered data ------------------------------------------------------#
  structure(
    list(
      downloaded_on = x$downloaded_on,
      areas = x$areas,
      sites = x$sites,
      surveys = x$surveys %>% season_filter(),
      animals = x$animals %>% season_filter(),
      turtle_dmg = x$turtle_dmg %>% season_filter(),
      turtle_tags = x$turtle_tags %>% season_filter(),
      turtle_morph = x$turtle_morph %>% season_filter(),
      tracks = x$tracks %>% season_filter(),
      nest_dist = x$nest_dist %>% season_filter(),
      nest_tags = x$nest_tags %>% season_filter(),
      nest_excavations = x$nest_excavations %>% season_filter(),
      hatchling_morph = x$hatchling_morph %>% season_filter(),
      nest_fans = x$nest_fans %>% season_filter(),
      nest_fan_outliers = x$nest_fan_outliers %>% season_filter(),
      nest_lightsources = x$nest_lightsources %>% season_filter(),
      nest_loggers = x$nest_loggers %>% season_filter(),
      linetx = x$linetx %>% season_filter(), # TODO: filter doesn't work yet
      track_tally = x$track_tally %>% season_filter(),
      disturbance_tally = x$disturbance_tally %>% season_filter(),
      loggers = x$loggers # loggers are deprecated
    ),
    class = "wastd_data"
  )
}


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
#' @param seasons (list of int) A list of seasons to filter the data by.
#'   * NULL (default): return data from all seasons.
#'   * list of numbers: return data from given seasons.
#'     E.g. `c(2017L, 2018L, 2019L)` or `2017:2019` returns data from seasons
#'     2017-18 through to 2019-20.
#' @template param-verbose
#' @return An object of class `wastd_data` filtered to records within
#'   `area_name` and the list of `seasons`.
#' @export
#' @family api
#' @examples
#' \dontrun{
#' data(wastd_data)
#' first_area <- wastd_data$areas$area_name[[1]]
#' wastd_data_filtered <- wastd_data %>%
#'   filter_wastd_turtledata(area_name = first_area)
#' wastd_data
#' wastd_data_filtered
#' unique(wastd_data_filtered$areas$area_name)
#' }
filter_wastd_turtledata <- function(x,
                                    area_name = NULL,
                                    seasons = NULL,
                                    verbose = wastdr::get_wastdr_verbose()) {
  # Gate checks ---------------------------------------------------------------#
  verify_wastd_data(x)

  x %>%
    filter_wastd_turtledata_area(area_name = area_name) %>%
    filter_wastd_turtledata_seasons(seasons = seasons)
}

# usethis::use_test("filter_wastd_turtledata")
