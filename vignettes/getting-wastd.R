## ----setup, message=FALSE------------------------------------------------
require(dplyr)
require(lubridate)
require(stringr)
require(tidyverse)
require(magrittr)
require(listviewer)
require(leaflet)
library(wastdr)

## ------------------------------------------------------------------------
wastdr::wastdr_setup(api_token = "c12345asdfqwer")

## ------------------------------------------------------------------------
wastdr::wastdr_settings()

## ----call_api, eval=FALSE------------------------------------------------
#  turtle_nest_encounters <- get_wastd('turtle-nest-encounters')
#  listviewer::jsonedit(turtle_nest_encounters)
#  
#  tracks <- parse_turtle_nest_encounters(turtle_nest_encounters)

## ------------------------------------------------------------------------
require(wastdr)

data("animal_encounters")
data("turtle_nest_encounters_hatched")
data("turtle_nest_encounters")

listviewer::jsonedit(animal_encounters$content)
# listviewer::jsonedit(turtle_nest_encounters_hatched$content)
# listviewer::jsonedit(turtle_nest_encounters$content)

animals <- parse_animal_encounters(animal_encounters)
nests <- parse_turtle_nest_encounters(turtle_nest_encounters_hatched)
tracks <- parse_turtle_nest_encounters(turtle_nest_encounters)

DT::datatable(animals)
# DT::datatable(nests)
# DT::datatable(tracks)

## ------------------------------------------------------------------------
#' makeAwesomeIcon factory
mkicon <- function(ico, col) makeAwesomeIcon(icon = ico, markerColor = col)

trackIcons <- awesomeIconList(
  "cheloniidae-fam" = mkicon('align-center', 'black'),
  "chelonia-mydas" = mkicon('align-center', 'green'),
  "eretmochelys-imbricata" = mkicon('align-center', 'blue'),
  "natator-depressus" = mkicon('align-center', 'red'),
  "caretta-caretta" = mkicon('align-center', 'yellow')
  )

tagIcons <- awesomeIconList(
  "cheloniidae-fam" = mkicon('tag', 'black'),
  "chelonia-mydas" = mkicon('tag', 'green'),
  "eretmochelys-imbricata" = mkicon('tag', 'blue'),
  "natator-depressus" = mkicon('tag', 'red'),
  "caretta-caretta" = mkicon('tag', 'yellow')
  )

nestIcons <- awesomeIconList(
  "cheloniidae-fam" = mkicon('baby-formula', 'black'),
  "chelonia-mydas" = mkicon('baby-formula', 'green'),
  "eretmochelys-imbricata" = mkicon('baby-formula', 'blue'),
  "natator-depressus" = mkicon('baby-formula', 'red'),
  "caretta-caretta"  = mkicon('baby-formula', 'yellow')
  )

leaflet(tracks) %>%
  addProviderTiles("Esri.WorldImagery", group = "Aerial") %>%
  addProviderTiles("OpenStreetMap.Mapnik", group = "Place names") %>%
  setView(lng=115.0, lat=-21.45, zoom=12) %>%
  addAwesomeMarkers(~longitude, ~latitude,
                    data = filter(tracks, nest_type != "hatched-nest"),
                    icon = ~trackIcons[species],
                    label = ~paste("Track", date, nest_age, species, nest_type),
                    # popup = ~paste("Track", date, nest_age, species, nest_type),
                    group = "Tracks") %>%
  addAwesomeMarkers(~longitude, ~latitude, data = animals,
                    icon = ~tagIcons[species],
                    # label = ~paste("Tag", date, species, name, "nesting:", nesting),
                    # popup = ~paste("Tag", date, species, name, "nesting:", nesting),
                    group = "Tags") %>%
  # addHeatmap(data=tags, lng = ~longitude, lat = ~latitude,
  #            blur = 20, max = 1, radius = 15) %>%
  addAwesomeMarkers(~longitude, ~latitude,
                    data = nests,
                    icon = ~nestIcons[species],
                    label = ~paste("Nest", date, species,
                                   "HS", as.numeric(hatching_success),
                                   "%, ES", as.numeric(emergence_success), "%"),
                    popup = ~paste("Nest", date, species,
                                   "HS", as.numeric(hatching_success),
                                   "%, ES", as.numeric(emergence_success), "%"),
                    group = "Nests") %>%
  addLayersControl(baseGroups = c("Aerial", "Place names"),
                   overlayGroups = c("Tracks", "Tags", "Nests"))


