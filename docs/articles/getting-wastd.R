## ------------------------------------------------------------------------
library(wastdr)
library(dplyr)
library(magrittr)
library(leaflet)
library(listviewer)
library(DT)
library(ggplot2)

## ----call_api, eval=FALSE------------------------------------------------
#  tne <- wastd_GET("turtle-nest-encounters")
#  listviewer::jsonedit(tne$content, width = 800, height = 600)
#  tracks <- parse_turtle_nest_encounters(tne)

## ---- eval=T-------------------------------------------------------------
data(animal_encounters)
data(tne)

## ----load_vignette_data, eval=FALSE--------------------------------------
#  load(file = "vignettes/data.rda")

## ----inspect_data--------------------------------------------------------
listviewer::jsonedit(animal_encounters$features, width = 800, height = 600)

animals <- parse_animal_encounters(animal_encounters)
nests <- parse_turtle_nest_encounters(tne)

DT::datatable(animals)
# DT::datatable(nests)

## ----surveys, fig.height=5, fig.width=10, eval=FALSE---------------------
#  surveys <- wastd_GET("surveys") %>% parse_surveys()
#  DT::datatable(head(surveys))

