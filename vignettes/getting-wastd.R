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
#                               query=list(taxon="Cheloniidae",
#                                          limit=300,
#                                          format="json"))
#  track_json <- get_wastd("turtle-nest-encounters",
#                               query=list(taxon="Cheloniidae",
#                                          limit=300,
#                                          format="json"))
#  nest_json <- get_wastd("turtle-nest-encounters",
#                               query=list(taxon="Cheloniidae",
#                                          limit=300,
#                                          format="json",
#                                          nest_type="hatched-nest"))

## ------------------------------------------------------------------------
tag_json <- data("tag_json")

## ------------------------------------------------------------------------
# listviewer::jsonedit(head(nest_json$content))

## ------------------------------------------------------------------------
#' Convert between url-safe dash-separated-names and Human Readable Title Case
humanize <- . %>% stringr::str_to_title() %>% stringr::str_replace("-", " ")
urlize <- . %>% stringr::str_to_lower() %>% stringr::str_replace(" ", "-")

#' O Lord of Darkness, accept this our functional sacrifice of three days and three nights
#' From a list of unnamed lists, or the data.frame equivalent, extract a field or -1
extract_possibly <- purrr::possibly(magrittr::extract, otherwise = -1)
get_f <- function(lol, field) lol %>% unlist %>% extract_possibly(field) %>% unlist %>% as.numeric

#' Filter a data.frame to records collected at THV after 19 Dec 2016
#' TODO replace with filtering for THV 2016/2017 field trips at API
thv_filter <- . %>% filter(
    latitude < -21.43,
    latitude > -21.48,
    longitude > 114.96,
    longitude < 115.05,
    date > dmy("17/11/2016"))

# nests <- nest_json$content %>% {
#   tibble::tibble(
#     datetime = map_chr(., c("properties", "when")) %>% utc_as_gmt08,
#     longitude = map_dbl(., c("properties", "longitude")),
#     latitude = map_dbl(., c("properties", "latitude")),
#     date = map_chr(., c("properties", "when")) %>% as_turtle_date,
#     species = map_chr(., c("properties", "species")),
#     obs = map(., c("properties", "observation_set")),
#     hatching_success = obs %>% map(get_f, "hatching_success") %>% as.numeric,
#     emergence_success = obs %>% map(get_f, "emergence_success") %>% as.numeric,
#     clutch_size = obs %>% map(get_f, "egg_count_calculated") %>% as.numeric
#     )
# } %>% thv_filter

## ---- echo=FALSE, results='asis'-----------------------------------------
knitr::kable(head(mtcars, 10))

