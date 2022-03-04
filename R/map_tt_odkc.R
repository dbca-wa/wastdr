#' Map Turtle Tagging 3.0 parsed with ruODK from ODK Central.
#'
#' \lifecycle{maturing}
#'
#' @details Creates a Leaflet map with an interactive legend offering to toggle
#' each species separately. The maps auto-zooms to the extent of data given.
#'
#' This map function uses data from ODK Central / ruODK using form
#' "Turtle Tagging 3.0".
#'
#' @param data The output of `odkc_data$tt` from ODK form `Turtle Tagging 3.0`.
#' @param sites An sf object of sites with `site_name` and polygon geom, e.g.
#'  `turtleviewer::turtledata$sites`.
#' @template param-wastd_url
#' @template param-fmt
#' @template param-tz
#' @template param-cluster
#' @return A leaflet map
#' @export
#' @family odkc
#' @examples
#' \dontrun{
#' data("odkc_data")
#' map_tt_odkc(odkc_data$tt, sites = odkc_data$sites)
#' map_tt_odkc(data = NULL, sites = odkc_data$sites)
#' }
map_tt_odkc <- function(data,
                        sites = NULL,
                        wastd_url = wastdr::get_wastd_url(),
                        fmt = "%d/%m/%Y %H:%M",
                        tz = "Australia/Perth",
                        cluster = FALSE) {
  co <- if (cluster == TRUE) leaflet::markerClusterOptions() else NULL
  sbo <- leaflet::scaleBarOptions(imperial = FALSE, maxWidth = 200)
  overlay_names <- c()

  l <- leaflet::leaflet(width = 800, height = 600) %>%
    leaflet::addProviderTiles("Esri.WorldImagery", group = "Basemap") %>%
    leaflet::addProviderTiles(
      "OpenStreetMap.Mapnik",
      group = "Basemap",
      options = leaflet::providerTileOptions(opacity = 0.35)
    ) %>%
    leaflet.extras::addFullscreenControl(pseudoFullscreen = TRUE) %>%
    leaflet::addScaleBar(position = "bottomleft", options = sbo) %>%
    leaflet::clearBounds()


  if (!is.null(data) && nrow(data) > 0) {
    data <- data %>% wastdr::sf_as_tbl()
    pal_mwi <- leaflet::colorFactor(
      palette = "viridis",
      domain = data$turtle_species
    )
    data.df <- data %>% split(data$turtle_species)
    overlay_names <- names(data.df)
    if (!is.null(sites)) overlay_names <- c("Sites", overlay_names)

    names(data.df) %>%
      purrr::walk(function(df) {
        l <<- l %>% leaflet::addAwesomeMarkers(
          data = data.df[[df]],
          lng = ~start_geopoint_longitude,
          lat = ~start_geopoint_latitude,
          icon = leaflet::makeAwesomeIcon(
            icon = "home",
            markerColor = "green",
            iconColor = ~ pal_mwi(turtle_species)
          ),
          label = ~ glue::glue("
            {lubridate::with_tz(observation_start_time, tz)} {ft1_ft1_name}
          "),
          popup = ~ glue::glue('
<h3>{humanize(turtle_species)}</h3>

<span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>
{lubridate::with_tz(observation_start_time, tz)} AWST</br>

<span class="glyphicon glyphicon-user" aria-hidden="true"></span>
{reporter}<br/>

<div style="min-height:200px; max-height:200px; overflow: auto;">
<img class="d-block w-100" src="{datasheet_photo_datasheet_front %||% ""}" alt="Photo datasheet front">
<img class="d-block w-100" src="{datasheet_photo_datasheet_rear %||% ""}" alt="Photo datasheet rear">
</div>
          '),
          group = df,
          clusterOptions = co
        )
      })
  }

  l %>%
    {
      if (!is.null(sites) && nrow(sites) > 0) {
        leaflet::addPolygons(
          .,
          data = sites,
          group = "Sites",
          weight = 1,
          fillOpacity = 0.5,
          fillColor = "blue",
          label = ~site_name
        )
      } else {
        .
      }
    } %>%
    leaflet::addLayersControl(
      baseGroups = c("Basemap"),
      overlayGroups = overlay_names,
      options = leaflet::layersControlOptions(collapsed = FALSE)
    )
}

# usethis::use_test("map_tt_odkc")
