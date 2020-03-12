library(wastdr)

sanitize_names <- . %>%
  dplyr::mutate_at(
    dplyr::vars(
      tidyr::ends_with("reporter"),
      tidyr::contains("reporter_id"),
      tidyr::ends_with("observer"),
      tidyr::contains("observer_id")
    ),
    ~"Name hidden"
  )

# Generate animal_encounters ("observed" by author)
q <- list(taxon = "Cheloniidae", area_id = 17, observer = 4)
wastd_ae_raw <- wastd_GET("animal-encounters", query = q, max_records = 10)
wastd_ae <- parse_animal_encounters(wastd_ae_raw)
usethis::use_data(wastd_ae_raw, compress = "xz", overwrite = TRUE)
usethis::use_data(wastd_ae, compress = "xz", overwrite = TRUE)

# Generate tracks
q <- list(area_id = 17, observer = 4)
wastd_tne_raw <- wastdr::wastd_GET("turtle-nest-encounters", query = q, max_records = 10)
wastd_tne <- parse_turtle_nest_encounters(wastd_tne_raw) %>% add_nest_labels()
usethis::use_data(wastd_tne_raw, compress = "xz", overwrite = TRUE)
usethis::use_data(wastd_tne, compress = "xz", overwrite = TRUE)

# Area > tests parse_area, parse_area_sf, filter to sites
wastd_area_raw <- wastdr::wastd_GET("area")
usethis::use_data(wastd_area_raw, compress = "xz", overwrite = TRUE)

# Surveys > test parse_surveys
wastd_surveys_raw <- wastdr::wastd_GET(
  "surveys",
  query = list(reporter = 4), max_records = 10
)
usethis::use_data(wastd_surveys_raw, compress = "xz", overwrite = TRUE)

# TODO generate odkc data
library(turtleviewer)
data(turtledata, package = "turtleviewer")
odkc_data <- list(
  tracks = head(turtledata$tracks),
  tracks_dist = head(turtledata$tracks_dist),
  tracks_egg = head(turtledata$tracks_egg),
  tracks_log = head(turtledata$tracks_log),
  tracks_hatch = head(turtledata$tracks_hatch),
  tracks_fan_outlier = head(turtledata$tracks_fan_outlier),
  tracks_light = head(turtledata$tracks_light),
  track_tally = head(turtledata$track_tally),
  dist = head(turtledata$dist),
  mwi = head(turtledata$mwi),
  mwi_dmg = head(turtledata$mwi_dmg),
  mwi_tag = head(turtledata$mwi_tag),
  tsi = head(turtledata$tsi),
  svs = head(turtledata$svs),
  sve = head(turtledata$sve),
  sites = turtledata$sites,
  areas = turtledata$areas,
  downloaded_on = turtledata$downloaded_on
)
usethis::use_data(odkc_data, compress = "xz", overwrite = TRUE)

# WAStD Turtle Data, 10 records each, names sanitised
wastd_data <- download_wastd_turtledata(max_records = 10)
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

# Generate tcl
get_10 <- . %>% wastdr::wastd_GET(max_records = 10) %>% wastd_parse()
get_all <- . %>% wastdr::wastd_GET() %>% wastd_parse()

tsc_data <- list(
  # Taxonomy
  taxon = get_10("taxon"),
  taxon_fast = get_10("taxon-fast"),
  vernacular = get_10("vernacular"),
  crossreference = get_10("crossreference"),
  community = get_10("community"),

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
