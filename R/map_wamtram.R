#' Map WAMTRAM data
#'
#' @param data The output of `wastdr::download_w2_data()`.
#' @param location A W2 location code, e.g. "TH", to filter the data by.
#' @param place A W2 place code, e.g. "THEE", to filter the data by. Providing
#'   `place` overrides `location`.
#' @return A leaflet map showing W2 sites and encounters.
#' @export
#' @examples \dontrun{
#' data("w2_data", package="etlTurtleNesting")
#' map_wamtram(w2_data)
#'
#' map_wamtram(w2_data, location="DH")
#' map_wamtram(w2_data, place="DHTB")
#' }
map_wamtram <- function(data, location=NULL, place=NULL){

    if (class(data) != "wamtram_data") {
        glue::glue(
            "The first argument needs to be an object of class ",
            "\"wamtram_data\", e.g. the output of wastdr::download_w2_data."
        ) %>% wastdr_msg_abort()
    }

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


# usethis::use_test("map_wamtram")  # nolint
