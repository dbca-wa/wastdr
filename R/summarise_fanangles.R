#' Return a ggplot violin plot of hatchling emergence misorientation
#'
#' Facets: species
#'
#' @template param-wastd-data
#'
#' @return A ggplot figure
#' @importFrom ggplot2 ggplot aes facet_wrap ylim theme theme_minimal labs
#'   geom_violin geom_jitter geom_point
#' @export
#'
#' @examples
#' data(wastd_data)
#' wastd_data %>%
#'   filter_wastd_turtledata(area_name = "Delambre Island") %>%
#'   ggplot_hatchling_misorientation()
#'
#' wastd_data %>%
#'   filter_wastd_turtledata(area_name = "Delambre Island") %>%
#'   ggplot_hatchling_misorientation() %>%
#'   plotly::ggplotly()
ggplot_hatchling_misorientation <- function(x) {
  x$nest_fans %>%
    filter_realspecies() %>%
    dplyr::filter(!is.na(misorientation_deg)) %>%
    dplyr::mutate(
      encounter_species = encounter_species %>%
        stringr::str_to_sentence(encounter_species) %>%
        stringr::str_replace("-", " ")
    ) %>%
    ggplot(aes(x = factor(season), y = misorientation_deg)) +
    geom_violin(show.legend = TRUE) +
    # geom_jitter(height = 0, width = 0.1, ) + # jittered around season
    facet_wrap(~encounter_species, ncol = 1) +
    ylim(0, 180) +
    theme_minimal() +
    labs(
      title = "Turtle Hatchling Misorientation",
      subtitle = "Difference between mean nest emergence bearing and direction to water in degrees",
      x = "Season (FY start)",
      y = "Misorientation [°]",
      alt = paste0(
        "Violin plots showing Turtle Hatchling Misorientation ",
        "for each species (facets) over each season (x axis) ",
        "as the smallest angular difference between the mean direction ",
        "of nest emergences and the shortest path to water in degrees."
      )
    )
}

# use_test("ggplot_hatchling_misorientation")  # nolint
# use_r("summarise_fanangles")  # nolint
