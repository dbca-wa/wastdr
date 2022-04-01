#' Summarise WAStD data per day and site
#'
#' @template param-wastd-data
#' @return A tibble, grouped and ordered by area, site, and date, with counts of
#'   surveys, tracks (by nest type), nest and general disturbances, live
#'   sightings and mortalities.
#'   The columns returned are:
#'
#'   Grouping variables
#'   * `area_name` The WAStD locality, e.g. Thevenard Island. This is only
#'     useful if the summary combines several localities.
#'   * `site_name` The WAStD site, e.g. a nesting beach. This is useful to
#'     filter an interactive table to one site.
#'   * `calendar_date_awst`	The calendar date (NOT the "turtle date"). This one
#'     should be kind of self-explanatory.
#'
#'   Tally variables
#'   * `no_surveys`	The number of "production" surveys on that site and date.
#'      In almost all cases, there will be no more than one production survey
#'      for any given site and date. Two and more indicate a need to QA and
#'      merge these potential duplicate surveys in WAStD.
#'   * `body_pit` The number of body pits found.
#'   * `false_crawl` The number of "tracks without nest". These are confirmed
#'     "no nest" tracks. The total
#'     number of "tracks without nest" can be higher, in that some might have
#'     been missed by the observer, and others might have been ambiguous
#'     (track unsure) or not closer inspected (track not assessed).
#'   * `hatched_nest` The number of freshly hatched nests. These could have been
#'     recorded as "track with nest" after the initial laying night.
#'   * `nest` The number of incubating nests, neither freshly made
#'     (successful crawl), nor hatched (hatched nest). The only reason to record
#'     these is to record a resighting of a nest tag marking that nest.
#'   * `successful_crawl` The number of confirmed "tracks with nest". The total
#'     number of successfully made nests can be higher, in that some might have
#'     been missed by the observer, and others might have been ambiguous
#'     (track unsure) or not closer inspected (track not assessed).
#'   * `track_not_assessed` Tracks which have not been further assessed for
#'     the presence of a nest. This can happen when tracks are convoluted,
#'     covered, vanish in the dunes, or when the observer is under time
#'     pressure.
#'   * `track_unsure` Tracks where the observer is not sure whether a nest
#'     exists or not. Some of these records come with photos, and some of those
#'     with photos can be reasonably determined by an experienced QA operator.
#'     There will always remain a number of "track, assessed for nest, unsure if
#'     nest" records, and it is up to the analyst how to determine their nesting
#'     success, i.e. whether to count those as nest or not.
#'   * `disturbed_nests` The total number of disturbed or predated nests. The
#'     primary presence of these nests is also included in the nest count from
#'     earlier columns.
#'   * `general_dist` The total number of general signs of disturbance or
#'     predator presence. These signs are not linked to any nest in particular.
#'   * `live_sightings` The total number of encounters with animals with an alive
#'     outcome. This includes tagged turtles, rescued turtles, turtles
#'     encountered in-water. Note that turtle tagging is currently recorded
#'     in the Turtle Tagging database, a legacy system pending sunsetting.
#'   * `mortalities` The total number of encounters with dead animals. This
#'     includes strandings and other incidents where the animal is dead at the
#'     time of encounter or soon after.
#'   * `track_tallies` The total number of line transects, during which tallies
#'     of turtle tracks and disturbance or predation may be recorded.
#' @family wastd
#' @export
#' @examples
#' \dontrun{
#' data("wastd_data", package = "wastdr")
#' x <- wastd_data %>%
#'   wastdr::filter_wastd_turtledata(area_name = "Thevenard Island") %>%
#'   summarise_wastd_data_per_day_site()
#'
#' x <- wastd_data %>%
#'   wastdr::filter_wastd_turtledata(area_name = "Troughton Island") %>%
#'   summarise_wastd_data_per_day_site()
#'
#' x <- wastd_data %>%
#'   wastdr::filter_wastd_turtledata(area_name = "Eco Beach") %>%
#'   summarise_wastd_data_per_day_site()
#' }
summarise_wastd_data_per_day_site <- function(x) {
  svy <- x$surveys %>%
    filter_realsurveys() %>%
    dplyr::group_by(area_name, site_name, turtle_date, turtle_date_awst_text) %>%
    dplyr::tally(name = "no_surveys") %>%
    dplyr::arrange(by_group = TRUE) %>%
    dplyr::ungroup()

  trk <- x$tracks %>%
    filter_realspecies() %>%
    dplyr::mutate(
      nest_type = stringr::str_replace_all(nest_type, "-", "_")
    ) %>%
    dplyr::group_by(area_name, site_name, turtle_date, turtle_date_awst_text, nest_type) %>%
    dplyr::tally() %>%
    dplyr::ungroup() %>%
    tidyr::spread(nest_type, n, fill = 0)

  dst <- x$nest_dist %>%
    dplyr::rename(
      area_name = encounter_area_name,
      site_name = encounter_site_name,
      encounter_type = encounter_encounter_type
    ) %>%
    dplyr::group_by(
      area_name, site_name, turtle_date, turtle_date_awst_text, encounter_type
    ) %>%
    dplyr::tally() %>%
    dplyr::ungroup() %>%
    tidyr::spread(encounter_type, n, fill = 0) %>%
    {
      if ("nest" %in% names(.)) {
        dplyr::rename(., disturbed_nests = nest)
      } else {
        .
      }
    } %>%
    {
      if ("other" %in% names(.)) {
        dplyr::rename(., general_dist = other)
      } else {
        .
      }
    }


  ani <- x$animals %>%
    filter_realspecies() %>%
    filter_alive() %>%
    dplyr::group_by(area_name, site_name, turtle_date, turtle_date_awst_text) %>%
    dplyr::tally(name = "live_sightings") %>%
    dplyr::ungroup()

  ded <- x$animals %>%
    filter_realspecies() %>%
    filter_dead() %>%
    dplyr::group_by(area_name, site_name, turtle_date, turtle_date_awst_text) %>%
    dplyr::tally(name = "mortalities") %>%
    dplyr::ungroup()

  tal <- x$linetx %>%
    dplyr::group_by(area_name, site_name, turtle_date, turtle_date_awst_text) %>%
    dplyr::tally(name = "track_tallies") %>%
    dplyr::ungroup()

  common_vars <- c(
    "area_name",
    "site_name",
    "turtle_date",
    "turtle_date_awst_text"
  )

  svy %>%
    dplyr::left_join(trk, by = common_vars) %>%
    dplyr::left_join(dst, by = common_vars) %>%
    dplyr::left_join(ani, by = common_vars) %>%
    dplyr::left_join(ded, by = common_vars) %>%
    dplyr::left_join(tal, by = common_vars)
}

# usethis::use_test("summarise_wastd_data_per_day_site")  # nolint


# -----------------------------------------------------------------------------#
# Processing Success
# -----------------------------------------------------------------------------#
#' Calculate processing success for emergences per area, season, species
#'
#' Break up total emergences into tagged and non_tagged animals
#'
#' @template param-wastd-data
#'
#' @return A tibble with the summary data
#' @export
#'
#' @examples
#' data(wastd_data)
#' wastd_data %>% total_emergences_per_area_season_species()
total_emergences_per_area_season_species <- function(x) {
  if (class(x) != "wastd_data") {
    wastdr_msg_abort(
      glue::glue(
        "The first argument needs to be an object of class \"wastd_data\", ",
        "e.g. the output of wastdr::download_wastd_turtledata."
      )
    )
  }

  shared_cols <- c("area_name", "species", "season")

  # Missed turtles from form "Turtle Track or Nest" filled during tagging
  # We don't filter by track_age
  # This includes "missed just now" from tagging,
  # "fresh" and "old" from morning track count.
  wastd_missed_turtles_single <-
    x$tracks %>%
    wastdr::filter_realspecies() %>%
    dplyr::filter(
      nest_type %in% c(
        "successful-crawl",
        "false-crawl",
        "track-unsure",
        "track-not-assessed"
      )
    ) %>%
    dplyr::group_by(area_name, season, species) %>%
    dplyr::tally(name = "missed_single") %>%
    dplyr::ungroup()

  # Missed turtles from "Track Tally"
  # This data comes from either saturated beaches (CDO) or backfilled datasheets
  wastd_missed_turtles_tally <-
    x$track_tally %>%
    wastdr::filter_realspecies() %>%
    dplyr::filter(
      nest_type %in% c(
        "successful-crawl",
        "false-crawl",
        "track-unsure",
        "track-not-assessed"
      )
    ) %>%
    dplyr::group_by(encounter_area_name, season, species) %>%
    dplyr::rename(area_name = encounter_area_name) %>%
    dplyr::summarize(missed_tally = sum(tally)) %>%
    dplyr::ungroup()

  # Combined from forms "Turtle Track or Nest" and "Track Tally"
  wastd_missed_turtles <-
    wastd_missed_turtles_single %>%
    dplyr::full_join(wastd_missed_turtles_tally, by = shared_cols) %>%
    tidyr::replace_na(list(missed_single = 0, missed_tally = 0)) %>%
    dplyr::mutate(missed = missed_single + missed_tally) %>%
    dplyr::select(-missed_single, -missed_tally)

  # -----------------------------------------------------------------------------#
  # Emergences: processed + missed
  wastd_processed_turtles <- x$animals %>%
    filter_realspecies() %>%
    filter_alive() %>%
    dplyr::filter(taxon == "Cheloniidae") %>%
    dplyr::group_by(area_name, season, species) %>%
    dplyr::tally(name = "processed") %>%
    dplyr::ungroup()

  wastd_processed_turtles_tagged <- x$animals %>%
    filter_realspecies() %>%
    filter_alive() %>%
    dplyr::filter(taxon == "Cheloniidae") %>%
    dplyr::filter(encounter_type == "tagging") %>%
    dplyr::group_by(area_name, season, species) %>%
    dplyr::tally(name = "tagged") %>%
    dplyr::ungroup()

  wastd_processed_turtles_non_tagged <- x$animals %>%
    filter_realspecies() %>%
    filter_alive() %>%
    dplyr::filter(taxon == "Cheloniidae") %>%
    dplyr::filter(encounter_type != "tagging") %>%
    dplyr::group_by(area_name, season, species) %>%
    dplyr::tally(name = "non_tagged") %>%
    dplyr::ungroup()

  # Total emergences = missed (WAStD) + processed (w2)
  # Important to replace NA with 0 before adding, as num + NA = NA
  total_turtles <-
    wastd_missed_turtles %>%
    dplyr::full_join(wastd_processed_turtles, by = shared_cols) %>%
    dplyr::full_join(wastd_processed_turtles_tagged, by = shared_cols) %>%
    dplyr::full_join(wastd_processed_turtles_non_tagged, by = shared_cols) %>%
    tidyr::replace_na(list(missed = 0, processed = 0, tagged = 0, non_tagged = 0)) %>%
    dplyr::mutate(
      emergences = processed + missed,
      processed_pct = round(processed * 100 / emergences, 2)
    ) %>%
    dplyr::arrange(season, species) %>%
    dplyr::mutate(
      species = stringr::str_to_sentence(species) %>% stringr::str_replace("-", " ")
    ) %>%
    dplyr::select(
      area_name, season, species,
      emergences, processed, missed, processed_pct, tagged, non_tagged
    )
  # %>% janitor::clean_names(case="sentence")

  total_turtles
}

#' Calculate processing success for emergences per site, season, species
#'
#' Break up total emergences into processed (tagged) and missed animals.
#'
#' @template param-wastd-data
#'
#' @return A tibble with the summary data
#' @export
#'
#' @examples
#' data(wastd_data)
#' wastd_data %>% total_emergences_per_site_season_species()
total_emergences_per_site_season_species <- function(x) {
  if (class(x) != "wastd_data") {
    wastdr_msg_abort(
      glue::glue(
        "The first argument needs to be an object of class \"wastd_data\", ",
        "e.g. the output of wastdr::download_wastd_turtledata."
      )
    )
  }

  shared_cols <- c("area_name", "site_name", "species", "season")

  # Missed turtles from form "Turtle Track or Nest" filled during tagging
  # We don't filter by track_age
  # This includes "missed just now" from tagging,
  # "fresh" and "old" from morning track count.
  wastd_missed_turtles_single <-
    x$tracks %>%
    wastdr::filter_realspecies() %>%
    dplyr::filter(
      nest_type %in% c(
        "successful-crawl",
        "false-crawl",
        "track-unsure",
        "track-not-assessed"
      )
    ) %>%
    dplyr::group_by(area_name, site_name, species, season) %>%
    dplyr::tally(name = "missed_single") %>%
    dplyr::ungroup()

  # Missed turtles from "Track Tally"
  # This data comes from either saturated beaches (CDO) or backfilled datasheets
  wastd_missed_turtles_tally <-
    x$track_tally %>%
    wastdr::filter_realspecies() %>%
    dplyr::filter(
      nest_type %in% c(
        "successful-crawl",
        "false-crawl",
        "track-unsure",
        "track-not-assessed"
      )
    ) %>%
    dplyr::group_by(encounter_area_name, encounter_site_name, season, species) %>%
    dplyr::rename(area_name = encounter_area_name, site_name = encounter_site_name) %>%
    dplyr::summarize(missed_tally = sum(tally)) %>%
    dplyr::ungroup()

  # Combined from forms "Turtle Track or Nest" and "Track Tally"
  wastd_missed_turtles <-
    wastd_missed_turtles_single %>%
    dplyr::full_join(wastd_missed_turtles_tally,
      by = shared_cols
    ) %>%
    tidyr::replace_na(list(missed_single = 0, missed_tally = 0)) %>%
    dplyr::mutate(missed = missed_single + missed_tally) %>%
    dplyr::select(-missed_single, -missed_tally)

  # -----------------------------------------------------------------------------#
  # Emergences: processed + missed
  wastd_processed_turtles <- x$animals %>%
    filter_realspecies() %>%
    filter_alive() %>%
    dplyr::filter(taxon == "Cheloniidae") %>%
    dplyr::group_by(area_name, site_name, season, species) %>%
    dplyr::tally(name = "processed") %>%
    dplyr::ungroup()

  wastd_processed_turtles_tagged <- x$animals %>%
    filter_realspecies() %>%
    filter_alive() %>%
    dplyr::filter(taxon == "Cheloniidae") %>%
    dplyr::filter(encounter_type == "tagging") %>%
    dplyr::group_by(area_name, site_name, season, species) %>%
    dplyr::tally(name = "tagged") %>%
    dplyr::ungroup()

  wastd_processed_turtles_non_tagged <- x$animals %>%
    filter_realspecies() %>%
    filter_alive() %>%
    dplyr::filter(taxon == "Cheloniidae") %>%
    dplyr::filter(encounter_type != "tagging") %>%
    dplyr::group_by(area_name, site_name, season, species) %>%
    dplyr::tally(name = "non_tagged") %>%
    dplyr::ungroup()

  # Total emergences = missed (WAStD) + processed (w2)
  # Important to replace NA with 0 before adding, as num + NA = NA
  total_turtles <-
    wastd_missed_turtles %>%
    dplyr::full_join(wastd_processed_turtles, by = shared_cols) %>%
    dplyr::full_join(wastd_processed_turtles_tagged, by = shared_cols) %>%
    dplyr::full_join(wastd_processed_turtles_non_tagged, by = shared_cols) %>%
    tidyr::replace_na(list(missed = 0, processed = 0, tagged = 0, non_tagged = 0)) %>%
    dplyr::mutate(
      emergences = processed + missed,
      processed_pct = round(processed * 100 / emergences, 2)
    ) %>%
    dplyr::arrange(season, species) %>%
    dplyr::mutate(
      species = stringr::str_to_sentence(species) %>% stringr::str_replace("-", " ")
    ) %>%
    dplyr::select(
      area_name, site_name, season, species, emergences, processed, missed, processed_pct, tagged, non_tagged
    )
  # %>% janitor::clean_names(case="sentence")

  total_turtles
}

#' Return a stacked ggplot barchart of emergences by processing status
#'
#' Facets: species
#'
#' @param data The output of `total_emergences_per_area_season_species`, a
#'  summary of `wastd_data`.
#' @return A ggplot2 figure
#' @export
#'
#' @examples
#' data(wastd_data)
#' wastd_data %>%
#'   total_emergences_per_area_season_species() %>%
#'   ggplot_total_emergences_per_area_season_species()
#'
#' wastd_data %>%
#'   total_emergences_per_area_season_species() %>%
#'   ggplot_total_emergences_per_area_season_species() %>%
#'   plotly::ggplotly()
ggplot_total_emergences_per_area_season_species <- function(data) {
  data %>%
    dplyr::select(-emergences, -processed, -processed_pct) %>%
    tidyr::pivot_longer(c(tagged, non_tagged, missed),
      names_to = "Processing",
      values_to = "Emergences"
    ) %>%
    ggplot2::ggplot(ggplot2::aes(fill = Processing, y = Emergences, x = season)) +
    ggplot2::geom_bar(position = "stack", stat = "identity") +
    ggplot2::facet_wrap(~species, ncol = 1) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      legend.position = "bottom"
      # legend.title = ggplot2::element_text("Processing Status")
    ) +
    ggplot2::labs(
      title = "Emergences and processing status",
      subtitle = "Count of emergences split by processing status",
      x = "Season (FY start)",
      alt = paste0(
        "Stacked bar charts showing emergence numbers ",
        "for each species (facets) over each season (x axis) ",
        "as counts of emergences that were tagged, not tagged, or missed."
      )
    )
}

# -----------------------------------------------------------------------------#
# Nesting Success
# -----------------------------------------------------------------------------#
#' Calculate nesting success for emergences per area, season, species
#'
#' Break up total emergences into tagged and non_tagged animals
#'
#' @template param-wastd-data
#'
#' @return A tibble with the summary data
#' @export
#'
#' @examples
#' data(wastd_data)
#' wastd_data %>%
#'   nesting_success_per_area_season_species()
nesting_success_per_area_season_species <- function(x) {
  if (class(x) != "wastd_data") {
    wastdr_msg_abort(
      glue::glue(
        "The first argument needs to be an object of class \"wastd_data\", ",
        "e.g. the output of wastdr::download_wastd_turtledata."
      )
    )
  }

  shared_cols <- c("area_name", "species", "season")

  # Nesting success by season and species: season summary
  # From ToN
  wastd_nesting_success_by_season_area_species_single <-
    x$tracks %>%
    wastdr::filter_realspecies() %>%
    dplyr::group_by(area_name, season, species, nest_type) %>%
    dplyr::tally() %>%
    dplyr::ungroup() %>%
    tidyr::spread(nest_type, n, fill = 0)

  # From TT
  wastd_nesting_success_by_season_area_species_tally <-
    x$track_tally %>%
    wastdr::filter_realspecies() %>%
    dplyr::rename(area_name = encounter_area_name) %>%
    dplyr::group_by(area_name, season, species, nest_type) %>%
    dplyr::summarise(n = sum(tally), .groups = "keep") %>%
    dplyr::ungroup() %>%
    tidyr::spread(nest_type, n, fill = 0)

  # From animals
  wastd_nesting_success_by_season_area_species_animals <-
    x$animals %>%
    wastdr::filter_realspecies() %>%
    dplyr::group_by(area_name, season, species, nesting_event) %>%
    dplyr::tally() %>%
    dplyr::ungroup() %>%
    tidyr::spread(nesting_event, n, fill = 0)

  # All possible data cols
  data_cols <- c(
    "false-crawl", "hatched-nest", "nest",
    "successful-crawl", "track-not-assessed", "track-unsure",
    "absent", "na", "nest-unsure-of-eggs",
    "nest-with-eggs", "no-nest", "unsure-if-nest"
  )
  # Named list of all data cols for replace_na
  data_cols_list <- as.list(stats::setNames(rep(0, length(data_cols)), data_cols))

  # Combined
  out <-
    dplyr::bind_rows(
      wastd_nesting_success_by_season_area_species_single %>% tibble::rownames_to_column(),
      wastd_nesting_success_by_season_area_species_tally %>% tibble::rownames_to_column(),
      wastd_nesting_success_by_season_area_species_animals %>% tibble::rownames_to_column()
    ) %>%
    dplyr::select(-rowname) %>%
    dplyr::group_by(area_name, season, species) %>%
    tidyr::replace_na(data_cols_list) %>%
    dplyr::summarise_all(sum) %>%
    dplyr::ungroup() %>%
    dplyr::arrange(area_name, season, species)


  data_cols_have <- out %>%
    dplyr::select(-area_name, -season, -species) %>%
    names()


  # Make sure all data cols exist
  missing_data_cols <- setdiff(data_cols, data_cols_have)
  # "Missing data columns {paste(missing_data_cols, collapse=', ')}" %>%
  #     glue::glue() %>% wastdr::wastdr_msg_noop()
  for (dc in missing_data_cols) {
    out <- dplyr::mutate(out, !!dc := 0)
    # "Adding missing column {dc}, cols: {paste(names(out), collapse=', ')}" %>%
    # glue::glue() %>% wastdr::wastdr_msg_noop()
  }

  out %>%
    tidyr::replace_na(data_cols_list) %>%
    dplyr::transmute(
      area_name = area_name,
      season = season,
      species = species,
      emergences = (
        `successful-crawl` + `nest-with-eggs` + `nest-unsure-of-eggs` +
          `unsure-if-nest` + `track-not-assessed` + `track-unsure` + `na` +
          `false-crawl` + `absent` + `no-nest`
      ),
      nesting_present = `successful-crawl` + `nest-with-eggs` + `nest-unsure-of-eggs`,
      nesting_unsure = `unsure-if-nest` + `track-not-assessed` + `track-unsure` + `na`,
      nesting_absent = `false-crawl` + `absent` + `no-nest`,
      nesting_success_optimistic = round(100 * (nesting_present + nesting_unsure) / emergences, 2),
      nesting_success_pessimistic = round(100 * nesting_present / emergences, 2)
    )
}


#' Calculate nesting success for emergences per area, day (turtle_date), species
#'
#' Break up total emergences into tagged and non_tagged animals
#'
#' @template param-wastd-data
#'
#' @return A tibble with the summary data
#' @export
#'
#' @examples
#' data(wastd_data)
#' wastd_data %>%
#'   nesting_success_per_area_day_species()
nesting_success_per_area_day_species <- function(x) {
  if (class(x) != "wastd_data") {
    wastdr_msg_abort(
      glue::glue(
        "The first argument needs to be an object of class \"wastd_data\", ",
        "e.g. the output of wastdr::download_wastd_turtledata."
      )
    )
  }

  shared_cols <- c("area_name", "species", "calendar_date_awst")

  # Nesting success by turtle_date and species: turtle_date summary
  # From ToN
  wastd_nesting_success_by_day_area_species_single <-
    x$tracks %>%
    wastdr::filter_realspecies() %>%
    dplyr::group_by(area_name, turtle_date, species, nest_type) %>%
    dplyr::tally() %>%
    dplyr::ungroup() %>%
    tidyr::spread(nest_type, n, fill = 0)

  # From TT
  wastd_nesting_success_by_day_area_species_tally <-
    x$track_tally %>%
    wastdr::filter_realspecies() %>%
    dplyr::rename(area_name = encounter_area_name) %>%
    dplyr::group_by(area_name, season, turtle_date, nest_type) %>%
    dplyr::summarise(n = sum(tally), .groups = "keep") %>%
    dplyr::ungroup() %>%
    tidyr::spread(nest_type, n, fill = 0)

  # From animals
  wastd_nesting_success_by_day_area_species_animals <-
    x$animals %>%
    wastdr::filter_realspecies() %>%
    dplyr::group_by(area_name, turtle_date, species, nesting_event) %>%
    dplyr::tally() %>%
    dplyr::ungroup() %>%
    tidyr::spread(nesting_event, n, fill = 0)

  # All possible data cols
  data_cols <- c(
    "false-crawl", "hatched-nest", "nest",
    "successful-crawl", "track-not-assessed", "track-unsure",
    "absent", "na", "nest-unsure-of-eggs",
    "nest-with-eggs", "no-nest", "unsure-if-nest"
  )
  # Named list of all data cols for replace_na
  data_cols_list <- as.list(stats::setNames(rep(0, length(data_cols)), data_cols))

  # Combined
  out <-
    dplyr::bind_rows(
      wastd_nesting_success_by_day_area_species_single %>% tibble::rownames_to_column(),
      wastd_nesting_success_by_day_area_species_tally %>% tibble::rownames_to_column(),
      wastd_nesting_success_by_day_area_species_animals %>% tibble::rownames_to_column()
    ) %>%
    dplyr::select(-rowname) %>%
    dplyr::group_by(area_name, turtle_date, species) %>%
    tidyr::replace_na(data_cols_list) %>%
    dplyr::summarise_all(sum) %>%
    dplyr::ungroup() %>%
    dplyr::arrange(area_name, turtle_date, species)


  data_cols_have <- out %>%
    dplyr::select(-area_name, -turtle_date, -species) %>%
    names()


  # Make sure all data cols exist
  missing_data_cols <- setdiff(data_cols, data_cols_have)
  # "Missing data columns {paste(missing_data_cols, collapse=', ')}" %>%
  #     glue::glue() %>% wastdr::wastdr_msg_noop()
  for (dc in missing_data_cols) {
    out <- dplyr::mutate(out, !!dc := 0)
    # "Adding missing column {dc}, cols: {paste(names(out), collapse=', ')}" %>%
    # glue::glue() %>% wastdr::wastdr_msg_noop()
  }

  out %>%
    tidyr::replace_na(data_cols_list) %>%
    dplyr::transmute(
      area_name = area_name,
      turtle_date = turtle_date,
      species = species,
      emergences = (
        `successful-crawl` + `nest-with-eggs` + `nest-unsure-of-eggs` +
          `unsure-if-nest` + `track-not-assessed` + `track-unsure` + `na` +
          `false-crawl` + `absent` + `no-nest`
      ),
      nesting_present = `successful-crawl` + `nest-with-eggs` + `nest-unsure-of-eggs`,
      nesting_unsure = `unsure-if-nest` + `track-not-assessed` + `track-unsure` + `na`,
      nesting_absent = `false-crawl` + `absent` + `no-nest`,
      nesting_success_optimistic = round(100 * (nesting_present + nesting_unsure) / emergences, 2),
      nesting_success_pessimistic = round(100 * nesting_present / emergences, 2)
    )
}

# use_test("nesting_success_per_area_day_species")  # nolint


#' Return a stacked ggplot barchart of emergences
#'
#' Facets: species
#'
#' @param data The output of `nesting_success_per_area_season_species`, a
#'  summary of `wastd_data`.
#'
#' @return A ggplot figure
#' @export
#'
#' @examples
#' data(wastd_data)
#' wastd_data %>%
#'   filter_wastd_turtledata(area_name = "Delambre Island") %>%
#'   nesting_success_per_area_season_species() %>%
#'   ggplot_nesting_success_per_area_season_species()
#'
#' wastd_data %>%
#'   filter_wastd_turtledata(area_name = "Delambre Island") %>%
#'   nesting_success_per_area_season_species() %>%
#'   ggplot_nesting_success_per_area_season_species() %>%
#'   plotly::ggplotly()
ggplot_nesting_success_per_area_season_species <- function(data) {
  data %>%
    dplyr::select(
      -emergences,
      -nesting_success_optimistic,
      -nesting_success_pessimistic
    ) %>%
    tidyr::pivot_longer(c(nesting_present, nesting_unsure, nesting_absent),
      names_to = "Nesting",
      values_to = "Emergences"
    ) %>%
    ggplot2::ggplot(
      ggplot2::aes(fill = Nesting, y = Emergences, x = season)
    ) +
    ggplot2::geom_bar(position = "stack", stat = "identity") +
    ggplot2::facet_wrap(~species, ncol = 1) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      legend.position = "bottom"
      # legend.title = ggplot2::element_text("Nesting success")
    ) +
    ggplot2::labs(
      title = "Absolute Nesting Success",
      subtitle = "Count of emergences with successful nesting",
      x = "Season (FY start)",
      alt = paste0(
        "Stacked bar charts showing the Absolute Nesting Success ",
        "for each species (facets) over each season (x axis) ",
        "as counts of emergences with successful, unsure, and absent nesting."
      )
    )
}

#' Return a stacked ggplot barchart of emergences
#'
#' Facets: species
#'
#' @param data The output of `nesting_success_per_area_season_species`, a
#'  summary of `wastd_data`.
#'
#' @return A ggplot figure
#' @export
#'
#' @examples
#' data(wastd_data)
#' wastd_data %>%
#'   filter_wastd_turtledata(area_name = "Delambre Island") %>%
#'   nesting_success_per_area_season_species() %>%
#'   ggplot_nesting_success_per_area_season_species_pct()
#'
#' wastd_data %>%
#'   filter_wastd_turtledata(area_name = "Delambre Island") %>%
#'   nesting_success_per_area_season_species() %>%
#'   ggplot_nesting_success_per_area_season_species_pct() %>%
#'   plotly::ggplotly()
ggplot_nesting_success_per_area_season_species_pct <- function(data) {
  data %>%
    dplyr::select(
      -emergences,
      -nesting_present,
      -nesting_unsure,
      -nesting_absent
    ) %>%
    ggplot2::ggplot(ggplot2::aes(x = season)) +
    ggplot2::geom_errorbar(
      ggplot2::aes(
        ymin = nesting_success_pessimistic,
        ymax = nesting_success_optimistic
      ),
      width = 0.5
    ) +
    ggplot2::facet_wrap(~species, ncol = 1) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      legend.position = "bottom"
      # legend.title = ggplot2::element_text("Nesting success")
    ) +
    ggplot2::labs(
      title = "Relative Nesting Success",
      subtitle = "Percent of emergences with successful nesting (pessimistic and optimistic estimates)",
      x = "Season (FY start)",
      alt = paste0(
        "Stacked bar charts showing the Relative Nesting Success ",
        "for each species (facets) over each season (x axis) ",
        "as optimistic (at most) and pessimistic (at least) ",
        "percentages of emergences with successful nesting."
      )
    )
}

# use_test("nesting_success_per_area_season_species")  # nolint


# -----------------------------------------------------------------------------#
# Nesting Success
# -----------------------------------------------------------------------------#
#' Calculate sighting status for emergences per area, season, species
#'
#' Break up total emergences by sighting status:
#'
#' * Na - Unidentified (encounter with untagged animal)
#' * New - Initial sighting (new tags applied onto untagged animal)
#' * Resighting (existing tags, animal resighted at same site, same season)
#' * Remigrant (existing tags, animal resighted at different or same site, different season)
#'
#' @template param-wastd-data
#'
#' @return A tibble with the summary data
#' @export
#'
#' @examples
#' data(wastd_data)
#' wastd_data %>%
#'   sighting_status_per_area_season_species()
sighting_status_per_area_season_species <- function(x) {
  if (class(x) != "wastd_data") {
    wastdr_msg_abort(
      glue::glue(
        "The first argument needs to be an object of class \"wastd_data\", ",
        "e.g. the output of wastdr::download_wastd_turtledata."
      )
    )
  }

  x$animals %>%
    dplyr::filter(taxon == "Cheloniidae") %>%
    filter_realspecies() %>%
    dplyr::group_by(area_name, season, species, sighting_status) %>%
    dplyr::tally() %>%
    dplyr::ungroup() %>%
    dplyr::arrange(area_name, season, species) %>%
    tidyr::pivot_wider(names_from = sighting_status, values_from = n)
  # %>% dplyr::mutate(
  # species = stringr::str_to_sentence(species) %>% stringr::str_replace("-", " ")
  # ) %>% janitor::clean_names(case = "sentence")
}


#' Calculate sighting status for emergences per site, season, species
#'
#' Break up total emergences by sighting status:
#'
#' * Na - Unidentified (encounter with untagged animal)
#' * New - Initial sighting (new tags applied onto untagged animal)
#' * Resighting (existing tags, animal resighted at same site, same season)
#' * Remigrant (existing tags, animal resighted at different or same site, different season)
#'
#' @template param-wastd-data
#'
#' @return A tibble with the summary data
#' @export
#'
#' @examples
#' data(wastd_data)
#' wastd_data %>%
#'   sighting_status_per_site_season_species()
sighting_status_per_site_season_species <- function(x) {
  if (class(x) != "wastd_data") {
    wastdr_msg_abort(
      glue::glue(
        "The first argument needs to be an object of class \"wastd_data\", ",
        "e.g. the output of wastdr::download_wastd_turtledata."
      )
    )
  }

  x$animals %>%
    dplyr::filter(taxon == "Cheloniidae") %>%
    filter_realspecies() %>%
    dplyr::group_by(site_name, season, species, sighting_status) %>%
    dplyr::tally() %>%
    dplyr::ungroup() %>%
    dplyr::arrange(site_name, season, species) %>%
    tidyr::pivot_wider(names_from = sighting_status, values_from = n)
  # %>% dplyr::mutate(
  # species = stringr::str_to_sentence(species) %>% stringr::str_replace("-", " ")
  # ) %>% janitor::clean_names(case = "sentence")
}

# use_test("sighting_status_per_site_season_species")  # nolint
