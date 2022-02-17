#' Map TurtleNestEncounters interactively.
#'
#' \lifecycle{maturing}
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
#' @param ts Whether to render the data as additional timeseries (warning: slow)
#' @return A leaflet map
#' @export
#' @family wastd
#' @examples
#' \dontrun{
#' data("wastd_data")
#' map_tracks(wastd_data$tracks, sites = wastd_data$sites, cluster = T)
#' map_tracks(wastd_data$tracks, sites = wastd_data$sites, cluster = F)
#' }
map_tracks <- function(tracks,
                       sites = NULL,
                       wastd_url = wastdr::get_wastd_url(),
                       fmt = "%d/%m/%Y %H:%M",
                       cluster = FALSE,
                       ts = FALSE) {
  co <- if (cluster == TRUE) leaflet::markerClusterOptions() else NULL
  url <- sub("/$", "", wastd_url)

  if (!("name" %in% names(tracks))) tracks <- dplyr::mutate(tracks, name = "")

  l <- leaflet::leaflet(width = 800, height = 600) %>%
    leaflet::addProviderTiles("Esri.WorldImagery", group = "Basemap") %>%
    leaflet::addProviderTiles(
      "OpenStreetMap.Mapnik",
      group = "Basemap",
      options = leaflet::providerTileOptions(opacity = 0.35)
    ) %>%
    leaflet.extras::addFullscreenControl(pseudoFullscreen = TRUE) %>%
    leaflet::clearBounds() %>%
    {
      if (ts == TRUE) {
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
      } else {
        invisible(.)
      }
    }

  tracks.df <- tracks %>% split(tracks$species)
  overlay_names <- humanize(names(tracks.df))
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
          label = ~ glue::glue("
            {format(datetime, fmt)} {humanize(nest_age)}
            {humanize(species)} {humanize(nest_type)} {name}
          "),
          popup = ~ glue::glue('
<h3>{humanize(nest_age)} {humanize(species)}
{humanize(nest_type)} {name}</h3>

<span class="glyphicon glyphicon-globe" aria-hidden="true"></span>
{area_name} - {site_name}</br>

<span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>
{format(datetime, fmt)} AWST<br/>
<span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span>
{observer_name}<br/>
<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
{reporter_name}<br/>

<p>Survey {survey_id} at {site_name}
{format(httpdate_as_gmt08(survey_start_time), fmt)}-
{format(httpdate_as_gmt08(survey_end_time), fmt)} AWST</p>

<p><a class="btn btn-xs btn-secondary" target="_" rel="nofollow"
href="{url}{absolute_admin_url}">Edit on WAStD</a></p>
          '),
          group = humanize(df),
          clusterOptions = co
        )
    })

  l %>%
    {
      if (!is.null(sites)) {
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
      baseGroups = c("Basemap"),
      overlayGroups = overlay_names,
      options = leaflet::layersControlOptions(collapsed = FALSE)
    )
}

# usethis::use_test("map_tracks")
