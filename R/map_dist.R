#' Map Disturbance observations interactively.
#'
#' @details Creates a Leaflet map with an interactive legend offering to toggle each disturbance class
#' separately. The maps auto-zooms to the extent of data given.
#'
#' @param dist The output of \code{wastdr::parse_disturbance_observations()}.
#' @param fmt The desired date format, default: "d/m/Y H:M"
#' @return A leaflet map
#' @importFrom purrr walk
#' @importFrom glue glue
#' @importFrom leaflet leaflet addAwesomeMarkers addLayersControl addProviderTiles clearBounds
#' @export
map_dist <- function(dist,
                     fmt = "%d/%m/%Y %H:%M") {
  . <- NULL
  wastd_url <- get_wastd_url()

  pal <- leaflet::colorFactor(
    palette = "viridis",
    domain = dist$disturbance_cause
  )

  layersControlOptions <- NULL
  l <- leaflet(width = 800, height = 600) %>%
    addProviderTiles("Esri.WorldImagery", group = "Aerial") %>%
    addProviderTiles("OpenStreetMap.Mapnik", group = "Place names") %>%
    clearBounds()

  dist.df <- dist %>% split(dist$disturbance_cause)

  names(dist.df) %>%
    purrr::walk(function(df) {
      l <<- l %>% addAwesomeMarkers(
        data = dist.df[[df]],
        lng = ~longitude, lat = ~latitude,
        icon = leaflet::makeAwesomeIcon(
          text = ~stringr::str_sub(disturbance_cause, 0, 1),
          markerColor = ~pal(disturbance_cause)
        ),
        label = ~glue::glue(
          "{format(datetime, fmt)} {humanize(disturbance_cause)}"
        ),
        popup = ~glue::glue(
          "<h3>{humanize(disturbance_cause)}</h3>",
          "<p>Seen on {format(datetime, fmt)} AWST by {observer}",
          "<p>Survey {survey_id} at {site_name} ",
          "{format(survey_start_time, fmt)}-{format(survey_end_time, fmt)} AWST</p>",
          '<p><a class="btn btn-xs btn-primary" target="_" rel="nofollow" ',
          'href="{wastd_url}{absolute_admin_url}">Edit on WAStD</a></p>'
        ),

        group = df
      )
    })

  l %>%
    addLayersControl(
      baseGroups = c("Aerial", "Place names"),
      overlayGroups = names(dist.df),
      options = layersControlOptions(collapsed = FALSE)
    )
}
