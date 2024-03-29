library(wastdr)
library(sf)

# We don't include W2 data in the package to protect its sensitive and PII data
# w2 <- download_w2_data()
# saveRDS(w2, file = here::here("data-raw/w2.rds"), compress="xz")
# w2 <- readRDS(here::here("data-raw/w2.rds"))

sanitize_names <- . %>%
  dplyr::mutate_at(
    dplyr::vars(
      tidyr::contains(
        c(
          "reporter",
          "observer",
          "handler",
          "recorder",
          "system_submitter_name",
          "encounter_handler",
          "ft1_ft1_handled_by",
          "ft2_ft2_handled_by",
          "ft3_ft3_handled_by",
          "morphometrics_morphometrics_handled_by",
          "tag_handled_by"
        )
      ),
    ),
    ~"Name hidden"
  )

# Generate animal_encounters ("observed" by author)
q <- list(taxon = "Cheloniidae", area_id = 17, observer = 4)
wastd_ae_raw <- wastd_GET("animal-encounters", query = q, max_records = 100)
wastd_ae <- parse_animal_encounters(wastd_ae_raw)
usethis::use_data(wastd_ae_raw, compress = "xz", overwrite = TRUE)
usethis::use_data(wastd_ae, compress = "xz", overwrite = TRUE)

# Generate tracks
q <- list(area_id = 17, observer = 4)
wastd_tne_raw <- wastdr::wastd_GET("turtle-nest-encounters", query = q, max_records = 100)
wastd_tne <- parse_turtle_nest_encounters(wastd_tne_raw)
usethis::use_data(wastd_tne_raw, compress = "xz", overwrite = TRUE)
usethis::use_data(wastd_tne, compress = "xz", overwrite = TRUE)

# Area > tests parse_area, parse_area_sf, filter to sites
wastd_area_raw <- wastdr::wastd_GET("area")
usethis::use_data(wastd_area_raw, compress = "xz", overwrite = TRUE)

# Surveys > test parse_surveys
q2 <- list(reporter = 4)
wastd_surveys_raw <- wastdr::wastd_GET("surveys", query = q2, max_records = 10)
usethis::use_data(wastd_surveys_raw, compress = "xz", overwrite = TRUE)

# ODKC data
odkc_data <- wastdr::download_odkc_turtledata_2020(download = FALSE, verbose = FALSE)
# x <- odkc_data %>% wastdr::filter_odkc_turtledata(area_name = "Perth Metro")
odkc_data$tracks <- odkc_data$tracks %>%
  dplyr::filter(!is.na(area_name)) %>%
  head(n = 100) %>%
  sanitize_names()
odkc_data$tracks_dist <- odkc_data$tracks_dist %>%
  dplyr::filter(!is.na(area_name)) %>%
  head(n = 100) %>%
  sanitize_names()
odkc_data$tracks_log <- odkc_data$tracks_log %>%
  dplyr::filter(!is.na(area_name)) %>%
  head(n = 100) %>%
  sanitize_names()
odkc_data$tracks_egg <- odkc_data$tracks_egg %>%
  dplyr::filter(!is.na(area_name)) %>%
  head(n = 100) %>%
  sanitize_names()
odkc_data$tracks_hatch <- odkc_data$tracks_hatch %>%
  dplyr::filter(!is.na(area_name)) %>%
  head(n = 100) %>%
  sanitize_names()
odkc_data$tracks_fan_outlier <- odkc_data$tracks_fan_outlier %>%
  dplyr::filter(!is.na(area_name)) %>%
  head(n = 100) %>%
  sanitize_names()
odkc_data$track_tally <- odkc_data$track_tally %>%
  dplyr::filter(!is.na(area_name)) %>%
  head(n = 100) %>%
  sanitize_names()
odkc_data$dist <- odkc_data$dist %>%
  dplyr::filter(!is.na(area_name)) %>%
  head(n = 100) %>%
  sanitize_names()
odkc_data$mwi <- odkc_data$mwi %>%
  dplyr::filter(!is.na(area_name)) %>%
  head(n = 100) %>%
  sanitize_names()
odkc_data$mwi_dmg <- odkc_data$mwi_dmg %>%
  dplyr::filter(!is.na(area_name)) %>%
  head(n = 100) %>%
  sanitize_names()
odkc_data$mwi_tag <- odkc_data$mwi_tag %>%
  dplyr::filter(!is.na(area_name)) %>%
  head(n = 100) %>%
  sanitize_names()
odkc_data$tsi <- odkc_data$tsi %>%
  dplyr::filter(!is.na(area_name)) %>%
  head(n = 100) %>%
  sanitize_names()
odkc_data$svs <- odkc_data$svs %>%
  dplyr::filter(!is.na(area_name)) %>%
  head(n = 100) %>%
  sanitize_names()
odkc_data$sve <- odkc_data$sve %>%
  dplyr::filter(!is.na(area_name)) %>%
  head(n = 100) %>%
  sanitize_names()
odkc_data$tt <- odkc_data$tt %>%
  dplyr::filter(!is.na(area_name)) %>%
  head(n = 100) %>%
  sanitize_names()
odkc_data$tt_tag <- odkc_data$tt_tag %>%
  head(n = 100) %>%
  sanitize_names()
odkc_data$tt_log <- odkc_data$tt_log %>%
  head(n = 100) %>%
  sanitize_names()
odkc_data$tt_dmg <- odkc_data$tt_dmg %>%
  head(n = 100) %>%
  sanitize_names()

usethis::use_data(odkc_data, compress = "xz", overwrite = TRUE)

# WAStD Turtle Data, 10 records each, names sanitised
wastd_data <- download_wastd_turtledata(max_records = 1000, min_year = 2021)
wastd_data$surveys <- wastd_data$surveys %>% sanitize_names()
wastd_data$survey_media <- wastd_data$survey_media %>% sanitize_names()
wastd_data$animals <- wastd_data$animals %>% sanitize_names()
wastd_data$animals$location_accuracy_m <- 10L # avoid NULL being dropped
wastd_data$animals$comments <- "Placeholder comment" # avoid NULL being dropped
wastd_data$turtle_morph <- wastd_data$turtle_morph %>% sanitize_names()
wastd_data$turtle_tags <- wastd_data$turtle_tags %>% sanitize_names()
wastd_data$turtle_dmg <- wastd_data$turtle_dmg %>% sanitize_names()
wastd_data$tracks <- wastd_data$tracks %>% sanitize_names()
wastd_data$nest_dist <- wastd_data$nest_dist %>% sanitize_names()
wastd_data$nest_tags <- wastd_data$nest_tags %>% sanitize_names()
wastd_data$nest_excavations <- wastd_data$nest_excavations %>% sanitize_names()
wastd_data$hatchling_morph <- wastd_data$hatchling_morph %>% sanitize_names()
wastd_data$nest_fans <- wastd_data$nest_fans %>% sanitize_names()
wastd_data$nest_fan_outliers <- wastd_data$nest_fan_outliers %>% sanitize_names()
wastd_data$nest_lightsources <- wastd_data$nest_lightsources %>% sanitize_names()
wastd_data$linetx <- wastd_data$linetx %>% sanitize_names()
wastd_data$track_tally <- wastd_data$track_tally %>% sanitize_names()
wastd_data$disturbance_tally <- wastd_data$disturbance_tally %>% sanitize_names()
usethis::use_data(wastd_data, compress = "xz", overwrite = TRUE)

# # Generate data
# get_10 <- . %>%
#   wastdr::wastd_GET(max_records = 10) %>%
#   wastd_parse()
# get_all <- . %>%
#   wastdr::wastd_GET() %>%
#   wastd_parse()
#
# tsc_data <- list(
#   # Taxonomy
#   taxon = get_all("taxon"),
#   taxon_fast = get_all("taxon-fast"),
#   vernacular = get_all("vernacular"),
#   crossreference = get_all("crossreference"),
#   community = get_all("community"),
#
#   # Conservation listings
#   conservationlist = get_all("conservationlist"),
#   taxon_conservationlisting = get_10("taxon-conservationlisting"),
#   community_conservationlisting = get_10("community-conservationlisting"),
#
#   # Occurrence
#   occ_taxon_areas = get_10("occ-taxon-areas"),
#   occ_taxon_points = get_10("occ-taxon-points"),
#   occ_community_areas = get_10("occ-community-areas"),
#   occ_taxon_points = get_10("occ-community-points"),
#   occ_observation = get_10("occ-observation"),
#
#   # Conservation documents
#   document = get_10("document")
# )
# usethis::use_data(tsc_data, compress = "xz", overwrite = TRUE)
