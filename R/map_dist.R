#' Map Disturbance observations interactively.
#'
#' @details Creates a Leaflet map with an interactive legend offering to toggle
#' each disturbance class separately.
#' The maps auto-zooms to the extent of data given.
#'
#' @param dist The output of \code{parse_disturbance_observations()}.
#' @param tracks TurtleNestDisturbanceObservations, optional. Planned feature.
#' @template param-wastd_url
#' @template param-fmt
#' @template param-cluster
#' @return A leaflet map
#' @export
map_dist <- function(dist,
                     tracks = NULL,
                     wastd_url = wastdr::get_wastd_url(),
                     fmt = "%d/%m/%Y %H:%M",
                     cluster = FALSE) {
  # ---------------------------------------------------------------------------#
  # Options
  #
  co <- if (cluster == TRUE) leaflet::markerClusterOptions() else NULL
  pal <- leaflet::colorFactor(
    palette = "viridis",
    domain = dist$disturbance_cause
  )

  # ---------------------------------------------------------------------------#
  # Base map
  #
  l <- leaflet::leaflet(width = 800, height = 600) %>%
    leaflet::addProviderTiles("Esri.WorldImagery", group = "Aerial") %>%
    leaflet::addProviderTiles("OpenStreetMap.Mapnik", group = "Place names") %>%
    leaflet::clearBounds()

  # ---------------------------------------------------------------------------#
  # Disturbances by cause
  #
  dist.df <- dist %>% split(dist$disturbance_cause)

  overlay_names <- names(dist.df)

  names(dist.df) %>%
    purrr::walk(function(df) {
      l <<- l %>% leaflet::addAwesomeMarkers(
        data = dist.df[[df]],
        lng = ~encounter_longitude,
        lat = ~encounter_latitude,
        icon = leaflet::makeAwesomeIcon(
          text = ~ stringr::str_sub(disturbance_cause, 0, 1),
          markerColor = "orange",
          iconColor = ~ pal(disturbance_cause)
        ),
        label = ~ glue::glue("{datetime} {humanize(disturbance_cause)}"),
        popup = ~ glue::glue(
          "<h3>Signs of {humanize(disturbance_cause)}</h3>",
          '<span class="glyphicon glyphicon-globe" aria-hidden="true"></span> ',
          "{encounter_site_name}</br>",
          '<span class="glyphicon glyphicon-calendar" aria-hidden="true"></span> ',
          "{datetime} AWST</br>",
          '<span class="glyphicon glyphicon-user" aria-hidden="true"></span>',
          " {encounter_observer_name}<br/>",
          '<span class="glyphicon glyphicon-comment" aria-hidden="true"></span> ',
          "Confidence: {humanize(disturbance_cause_confidence)}. ",
          "{encounter_comments}<br/>",


          "<p>Survey {encounter_survey_id} at {encounter_site_name} ",
          "{encounter_survey_start_time}-",
          "{encounter_survey_end_time} AWST</p>",
          '<p><a class="btn btn-xs btn-secondary" target="_" rel="nofollow" ',
          'href="{wastd_url}{encounter_absolute_admin_url}">Edit on WAStD</a></p>'
        ),
        group = df,
        clusterOptions = co
      )
    })

  # ---------------------------------------------------------------------------#
  # Dist nests by dist cause
  #
  l %>%
    leaflet::addLayersControl(
      baseGroups = c("Aerial", "Place names"),
      overlayGroups = overlay_names,
      options = leaflet::layersControlOptions(collapsed = FALSE)
    )
}
