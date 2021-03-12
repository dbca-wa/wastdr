#' Map Marine Wildlife Incident 0.6
#'
#' \lifecycle{maturing}
#'
#' @details Creates a Leaflet map with an interactive legend offering to toggle
#' each species separately. The maps auto-zooms to the extent of data given.
#'
#' @param data AnimalEncounters from WAStD.
#' @param sites An sf object of sites with `site_name` and polygon geom, e.g.
#'  `wastdr::wastd_data$sites`.
#' @template param-wastd_url
#' @template param-fmt
#' @template param-tz
#' @template param-cluster
#' @return A leaflet map
#' @export
#' @family wastd
map_mwi <- function(data,
                    sites = NULL,
                    wastd_url = wastdr::get_wastd_url(),
                    fmt = "%d/%m/%Y %H:%M",
                    tz = "Australia/Perth",
                    cluster = FALSE) {
  co <- if (cluster == TRUE) leaflet::markerClusterOptions() else NULL
  overlay_names <- c()
  url <- sub("/$", "", wastd_url)

  l <- leaflet::leaflet(width = 800, height = 600) %>%
    leaflet::addProviderTiles("Esri.WorldImagery", group = "Aerial") %>%
    leaflet::addProviderTiles("OpenStreetMap.Mapnik", group = "Place names") %>%
    leaflet::clearBounds()


  if (!is.null(data) && nrow(data) > 0) {
    pal_mwi <- leaflet::colorFactor(palette = "viridis", domain = data$taxon)
    data.df <- data %>% split(data$taxon)
    overlay_names <- names(data.df)
    if (!is.null(sites)) overlay_names <- c("Sites", overlay_names)

    names(data.df) %>%
      purrr::walk(function(df) {
        l <<- l %>% leaflet::addAwesomeMarkers(
          data = data.df[[df]],
          lng = ~longitude,
          lat = ~latitude,
          icon = leaflet::makeAwesomeIcon(
            icon = "warning-sign",
            markerColor = "red",
            iconColor = ~ pal_mwi(taxon)
          ),
          label = ~ glue::glue("
             {lubridate::with_tz(datetime, tz)}
             {humanize(health)}
             {humanize(maturity)}
             {humanize(sex)}
             {humanize(species)}
          "),
          popup = ~ glue::glue('
<h3>{humanize(health)} {humanize(maturity)}
{humanize(sex)} {humanize(species)}</h3>

<span class="glyphicon glyphicon-globe" aria-hidden="true"></span>
{area_name} - {site_name}</br>

<span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>
{format(datetime, fmt)} AWST<br/>
<span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span>
{observer_name}<br/>
<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
{reporter_name}<br/>

<span class="glyphicon glyphicon-comment" aria-hidden="true"></span>
Cause of death: {humanize(cause_of_death)}<br/>
<span class="glyphicon glyphicon-comment" aria-hidden="true"></span>
Activity: {humanize(activity)}<br/>

<p><a class="btn btn-xs btn-secondary" target="_" rel="nofollow"
href="{url}{absolute_admin_url}">Edit on WAStD</a></p>
          '),
          group = df,
          clusterOptions = co
        )
      })
  }

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
      baseGroups = c("Aerial", "Place names"),
      overlayGroups = overlay_names,
      options = leaflet::layersControlOptions(collapsed = FALSE)
    )
}

# usethis::use_test("map_mwi")
