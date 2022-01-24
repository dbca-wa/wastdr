#' Map nest and general disturbance observations interactively.
#'
#' \lifecycle{maturing}
#'
#' @details Creates a Leaflet map with an interactive legend offering to toggle
#' each disturbance class separately.
#' The maps auto-zooms to the extent of data given.
#'
#' @param dist Turtle nest and general disturbance and predation, e.g.
#'   \code{\link{wastd_data}$nest_dist}. This data contains both dist/pred
#'   recorded against nests and general signs of disturbance or predation.
#' @template param-wastd_url
#' @template param-fmt
#' @template param-cluster
#' @return A leaflet map
#' @export
#' @family wastd
#' @examples
#' \dontrun{
#' data("wastd_data")
#' wastd_data$nest_dist %>% map_dist()
#' }
map_dist <- function(dist,
                     wastd_url = wastdr::get_wastd_url(),
                     fmt = "%d/%m/%Y %H:%M",
                     cluster = FALSE) {
  # ---------------------------------------------------------------------------#
  # Options
  #
  co <- if (cluster == TRUE) leaflet::markerClusterOptions() else NULL
  url <- sub("/$", "", wastd_url)
  pal_cause <- leaflet::colorFactor(
    palette = "viridis",
    domain = dist$disturbance_cause
  )
  pal_type <- leaflet::colorFactor(
    palette = "viridis",
    domain = dist$encounter_encounter_type
  )

  # ---------------------------------------------------------------------------#
  # Base map
  #
  l <- leaflet::leaflet(width = 800, height = 600) %>%
      leaflet::addProviderTiles("Esri.WorldImagery", group = "Basemap") %>%
      leaflet::addProviderTiles(
          "OpenStreetMap.Mapnik", group = "Basemap",
          options = leaflet::providerTileOptions(opacity = 0.35)) %>%
      leaflet.extras::addFullscreenControl(pseudoFullscreen = TRUE) %>%
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
          markerColor = ~ pal_type(encounter_encounter_type),
          iconColor = ~ pal_cause(disturbance_cause)
        ),
        label = ~ glue::glue("{datetime} {humanize(disturbance_cause)}"),
        popup = ~ glue::glue('
<h3>Signs of {humanize(disturbance_cause)}
({humanize(encounter_encounter_type)})</h3>

<span class="glyphicon glyphicon-globe" aria-hidden="true"></span>
{encounter_area_name} - {encounter_site_name}</br>

<span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>
{datetime} AWST</br>

<span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span>
{encounter_observer_name}<br/>
<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
{encounter_reporter_name}<br/>

<span class="glyphicon glyphicon-comment" aria-hidden="true"></span>
Confidence: {humanize(disturbance_cause_confidence)}.
{encounter_comments}<br/>

<p>Survey {encounter_survey_id} at {encounter_site_name}<br/>
{encounter_survey_start_time}-{encounter_survey_end_time}</p>
<a href="{url}{encounter_survey_absolute_admin_url}"
class="btn btn-xs btn-secondary" target="_" rel="nofollow">
Edit survey in WAStD</a>

<p><a class="btn btn-xs btn-secondary" target="_" rel="nofollow"
href="{url}{absolute_admin_url}">
Edit record in WAStD</a></p>
        '),
        group = df,
        clusterOptions = co
      )
    })

  l %>%
    leaflet::addLayersControl(
      baseGroups = c("Basemap"),
      overlayGroups = overlay_names,
      options = leaflet::layersControlOptions(collapsed = FALSE)
    )
}

# usethis::use_test("map_dist")
