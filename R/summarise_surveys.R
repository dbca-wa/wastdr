#' Return the number of surveys for a given site_id and season
#'
#' \lifecycle{stable}
#'
#' @template param-surveys
#' @param sid The ID of a site, e.g. 22
#' @param seas The season as integer, e.g. 2018
#' @export
#' @family wastd_surveys
#' @examples
#' data("wastd_data")
#' one_season <- unique(wastd_data$surveys$season)[1]
#' one_site_id <- unique(wastd_data$surveys$site_id)[1]
#' survey_count(wastd_data$surveys, one_site_id, one_season)
survey_count <- function(surveys, sid, seas) {
  surveys %>%
    dplyr::filter(site_id == sid, season == seas) %>%
    nrow()
}

#' Return the number of surveys for a given site_id and season
#'
#' \lifecycle{stable}
#'
#' @template param-surveys
#' @param sid The ID of a site, e.g. 22
#' @param kms The numbers of kilometers covered in a survey, e.g. 1.6
#' @param seas The season as integer, e.g. 2018
#' @export
#' @family wastd_surveys
#' @examples
#' data("wastd_data")
#' one_season <- unique(wastd_data$surveys$season)[1]
#' one_site_id <- unique(wastd_data$surveys$site_id)[1]
#' some_kms <- 10
#' survey_ground_covered(wastd_data$surveys, one_site_id, some_kms, one_season)
survey_ground_covered <- function(surveys, sid, kms, seas) {
  survey_count(surveys, sid, seas) * kms
}


#' Count number of surveys per season, turtle date and site_name from the output
#' of \code{parse_surveys}
#'
#' \lifecycle{stable}
#'
#' @template param-surveys
#' @return A tibble with columns season, turtle_date, site_name, n
#' (number of surveys)
#' @export
#' @family wastd_surveys
#' @examples
#' data("wastd_data")
#' surveys_per_site_name_and_date(wastd_data$surveys)
surveys_per_site_name_and_date <- function(surveys) {
  surveys %>%
    dplyr::group_by(season, turtle_date, site_name) %>%
    dplyr::tally() %>%
    dplyr::ungroup()
}

#' Sum the hours surveyed per site_name and turtle date from the output of
#' \code{parse_surveys}
#'
#' \lifecycle{stable}
#'
#' @template param-surveys
#' @return A tibble with columns season, turtle_date, site_name, hours_surveyed
#' @export
#' @family wastd_surveys
survey_hours_per_site_name_and_date <- function(surveys) {
  surveys %>%
    dplyr::group_by(season, turtle_date, site_name) %>%
    dplyr::tally(duration_hours) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(hours_surveyed = round(n)) %>%
    dplyr::select(-n)
}

#' Sum the hours surveyed per person by season from the output of
#' \code{parse_surveys}
#'
#' \lifecycle{stable}
#'
#' @template param-surveys
#' @return A tibble with columns reporter, season, hours_surveyed,
#' sorted by most to fewest hours.
#' @export
#' @family wastd_surveys
survey_hours_per_person <- function(surveys) {
  surveys %>%
    dplyr::group_by(season, reporter) %>%
    dplyr::tally(duration_hours) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(hours_surveyed = round(n)) %>%
    dplyr::select(-n) %>%
    dplyr::arrange(desc(hours_surveyed))
}

#' Create a table of survey counts from the output of \code{parse_surveys}
#'
#' \lifecycle{stable}
#'
#' @template param-surveys
#' @template param-placename
#' @export
#' @family wastd_surveys
list_survey_count <- function(surveys, placename = "") {
  surveys %>%
    surveys_per_site_name_and_date() %>%
    reactable::reactable(filterable = TRUE, sortable = TRUE)
}

#' Plot the surveyed hours from the output of \code{parse_surveys}
#'
#' \lifecycle{stable}
#'
#' @template param-surveys
#' @template param-local_dir
#' @template param-placename
#' @template param-prefix
#' @template param-export
#' @export
#' @family wastd_surveys
plot_survey_count <-
  function(surveys,
           local_dir = here::here(),
           placename = "",
           prefix = "",
           export = FALSE) {
    plt <- surveys %>%
      surveys_per_site_name_and_date() %>%
      ggplot2::ggplot(
        .,
        ggplot2::aes(x = tdate_as_fdate(turtle_date), site_name)
      ) +
      ggplot2::geom_bar(ggplot2::aes(y = n),
        stat = "identity",
        color = "black",
        fill = "grey"
      ) +
      ggplot2::facet_grid(facets = ggplot2::vars(season), scales = "free_x") +
      ggplot2::scale_x_continuous(labels = function(x) {fdate_as_tdate(x)}) +
      ggplot2::scale_y_continuous(limits = c(0, NA)) +
      ggplot2::theme_classic() +
      ggplot2::ggtitle(glue::glue("Survey Count {placename}"),
                       subtitle = "Number of surveys"
        ) +
      ggplot2::labs(x = "Turtle date", y = "")

    if (export == TRUE) {
      ggplot2::ggsave(
        plot = plt,
        filename = glue::glue("{prefix}_survey_count_{urlize(placename)}.png"),
        path = local_dir,
        width = 10,
        height = 6
      )
    }
    plt
  }

#' Create a table from the surveyed hours from the output of
#' \code{parse_surveys}
#'
#' \lifecycle{stable}
#'
#' @template param-surveys
#' @template param-placename
#' @export
#' @family wastd_surveys
list_survey_effort <- function(surveys, placename = "") {
  surveys %>%
    survey_hours_per_site_name_and_date() %>%
    reactable::reactable(filterable = TRUE, sortable = TRUE)
}

#' Plot the surveyed hours from the output of \code{parse_surveys}
#'
#' \lifecycle{stable}
#'
#' @template param-surveys
#' @template param-local_dir
#' @template param-placename
#' @template param-prefix
#' @template param-export
#' @export
#' @family wastd_surveys
plot_survey_effort <-
  function(surveys,
           local_dir = here::here(),
           placename = "",
           prefix = "",
           export = FALSE) {
    fname <- glue::glue("{prefix}_survey_effort_{urlize(placename)}.png")
    plt <- surveys %>%
      survey_hours_per_site_name_and_date() %>%
      ggplot2::ggplot(
        .,
        ggplot2::aes(x = tdate_as_fdate(turtle_date), site_name)
      ) +
      ggplot2::geom_bar(ggplot2::aes(y = hours_surveyed),
                        stat = "identity",
                        color = "black",
                        fill = "grey"
      ) +
      ggplot2::facet_grid(facets = ggplot2::vars(season), scales = "free_x") +
      ggplot2::scale_x_continuous(labels = function(x) {fdate_as_tdate(x)}) +
      ggplot2::scale_y_continuous(limits = c(0, NA)) +
      ggplot2::theme_classic() +
      ggplot2::ggtitle(glue::glue("Survey Effort {placename}"),
                       subtitle = "Hours surveyed") +
      ggplot2::labs(x = "Turtle date", y = "")

    if (export == TRUE) {
      ggplot2::ggsave(
        plot = plt,
        filename = fname,
        path = local_dir,
        width = 10,
        height = 6
      )
    }
    plt
  }

#' Plot the surveyed hours from the output of \code{parse_surveys} as heatmap
#'
#' All surveys are plotted, production and training surveys alike.
#'
#' \lifecycle{stable}
#'
#' @template param-surveys
#' @template param-local_dir
#' @template param-placename
#' @template param-prefix
#' @template param-export
#' @export
#' @family wastd_surveys
survey_hours_heatmap <-
  function(surveys,
           local_dir = here::here(),
           placename = "",
           prefix = "",
           export = FALSE) {
    plt <- surveys %>%
      wastdr::survey_hours_per_site_name_and_date(.) %>%
      ggTimeSeries::ggplot_calendar_heatmap("turtle_date", "hours_surveyed") +
      ggplot2::scale_fill_continuous(low = "green", high = "red") +
      ggplot2::facet_grid(rows = ggplot2::vars(Year)) +
      ggplot2::ggtitle(glue::glue("Survey effort at {placename}")) +
      ggplot2::xlab(NULL) + ggplot2::ylab(NULL) +
      ggplot2::theme_classic()

    if (export == TRUE) {
      ggplot2::ggsave(
        plot = plt,
        filename = glue::glue(
          "{prefix}_survey_hours_heatmap_{wastdr::urlize(placename)}.png"
        ),
        path = local_dir,
        width = 10,
        height = 6
      )
    }

    plt
  }

#' Plot the survey count from the output of \code{parse_surveys} as heatmap
#'
#' All surveys are plotted, production and training surveys alike.
#'
#' \lifecycle{stable}
#'
#' @template param-surveys
#' @template param-local_dir
#' @template param-placename
#' @template param-prefix
#' @template param-export
#' @export
#' @family wastd_surveys
survey_count_heatmap <- function(surveys,
                                 local_dir = here::here(),
                                 placename = "",
                                 prefix = "",
                                 export = FALSE) {
  fname <- glue::glue(
    "{prefix}_survey_count_heatmap_{wastdr::urlize(placename)}.png"
  )
  plt <- surveys %>%
    wastdr::surveys_per_site_name_and_date(.) %>%
    ggTimeSeries::ggplot_calendar_heatmap("turtle_date", "n") +
    ggplot2::scale_fill_continuous(low = "green", high = "red") +
    ggplot2::facet_grid(rows = ggplot2::vars(Year)) +
    ggplot2::ggtitle(glue::glue("Survey effort at {placename}")) +
    ggplot2::xlab(NULL) + ggplot2::ylab(NULL) +
    ggplot2::theme_classic()

  if (export == TRUE) {
    ggplot2::ggsave(
      plot = plt,
      filename = fname,
      path = local_dir,
      width = 10,
      height = 6
    )
  }
  plt
}

#' Generate a season summary from the output of \code{parse_surveys}
#'
#' \lifecycle{stable}
#'
#' @details Surveys, excluding training surveys,
#'   grouped by \code{season},
#'   summarised as first and last day of surveys, season length in days,
#'   number and total hours of surveys.
#'
#' @template param-surveys
#' @export
#' @family wastd_surveys
survey_season_stats <- function(surveys) {
  surveys %>%
    wastdr::filter_realsurveys() %>%
    dplyr::group_by(season) %>%
    dplyr::summarise(
      first_day = min(calendar_date_awst),
      last_day = max(calendar_date_awst),
      season_length_days = (as.numeric(
          lubridate::interval(first_day, last_day)
      ) / (3600 * 24)) + 1,
      number_surveys = dplyr::n(),
      hours_surveyed = round(sum(duration_hours))
    )
}


#' Generate a season by site summary from the output of \code{parse_surveys}
#'
#' \lifecycle{stable}
#'
#' @details Surveys, excluding training surveys,
#'   grouped by \code{season} and \code{site_name},
#'   summarised as first and last day of surveys, season length in days,
#'   number and total hours of surveys.
#'
#' @template param-surveys
#'
#' @export
#' @family wastd_surveys
survey_season_site_stats <- function(surveys) {
  surveys %>%
    wastdr::filter_realsurveys() %>%
    dplyr::group_by(season, site_name) %>%
    dplyr::summarise(
      first_day = min(calendar_date_awst),
      last_day = max(calendar_date_awst),
      season_length_days = (as.numeric(
          lubridate::interval(first_day, last_day)
      ) / (3600 * 24)) + 1,
      number_surveys = dplyr::n(),
      hours_surveyed = round(sum(duration_hours))
    )
}


#' Select main survey attributes
#'
#' \lifecycle{stable}
#'
#' @template param-surveys
#' @family wastd_surveys
#' @export
survey_show_detail <- function(surveys) {
  surveys %>%
    dplyr::select(
      change_url,
      site_name,
      season,
      turtle_date,
      calendar_date_awst,
      is_production,
      start_time,
      end_time,
      duration_hours,
      start_comments,
      end_comments,
      status
    )
}


#' List sites with more than one production survey on a given date
#'
#' Sites are expected to be surveyed not more than once daily with the exception
#' of turtle tagging, where a morning survey and night tagging can happen
#' legitimately on the same calendar date.
#'
#' QA operators will want to open each link from this list of potential duplicate
#' surveys, inspect their details, then decide on whether to make one the main
#' survey and close others as duplicates with the "make production" button.
#'
#' \lifecycle{stable}
#'
#' @template param-surveys
#' @family wastd_surveys
#' @export
duplicate_surveys <- function(surveys) {
  surveys %>%
    wastdr::filter_realsurveys() %>%
    dplyr::group_by(season, calendar_date_awst, site_name, site_id) %>%
    dplyr::tally() %>%
    dplyr::ungroup() %>%
    dplyr::arrange(-season, -n) %>%
    dplyr::filter(n > 1) %>%
    dplyr::mutate(
      wastd = glue::glue(
        "<a href=\"https://wastd.dbca.wa.gov.au/observations/surveys/",
        "?site={site_id}&survey_date={calendar_date_awst}\">QA surveys</a>"
      )
    )
}
# usethis::use_test("summarise_surveys")
