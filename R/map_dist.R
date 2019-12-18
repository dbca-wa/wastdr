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
  layersControlOptions <- NULL
  markerClusterOptions <- NULL

  if (cluster == TRUE) {
    co <- leaflet::markerClusterOptions()
  } else {
    co <- NULL
  }

  pal <- leaflet::colorFactor(palette = "viridis",
                              domain = dist$disturbance_cause)


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
        lng = ~ longitude,
        lat = ~ latitude,
        icon = leaflet::makeAwesomeIcon(
          text = ~ stringr::str_sub(disturbance_cause, 0, 1),
          markerColor = "orange",
          iconColor = ~ pal(disturbance_cause)
        ),
        label = ~ glue::glue("{format(datetime, fmt)} {humanize(disturbance_cause)}"),
        popup = ~ glue::glue(
          "<h3>{humanize(disturbance_cause)}</h3>",
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

  # ---------------------------------------------------------------------------#
  # Dist nests by dist cause
  #
  if (!is.null(tracks)) {

  }

  l %>%
    leaflet::addLayersControl(
      baseGroups = c("Aerial", "Place names"),
      overlayGroups = overlay_names,
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
#' @param tracks The output of `turtleviewer::turtledata$tracks_dist` -
#'  Turtle nest disturbance obs joined to turtle nests.
#' @param sites An sf object of sites with `site_name` and polygon geom, e.g.
#'  `turtleviewer::turtledata$sites`.
#' @template param-wastd_url
#' @template param-fmt
#' @template param-tz
#' @template param-cluster
#' @return A leaflet map
#' @export
#' @examples
#' \dontrun{
#' library(turtleviewer)
#' data("turtledata", package="turtleviewer")
#' map_dist_odkc(
#'   turtledata$dist,
#'   tracks=turtledata$tracks_dist,
#'   sites=turtledata$sites)
#' }
map_dist_odkc <- function(dist,
                          tracks = NULL,
                          sites = NULL,
                          wastd_url = wastdr::get_wastd_url(),
                          fmt = "%d/%m/%Y %H:%M",
                          tz = "Australia/Perth",
                          cluster = FALSE) {
  layersControlOptions <- NULL
  markerClusterOptions <- NULL
  co <- if (cluster == TRUE) leaflet::markerClusterOptions() else NULL
  pal <- leaflet::colorFactor(palette = "viridis",
                              domain = dist$disturbance_cause)

  l <- leaflet::leaflet(width = 800, height = 600) %>%
    leaflet::addProviderTiles("Esri.WorldImagery", group = "Aerial") %>%
    leaflet::addProviderTiles("OpenStreetMap.Mapnik", group = "Place names") %>%
    leaflet::clearBounds()

  # ---------------------------------------------------------------------------#
  # Disturbances by cause
  #
  dist.df <- dist %>% split(dist$disturbance_cause)
  overlay_names <- names(dist.df) %>% purrr::map_chr(humanize)

  names(dist.df) %>%
    purrr::walk(function(df) {
      l <<- l %>% leaflet::addAwesomeMarkers(
        data = dist.df[[df]],
        lng = ~ location_longitude,
        lat = ~ location_latitude,
        icon = leaflet::makeAwesomeIcon(
          text = ~ stringr::str_sub(disturbance_cause, 0, 1),
          markerColor = "orange",
          iconColor = ~ pal(disturbance_cause)
        ),
        label = ~ glue::glue(
          "{calendar_date_awst} ",
          "Signs of {humanize(disturbance_cause)}"
        ),
        popup = ~ glue::glue(
          "<h3>Signs of {humanize(disturbance_cause)}</h3>",
          '<span class="glyphicon glyphicon-calendar" aria-hidden="true"></span> ',
          '{lubridate::with_tz(observation_start_time, tz)} AWST</br>',
          '<span class="glyphicon glyphicon-user" aria-hidden="true"></span> {reporter}<br/>',
          '<span class="glyphicon glyphicon-comment" aria-hidden="true"></span> ',
          'Confidence: {humanize(disturbance_cause_confidence)}. {comments}<br/>',
          '<img height="150px;" alt="Photo" src="{ifelse(!is.na({photo_disturbance}), photo_disturbance, "")}"></img><br/>'
        ),

        group = humanize(df),
        clusterOptions = co
      )
    })

  # ---------------------------------------------------------------------------#
  # Dist nests by dist cause
  #
  if (!is.null(tracks)) {
    pal_tracks <- leaflet::colorFactor(palette = "viridis",
                                       domain = tracks$disturbance_cause)

    dist.tr <- tracks %>% split(tracks$disturbance_cause)
    overlay_names <- c(overlay_names, names(dist.tr)) %>%
      unique() %>%
      purrr::map_chr(humanize)

    names(dist.tr) %>%
      purrr::walk(function(df) {
        l <<- l %>% leaflet::addAwesomeMarkers(
          data = dist.tr[[df]],
          lng = ~ observed_at_longitude,
          lat = ~ observed_at_latitude,
          icon = leaflet::makeAwesomeIcon(
            text = ~ stringr::str_sub(disturbance_cause, 0, 1),
            markerColor = "red",
            iconColor = ~ pal_tracks(disturbance_cause)
          ),
          label = ~ glue::glue(
            "{calendar_date_awst} ",
            "Nest with {humanize(disturbance_cause)}"
          ),
          popup = ~ glue::glue(
            "<h3>Nest disturbed by {humanize(disturbance_cause)}</h3>",
            '<span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>',
            '{lubridate::with_tz(observation_start_time, tz)} AWST</br>',
            '<span class="glyphicon glyphicon-user" aria-hidden="true"></span> {reporter}<br/>',
            '<span class="glyphicon glyphicon-comment" aria-hidden="true"></span> ',
            'Confidence: {disturbance_cause_confidence}. {comments}<br/>',
            '<img height="150px;" alt="Photo" src="{ifelse(!is.na({photo_disturbance}), photo_disturbance, "")}"></img><br/>'
          ),

          group = humanize(df),
          clusterOptions = co
        )
      })
  }

  l %>%
    {
      if (!is.null(sites))
        leaflet::addPolygons(
          .,
          data = sites,
          group = "Sites",
          weight = 1,
          fillOpacity = 0.5,
          fillColor = "blue",
          label = ~ site_name
        )
    } %>%
    leaflet::addLayersControl(
      baseGroups = c("Aerial", "Place names"),
      overlayGroups = (
        if (!is.null(sites))
          c("Sites", overlay_names)
        else
          overlay_names),
      options = leaflet::layersControlOptions(collapsed = FALSE)
    )

}
