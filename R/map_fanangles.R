#' Map turtle hatchling emergence orientation from wastd_data
#'
#' @template param-wastd-data
#' @template param-wastd_url
#' @importFrom leaflet.circlesector addCircleSectorMid addCircleSectorMinMax
#' @export
#' @family wastd
#' @return A Leaflet map
#' @examples
#' \dontrun{
#' data(wastd_data)
#' wastd_data %>%
#'   filter_wastd_turtledata(area_name = "Thevenard Island") %>%
#'   map_fanangles()
#'
#' }
map_fanangles <- function(x,
                          wastd_url = wastdr::get_wastd_url()){
    # Data gatechecks ---------------------------------------------------------#
    if (class(x) != "wastd_data") {
        wastdr_msg_abort(
            glue::glue(
                "The first argument needs to be an object of class \"wastd_data\", ",
                "e.g. the output of wastdr::download_wastd_turtledata."
            )
        )
    }

    # Map options -------------------------------------------------------------#
    # co <- if (cluster == TRUE) leaflet::markerClusterOptions() else NULL
    overlay_names <- c()
    url <- sub("/$", "", wastd_url)

    # Prep data ---------------------------------------------------------------#
    fans <- x$nest_fans %>% wastdr::filter_realspecies()
    outliers <- x$nest_fan_outliers %>% wastdr::filter_realspecies()
    lights <- x$nest_lightsources %>% wastdr::filter_realspecies()

    # Transmute data to default column names and values (radius, colour)
    fans_tracks <- fans %>%
        dplyr::transmute(
            lat = encounter_latitude,
            lon = encounter_longitude,
            start_angle = bearing_leftmost_track_degrees,
            end_angle = bearing_rightmost_track_degrees,
            radius = 10,
            weight = 2,
            colour = "blue",
            label = glue::glue(
                "{no_tracks_main_group} tracks, ",
                "path: {stringr::str_replace_all(path_to_sea_comments, 'None', '')}"
            ),
            popup = glue::glue(
                "<h3>{no_tracks_main_group} tracks ",
                "<small>{no_tracks_main_group_min}-{no_tracks_main_group_max}</small></h3>",
                "Path to sea: {stringr::str_replace_all(path_to_sea_comments, 'None', '')}"
            )
        )

    # The mean direction of the fan is a 15m 1deg blue line
    fans_mean <- fans %>%
        dplyr::transmute(
            lat = encounter_latitude,
            lon = encounter_longitude,
            bearing = bearing_leftmost_track_degrees + (
                (bearing_leftmost_track_degrees - bearing_rightmost_track_degrees) / 2),
            angle = 1,
            radius = 15,
            weight = 1,
            colour = "blue",
            label = glue::glue("Mean bearing: {bearing} deg"),
            popup = glue::glue("Mean bearing: {bearing} deg")
        )


    # The main direction to water is a 15m 1deg black line
    fans_water <- fans %>%
        dplyr::transmute(
            lat = encounter_latitude,
            lon = encounter_longitude,
            bearing = bearing_to_water_degrees,
            angle = 1,
            radius = 15,
            weight = 1,
            colour = "black",
            label = glue::glue("Bearing to water: {bearing} deg"),
            popup = glue::glue("Bearing to water: {bearing} deg")
        )


    # Outlier tracks are 12m red lines
    outlier_segments <- outliers %>%
        dplyr::transmute(
            lat = encounter_latitude,
            lon = encounter_longitude,
            bearing = bearing_outlier_track_degrees,
            angle = 2,
            radius = 12,
            weight = 1,
            colour = "red",
            label = glue::glue("{outlier_group_size} track(s) {bearing} deg {outlier_track_comment}"),
            popup = glue::glue("<h3>{outlier_group_size} track(s)</h3>",
                               "Bearing: {bearing} deg<br/>",
                               "{outlier_track_comment}")
        )


    # Known light sources are 100m orange lines
    light_segments_artificial <- lights %>%
        dplyr::filter(light_source_type == "artificial") %>%
        dplyr::transmute(
            lat = encounter_latitude,
            lon = encounter_longitude,
            bearing = bearing_light_degrees,
            angle = 1,
            radius = 100,
            weight = 2,
            colour = "#FFC300",
            label = glue::glue("{light_source_description}"),
            popup = glue::glue("<h3>{light_source_description}</h3>",
                               "Artifical light source<br/>",
                               "Bearing {bearing} deg")
        )

    light_segments_natural <- lights %>%
        dplyr::filter(light_source_type == "natural") %>%
        dplyr::transmute(
            lat = encounter_latitude,
            lon = encounter_longitude,
            bearing = bearing_light_degrees,
            angle = 1,
            radius = 100,
            weight = 2,
            colour = "#f0ebc2",
            label = glue::glue("{light_source_description}"),
            popup = glue::glue("<h3>{light_source_description}</h3>",
                               "Natural light source<br/>",
                               "Bearing {bearing} deg")
        )


    # Map ---------------------------------------------------------------------#
    l <- leaflet_basemap(l_height = 500, l_width = 700) %>%
        # clearBounds releases setView from leaflet_basemap
        # so that addCircleSectorMid/MinMax can expandLimits
        leaflet::clearBounds() %>%
        leaflet::addCircles(
            data = fans_tracks,
            lat = ~lat,
            lng = ~lon,
            color = "white",
            weight = 2,
            radius = 5
        ) %>%
        addCircleSectorMid(data = light_segments_artificial) %>%
        addCircleSectorMid(data = light_segments_natural) %>%
        addCircleSectorMid(data = fans_mean) %>%
        addCircleSectorMid(data = fans_water) %>%
        addCircleSectorMid(data = outlier_segments) %>%
        addCircleSectorMinMax(data = fans_tracks)

    # Return map --------------------------------------------------------------#
    l
}


# use_test("map_fanangles")  # nolint
