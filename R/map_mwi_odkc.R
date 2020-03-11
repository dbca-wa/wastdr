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
#' data("odkc")
#' map_mwi_odkc(odkc$mwi, sites = odkc$sites)
#' map_mwi_odkc(data = NULL, sites = odkc$sites)
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
    leaflet::addProviderTiles("Esri.WorldImagery", group = "Aerial") %>%
    leaflet::addProviderTiles("OpenStreetMap.Mapnik", group = "Place names") %>%
    leaflet::clearBounds()


  if (!is.null(data) && nrow(data) > 0) {
    data <- data %>% wastdr::sf_as_tbl()
    pal_mwi <- leaflet::colorFactor(palette = "viridis", domain = data$details_taxon)
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
          popup = ~ glue::glue(
            '
          <h3>{humanize(status_health)} {humanize(details_maturity)}
          {humanize(details_sex)} {humanize(details_species)}</h3>
          <span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>
          {lubridate::with_tz(observation_start_time, tz)} AWST</br>
          <span class="glyphicon glyphicon-user" aria-hidden="true"></span>
          {reporter}<br/>
           <span class="glyphicon glyphicon-comment" aria-hidden="true"></span>
           Cause of death: {humanize(death_cause_of_death)}
           ({humanize(death_cause_of_death_confidence)})
           <h5>Animal</h5>
           Activity: {status_activity}; behaviour: {status_behaviour} <br/>
           <img height="150px;" alt="Photo carapace top"
           src="{photos_turtle_photo_carapace_top %||% ""}"></img><br/>
           <img height="150px;" alt="Photo head top"
           src="{ifelse(!is.na({photos_turtle_photo_head_top}),
                               photos_turtle_photo_head_top, "")}"></img><br/>
           <img height="150px;" alt="Photo head side"
           src="{ifelse(!is.na({photos_turtle_photo_head_side}),
                               photos_turtle_photo_head_side, "")}"></img><br/>
          <img height="150px;" alt="Photo head front"
           src="{ifelse(!is.na({photos_turtle_photo_head_front}),
                               photos_turtle_photo_head_front, "")}"></img><br/>
           <h5>Habitat</h5>
           <img height="150px;" alt="Photo Habitat 1"
          src="{ifelse(!is.na({incident_photo_habitat}),
          incident_photo_habitat, "")}"></img><br/>
          <img height="150px;" alt="Photo Habitat 2"
          src="{ifelse(!is.na({habitat_photos_photo_habitat_2}),
          habitat_photos_photo_habitat_2, "")}"></img><br/>
          <img height="150px;" alt="Photo Habitat 3"
          src="{ifelse(!is.na({habitat_photos_photo_habitat_3}),
          habitat_photos_photo_habitat_3, "")}"></img><br/>
          <img height="150px;" alt="Photo Habitat 4"
          src="{ifelse(!is.na({habitat_photos_photo_habitat_4}),
          habitat_photos_photo_habitat_4, "")}"></img><br/>
          '
          ),
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
      baseGroups = c("Aerial", "Place names"),
      overlayGroups = overlay_names,
      options = leaflet::layersControlOptions(collapsed = FALSE)
    )
}

# usethis::use_test("map_mwi_odkc")
