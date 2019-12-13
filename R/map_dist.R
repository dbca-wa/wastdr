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
        lng = ~longitude, lat = ~latitude,
        icon = leaflet::makeAwesomeIcon(
          text = ~ stringr::str_sub(disturbance_cause, 0, 1),
          markerColor = "orange",
          iconColor = ~ pal(disturbance_cause)
        ),
        label = ~ glue::glue(
          "{format(datetime, fmt)} {humanize(disturbance_cause)}"
        ),
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
  if (!is.null(tracks)){

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
map_dist_odkc <- function(dist,
                          tracks=NULL,
                          sites = NULL,
                          wastd_url = wastdr::get_wastd_url(),
                          fmt = "%d/%m/%Y %H:%M",
                          tz = "Australia/Perth",
                          cluster = FALSE) {
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

  # ---------------------------------------------------------------------------#
  # Disturbances by cause
  #
  dist.df <- dist %>% split(dist$disturbance_cause)
  overlay_names <- names(dist.df)

  names(dist.df) %>%
    purrr::walk(function(df) {
      l <<- l %>% leaflet::addAwesomeMarkers(
        data = dist.df[[df]],
        lng = ~location_longitude, lat = ~location_latitude,
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
          "<p>Seen on {lubridate::with_tz(observation_start_time, tz)} ",
          "AWST by {reporter}"
        ),

        group = df,
        clusterOptions = co
      )
    })

  # ---------------------------------------------------------------------------#
  # Dist nests by dist cause
  #
  if (!is.null(tracks)){

    pal_tracks <- leaflet::colorFactor(
      palette = "viridis",
      domain = tracks$disturbance_cause
    )

    dist.tr <- tracks %>% split(tracks$disturbance_cause)
    overlay_names <- unique(c(overlay_names, names(dist.tr)))

    names(dist.tr) %>%
      purrr::walk(function(df) {
        l <<- l %>% leaflet::addAwesomeMarkers(
          data = dist.tr[[df]],
          lng = ~observed_at_longitude, lat = ~observed_at_latitude,
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
            "<p>Seen on {lubridate::with_tz(observation_start_time, tz)} ",
            "AWST by {reporter}"
          ),

          group = df,
          clusterOptions = co
        )
      })

    # [1] "id"                              "submissions_id"
    # [3] "photo_disturbance"               "disturbance_cause"
    # [5] "disturbance_cause_confidence"    "disturbance_severity"
    # [7] "comments"                        "odata_context.x"
    # [9] "observation_start_time"          "reporter"
    # [11] "device_id"                       "observation_end_time"
    # [13] "submission_date"                 "submitter_id"
    # [15] "submitter_name"                  "instance_id"
    # [17] "nest_age"                        "species"
    # [19] "nest_type"                       "observed_at_longitude"
    # [21] "observed_at_latitude"            "observed_at_altitude"
    # [23] "habitat"                         "disturbance"
    # [25] "nest_tagged"                     "logger_found"
    # [27] "eggs_counted"                    "hatchlings_measured"
    # [29] "fan_angles_measured"             "bearing_to_water_manual"
    # [31] "leftmost_track_manual"           "rightmost_track_manual"
    # [33] "no_tracks_main_group"            "no_tracks_main_group_min"
    # [35] "no_tracks_main_group_max"        "outlier_tracks_present"
    # [37] "hatchling_path_to_sea"           "hatchling_emergence_time_known"
    # [39] "cloud_cover_at_emergence_known"  "light_sources_present"
    # [41] "photo_hatchling_tracks_seawards" "photo_hatchling_tracks_relief"
    # [43] "path_to_sea_comments"            "photo_nest_1"
    # [45] "photo_nest_2"                    "photo_nest_3"
    # [47] "photo_track_1"                   "tail_pokes"
    # [49] "photo_track_2"                   "max_track_width_rear"
    # [51] "max_track_width_front"           "carapace_drag_width"
    # [53] "step_length"                     "status"
    # [55] "date_nest_laid"                  "tag_label"
    # [57] "tag_comments"                    "photo_tag"
    # [59] "flipper_tag_id"                  "hatchling_emergence_time"
    # [61] "hatchling_emergence_time_source" "odata_context.y"
    # [63] "species_colours"                 "nest_type_text"
    # [65] "geometry"                        "site_id"
    # [67] "site_name"                       "area_id"
    # [69] "area_name"                       "datetime"
    # [71] "calendar_date_awst"              "turtle_date"
    # [73] "season"                          "season_week"
    # [75] "iso_week"

  }

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
