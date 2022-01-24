#' Map tagged Turtle Nests interactively.
#'
#' \lifecycle{maturing}
#'
#' @details Creates a Leaflet map with an interactive legend.
#' The maps auto-zooms to the extent of data given.
#'
#' @param data The output of \code{wastd_data$nest_tags}.
#' @template param-wastd_url
#' @template param-fmt
#' @template param-cluster
#' @return A leaflet map
#' @family wastd
#' @export
#' @examples
#' \dontrun{
#' data("wastd_data")
#' wastd_data$nest_tags %>% map_nests()
#' }
map_nests <- function(data,
                      wastd_url = wastdr::get_wastd_url(),
                      fmt = "%d/%m/%Y %H:%M",
                      cluster = FALSE) {
  co <- if (cluster == TRUE) leaflet::markerClusterOptions() else NULL
  pal <- leaflet::colorFactor(palette = "RdYlBu", domain = data$encounter_status)
  url <- sub("/$", "", wastd_url)

  l <- leaflet::leaflet(width = 800, height = 600) %>%
      leaflet::addProviderTiles("Esri.WorldImagery", group = "Basemap") %>%
      leaflet::addProviderTiles(
          "OpenStreetMap.Mapnik", group = "Basemap",
          options = leaflet::providerTileOptions(opacity = 0.35)) %>%
      leaflet.extras::addFullscreenControl(pseudoFullscreen = TRUE) %>%
      leaflet::clearBounds() %>%
    leaflet::addAwesomeMarkers(
      data = data,
      lng = ~encounter_longitude,
      lat = ~encounter_latitude,
      icon = leaflet::makeAwesomeIcon(
        icon = "tag",
        text = ~ toupper(substring(data$encounter_status, 1, 1)),
        markerColor = ~ pal(encounter_status)
      ),
      label = ~ glue::glue(
        "{datetime} {encounter_status} {flipper_tag_id} {date_nest_laid} {tag_label}"
      ),
      popup = ~ glue::glue('
<h3>{flipper_tag_id} {date_nest_laid} {tag_label}</h3>

<span class="glyphicon glyphicon-globe" aria-hidden="true"></span>
{encounter_area_name} - {encounter_site_name}</br>

<span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>
{datetime} AWST</br>

<span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span>
{encounter_observer_name}<br/>
<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
{encounter_reporter_name}<br/>

<span class="glyphicon glyphicon-wrench" aria-hidden="true"></span>
{humanize(encounter_status)}<br/>
<span class="glyphicon glyphicon-comment" aria-hidden="true"></span>
{encounter_comments} {comments}<br/>

Survey {encounter_survey_id} at {encounter_site_name}<br/>wa
{encounter_survey_start_time}-{encounter_survey_end_time} AWST</p>
<a href="{url}{encounter_survey_absolute_admin_url}"
class="btn btn-xs btn-secondary" target="_" rel="nofollow">
Edit survey in WAStD</a>

<p><a class="btn btn-xs btn-secondary" target="_" rel="nofollow"
href="{url}{encounter_absolute_admin_url}">Edit on WAStD</a></p>
      '),
      group = "Nests",
      clusterOptions = co
    ) %>%
    leaflet::addLayersControl(
      baseGroups = c("Basemap"),
      overlayGroups = c("Nests"),
      options = leaflet::layersControlOptions(collapsed = FALSE)
    )
  l
}

# usethis::use_test("map_nests")
