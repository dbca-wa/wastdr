#' Map TurtleNestEncounters interactively.
#'
#' @details Creates a Leaflet map with an interactive legend offering to toggle each species
#' separately. The maps auto-zooms to the extent of data given.
#'
#' @param tracks The output of \code{parse_turtle_nest_encounters} and \code{add_nest_labels}.
#' @param fmt The desired date format, default: "d/m/Y H:M"
#' @return A leaflet map
#' @importFrom purrr walk
#' @importFrom glue glue
#' @importFrom leaflet leaflet addAwesomeMarkers addLayersControl addProviderTiles clearBounds
#' @export
map_tracks <- function(tracks,
                       fmt="%d/%m/%Y %H:%M") {
  . <- NULL
  wastd_url <- get_wastd_url()
  layersControlOptions <- NULL
  l <- leaflet(width = 800, height = 600) %>%
    addProviderTiles("Esri.WorldImagery", group = "Aerial") %>%
    addProviderTiles("OpenStreetMap.Mapnik", group = "Place names") %>%
    clearBounds()

  tracks.df <- tracks %>% split(tracks$species)

  names(tracks.df) %>%
    purrr::walk(function(df) {
      l <<- l %>%
        addAwesomeMarkers(
          data = tracks.df[[df]],
          lng = ~ longitude, lat = ~ latitude,
          icon = leaflet::makeAwesomeIcon(
            text = ~ nest_type_text,
            markerColor = ~ species_colours
          ),
          label = ~ glue::glue(
            '{format(datetime, "%d/%m/%Y %H:%M")} {humanize(nest_age)}',
            ' {humanize(species)} {humanize(nest_type)} {name}'
          ),
          popup = ~ glue::glue(
            '<h3>{humanize(nest_age)} {humanize(species)} {humanize(nest_type)} {name}</h3>',
            '<p>Seen on {format(datetime, fmt)} AWST by {observer}',
            '<p>Survey {survey_id} at {site_name} ',
            '{format(survey_start_time, fmt)}-{format(survey_end_time, fmt)} AWST</p>',
            '<p><a class="btn btn-xs btn-primary" target="_" rel="nofollow" ',
            'href="{wastd_url}{absolute_admin_url}">Edit on WAStD</a></p>'
          ),
          group = df
        )
    })

  l %>%
    addLayersControl(
      baseGroups = c("Aerial", "Place names"),
      overlayGroups = names(tracks.df),
      options = layersControlOptions(collapsed = FALSE)
    )
}
