#' Parse a \code{wastd_api_response} of \code{animal-encounters} to tbl_df
#'
#'
#' @param wastd_api_response A \code{wastd_api_response} of
#' \code{animal-encounters}, e.g. \code{get_wastd("animal-encounters")}
#' @return A \code{tbl_df} with columns:
#' \itemize{
#'   \item site_name <chr>
#'   \item site_type <chr>
#'   \item site_id <int>
#'   \item reporter <chr>
#'   \item reporter_username <chr>
#'   \item reporter_id <chr>
#'   \item date <dttm> The "turtle date" of the survey.
#'   \item start_time <dttm> The actual start time of the survey.
#'   \item end_time <dttm> The actual, automatically guessed (if 6h later), or human guessed end time.
#'   \item start_comments <chr> Comments at start plus QA messages from username guessing
#'   \item end_comments <chr> Comments at end plus QA messages from username guessing. A mismatch
#'         of original usernames can indicate an incorrectly picked Site Visit End point.
#'   \item source <chr> Where this record was born.
#'   \item source_id <chr> The ODK record UID of the Site Visit Start.
#'   \item end_source_id <chr> The ODK record UID of the Site Visit End.
#'   \item status <chr> The QA status of the Survey. "Proofread" or "Curated" indicate human QA edits.
#'   \item device_id <chr> The unique ID of the device the Site Visit Start was captured on.
#'   \item end_device_id <chr> The unique ID of the device the Site Visit End was captured on.
#' }
#' @export
#' @import magrittr
#' @importFrom tibble tibble
#' @importFrom purrr map map_chr map_dbl
#' @importFrom lubridate interval as.period
parse_surveys <- function(wastd_api_response) {
  obs <- NULL
  . <- NULL
  start_time <- NULL
  end_time <- NULL
  duration_minutes <- NULL
  wastd_api_response$features %>%
    {
      tibble::tibble(
        site_name = map_chr_hack(., c("properties", "site", "name")),
        site_type = map_chr_hack(., c("properties", "site", "area_type")),
        site_id = map_chr_hack(., c("properties", "site", "pk")) %>% as.integer(),
        reporter = map_chr_hack(., c("properties", "reporter", "name")),
        reporter_username = map_chr_hack(., c("properties", "reporter", "username")),
        reporter_id = map_chr_hack(., c("properties", "reporter", "pk")),
        date = purrr::map_chr(., c("properties", "start_time")) %>% httpdate_as_gmt08_turtle_date(),
        start_time = purrr::map_chr(., c("properties", "start_time")) %>% httpdate_as_gmt08(),
        end_time = map_chr_hack(., c("properties", "end_time")) %>% httpdate_as_gmt08(),
        start_comments = map_chr_hack(., c("properties", "start_comments")),
        end_comments = map_chr_hack(., c("properties", "end_comments")),
        source = purrr::map_chr(., c("properties", "source")),
        source_id = purrr::map_chr(., c("properties", "source_id")),
        end_source_id = map_chr_hack(., c("properties", "end_source_id")),
        device_id = map_chr_hack(., c("properties", "device_id")),
        end_device_id = map_chr_hack(., c("properties", "end_device_id")),
        status = map_chr_hack(., c("properties", "status"))
        # transect, start_photo, end_photo, start_location, end_location, team
      )
    } %>%
    dplyr::mutate(
      duration_minutes = (interval(start_time, end_time) %>% as.period() %>% as.numeric() %>% round()) / 60,
      duration_hours = duration_minutes / 60
    )
}

#' Count number of surveys per site_name and date from the output of \code{parse_surveys}.
#'
#' @param surveys (tibble) The output of \code{parse_surveys}.
#' @return A tibble with columns date, site_name, n (number of surveys)
#' @importFrom dplyr group_by tally ungroup
#' @export
surveys_per_site_name_and_date <- function(surveys) {
  site_name <- NULL
  surveys %>%
    dplyr::group_by(date, site_name) %>%
    dplyr::tally() %>%
    dplyr::ungroup()
}

#' Sum the hours surveyed per site_name and date from the output of \code{parse_surveys}.
#'
#' @param surveys (tibble) The output of \code{parse_surveys}.
#' @return A tibble with columns date, site_name, hours_surveyed
#' @importFrom dplyr group_by tally ungroup mutate select
#' @export
survey_hours_per_site_name_and_date <- function(surveys) {
  site_name <- NULL
  duration_hours <- NULL
  n <- NULL
  surveys %>%
    dplyr::group_by(date, site_name) %>%
    tally(duration_hours) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(hours_surveyed = round(n)) %>%
    dplyr::select(-n)
}

#' Sum the hours surveyed per person from the output of \code{parse_surveys}.
#'
#' @param surveys (tibble) The output of \code{parse_surveys}.
#' @return A tibble with columns reporter, hours_surveyed, sorted by most to fewest hours.
#' @importFrom dplyr group_by tally ungroup mutate select
#' @export
survey_hours_per_person <- function(surveys) {
  reporter <- NULL
  duration_hours <- NULL
  hours_surveyed <- NULL
  n <- NULL
  desc <- NULL

  surveys %>%
    dplyr::group_by(reporter) %>%
    tally(duration_hours) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(hours_surveyed = round(n)) %>%
    dplyr::select(-n) %>%
    dplyr::arrange(desc(hours_surveyed))
}

#' Create a datatable of survey counts from the output of \code{parse_surveys}.
#'
#' @param surveys (tibble) The output of \code{parse_surveys}.
#' @param placename (string) The place name, used in labels.
#' @importFrom DT datatable
#' @export
list_survey_count <- function(surveys, placename) {
  . <- NULL
  surveys %>%
    surveys_per_site_name_and_date() %>%
    DT::datatable(., caption = paste("Survey Count", placename))
}

#' Plot the surveyed hours from the output of \code{parse_surveys}.
#'
#' @param surveys (tibble) The output of \code{parse_surveys}.
#' @param placename (string) The place name, used in labels.
#' @export
plot_survey_count <- function(surveys, placename) {
  . <- NULL
  aes <- NULL
  site_name <- NULL
  n <- NULL
  surveys %>%
    surveys_per_site_name_and_date() %>%
    ggplot2::ggplot(., aes(date, site_name, fill = n)) +
    ggplot2::geom_raster() +
    # ggplot2::scale_x_date(
    #   breaks = scales::pretty_breaks,
    #   labels = scales::date_format("%d %b %Y")
    # ) +
    ggplot2::theme_light() +
    ggplot2::ggtitle(paste("Survey Count", placename)) +
    ggplot2::labs(x = "Turtle date", y = "", fill = "Number of surveys") +
    ggplot2::ggsave(
      filename = paste0(
        "survey_count_",
        stringr::str_replace_all(placename, " ", "_"),
        ".png"
      ), width = 9, height = 5
    )
}

#' Create a datatable from the surveyed hours from the output of \code{parse_surveys}.
#'
#' @param surveys (tibble) The output of \code{parse_surveys}.
#' @param placename (string) The place name, used in labels.
#' @export
list_survey_effort <- function(surveys, placename) {
  . <- NULL
  surveys %>%
    survey_hours_per_site_name_and_date() %>%
    DT::datatable(., caption = paste("Survey Effort [hours]", placename))
}

#' Plot the surveyed hours from the output of \code{parse_surveys}.
#'
#' @param surveys (tibble) The output of \code{parse_surveys}.
#' @param placename (string) The place name, used in labels.
#' @export
plot_survey_effort <- function(surveys, placename) {
  . <- NULL
  aes <- NULL
  site_name <- NULL
  n <- NULL
  hours_surveyed <- NULL
  surveys %>%
    survey_hours_per_site_name_and_date() %>%
    ggplot2::ggplot(., aes(date, site_name, fill = hours_surveyed)) +
    ggplot2::geom_raster() +
    ggplot2::scale_x_date(
      breaks = scales::pretty_breaks(),
      labels = scales::date_format("%d %b %Y")
    ) +
    ggplot2::theme_light() +
    ggplot2::ggtitle(paste("Survey Effort", placename)) +
    ggplot2::labs(x = "Turtle date", y = "", fill = "Hours surveyed") +
    ggplot2::ggsave(
      filename = paste0(
        "survey_effort_",
        stringr::str_replace_all(placename, " ", "_"),
        ".png"
      ), width = 9, height = 5
    )
}
