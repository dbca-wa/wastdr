#' Map tagged Turtle Nests interactively.
#'
#' @details Creates a Leaflet map with an interactive legend.
#' The maps auto-zooms to the extent of data given.
#'
#' @param data The output of \code{parse_nesttag_observations}.
#' @param fmt The desired date format, default: "d/m/Y H:M"
#' @return A leaflet map
#' @importFrom purrr walk
#' @importFrom glue glue
#' @importFrom leaflet leaflet addAwesomeMarkers addLayersControl addProviderTiles clearBounds
#' @export
map_nests <- function(data,
                      fmt = "%d/%m/%Y %H:%M") {
  . <- NULL
  layersControlOptions <- NULL
  wastd_url <- get_wastd_url()
  pal <- leaflet::colorFactor(palette = "RdYlBu", domain = data$tag_status)

  l <- leaflet::leaflet(width = 800, height = 600) %>%
    leaflet::addProviderTiles("Esri.WorldImagery", group = "Aerial") %>%
    leaflet::addProviderTiles("OpenStreetMap.Mapnik", group = "Place names") %>%
    leaflet::clearBounds() %>%
    leaflet::addAwesomeMarkers(
      data = data,
      lng = ~ longitude, lat = ~ latitude,
      icon = leaflet::makeAwesomeIcon(
        icon = "tag",
        text = ~ tag_label,
        markerColor = ~ pal(tag_status)
      ),
      label = ~ glue::glue(
        '{format(datetime, "%d/%m/%Y %H:%M")} {tag_status} ',
        "{flipper_tag_id} {date_nest_laid} {tag_label}"
      ),
      popup = ~ glue::glue(
        "<h3>{flipper_tag_id} {date_nest_laid} {tag_label}</h3>",
        "<p>{humanize(tag_status)} on {format(datetime, fmt)} AWST by {observer}",
        "<p>Survey {survey_id} at {site_name} ",
        "{format(survey_start_time, fmt)}-{format(survey_end_time, fmt)} AWST</p>",
        '<p><a class="btn btn-xs btn-primary" target="_" rel="nofollow" ',
        'href="{wastd_url}{absolute_admin_url}">Edit on WAStD</a></p>'
      ),
      group = "Nests"
    ) %>%
    leaflet::addLayersControl(
      baseGroups = c("Aerial", "Place names"),
      overlayGroups = c("Nests"),
      options = leaflet::layersControlOptions(collapsed = FALSE)
    )
  l
}
