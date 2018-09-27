## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
collapse = TRUE,
comment = "#>",
eval=T
)
library(wastdr)
library(dplyr)
library(tidyr)
library(magrittr)
library(skimr)
library(leaflet)
library(lubridate)
library(listviewer)
library(DT)
library(ggplot2)
wastdr::wastdr_setup()
# wastdr::wastdr_settings()

## ----load_data, echo=T---------------------------------------------------
if (file.exists("tracks.Rda")){
    load("tracks.Rda")
} else {
    q = list(observer=4)
    track_records <- wastdr::wastd_GET("turtle-nest-encounters", query=q)
    tracks_all <- parse_turtle_nest_encounters(track_records)
    surveys <- wastd_GET("surveys", query=q) %>% parse_surveys()
    save(tracks_all, track_records, surveys, file = "tracks.Rda")
}

## ----filter_data---------------------------------------------------------
filter_2017 <- . %>% dplyr::filter(date > dmy("01/10/2017"), date < dmy("31/03/2018"))
filter_broome <- . %>% dplyr::filter(area_name=="Cable Beach Broome")
filter_broome_sites <- . %>% dplyr::filter(site_id %in% c(22, 23, 24))
filter_cbb1 <- . %>% dplyr::filter(site_name=="Cable Beach Broome Sector 1")
filter_cbb2 <- . %>% dplyr::filter(site_name=="Cable Beach Broome Sector 2")
filter_cbb3 <- . %>% dplyr::filter(site_name=="Cable Beach Broome Sector 3")
filter_eighty_mile_beach <- . %>% dplyr::filter(area_name=="Eighty Mile Beach Caravan Park")
filter_anna_plains <- . %>% dplyr::filter(area_name=="Anna Plains")
filter_port_hedland_sites <- . %>% dplyr::filter(site_id %in% c(35, 45))
filter_port_hedland_cemetery <- . %>% dplyr::filter(site_name=="Port Hedland Cemetery Beach")
filter_port_hedland_prettypool <- . %>% dplyr::filter(site_name=="Port Hedland Pretty Pool Beach")
filter_west_pilbara <- . %>% dplyr::filter(area_name=="West Pilbara Turtle Program beaches Wickam")
filter_delambre <- . %>% dplyr::filter(area_name=="Delambre Island")
filter_rosemary <- . %>% dplyr::filter(area_name=="Rosemary Island")
filter_thevenard <- . %>% dplyr::filter(area_name=="Thevenard Island")

tracks <- tracks_all %>% filter_2017

## ----data_wp_daily-------------------------------------------------------
species_by_type <- . %>% 
  filter(nest_age=="fresh") %>%
  group_by(species, nest_type) %>% 
  tally() %>%
  ungroup() %>% 
  tidyr::spread(nest_type, n, fill=0)

daily_species_by_type <- . %>% 
    filter(nest_age=="fresh") %>%
    group_by(date, species, nest_type) %>% 
    tally() %>%
    ungroup()

daily_summary <- . %>% 
    daily_species_by_type %>% 
    tidyr::spread(nest_type, n, fill=0) %>%
    DT::datatable(.)

tracks_ts <- . %>% 
    daily_species_by_type %>% 
    {ggplot2::ggplot(data=., aes(x = date, y = n, colour = nest_type)) + 
            ggplot2::geom_point() + 
            ggplot2::geom_smooth(method = "auto") +
            # ggplot2::geom_line() +
            ggplot2::scale_x_date(breaks = scales::pretty_breaks(),
                                  labels = scales::date_format("%d %b %Y")) +
            ggplot2::scale_y_continuous(limits = c(0, NA)) +
            ggplot2::xlab("Date") +
            ggplot2::ylab("Number counted per day") +
            ggplot2::ggtitle("Nesting activity") +
            ggplot2::theme_light()}

## ---- fig.width=9, fig.height=5, eval=T----------------------------------
tracks %>% add_nest_labels %>% map_tracks
tracks %>% tracks_ts

place <- "Example place"
surveys %>% plot_survey_count(place)
surveys %>% list_survey_count(place)
surveys %>% survey_hours_per_person %>% DT::datatable(.)

