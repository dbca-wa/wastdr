#' Map TurtleNestEncounters interactively.
#'
#' @details Creates a Leaflet map with an interactive legend offering to
#' toggle each species separately.
#' The maps auto-zooms to the extent of data given.
#'
#' @template param-tracks
#' @param sites An sf object of sites with `site_name` and polygon geom, e.g.
#'  `turtleviewer::turtledata$sites`.
#' @template param-wastd_url
#' @template param-fmt
#' @template param-cluster
#' @return A leaflet map
#' @export
map_tracks <- function(tracks,
                       sites = NULL,
                       wastd_url = wastdr::get_wastd_url(),
                       fmt = "%d/%m/%Y %H:%M",
                       cluster = FALSE) {
  layersControlOptions <- NULL
  markerClusterOptions <- NULL

  if (cluster == TRUE) {
    co <- leaflet::markerClusterOptions()
  } else {
    co <- NULL
  }
  l <- leaflet::leaflet(width = 800, height = 600) %>%
    leaflet::addProviderTiles("Esri.WorldImagery", group = "Aerial") %>%
    leaflet::addProviderTiles("OpenStreetMap.Mapnik", group = "Place names") %>%
    leaflet::clearBounds()

  tracks.df <- tracks %>% split(tracks$species)
  overlay_names <- names(tracks.df)

  names(tracks.df) %>%
    purrr::walk(function(df) {
      l <<- l %>%
        leaflet::addAwesomeMarkers(
          data = tracks.df[[df]],
          lng = ~longitude, lat = ~latitude,
          icon = leaflet::makeAwesomeIcon(
            text = ~nest_type_text,
            markerColor = ~species_colours
          ),
          label = ~ glue::glue(
            '{format(datetime, "%d/%m/%Y %H:%M")} {humanize(nest_age)}',
            " {humanize(species)} {humanize(nest_type)} {name}"
          ),
          popup = ~ glue::glue(
            "<h3>{humanize(nest_age)} {humanize(species)}",
            " {humanize(nest_type)} {name}</h3>",
            "<p>Seen on {format(datetime, fmt)} AWST by {observer}",
            "<p>Survey {survey_id} at {site_name} ",
            "{format(survey_start_time, fmt)}-",
            "{format(survey_end_time, fmt)} AWST</p>",
            '<p><a class="btn btn-xs btn-secondary" target="_" rel="nofollow" ',
            'href="{wastd_url}{absolute_admin_url}">Edit on WAStD</a></p>'
          ),
          group = df,
          clusterOptions = co
        )
    })

  if (!is.null(sites)) {
    l %>%
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
        overlayGroups = c("Sites", overlay_names),
        options = leaflet::layersControlOptions(collapsed = FALSE)
      )
  } else {
    l %>%
      leaflet::addLayersControl(
        baseGroups = c("Aerial", "Place names"),
        overlayGroups = c("Sites", overlay_names),
        options = leaflet::layersControlOptions(collapsed = FALSE)
      )
  }
}

#' Map tracks directly from ODK data
#'
#' @details Creates a Leaflet map with an interactive legend offering to toggle
#' each species separately. The maps auto-zooms to the extent of data given.
#'
#' This map function uses data from ODK Central / ruODK using form
#' "Turtle Track or Nest 1.0".
#'
#' @template param-tracks
#' @template param-wastd_url
#' @template param-fmt
#' @template param-tz
#' @template param-cluster
#' @return A leaflet map
#' @export
map_tracks_odkc <- function(tracks,
                            wastd_url = wastdr::get_wastd_url(),
                            fmt = "%d/%m/%Y %H:%M",
                            tz = "Australia/Perth",
                            cluster = FALSE) {
  . <- NULL
  layersControlOptions <- NULL
  markerClusterOptions <- NULL

  if (cluster == TRUE) {
    co <- leaflet::markerClusterOptions()
  } else {
    co <- NULL
  }
  l <- leaflet::leaflet(width = 800, height = 600) %>%
    leaflet::addProviderTiles("Esri.WorldImagery", group = "Aerial") %>%
    leaflet::addProviderTiles("OpenStreetMap.Mapnik", group = "Place names") %>%
    leaflet::clearBounds()

  tracks.df <- tracks %>% split(tracks$species)

  names(tracks.df) %>%
    purrr::walk(function(df) {
      l <<- l %>%
        leaflet::addAwesomeMarkers(
          data = tracks.df[[df]],
          lng = ~observed_at_longitude, lat = ~observed_at_latitude,
          icon = leaflet::makeAwesomeIcon(
            text = ~nest_type_text,
            markerColor = ~species_colours
          ),
          label = ~ glue::glue(
            "{lubridate::with_tz(observation_start_time, tz)}",
            " {humanize(nest_age)}",
            " {humanize(species)} {humanize(nest_type)}"
          ),
          popup = ~ glue::glue(
            "<h3>{humanize(nest_age)} {humanize(species)}",
            " {humanize(nest_type)}</h3>",
            "<p>Seen on {lubridate::with_tz(observation_start_time, tz)}",
            " by {reporter}",
          ),
          group = df,
          clusterOptions = co
        )
    })

  l %>%
    leaflet::addLayersControl(
      baseGroups = c("Aerial", "Place names"),
      overlayGroups = names(tracks.df),
      options = leaflet::layersControlOptions(collapsed = FALSE)
    )
}
