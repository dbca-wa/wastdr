#' Map Marine Wildlife Incident 0.6 parsed with ruODK from ODK Central.
#'
#' @details Creates a Leaflet map with an interactive legend offering to toggle
#' each species separately. The maps auto-zooms to the extent of data given.
#'
#' This map function uses data from ODK Central / ruODK using form
#' "Marine Wildlife Incident 0.6".
#'
#' @template param-tracks
#' @template param-wastd_url
#' @template param-fmt
#' @template param-cluster
#' @return A leaflet map
#' @export
map_mwi_odkc <- function(data,
                         wastd_url = wastdr::get_wastd_url(),
                         fmt = "%d/%m/%Y %H:%M",
                         tz = "Australia/Perth",
                         cluster = FALSE) {
    . <- NULL
    layersControlOptions <- NULL
    markerClusterOptions <- NULL

    if (cluster == TRUE) {
        co <- markerClusterOptions()
    } else {
        co <- NULL
    }
    leaflet(width = 800, height = 600) %>%
        addProviderTiles("Esri.WorldImagery", group = "Aerial") %>%
        addProviderTiles("OpenStreetMap.Mapnik", group = "Place names") %>%
        clearBounds() %>%
        addAwesomeMarkers(
            data = data,
            lng = ~observed_at_longitude, lat = ~observed_at_latitude,
            icon = leaflet::makeAwesomeIcon(
                text = "MWI",
                markerColor = "red"
            ),
            label = ~ glue::glue(
                '{lubridate::with_tz(observation_start_time, tz)} {humanize(health)}',
                " {humanize(maturity)} {humanize(sex)} {humanize(species)}"
            ),
            popup = ~ glue::glue(
                "<h3>{humanize(health)} {humanize(maturity)} ",
                "{humanize(sex)} {humanize(species)}</h3>",
                "<p>Seen on {lubridate::with_tz(observation_start_time, tz)} by {reporter}",
                "<p>Cause of death: {humanize(cause_of_death)}</p>"
            ),
            group = df,
            clusterOptions = co
        ) %>%
        addLayersControl(
            baseGroups = c("Aerial", "Place names"),
            overlayGroups = c("Marine Wildlife Incidents"),
            options = layersControlOptions(collapsed = FALSE)
        )
}
