#' Filter WAStD turtledata to an area_name
#'
#' @param x An object of class `wastd_data` as returned by
#'   \code{\link{download_wastd_turtledata}}. This data can be filtered to
#'   an area_name (WAStD Area of type Locality).
#' @param area_name The name of a WAStD Area of type Locality to filter the
#'   data.
#' @return An object of class `wastd_data` filtered to records within
#'   `area_name`.
#' @export
filter_wastd_turtledata <- function(x, area_name){
    list(
        downloaded_on = x$downloaded_on,

        areas = x$areas %>% dplyr::filter(area_name == area_name),
        sites = x$sites %>% dplyr::filter(area_name == area_name),
        surveys = x$surveys %>%
            dplyr::left_join(x$sites) %>%
            dplyr::filter(area_name == area_name),

        animals = x$animals %>%
            dplyr::filter(area_name == area_name),
        turtle_dmg = x$turtle_dmg %>%
            dplyr::filter(encounter_area_name == area_name),
        turtle_tags = x$turtle_tags %>%
            dplyr::filter(encounter_area_name == area_name),
        turtle_morph = x$turtle_morph %>%
            dplyr::filter(encounter_area_name == area_name),

        tracks = x$tracks %>%
            dplyr::filter(area_name == area_name),
        nest_dist = x$nest_dist %>%
            dplyr::filter(encounter_area_name == area_name),
        nest_tags = x$nest_tags %>%
            dplyr::filter(encounter_area_name == area_name),
        nest_excavations = x$nest_excavations %>%
            dplyr::filter(encounter_area_name == area_name),
        hatchling_morph = x$hatchling_morph %>%
            dplyr::filter(encounter_area_name == area_name),
        nest_fans = x$nest_fans %>%
            dplyr::filter(encounter_area_name == area_name),
        nest_fan_outliers = x$nest_fan_outliers %>%
            dplyr::filter(encounter_area_name == area_name),
        nest_lightsources = x$nest_lightsources %>%
            dplyr::filter(encounter_area_name == area_name),

        linetx = x$linetx %>%
            dplyr::filter(area_name == area_name),
        track_tally = x$track_tally %>%
            dplyr::filter(area_name == area_name),
        disturbance_tally = x$disturbance_tally %>%
            dplyr::filter(area_name == area_name),

        loggers = x$loggers %>%
            dplyr::filter(area_name == area_name)
    )
}
