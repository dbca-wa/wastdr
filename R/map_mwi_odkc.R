#' Map Marine Wildlife Incident 0.6 parsed with ruODK from ODK Central.
#'
#' \lifecycle{maturing}
#'
#' @details Creates a Leaflet map with an interactive legend offering to toggle
#' each species separately. The maps auto-zooms to the extent of data given.
#'
#' This map function uses data from ODK Central / ruODK using form
#' "Marine Wildlife Incident 0.6".
#'
#' @param data The output of `turtleviewer::turtledata$mwi` from ODK form
#'   `Marine Wildlife Incident 0.6`.
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
#' map_mwi_odkc(odkc_data$mwi, sites = odkc_data$sites)
#' map_mwi_odkc(data = NULL, sites = odkc_data$sites)
#' }
map_mwi_odkc <- function(data,
                         sites = NULL,
                         wastd_url = wastdr::get_wastd_url(),
                         fmt = "%d/%m/%Y %H:%M",
                         tz = "Australia/Perth",
                         cluster = FALSE) {
  co <- if (cluster == TRUE) leaflet::markerClusterOptions() else NULL
  overlay_names <- c()

  l <- leaflet::leaflet(width = 800, height = 600) %>%
      leaflet::addProviderTiles("Esri.WorldImagery", group = "Basemap") %>%
      leaflet::addProviderTiles(
          "OpenStreetMap.Mapnik", group = "Basemap",
          options = leaflet::providerTileOptions(opacity = 0.35)) %>%
      leaflet.extras::addFullscreenControl(pseudoFullscreen = TRUE) %>%
      leaflet::clearBounds()


  if (!is.null(data) && nrow(data) > 0) {
    data <- data %>% wastdr::sf_as_tbl()
    pal_mwi <- leaflet::colorFactor(
      palette = "viridis",
      domain = data$details_taxon
    )
    data.df <- data %>% split(data$details_taxon)
    overlay_names <- names(data.df)
    if (!is.null(sites)) overlay_names <- c("Sites", overlay_names)

    names(data.df) %>%
      purrr::walk(function(df) {
        l <<- l %>% leaflet::addAwesomeMarkers(
          data = data.df[[df]],
          lng = ~incident_observed_at_longitude,
          lat = ~incident_observed_at_latitude,
          icon = leaflet::makeAwesomeIcon(
            icon = "warning-sign",
            markerColor = "red",
            iconColor = ~ pal_mwi(details_taxon)
          ),
          label = ~ glue::glue("
            {lubridate::with_tz(observation_start_time, tz)}
            {humanize(status_health)}
            {humanize(details_maturity)}
            {humanize(details_sex)}
            {humanize(details_species)}
          "),
          popup = ~ glue::glue('
<h3>
 {humanize(status_health)} {humanize(details_maturity)}
 {humanize(details_sex)} {humanize(details_species)}
</h3>

<span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>
{lubridate::with_tz(observation_start_time, tz)} AWST</br>

<span class="glyphicon glyphicon-user" aria-hidden="true"></span>
{reporter}<br/>

<span class="glyphicon glyphicon-comment" aria-hidden="true"></span>
Cause of death: {humanize(death_cause_of_death)}
({humanize(death_cause_of_death_confidence)})<br/>

<span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span>
Activity: {humanize(status_activity)}; behaviour: {status_behaviour};<br/>

<span class="glyphicon glyphicon-hand-right" aria-hidden="true"></span>
Fate: {animal_fate_animal_fate_comment}<br/>

<span class="glyphicon glyphicon-search" aria-hidden="true"></span>
Injuries: {checks_checked_for_injuries}<br/>

<span class="glyphicon glyphicon-search" aria-hidden="true"></span>
Flipper tags: {checks_checked_for_flipper_tags}<br/>

<span class="glyphicon glyphicon-search" aria-hidden="true"></span>
PIT tags: {checks_scanned_for_pit_tags}<br/>

<span class="glyphicon glyphicon-search" aria-hidden="true"></span>
Samples taken: {checks_samples_taken}<br/>

<div style="min-height:200px; max-height:200px; overflow: auto;">
<img class="d-block w-100" src="{incident_photo_habitat %||% ""}" alt="Photo habitat">
<img class="d-block w-100" src="{habitat_photos_photo_habitat_2 %||% ""}" alt="Photo habitat 2">
<img class="d-block w-100" src="{habitat_photos_photo_habitat_3 %||% ""}" alt="Photo habitat 3">
<img class="d-block w-100" src="{habitat_photos_photo_habitat_4 %||% ""}" alt="Photo habitat 4">
<img class="d-block w-100" src="{photos_turtle_photo_carapace_top %||% ""}" alt="Photo carapace top">
<img class="d-block w-100" src="{photos_turtle_photo_head_top %||% ""}" alt="Photo head top">
<img class="d-block w-100" src="{photos_turtle_photo_head_side %||% ""}" alt="Photo head side">
<img class="d-block w-100" src="{photos_turtle_photo_head_front %||% ""}" alt="Photo head front">
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

# usethis::use_test("map_mwi_odkc")
