#' Map WAMTRAM data
#'
#' @param data The output of `wastdr::download_w2_data()`
#' @return A leaflet map showing W2 sites and encounters
#' @export
#' @examples \dontrun{
#' data("w2_data")
#' map_wamtram(wamtram_data)
#'
#' map_wamtram(wamtram_data, location_code="DH")
#' map_wamtram(wamtram_data, place_code="DHTB")
#' }
map_wamtram <- function(data, location=NULL, place=NULL){

    enc <- data$enc
    sites <- data$sites

    if (!is.null(location)) {
        enc <- data$enc %>% dplyr::filter(location_code == location)
        sites <- data$sites %>% dplyr::filter(prefix == location)
    }

    if (!is.null(place)) {
        enc <- data$enc %>% dplyr::filter(place_code == place)
        sites <- data$sites %>% dplyr::filter(code == place)
    }

    co <- ifelse(nrow(enc) > 1000, leaflet::markerClusterOptions(), NULL)

    leaflet::leaflet() %>%
        leaflet::addProviderTiles("Esri.WorldImagery", group = "Basemap") %>%
        leaflet::addProviderTiles(
            "OpenStreetMap.Mapnik",
            group = "Basemap",
            options = leaflet::providerTileOptions(opacity = 0.35)
        ) %>%
        leaflet.extras::addFullscreenControl(pseudoFullscreen = TRUE) %>%
        leaflet::clearBounds() %>%
        leaflet::addAwesomeMarkers(
            data = sites,
            lng = ~ site_longitude,
            lat = ~ site_latitude,
            icon = leaflet::makeAwesomeIcon(markerColor = "green",
                                            iconColor = "white"),
            label = ~ glue::glue("[{prefix} {code}] {label}"),
            popup = ~ glue::glue("[{prefix} {code}] {label}\n{description}"),
            group = "WAMTRAM sites"
        ) %>%
        leaflet::addAwesomeMarkers(
            data = enc,
            lng = ~ longitude,
            lat = ~ latitude,
            icon = leaflet::makeAwesomeIcon(markerColor = "red",
                                            iconColor = "white"),
            label = ~ glue::glue("{observation_datetime_gmt08} {species_code} {observation_status}"),
            popup = ~ glue::glue("{observation_datetime_gmt08} {species_code} {observation_status}"),
            group = "WAMTRAM turtles",
            clusterOptions = co
        ) %>%
        leaflet::addLayersControl(
            baseGroups = c("Basemap"),
            overlayGroups = c("WAMTRAM sites", "WAMTRAM turtles"),
            options = leaflet::layersControlOptions(collapsed = FALSE)
        )
}
