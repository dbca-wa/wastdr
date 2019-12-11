#' Map Disturbance observations interactively.
#'
#' @details Creates a Leaflet map with an interactive legend offering to toggle each disturbance class
#' separately. The maps auto-zooms to the extent of data given.
#'
#' @param dist The output of \code{parse_disturbance_observations()}.
#' @template param-wastd_url
#' @template param-fmt
#' @template param-cluster
#' @return A leaflet map
#' @importFrom purrr walk
#' @importFrom glue glue
#' @importFrom leaflet leaflet addAwesomeMarkers addLayersControl addProviderTiles clearBounds
#' @export
map_dist <- function(dist,
                     wastd_url = wastdr::get_wastd_url(),
                     fmt = "%d/%m/%Y %H:%M",
                     cluster = FALSE) {
  . <- NULL
  layersControlOptions <- NULL
  markerClusterOptions <- NULL

  if (cluster == TRUE) {
    co <- leaflet::markerClusterOptions()
  } else {
    co <- NULL
  }

  pal <- leaflet::colorFactor(
    palette = "viridis",
    domain = dist$disturbance_cause
  )

  layersControlOptions <- NULL
  l <- leaflet::leaflet(width = 800, height = 600) %>%
    leaflet::addProviderTiles("Esri.WorldImagery", group = "Aerial") %>%
    leaflet::addProviderTiles("OpenStreetMap.Mapnik", group = "Place names") %>%
    leaflet::clearBounds()

  dist.df <- dist %>% split(dist$disturbance_cause)

  names(dist.df) %>%
    purrr::walk(function(df) {
      l <<- l %>% leaflet::addAwesomeMarkers(
        data = dist.df[[df]],
        lng = ~longitude, lat = ~latitude,
        icon = leaflet::makeAwesomeIcon(
          text = ~ stringr::str_sub(disturbance_cause, 0, 1),
          markerColor = "red",
          iconColor = ~ pal(disturbance_cause)
        ),
        label = ~ glue::glue(
          "{format(datetime, fmt)} {humanize(disturbance_cause)}"
        ),
        popup = ~ glue::glue(
          "<h3>{humanize(disturbance_cause)}</h3>",
          "<p>Seen on {format(datetime, fmt)} AWST by {observer}",
          "<p>Survey {survey_id} at {site_name} ",
          "{format(survey_start_time, fmt)}-{format(survey_end_time, fmt)} AWST</p>",
          '<p><a class="btn btn-xs btn-secondary" target="_" rel="nofollow" ',
          'href="{wastd_url}{absolute_admin_url}">Edit on WAStD</a></p>'
        ),

        group = df,
        clusterOptions = co
      )
    })

  l %>%
    leaflet::addLayersControl(
      baseGroups = c("Aerial", "Place names"),
      overlayGroups = names(dist.df),
      options = leaflet::layersControlOptions(collapsed = FALSE)
    )
}

#' Map Disturbance observations interactively from ODK Central data.
#'
#' @details Creates a Leaflet map with an interactive legend offering to toggle
#' each disturbance class separately. The maps auto-zooms to the extent of data
#' given.
#'
#' @param dist The output of \code{parse_disturbance_observations()}.
#' @template param-wastd_url
#' @template param-fmt
#' @template param-cluster
#' @return A leaflet map
#' @importFrom purrr walk
#' @importFrom glue glue
#' @importFrom leaflet leaflet addAwesomeMarkers addLayersControl addProviderTiles clearBounds
#' @export
map_dist_odkc <- function(dist,
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

  pal <- leaflet::colorFactor(
    palette = "viridis",
    domain = dist$disturbance_cause
  )

  layersControlOptions <- NULL
  l <- leaflet::leaflet(width = 800, height = 600) %>%
    leaflet::addProviderTiles("Esri.WorldImagery", group = "Aerial") %>%
    leaflet::addProviderTiles("OpenStreetMap.Mapnik", group = "Place names") %>%
    leaflet::clearBounds()

  dist.df <- dist %>% split(dist$disturbance_cause)

  names(dist.df) %>%
    purrr::walk(function(df) {
      l <<- l %>% leaflet::addAwesomeMarkers(
        data = dist.df[[df]],
        lng = ~location_longitude, lat = ~location_latitude,
        icon = leaflet::makeAwesomeIcon(
          text = ~ stringr::str_sub(disturbance_cause, 0, 1),
          markerColor = "red",
          iconColor = ~ pal(disturbance_cause)
        ),
        label = ~ glue::glue(
          "{lubridate::with_tz(observation_start_time, tz)} {humanize(disturbance_cause)}"
        ),
        popup = ~ glue::glue(
          "<h3>{humanize(disturbance_cause)}</h3>",
          "<p>Seen on {lubridate::with_tz(observation_start_time, tz)} AWST by {reporter}"
        ),

        group = df,
        clusterOptions = co
      )
    })

  l %>%
    leaflet::addLayersControl(
      baseGroups = c("Aerial", "Place names"),
      overlayGroups = names(dist.df),
      options = leaflet::layersControlOptions(collapsed = FALSE)
    )
}
