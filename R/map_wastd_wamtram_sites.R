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
#' wastd_sites <- wastdr::download_wastd_sites()
#' load("inst/wamtram_data.RData")
#' w2_data <- wamtram_data
#' map_wastd_wamtram_sites(wastd_sites$localities, wastd_sites$sites, w2_data$sites)
#'
#'
#' # From live data
#' ws <- wastdr::download_wastd_sites()
#'
#' # split rows by place code, map only what place codes are not in wastd yet
#' map_wastd_wamtram_sites(areas, sites, w2_data$sites)
#' }
map_wastd_wamtram_sites <-
  function(wastd_areas, wastd_sites, wamtram_sites) {
    sbo <- leaflet::scaleBarOptions(imperial = FALSE, maxWidth = 200)
    s <- wastd_sites %>%
      tidyr::separate_rows(w2_place_code, sep = " ")

    w_missing <- wamtram_sites %>%
      dplyr::anti_join(s, by = c("code" = "w2_place_code")) %>%
      dplyr::filter(!is.na(site_longitude), !is.na(site_latitude))

    w_imported <- wamtram_sites %>%
      dplyr::right_join(s, by = c("code" = "w2_place_code")) %>%
      dplyr::filter(!is.na(site_longitude), !is.na(site_latitude))

    w2_site_popup <- "<h3>{label}</h3>
        <strong>W2 location</strong> {prefix}<br/>
        <strong>W2 place</strong> {code}<br/>
        <strong>Lat</strong> {site_latitude}<br/>
        <strong>Lon</strong> {site_longitude}<br/>
        {description}"

    wastd_area_popup <- '<h3>{area_name}</h3>
        <strong>W2 location</strong> {w2_location_code}<br/>
        <a href="https://wastd.dbca.wa.gov.au/admin/observations/area/{area_id}"
         class="btn btn-xs btn-success">Edit</a>'

    wastd_site_popup <- '<h3>{site_name}</h3>
        <strong>W2 location</strong> {w2_location_code}<br/>
        <strong>W2 place</strong> {w2_place_code}<br/>
        <a href="https://wastd.dbca.wa.gov.au/admin/observations/area/{site_id}"
         class="btn btn-xs btn-success">Edit</a>'

    leaflet::leaflet() %>%
      leaflet::addProviderTiles("Esri.WorldImagery", group = "Basemap") %>%
      leaflet::addProviderTiles(
        "OpenStreetMap.Mapnik",
        group = "Basemap",
        options = leaflet::providerTileOptions(opacity = 0.35)
      ) %>%
      leaflet.extras::addFullscreenControl(pseudoFullscreen = TRUE) %>%
      leaflet::addScaleBar(position = "bottomleft", options = sbo) %>%
      leaflet::clearBounds() %>%
      leaflet::addAwesomeMarkers(
        data = w_imported,
        lng = ~site_longitude,
        lat = ~site_latitude,
        icon = leaflet::makeAwesomeIcon(
          markerColor = "green",
          iconColor = "white"
        ),
        label = ~ glue::glue("[{prefix} {code}] {label}"),
        popup = ~ glue::glue(w2_site_popup),
        group = "WAMTRAM imported sites"
      ) %>%
      leaflet::addAwesomeMarkers(
        data = w_missing,
        lng = ~site_longitude,
        lat = ~site_latitude,
        icon = leaflet::makeAwesomeIcon(
          markerColor = "red",
          iconColor = "white"
        ),
        label = ~ glue::glue("[{prefix} {code}] {label}"),
        popup = ~ glue::glue(w2_site_popup),
        group = "WAMTRAM missing sites"
      ) %>%
      leaflet::addPolygons(
        data = wastd_areas,
        weight = 1,
        fillOpacity = 0.5,
        fillColor = "blue",
        label = ~ glue::glue("[{area_id} {w2_location_code}] {area_name}"),
        popup = ~ glue::glue(wastd_area_popup),
        group = "WAStD areas"
      ) %>%
      leaflet::addPolygons(
        data = wastd_sites,
        weight = 1,
        fillOpacity = 0.5,
        fillColor = "green",
        label = ~ glue::glue("[{site_id} {w2_location_code} {w2_place_code}] {site_name}"),
        popup = ~ glue::glue(wastd_site_popup),
        group = "WAStD sites"
      ) %>%
      leaflet::addLayersControl(
        baseGroups = c("Basemap"),
        overlayGroups = c(
          "WAMTRAM imported sites",
          "WAMTRAM missing sites",
          "WAStD areas",
          "WAStD sites"
        ),
        options = leaflet::layersControlOptions(collapsed = FALSE)
      )
  }
