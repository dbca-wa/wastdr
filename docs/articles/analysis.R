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
    track_records <- wastdr::get_wastd("turtle-nest-encounters")
    save_file <- Sys.getenv("WASTDR_SAVE_LOCALLY", unset = FALSE)
    if (save_file==TRUE){
        save(track_records, file = "~/track_records.Rda")
        load("~/track_records.Rda")
    }
    # listviewer::jsonedit(utils::head(track_records$features))
    tracks <- parse_turtle_nest_encounters(track_records)
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

filter_2017 <- . %>% dplyr::filter(date > dmy("17/11/2017")) %>% add_lookups
filter_broome <- . %>% dplyr::filter(area_name=="Cable Beach Broome")
filter_eighty_mile_beach <- . %>% dplyr::filter(area_name=="Eighty Mile Beach Caravan Park")
filter_anna_plains <- . %>% dplyr::filter(area_name=="Anna Plains")
filter_port_hedland <- . %>% dplyr::filter(site_name=="Port Hedland Turtle Nesting Beaches")
filter_west_pilbara <- . %>% dplyr::filter(area_name=="West Pilbara Turtle Program beaches Wickam")
filter_delambre <- . %>% dplyr::filter(area_name=="Delambre Island")
filter_rosemary <- . %>% dplyr::filter(area_name=="Rosemary Island")
filter_thevenard <- . %>% dplyr::filter(area_name=="Thevenard Island")

## ---- eval=T-------------------------------------------------------------
tracks_map <- function(track_data) {
    l <- leaflet(width=800, height=600) %>% 
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

## ---- fig.width=7, fig.height=5------------------------------------------
tracks_pth <- tracks %>% filter_2017 %>% filter_port_hedland
tracks_pth %>% tracks_map
tracks_pth %>% DT::datatable(.)
tracks_pth %>% daily_summary
tracks_pth %>% tracks_ts

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

