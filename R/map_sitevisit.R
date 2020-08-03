#' Map Site Visit Start and End from ODK Central data over WAStD Sites.
#'
#' \lifecycle{maturing}
#'
#' @details Creates a Leaflet map of site visit start and end points.
#' The maps auto-zooms to the extent of data given.
#'
#' @param svs The output of `turtleviewer::turtledata$svs` - data from ODK form
#'   `Site Visit Start 0.3`.
#' @param sve The output of `turtleviewer::turtledata$sve` - data from ODK form
#'   `Site Visit End 0.2`.
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
#' map_sv_odkc(odkc_data$svs, odkc_data$sve, sites = odkc_data$sites)
#' }
map_sv_odkc <- function(svs,
                        sve,
                        sites,
                        wastd_url = wastdr::get_wastd_url(),
                        fmt = "%d/%m/%Y %H:%M",
                        tz = "Australia/Perth",
                        cluster = FALSE) {
  co <- if (cluster == TRUE) leaflet::markerClusterOptions() else NULL

  l <- leaflet::leaflet(width = 800, height = 600) %>%
    leaflet::addProviderTiles("Esri.WorldImagery", group = "Aerial") %>%
    leaflet::addProviderTiles("OpenStreetMap.Mapnik", group = "Place names") %>%
    leaflet::clearBounds() %>%
    # Site Visit Start
    leaflet::addAwesomeMarkers(
      data = svs,
      lng = ~site_visit_location_longitude,
      lat = ~site_visit_location_latitude,
      icon = leaflet::makeAwesomeIcon(
        text = "SVS",
        markerColor = "green",
        iconColor = "white"
      ),
      label = ~ glue::glue(
        "{calendar_date_awst} ",
        " Start {reporter} {site_name}"
      ),
      popup = ~ glue::glue('
<h3>Site Visit Start</h3>

<span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>
{lubridate::with_tz(survey_start_time, tz)} AWST</br>

<span class="glyphicon glyphicon-user" aria-hidden="true"></span>
{humanize(reporter)} with {humanize(site_visit_team)}
(Device ID {device_id})<br/>

<span class="glyphicon glyphicon-comment" aria-hidden="true"></span>
{site_visit_comments}<br/>

<img class="d-block w-100" alt="Photo" src="{site_visit_site_conditions %||% ""}"></img>
    '),

      group = "Site Visit Start",
      clusterOptions = co
    ) %>%
    # Site Visit End
    leaflet::addAwesomeMarkers(
      data = sve,
      lng = ~site_visit_location_longitude,
      lat = ~site_visit_location_latitude,
      icon = leaflet::makeAwesomeIcon(
        text = "SVE",
        markerColor = "red",
        iconColor = "white"
      ),
      label = ~ glue::glue(
        "{calendar_date_awst} ",
        " End {reporter} {site_name}"
      ),
      popup = ~ glue::glue('
<h3>Site Visit End</h3>

<span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>
{lubridate::with_tz(survey_end_time, tz)} AWST</br>

<span class="glyphicon glyphicon-user" aria-hidden="true"></span>
{humanize(reporter)} (Device ID {device_id})<br/>

<span class="glyphicon glyphicon-comment" aria-hidden="true"></span>
{site_visit_comments}<br/>

<img class="d-block w-100" alt="Photo" src="{site_visit_site_conditions %||% ""}"></img>
      '),
      group = "Site Visit End",
      clusterOptions = co
    ) %>%
    # Sites
    leaflet::addPolygons(
      data = sites,
      group = "Sites",
      weight = 1,
      fillOpacity = 0.5,
      fillColor = "blue",
      label = ~site_name
    ) %>%
    leaflet::addLayersControl(
      baseGroups = c("Aerial", "Place names"),
      overlayGroups = c("Site Visit Start", "Site Visit End"),
      options = leaflet::layersControlOptions(collapsed = FALSE)
    )
  l
}

# usethis::use_test("map_sv_odkc")
