## ------------------------------------------------------------------------
library(wastdr)
library(dplyr)
library(magrittr)
library(leaflet)
library(listviewer)
library(DT)
library(ggplot2)

## ----call_api, eval=FALSE------------------------------------------------
#  tne <- wastd_GET('turtle-nest-encounters')
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
#  survey_res <- wastd_GET("surveys")
#  surveys <- survey_res %>% parse_surveys()
#  
#  surveys_pth <- surveys %>% dplyr::filter(site_id %in% c(35, 45))
#  
#  # survey_ts_plot <- . %>% dplyr::group_by(date, site_name) %>% dplyr::tally %>%
#  # ggplot(., aes(date, n, fill=site_name)) + ggplot2::geom_tile() + theme_minimal() + labs(title="Surveys", fill="Site", y="Number of surveys", x="Date")

