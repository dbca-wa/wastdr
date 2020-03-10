#' Plot of nesting_type_by_season_day_species over time
#'
#' @param data The output of \code{parse_turtle_nest_encounters}.
#' @template param-surveys
#' @template param-placename
#' @template param-prefix
#' @return A ggplot2 object. Saves the plot to .png.
#' @export
tracks_ts <- function(data,
                      surveys,
                      placename = "",
                      prefix = "") {
  fname <-
    glue::glue("{prefix}_track_abundance_{wastdr::urlize(placename)}.png")
  data %>%
    wastdr::nesting_type_by_season_day_species(.) %>%
    {
      ggplot2::ggplot() +
        ggplot2::facet_grid(rows = ggplot2::vars(season), scales = "free_x") +
        ggplot2::scale_x_continuous(
          labels = function(x) {
            fdate_as_tdate(x)
          }
        ) +
        ggplot2::scale_y_continuous(limits = c(0, NA)) +
        ggplot2::geom_bar(
          data = surveys,
          ggplot2::aes(x = tdate_as_fdate(turtle_date)),
          show.legend = FALSE
        ) +
        ggalt::geom_lollipop(
          data = .,
          ggplot2::aes(
            x = tdate_as_fdate(turtle_date),
            y = n,
            colour = nest_type
          ),
          point.size = 2
        ) +
        ggplot2::ggtitle(
          glue::glue("Nesting activity at {placename}"),
          subtitle = glue::glue(
            "Number counted per day (points) over number of surveys (bars)"
          )
        ) +
        ggplot2::ylab("Number of turtle tracks or nests") +
        ggplot2::xlab("Turtle date") +
        ggplot2::guides(colour = ggplot2::guide_legend(title = "Nest type")) +
        ggplot2::theme_classic() +
        ggplot2::ggsave(fname, width = 10, height = 6)
    }
}
