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
#' @template param-tz
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
                     tz = "Australia/Perth",
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
  l <- leaflet_basemap()

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
<h3>Signs of {humanize(disturbance_cause)} ({humanize(encounter_encounter_type)})
</h3>

<span class="glyphicon glyphicon-globe" aria-hidden="true"></span>
{encounter_area_name} - {encounter_site_name}<br/>

<span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>
{lubridate::with_tz(datetime, tz)} AWST<br/>

<span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span>
{encounter_observer_name}<br/>
<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
{encounter_reporter_name}<br/>

<a href="{url}{encounter_survey_absolute_admin_url}"
target="_" rel="nofollow" title="Edit Survey in WAStD">
<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
Survey {encounter_survey_id}</a>
{format(httpdate_as_gmt08(encounter_survey_start_time), fmt)} -
{format(httpdate_as_gmt08(encounter_survey_end_time), fmt)}
<br/>

<span class="glyphicon glyphicon-comment" aria-hidden="true"></span>
{encounter_comments}<br/>

<a target="_" rel="nofollow" href="{url}{absolute_admin_url}">
<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
Edit in WAStD</a><br/>'),
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
