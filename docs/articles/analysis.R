## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
collapse = TRUE,
comment = "#>"
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
if (file.exists("~/tracks.Rda")){
    load("~/tracks.Rda")
} else {
    track_records <- wastdr::wastd_GET("turtle-nest-encounters")
    save_file <- Sys.getenv("WASTDR_SAVE_LOCALLY", unset = FALSE)
    if (save_file==TRUE){
        save(track_records, file = "~/track_records.Rda")
        load("~/track_records.Rda")
    }
    # listviewer::jsonedit(utils::head(track_records$features))
    tracks <- wastdr::parse_turtle_nest_encounters(track_records)
    if (save_file == TRUE){
        save(tracks, file = "~/tracks.Rda")
    }
}

## ----filter_data---------------------------------------------------------
species_colours <- tibble::tibble(
    species = c(
    "cheloniidae-fam",
    "chelonia-mydas",
    "eretmochelys-imbricata",
    "natator-depressus",
    "corolla-corolla",
    "lepidochelys-olivacea",
    "caretta-caretta"    
    ),
    species_colours = c(
    "gray",
    "green",
    "darkblue",
    "beige",
    "pink",
    "darkgreen",
    "orange"
    )
)

nest_type_text <- tibble::tibble(
    nest_type = c(
        "hatched-nest", 
        "successful-crawl",
        "track-not-assessed",
        "track-unsure",
        "nest",
        "false-crawl"),
    nest_type_text = c(
        "NH", 
        "N",
        "T+?",
        "N?",
        "N",
        "T")
)


add_lookups <- . %>% 
    left_join(species_colours, by="species") %>%
    left_join(nest_type_text, by="nest_type")

filter_2017 <- . %>% dplyr::filter(date > dmy("01/10/2017"), date < dmy("31/03/2018"))
filter_broome <- . %>% dplyr::filter(area_name=="Cable Beach Broome")
filter_cbb1 <- . %>% dplyr::filter(site_name=="Cable Beach Broome Sector 1")
filter_cbb2 <- . %>% dplyr::filter(site_name=="Cable Beach Broome Sector 2")
filter_cbb3 <- . %>% dplyr::filter(site_name=="Cable Beach Broome Sector 3")

filter_eighty_mile_beach <- . %>% dplyr::filter(area_name=="Eighty Mile Beach Caravan Park")
filter_anna_plains <- . %>% dplyr::filter(area_name=="Anna Plains")
filter_port_hedland_cemetery <- . %>% dplyr::filter(site_name=="Port Hedland Cemetery Beach")
filter_port_hedland_prettypool <- . %>% dplyr::filter(site_name=="Port Hedland Pretty Pool Beach")
filter_west_pilbara <- . %>% dplyr::filter(area_name=="West Pilbara Turtle Program beaches Wickam")
filter_delambre <- . %>% dplyr::filter(area_name=="Delambre Island")
filter_rosemary <- . %>% dplyr::filter(area_name=="Rosemary Island")
filter_thevenard <- . %>% dplyr::filter(area_name=="Thevenard Island")

## ---- eval=T-------------------------------------------------------------
tracks_map <- function(track_data) {
    l <- leaflet(width=1000, height=800) %>% 
        addProviderTiles("Esri.WorldImagery", group = "Aerial") %>%
        addProviderTiles("OpenStreetMap.Mapnik", group = "Place names") %>%
        clearBounds()

    tracks.df <-  track_data %>% split(track_data$species)
    
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

## ---- fig.width=7, fig.height=5------------------------------------------
tracks %>% filter_2017 %>% tracks_map

## ---- fig.width=7, fig.height=5------------------------------------------
tracks_cbb <- tracks %>% filter_2017 %>% filter_broome
tracks_cbb %>% tracks_map
tracks_cbb %>% DT::datatable(.)
tracks_cbb %>% daily_summary
tracks_cbb %>% tracks_ts

named_nests_cbb <- tracks_cbb %>% filter(!(is.na(name)))
named_nests_cbb %>% tracks_map
named_nests_cbb %>% DT::datatable(.)

## ---- fig.width=7, fig.height=5------------------------------------------
tracks_ap <- tracks %>% filter_2017 %>% filter_anna_plains
tracks_ap %>% tracks_map
tracks_ap %>% DT::datatable(.)
tracks_ap %>% daily_summary
tracks_ap %>% tracks_ts

## ---- fig.width=7, fig.height=5------------------------------------------
tracks_emb <- tracks %>% filter_2017 %>% filter_eighty_mile_beach
tracks_emb %>% tracks_map
tracks_emb %>% DT::datatable(.)
tracks_emb %>% daily_summary
tracks_emb %>% tracks_ts

## ---- fig.width=9, fig.height=5------------------------------------------
tracks_pth_cem <- tracks %>% filter_2017 %>% filter_port_hedland_cemetery
tracks_pth_ppo <- tracks %>% filter_2017 %>% filter_port_hedland_prettypool


tracks_pth_cem %>% tracks_map
tracks_pth_cem %>% DT::datatable(.)
tracks_pth_cem %>% daily_summary
tracks_pth_cem %>% tracks_ts %T>% ggsave(filename="~/pth_daily_tracks_cem.png", device="png", width=9, height=5)


tracks_pth_ppo %>% tracks_map
tracks_pth_ppo %>% DT::datatable(.)
tracks_pth_ppo %>% daily_summary
tracks_pth_ppo %>% tracks_ts %T>% ggsave(filename="~/pth_daily_tracks_ppo.png", device="png", width=9, height=5)


# named_nests_pth <- tracks_pth %>% filter(!(is.na(name)))
# named_nests_pth %>% tracks_map
# named_nests_pth %>% DT::datatable(.)

## ---- fig.width=7, fig.height=5------------------------------------------
tracks_wp <- tracks %>% filter_2017 %>% filter_west_pilbara
tracks_wp %>% tracks_map
tracks_wp %>% DT::datatable(.)
tracks_wp %>% daily_summary
tracks_wp %>% tracks_ts

## ---- fig.width=7, fig.height=5------------------------------------------
tracks_de <- tracks %>% filter_2017 %>% filter_delambre
tracks_de %>% tracks_map
tracks_de %>% DT::datatable(.)
tracks_de %>% daily_summary
tracks_de %>% tracks_ts

## ---- fig.width=7, fig.height=5, eval=F----------------------------------
#  tracks_ri <- tracks %>% filter_2017 %>% filter_rosemary
#  tracks_ri %>% tracks_map
#  tracks_ri %>% DT::datatable(.)
#  tracks_ri %>% daily_summary
#  tracks_ri %>% tracks_ts

## ---- fig.width=7, fig.height=5------------------------------------------
tracks_thv <- tracks %>% filter_2017 %>% filter_thevenard
tracks_thv %>% tracks_map
tracks_thv %>% DT::datatable(.)
tracks_thv %>% daily_summary
tracks_thv %>% tracks_ts

