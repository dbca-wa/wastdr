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
#' @param ts Whether to render the data as additional timeseries (warning: slow)
#' @return A leaflet map
#' @export
#' @family odkc
#' @examples
#' \dontrun{
#' data("odkc_data")
#' map_tracks_odkc(odkc_data$tracks, sites = odkc_data$sites, cluster = TRUE)
#' map_tracks_odkc(odkc_data$tracks, sites = odkc_data$sites, cluster = FALSE)
#' map_tracks_odkc(odkc_data$tracks, sites = NULL, cluster = TRUE)
#' map_tracks_odkc(odkc_data$tracks, sites = NULL, cluster = FALSE)
#' }
map_tracks_odkc <- function(tracks,
                            sites = NULL,
                            wastd_url = wastdr::get_wastd_url(),
                            fmt = "%d/%m/%Y %H:%M",
                            tz = "Australia/Perth",
                            cluster = FALSE,
                            ts = FALSE) {
  co <- if (cluster == TRUE) {
    leaflet::markerClusterOptions()
  } else {
    NULL
  }

  l <- leaflet::leaflet(width = 800, height = 600) %>%
    leaflet::addProviderTiles("Esri.WorldImagery", group = "Aerial") %>%
    leaflet::addProviderTiles("OpenStreetMap.Mapnik", group = "Place names") %>%
    leaflet::clearBounds(.) %>%
    {
      if (ts == TRUE) {
        leaftime::addTimeline(
          .,
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

  tracks <- tracks %>% wastdr::sf_as_tbl()
  tracks_df <- tracks %>% split(tracks$details_species)
  overlay_names <- names(tracks_df) %>% purrr::map_chr(humanize)
  if (ts == TRUE) {
    overlay_names <- c("Time series", overlay_names)
  }
  if (!is.null(sites)) {
    overlay_names <- c("Sites", overlay_names)
  }

  names(tracks_df) %>%
    purrr::walk(function(df) {
      l <<- l %>%
        leaflet::addAwesomeMarkers(
          data = tracks_df[[df]],
          lng = ~details_observed_at_longitude,
          lat = ~details_observed_at_latitude,
          icon = leaflet::makeAwesomeIcon(
            text = ~nest_type_text,
            markerColor = ~species_colours
          ),
          label = ~ glue::glue(
            "{lubridate::with_tz(observation_start_time, tz)}",
            " {humanize(details_nest_age)}",
            " {humanize(details_species)} {humanize(details_nest_type)}"
          ),
          popup = ~ glue::glue('
<h3>{humanize(details_nest_age)}
{humanize(details_species)}
{humanize(details_nest_type)}</h3>

<span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>
{lubridate::with_tz(observation_start_time, tz)} AWST</br>
<span class="glyphicon glyphicon-user" aria-hidden="true"></span> {reporter}
<br/>

<div id="crsl" class="carousel slide" style="height:150px;" data-ride="carousel">
  <!-- Indicators -->
  <ol class="carousel-indicators">
    <li data-target="#crsl" data-slide-to="0" class="active"></li>
    <li data-target="#crsl" data-slide-to="1"></li>
    <li data-target="#crsl" data-slide-to="2"></li>
    <li data-target="#crsl" data-slide-to="3"></li>
    <li data-target="#crsl" data-slide-to="4"></li>
    <li data-target="#crsl" data-slide-to="5"></li>
  </ol>

  <!-- Wrapper for slides -->
  <div class="carousel-inner" role="listbox">
    <div class="item active">
      <img height="150px;" src="{track_photos_photo_track_1}" alt="Photo uptrack">
      <div class="carousel-caption"><p>Uptrack</p></div>
    </div>
    <div class="item">
      <img height="150px;" src="{track_photos_photo_track_2}" alt="Photo downtrack">
      <div class="carousel-caption"><p>Downtrack</p></div>
    </div>

    <div class="item">
      <img height="150px;" src="{nest_photos_photo_nest_1}" alt="Photo nest">
      <div class="carousel-caption"><p>Nest photo 1</p></div>
    </div>
    <div class="item">
      <img height="150px;" src="{nest_photos_photo_nest_2}" alt="Photo nest 2">
      <div class="carousel-caption"><p>Nest photo 2</p></div>
    </div>
        <div class="item">
      <img height="150px;" src="{nest_photos_photo_nest_3}" alt="Photo nest 3">
      <div class="carousel-caption"><p>Nest photo 3</p></div>
    </div>
  </div>

  <!-- Controls -->
  <a class="left carousel-control" href="#crsl" role="button" data-slide="prev">
    <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
    <span class="sr-only">Previous</span>
  </a>
  <a class="right carousel-control" href="#crsl" role="button" data-slide="next">
    <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
    <span class="sr-only">Next</span>
  </a>
</div>
          '),
          group = humanize(df),
          clusterOptions = co
        )
    })

  l %>%
    {
      if (!is.null(sites) && nrow(sites) > 0) {
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

# usethis::use_test("map_tracks_odkc")
