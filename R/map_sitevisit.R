#' Map Site Visit Start and End from ODK Central data over TSC Sites.
#'
#' @details Creates a Leaflet map of site visit start and end points.
#' The maps auto-zooms to the extent of data given.
#'
#' @param svs The output of `turtleviewer::turtledata$svs` - data from ODK form
#'   `Site Visit Start 0.3`.
#' @param sve The output of `turtleviewer::turtledata$sve` - data from ODK form
#'   `Site Visit End 0.2`.
#' @param sites An sf object of sites with `site_name` and polygon geom, e.g.
#'  `turtleviewer::turtledata$sites`.
#' @template param-wastd_url
#' @template param-fmt
#' @template param-tz
#' @template param-cluster
#' @return A leaflet map
#' @export
map_sv_odkc <- function(svs,
                        sve,
                          sites,
                          wastd_url = wastdr::get_wastd_url(),
                          fmt = "%d/%m/%Y %H:%M",
                          tz = "Australia/Perth",
                          cluster = FALSE) {
    layersControlOptions <- NULL
    markerClusterOptions <- NULL

    if (cluster == TRUE) {
        co <- leaflet::markerClusterOptions()
    } else {
        co <- NULL
    }

    layersControlOptions <- NULL

    l <- leaflet::leaflet(width = 800, height = 600) %>%
        leaflet::addProviderTiles("Esri.WorldImagery", group = "Aerial") %>%
        leaflet::addProviderTiles("OpenStreetMap.Mapnik", group = "Place names") %>%
        leaflet::clearBounds() %>%
        # Site Visit Start
        leaflet::addAwesomeMarkers(
        data = svs,
        lng = ~location_longitude, lat = ~location_latitude,
        icon = leaflet::makeAwesomeIcon(
            text = "SVS",
            markerColor = "green",
            iconColor = "white"
        ),
        label = ~ glue::glue(
            "{calendar_date_awst} ",
            " Start {reporter} {site_name}"
        ),
        popup = ~ glue::glue(
            "<h3>Site Visit Start</h3>",
            "<p>Start {lubridate::with_tz(survey_start_time, tz)} AWST</p>",
            "<p>Device ID{device_id}</p>",
            "<p>By {reporter} with {team}</p>",
            "<p>Comments: {comments}</p>"
        ),

        group = "Site Visit Start",
        clusterOptions = co
    ) %>%
        # Site Visit End
        leaflet::addAwesomeMarkers(
            data = sve,
            lng = ~location_longitude, lat = ~location_latitude,
            icon = leaflet::makeAwesomeIcon(
                text = "SVE",
                markerColor = "red",
                iconColor = "white"
            ),
            label = ~ glue::glue(
                "{calendar_date_awst} ",
                " End {reporter} {site_name}"
            ),
            popup = ~ glue::glue(
                "<h3>Site Visit End</h3>",
                "<p>End {lubridate::with_tz(survey_end_time, tz)} AWST</p>",
                "<p>Device ID{device_id}</p>",
                "<p>By {reporter}</p>",
                "<p>Comments: {comments}</p>"
            ),

            group = "Site Visit End",
            clusterOptions = co
        ) %>%
        # Sites
            leaflet::addPolygons(
                data=sites,
                group="Sites",
                weight = 1,
                fillOpacity = 0.5,
                fillColor = "blue",
                label = ~ site_name
            ) %>%
            leaflet::addLayersControl(
                baseGroups = c("Aerial", "Place names"),
                overlayGroups = c("Site Visit Start", "Site Visit End"),
                options = leaflet::layersControlOptions(collapsed = FALSE)
            )
    l
}
