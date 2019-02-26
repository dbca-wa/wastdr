## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")
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
    q = list(observer=4, format = "json")
    track_records <- wastdr::wastd_GET("turtle-nest-encounters", query=q)
    tracks <- parse_turtle_nest_encounters(track_records)
    disturbance_records <- wastdr::wastd_GET("disturbance-observations", query=q)
    disturbance <- disturbance_records %>% wastdr::parse_disturbance_observations()
    survey_records <- wastdr::wastd_GET("surveys", query=list(reporter=4, format = "json"))
    surveys <- survey_records %>% parse_surveys()
    nest_records <- wastdr::wastd_GET("nesttag-observations", query=q)
    nests <- nest_records %>% wastdr::parse_nesttag_observations()
    save(
      track_records, 
      tracks, 
      survey_records, 
      surveys, 
      disturbance_records, 
      disturbance, 
      nest_records, 
      nests, 
      file = "tracks.Rda"
    )
}

## ----filter_data---------------------------------------------------------
tracks_2017 <- tracks %>% dplyr::filter(season==2017)

## ----tracks_maps---------------------------------------------------------
tracks %>% add_nest_labels() %>% map_tracks()
tracks %>% add_nest_labels() %>% map_tracks(cluster=T)

## ----tracks_ns-----------------------------------------------------------
tracks %>% nesting_type_by_season_species()
tracks %>% nesting_type_by_area_season_species()
tracks %>% nesting_type_by_site_season_species()
tracks %>% nesting_type_by_season_week_species()
tracks %>% nesting_type_by_season_day_species()

# Track success by day and species
tracks %>% track_success()

# Track success by species
tracks %>% track_success() %>% track_success_by_species()

tracks %>% track_success %>% 
  ggplot_track_success_by_date("natator-depressus", placename="Test place", prefix="TEST")

tracks %>% track_success %>% 
  ggplot_track_successrate_by_date("natator-depressus", placename="Test place", prefix="TEST")

## ----tracks_hses---------------------------------------------------------
tracks %>% hatching_emergence_success()
tracks %>% hatching_emergence_success_area()
tracks %>% hatching_emergence_success_site()

## ----taggee_nests--------------------------------------------------------
nests %>% map_nests()

## ----dist_nests----------------------------------------------------------
tracks %>% dplyr::filter(disturbance == "present") %>% add_nest_labels() %>% map_tracks()
tracks %>% dplyr::filter(disturbance == "present") %>% add_nest_labels() %>% map_tracks(cluster=T)

## ------------------------------------------------------------------------
disturbance %>% disturbance_by_season()
disturbance %>% map_dist()
disturbance %>% map_dist(cluster=T)

## ----surveys-------------------------------------------------------------
surveys %>% survey_count()
surveys %>% surveys_per_site_name_and_date()
surveys %>% survey_hours_per_site_name_and_date()
surveys %>% survey_hours_per_person()
surveys %>% list_survey_count()
surveys %>% plot_survey_count()
surveys %>% list_survey_effort()
surveys %>% plot_survey_effort()
surveys %>% survey_hours_heatmap(placename = "All the places", prefix = "TEST")
surveys %>% survey_count_heatmap(placename = "All the places", prefix = "TEST")
surveys %>% survey_season_stats()
surveys %>% survey_season_site_stats()
surveys %>% survey_show_detail() %>% DT::datatable(escape = F)

