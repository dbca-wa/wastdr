## ----setup---------------------------------------------------------------
require(dplyr)
require(lubridate)
require(stringr)
require(tidyverse)
require(magrittr)
require(listviewer)
library(wastdr)
wastdr::wastdr_setup(api_token = "c12345asdfqwer")

## ----review_settings-----------------------------------------------------
wastdr::wastdr_settings()

## ----call_api, eval=FALSE------------------------------------------------
#  tag_json <- get_wastd("animal-encounters",
#                        query=list(taxon="Cheloniidae",
#                                   limit=300,
#                                   format="json"))
#  listviewer::jsonedit(head(tag_json$content))
#  tags <- tag_json %>% parse_animal_encounters
#  # devtools::use_data(tags, overwrite=T)
#  
#  track_json <- get_wastd("turtle-nest-encounters",
#                          query=list(taxon="Cheloniidae",
#                                     limit=300,
#                                     format="json"))
#  tracks <- nest_json %>% parse_turtle_nest_encounters
#  listviewer::jsonedit(head(track_json$content))
#  # devtools::use_data(tracks, overwrite=T)
#  
#  nest_json <- get_wastd("turtle-nest-encounters",
#                         query=list(taxon="Cheloniidae",
#                                    limit=300,
#                                    format="json",
#                                    nest_type="hatched-nest"))
#  nests <- nest_json %>% parse_turtle_nest_encounters
#  listviewer::jsonedit(head(nest_json$content))
#  # devtools::use_data(nests, overwrite=T)

## ------------------------------------------------------------------------
data("tags")
data("tracks")
data("nests")

## ---- eval=F-------------------------------------------------------------
#  #' Filter a data.frame to records collected at THV after 19 Dec 2016
#  #' TODO replace with filtering for THV 2016/2017 field trips at API
#  #' with query parameter `expedition=1`.
#  thv_filter <- . %>% filter(
#      latitude < -21.43,
#      latitude > -21.48,
#      longitude > 114.96,
#      longitude < 115.05,
#      date > dmy("17/11/2016"))
#  
#  tracks <- tracks %>% thv_filter
#  
#  nests <- nest_json %>% parse_turtle_nest_encounters %>% thv_filter
#  
#  

## ---- echo=FALSE, results='asis'-----------------------------------------
knitr::kable(head(mtcars, 10))

