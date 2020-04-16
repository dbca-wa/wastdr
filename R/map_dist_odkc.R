#' Map Disturbance observations interactively from ODK Central data.
#'
#' \lifecycle{maturing}
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
#' @family odkc
#' @examples
#' \dontrun{
#' data("odkc_data")
#' map_dist_odkc(
#'   odkc_data$dist,
#'   tracks = odkc_data$tracks_dist, sites = odkc_data$sites
#' )
#' map_dist_odkc(NULL, tracks = odkc_data$tracks_dist, sites = odkc_data$sites)
#' map_dist_odkc(odkc_data$dist, tracks = NULL, sites = odkc_data$sites)
#' map_dist_odkc(odkc_data$dist, tracks = odkc_data$tracks_dist, sites = NULL)
#' }
map_dist_odkc <- function(dist,
                          tracks = NULL,
                          sites = NULL,
                          wastd_url = wastdr::get_wastd_url(),
                          fmt = "%d/%m/%Y %H:%M",
                          tz = "Australia/Perth",
                          cluster = FALSE) {
  overlay_names <- NULL

  co <- if (cluster == TRUE) leaflet::markerClusterOptions() else NULL

  l <- leaflet::leaflet(width = 800, height = 600) %>%
    leaflet::addProviderTiles("Esri.WorldImagery", group = "Aerial") %>%
    leaflet::addProviderTiles("OpenStreetMap.Mapnik", group = "Place names") %>%
    leaflet::clearBounds()

  # ---------------------------------------------------------------------------#
  # Disturbances by cause
  #
  if (!is.null(dist) && nrow(dist) > 0) {
    dist <- dist %>% wastdr::sf_as_tbl()

    pal <- leaflet::colorFactor(
      palette = "viridis",
      domain = dist$disturbanceobservation_disturbance_cause
    )

    dist.df <-
      dist %>% split(dist$disturbanceobservation_disturbance_cause)
    overlay_names <- names(dist.df) %>% purrr::map_chr(humanize)

    names(dist.df) %>%
      purrr::walk(function(df) {
        l <<- l %>% leaflet::addAwesomeMarkers(
          data = dist.df[[df]],
          lng = ~disturbanceobservation_location_longitude,
          lat = ~disturbanceobservation_location_latitude,
          icon = leaflet::makeAwesomeIcon(
            text = ~ stringr::str_sub(
              disturbanceobservation_disturbance_cause, 0, 1
            ),
            markerColor = "orange",
            iconColor = ~ pal(disturbanceobservation_disturbance_cause)
          ),
          label = ~ glue::glue(
            "{calendar_date_awst} ",
            "Signs of {humanize(disturbanceobservation_disturbance_cause)} ",
          ),
          popup = ~ glue::glue('
<h3>Signs of {humanize(disturbanceobservation_disturbance_cause)}</h3>
<span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>
{lubridate::with_tz(observation_start_time, tz)} AWST</br>
<span class="glyphicon glyphicon-user" aria-hidden="true">
</span> {reporter}<br/>
<span class="glyphicon glyphicon-comment" aria-hidden="true"></span>
Confidence: {humanize(disturbanceobservation_disturbance_cause_confidence)}.
{disturbanceobservation_comments}<br/>
<img class="d-block w-100" alt="Photo"
src="{ifelse(!is.na({disturbanceobservation_photo_disturbance}),
disturbanceobservation_photo_disturbance, "")}"></img><br/>
          '),

          group = humanize(df),
          clusterOptions = co
        )
      })
  }
  # ---------------------------------------------------------------------------#
  # Dist nests by dist cause
  #
  if (!is.null(tracks) && nrow(tracks) > 0) {
    tracks <- tracks %>% wastdr::sf_as_tbl()

    pal_tracks <- leaflet::colorFactor(
      palette = "viridis",
      domain = tracks$disturbance_cause
    )

    dist.tr <- tracks %>% split(tracks$disturbance_cause)
    overlay_names <- c(overlay_names, names(dist.tr)) %>%
      unique() %>%
      purrr::map_chr(humanize)
    if (!is.null(sites)) {
      overlay_names <- c("Sites", overlay_names)
    }

    names(dist.tr) %>%
      purrr::walk(function(df) {
        l <<- l %>% leaflet::addAwesomeMarkers(
          data = dist.tr[[df]],
          lng = ~details_observed_at_longitude,
          lat = ~details_observed_at_latitude,
          icon = leaflet::makeAwesomeIcon(
            text = ~ stringr::str_sub(disturbance_cause, 0, 1),
            markerColor = "red",
            iconColor = ~ pal_tracks(disturbance_cause)
          ),
          label = ~ glue::glue(
            "{calendar_date_awst} ",
            "Nest with {humanize(disturbance_cause)}"
          ),
          popup = ~ glue::glue('
<h3>Nest disturbed by {humanize(disturbance_cause)}</h3>

<span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>
{lubridate::with_tz(observation_start_time, tz)} AWST</br>

<span class="glyphicon glyphicon-user" aria-hidden="true"></span>
{reporter}<br/>

<span class="glyphicon glyphicon-comment" aria-hidden="true"></span>
Confidence: {disturbance_cause_confidence}. {comments}<br/>

<img class="d-block w-100" alt="Photo"
src="{photo_disturbance %||% ""}"></img>
          '),
          group = humanize(df),
          clusterOptions = co
        )
      })
  }

  l %>%
    {
      if (!is.null(sites) && nrow(sites) > 0) {
        message(class(sites))
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

# usethis::use_test("map_dist_odkc")
