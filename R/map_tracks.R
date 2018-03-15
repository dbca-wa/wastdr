#' Map TurtleNestEncounters interactively.
#'
#' @details Creates a Leaflet map with an interactive legend offering to toggle each species
#' separately. The maps auto-zooms to the extent of data given.
#'
#'
#' @param tracks The output of \code{parse_turtle_nest_encounters} and \code{add_nest_labels}.
#' @return A leaflet map
#' @importFrom purrr walk
#' @importFrom leaflet leaflet addAwesomeMarkers addLayersControl addProviderTiles clearBounds
#' @export
map_tracks <- function(tracks) {
    l <- leaflet(width=800, height=600) %>%
        addProviderTiles("Esri.WorldImagery", group = "Aerial") %>%
        addProviderTiles("OpenStreetMap.Mapnik", group = "Place names") %>%
        clearBounds()

    tracks.df <-  tracks %>% split(tracks$species)

    names(tracks.df) %>%
        purrr::walk( function(df) {
            l <<- l %>%
                addAwesomeMarkers(
                    data = tracks.df[[df]],
                    lng = ~longitude, lat=~latitude,
                    icon = leaflet::makeAwesomeIcon(
                        text = ~nest_type_text,
                        markerColor = ~species_colours),
                    label=~paste(date, nest_age, species, nest_type, name),
                    popup=~paste(date, nest_age, species, nest_type, name),
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
