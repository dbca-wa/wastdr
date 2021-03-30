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
#'     includes strandings and other indicents where the animal is dead at the
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
summarise_wastd_data_per_day_site <- function(x){
    svy <- x$surveys %>%
        filter_realsurveys() %>%
        dplyr::group_by(area_name, site_name, calendar_date_awst) %>%
        dplyr::tally(name = "no_surveys") %>%
        dplyr::arrange(by_group=TRUE) %>%
        dplyr::ungroup()

    trk <- x$tracks %>%
        filter_realspecies() %>%
        dplyr::mutate(
            nest_type = stringr::str_replace_all(nest_type, "-", "_")
        ) %>%
        dplyr::group_by(area_name, site_name, calendar_date_awst, nest_type) %>%
        dplyr::tally() %>%
        dplyr::ungroup() %>%
        tidyr::spread(nest_type, n, fill = 0)

    dst <- x$nest_dist %>%
        dplyr::rename(area_name = encounter_area_name,
                      site_name = encounter_site_name,
                      encounter_type = encounter_encounter_type) %>%
        dplyr::group_by(
            area_name, site_name, calendar_date_awst, encounter_type
        ) %>%
        dplyr::tally() %>%
        dplyr::ungroup() %>%
        tidyr::spread(encounter_type, n, fill = 0) %>%
        {
            if ("nest" %in% names(.)){
                dplyr::rename(., disturbed_nests = nest)
            } else {.}
        } %>%
        {
            if ("other" %in% names(.)){
                dplyr::rename(., general_dist = other)
            } else {.}
        }


    ani <- x$animals %>%
        filter_realspecies() %>%
        filter_alive() %>%
        dplyr::group_by(area_name, site_name, calendar_date_awst) %>%
        dplyr::tally(name = "live_sightings") %>%
        dplyr::ungroup()

    ded <- x$animals %>%
        filter_realspecies() %>%
        filter_dead() %>%
        dplyr::group_by(area_name, site_name, calendar_date_awst) %>%
        dplyr::tally(name = "mortalities") %>%
        dplyr::ungroup()

    tal <- x$linetx %>%
        dplyr::group_by(area_name, site_name, calendar_date_awst) %>%
        dplyr::tally(name = "track_tallies") %>%
        dplyr::ungroup()

    common_vars <- c("area_name", "site_name", "calendar_date_awst")

    svy %>%
        dplyr::left_join(trk, by=common_vars) %>%
        dplyr::left_join(dst, by=common_vars) %>%
        dplyr::left_join(ani, by=common_vars) %>%
        dplyr::left_join(ded, by=common_vars) %>%
        dplyr::left_join(tal, by=common_vars)
}

# usethis::use_test("summarise_wastd_data_per_day_site")  # nolint
