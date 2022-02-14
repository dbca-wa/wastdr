#' Map WAStD and WAMTRAM sites
#'
#' This map is useful to compare and update WAStD with and from WAMTRAM sites.
#'
#' @param wastd_areas Areas from `wastd_data`.
#' @param wastd_sites Sites from `wastd_data`.
#' @param wamtram_sites Sites from `wamtram_data`.
#'
#' @return A leaflet map
#' @export
#'
#' @examples
#' \dontrun{
#' library(wastdr)
#'
#' # From canned data
#' data("wastd_data")
#' data("wamtram_data") # canned data for package
#' w2_data = readRDS(here::here("inst/w2.rds")) # full snapshot for dev
#' map_wastd_wamtram_sites(wastd_data$areas, wastd_data$sites, wamtram_data$sites)
#'
#'
#' # From live data
#' areas_sf <- wastd_GET("area") %>% magrittr::extract2("data") %>%
#'   geojsonio::as.json() %>% geojsonsf::geojson_sf()
#'
#' areas <- areas_sf %>%
#'   dplyr::filter(area_type == "Locality") %>%
#'   dplyr::transmute(area_id = pk, area_name = name, w2_location_code = w2_location_code)
#'
#' sites <- areas_sf %>%
#'   dplyr::filter(area_type == "Site") %>%
#'   dplyr::transmute(site_id = pk, site_name = name, w2_place_code = w2_place_code) %>%
#'   sf::st_join(areas)
#'
#' # split rows by place code, map only what place codes are not in wastd yet
#' map_wastd_wamtram_sites(areas, sites, w2_data$sites)
#' }
map_wastd_wamtram_sites <- function(wastd_areas, wastd_sites, wamtram_sites){

    s <- wastd_sites %>%
        tidyr::separate_rows(w2_place_code, sep=" ")

    w_missing <- wamtram_sites %>%
        dplyr::anti_join(s, by=c("code" = "w2_place_code"))

    w_imported <- wamtram_sites %>%
        dplyr::right_join(s, by=c("code" = "w2_place_code"))

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
            data = w_imported,
            lng = ~ site_longitude,
            lat = ~ site_latitude,
            icon = leaflet::makeAwesomeIcon(markerColor = "green",
                                            iconColor = "white"),
            label = ~ glue::glue("[{prefix} {code}] {label}"),
            popup = ~ glue::glue("[{prefix} {code}] {label}\n{description}"),
            group = "WAMTRAM imported sites"
        ) %>%
        leaflet::addAwesomeMarkers(
            data = w_missing,
            lng = ~ site_longitude,
            lat = ~ site_latitude,
            icon = leaflet::makeAwesomeIcon(markerColor = "red",
                                            iconColor = "white"),
            label = ~ glue::glue("[{prefix} {code}] {label}"),
            popup = ~ glue::glue("[{prefix} {code}] {label}\n{description}"),
            group = "WAMTRAM missing sites"
        ) %>%
        leaflet::addPolygons(
            data = wastd_areas,
            weight = 1,
            fillOpacity = 0.5,
            fillColor = "blue",
            label = ~ glue::glue("[{w2_location_code}] {area_name}"),
            popup = ~ glue::glue('
<h3>[{w2_location_code}] {area_name}</h3>
<a href="https://wastd.dbca.wa.gov.au/admin/observations/area/{area_id}" target="_">Edit</a>
'),
group = "WAStD areas"
        ) %>%
        leaflet::addPolygons(
            data = wastd_sites,
            weight = 1,
            fillOpacity = 0.5,
            fillColor = "green",
            label = ~ glue::glue("[{w2_location_code} {w2_place_code}] {site_name}"),
            popup = ~ glue::glue('
<h3>[{w2_location_code} {w2_place_code}] {site_name}</h3>
<a href="https://wastd.dbca.wa.gov.au/admin/observations/area/{site_id}" target="_">Edit</a>
'),
group = "WAStD sites"
        ) %>%
        leaflet::addLayersControl(
            baseGroups = c("Basemap"),
            overlayGroups = c(
                "WAMTRAM imported sites",
                "WAMTRAM missing sites",
                "WAStD areas",
                "WAStD sites"),
            options = leaflet::layersControlOptions(collapsed = FALSE)
        )

}
