## ------------------------------------------------------------------------
library(wastdr)
library(dplyr)
library(magrittr)
library(leaflet)
library(listviewer)
library(DT)
library(ggplot2)

## ----call_api, eval=FALSE------------------------------------------------
#  turtle_nest_encounters <- get_wastd('turtle-nest-encounters')
#  listviewer::jsonedit(turtle_nest_encounters$content, width = 800, height = 600)
#  tracks <- parse_turtle_nest_encounters(turtle_nest_encounters)

## ---- eval=T-------------------------------------------------------------
data(animal_encounters)
data(turtle_nest_encounters_hatched)
data(turtle_nest_encounters)

## ----load_vignette_data, eval=FALSE--------------------------------------
#  load(file = "vignettes/data.rda")

## ----inspect_data--------------------------------------------------------
listviewer::jsonedit(animal_encounters$features, width = 800, height = 600)
# listviewer::jsonedit(turtle_nest_encounters_hatched$content)
# listviewer::jsonedit(turtle_nest_encounters$content)

animals <- parse_animal_encounters(animal_encounters)
nests <- parse_turtle_nest_encounters(turtle_nest_encounters_hatched)
tracks <- parse_turtle_nest_encounters(turtle_nest_encounters)

DT::datatable(animals)
# DT::datatable(nests)
# DT::datatable(tracks)

