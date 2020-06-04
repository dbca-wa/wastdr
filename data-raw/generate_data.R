library(wastdr)
library(sf)
sanitize_names <- . %>%
  dplyr::mutate_at(
    dplyr::vars(
      tidyr::contains("reporter"),
      tidyr::contains("observer")
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

# TODO generate odkc data
library(turtleviewer)
data(odkc, package = "turtleviewer")
odkc_data <- list(
  tracks = head(odkc$tracks),
  tracks_dist = head(odkc$tracks_dist),
  tracks_egg = head(odkc$tracks_egg),
  tracks_log = head(odkc$tracks_log),
  tracks_hatch = head(odkc$tracks_hatch),
  tracks_fan_outlier = head(odkc$tracks_fan_outlier),
  tracks_light = head(odkc$tracks_light),
  track_tally = head(odkc$track_tally),
  dist = head(odkc$dist),
  mwi = head(odkc$mwi),
  mwi_dmg = head(odkc$mwi_dmg),
  mwi_tag = head(odkc$mwi_tag),
  tsi = head(odkc$tsi),
  svs = head(odkc$svs),
  sve = head(odkc$sve),
  sites = odkc$sites,
  areas = odkc$areas,
  downloaded_on = odkc$downloaded_on
)
usethis::use_data(odkc_data, compress = "xz", overwrite = TRUE)

# WAStD Turtle Data, 10 records each, names sanitised
wastd_data <- download_wastd_turtledata(max_records = 100)
wastd_data$surveys <- wastd_data$surveys %>% sanitize_names()
wastd_data$animals <- wastd_data$animals %>% sanitize_names()
wastd_data$turtle_morph <- wastd_data$turtle_morph %>% sanitize_names()
wastd_data$tracks <- wastd_data$tracks %>% sanitize_names()
wastd_data$nest_dist <- wastd_data$nest_dist %>% sanitize_names()
wastd_data$nest_tags <- wastd_data$nest_tags %>% sanitize_names()
wastd_data$nest_excavations <- wastd_data$nest_excavations %>% sanitize_names()
wastd_data$hatchling_morph <- wastd_data$hatchling_morph %>% sanitize_names()
wastd_data$nest_fans <- wastd_data$nest_fans %>% sanitize_names()
wastd_data$nest_fan_outliers <- wastd_data$nest_fan_outliers %>% sanitize_names()
wastd_data$nest_lightsources <- wastd_data$nest_lightsources %>% sanitize_names()
usethis::use_data(wastd_data, compress = "xz", overwrite = TRUE)

# Generate TSC data
get_10 <- . %>%
  wastdr::wastd_GET(max_records = 10) %>%
  wastd_parse()
get_all <- . %>%
  wastdr::wastd_GET() %>%
  wastd_parse()

tsc_data <- list(
  # Taxonomy
  taxon = get_all("taxon"),
  taxon_fast = get_all("taxon-fast"),
  vernacular = get_all("vernacular"),
  crossreference = get_all("crossreference"),
  community = get_all("community"),

  # Conservation listings
  conservationlist = get_all("conservationlist"),
  taxon_conservationlisting = get_10("taxon-conservationlisting"),
  community_conservationlisting = get_10("community-conservationlisting"),

  # Occurrence
  occ_taxon_areas = get_10("occ-taxon-areas"),
  occ_taxon_points = get_10("occ-taxon-points"),
  occ_community_areas = get_10("occ-community-areas"),
  occ_taxon_points = get_10("occ-community-points"),
  occ_observation = get_10("occ-observation"),

  # Conservation documents
  document = get_10("document")
)
usethis::use_data(tsc_data, compress = "xz", overwrite = TRUE)
