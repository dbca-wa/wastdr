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
                       cluster = FALSE,
                       ts = FALSE) {
  layersControlOptions <- NULL
  markerClusterOptions <- NULL
  co <- if(cluster==TRUE) leaflet::markerClusterOptions() else NULL

  l <- leaflet::leaflet(width = 800, height = 600) %>%
    leaflet::addProviderTiles("Esri.WorldImagery", group = "Aerial") %>%
    leaflet::addProviderTiles("OpenStreetMap.Mapnik", group = "Place names") %>%
    {
      if (ts == TRUE)
        leaftime::addTimeline(.,
                              group = "Time series",
                              data = tracks_as_geojson(tracks),
                              sliderOpts = leaftime::sliderOptions(
                                formatOutput = htmlwidgets::JS(
                                  "function(date) {return new Date(date).toDateString()}"
                                ),
                              ),
                              timelineOpts = leaftime::timelineOptions(
                                styleOptions = leaftime::styleOptions(
                                  radius = 10,
                                  stroke = FALSE,
                                  fillColor = "yellow",
                                  fillOpacity = .4
                                )
                              )
        )
    } %>%
    leaflet::clearBounds()

  tracks.df <- tracks %>% split(tracks$species)
  overlay_names <- names(tracks.df)
  if (ts == TRUE) overlay_names <- c("Time series", overlay_names)
  if (!is.null(sites)) overlay_names <- c("Sites", overlay_names)

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
      overlayGroups = overlay_names,
      options = leaflet::layersControlOptions(collapsed = FALSE)
    )
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
#' map_tracks_odkc(turtledata$tracks, sites=turtledata$sites, cluster=T)
#' }
map_tracks_odkc <- function(tracks,
                            sites = NULL,
                            wastd_url = wastdr::get_wastd_url(),
                            fmt = "%d/%m/%Y %H:%M",
                            tz = "Australia/Perth",
                            cluster = FALSE,
                            ts = FALSE) {
  . <- NULL
  layersControlOptions <- NULL
  markerClusterOptions <- NULL
  co <- if(cluster==TRUE) leaflet::markerClusterOptions() else NULL

  l <- leaflet::leaflet(width = 800, height = 600) %>%
    leaflet::addProviderTiles("Esri.WorldImagery", group = "Aerial") %>%
    leaflet::addProviderTiles("OpenStreetMap.Mapnik", group = "Place names") %>%
    {
      if (ts == TRUE)
        leaftime::addTimeline(.,
                              group = "Time series",
                              data = tracks_as_geojson(tracks),
                              sliderOpts = leaftime::sliderOptions(
                                formatOutput = htmlwidgets::JS(
                                  "function(date) {return new Date(date).toDateString()}"
                                ),
                              ),
                              timelineOpts = leaftime::timelineOptions(
                                styleOptions = leaftime::styleOptions(
                                  radius = 10,
                                  stroke = FALSE,
                                  fillColor = "yellow",
                                  fillOpacity = .4
                                )
                              )
        )
    } %>%
    leaflet::clearBounds()

  tracks.df <- tracks %>% split(tracks$species)
  overlay_names <- names(tracks.df) %>% purrr::map_chr(humanize)
  if (ts == TRUE) overlay_names <- c("Time series", overlay_names)
  if (!is.null(sites)) overlay_names <- c("Sites", overlay_names)

  names(tracks.df) %>%
    purrr::walk(function(df) {
      l <<- l %>%
        leaflet::addAwesomeMarkers(
          data = tracks.df[[df]],
          lng = ~ observed_at_longitude,
          lat = ~ observed_at_latitude,
          icon = leaflet::makeAwesomeIcon(
            text = ~ nest_type_text,
            markerColor = ~ species_colours
          ),
          label = ~ glue::glue(
            "{lubridate::with_tz(observation_start_time, tz)}",
            " {humanize(nest_age)}",
            " {humanize(species)} {humanize(nest_type)}"
          ),
          popup = ~ glue::glue(
            "<h3>{humanize(nest_age)} {humanize(species)} {humanize(nest_type)}</h3>",

            '<span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>',
            ' {lubridate::with_tz(observation_start_time, tz)} AWST</br>',
            '<span class="glyphicon glyphicon-user" aria-hidden="true"></span> {reporter}<br/>',

            "<h5>Photos of tracks</h5>",
            '<img height="150px;" alt="Track Photo 1" src="{ifelse(!is.na({photo_track_1}), photo_track_1, "")}"></img>',
            '<img height="150px;" alt="Track Photo 2" src="{ifelse(!is.na({photo_track_2}), photo_track_2, "")}"></img>',

            "<h5>Photos of nest</h5>",
            '<img height="150px;" alt="Track Nest 1" src="{ifelse(!is.na({photo_nest_1}), photo_nest_1, "")}"></img>',
            '<img height="150px;" alt="Track Nest 2" src="{ifelse(!is.na({photo_nest_2}), photo_nest_2, "")}"></img>',
            '<img height="150px;" alt="Track Nest 3" src="{ifelse(!is.na({photo_nest_3}), photo_nest_3, "")}"></img>'

          ),
          group = humanize(df),
          clusterOptions = co
        )
    })

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
      overlayGroups = overlay_names,
      options = leaflet::layersControlOptions(collapsed = FALSE)
    )
}
