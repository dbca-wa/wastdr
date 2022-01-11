test_that("survey_count requires sid and season", {
  data("wastd_data")

  expect_error(wastd_data$surveys %>% survey_count())
  expect_error(wastd_data$surveys %>% survey_count(1L))
})

test_that("survey_count filters surveys to site_id and season", {
  data("wastd_data")

  one_season <- unique(wastd_data$surveys$season)[1]
  one_site_id <- unique(wastd_data$surveys$site_id)[1]

  manual_result <- wastd_data$surveys %>%
    dplyr::filter(site_id == one_site_id, season == one_season) %>%
    nrow()

  calculated_result <- survey_count(
    wastd_data$surveys,
    one_site_id,
    one_season
  )

  expect_equal(calculated_result, manual_result)
})

test_that("survey_ground_covered works", {
  data("wastd_data")

  one_site_id <- unique(wastd_data$surveys$site_id)[1]
  one_season <- unique(wastd_data$surveys$season)[1]
  beach_kms <- 2

  manual_result <- wastd_data$surveys %>%
    dplyr::filter(site_id == one_site_id, season == one_season) %>%
    nrow() * beach_kms

  calculated_result <- survey_ground_covered(
    wastd_data$surveys,
    one_site_id,
    beach_kms,
    one_season
  )

  expect_equal(calculated_result, manual_result)
})

test_that("surveys_per_site_name_and_date returns a tibble", {
  data("wastd_data")

  x <- surveys_per_site_name_and_date(wastd_data$surveys)

  expect_true(tibble::is_tibble(x))
  expect_equal(names(x), c("season", "turtle_date", "site_name", "n"))
})


test_that("survey_hours_per_site_name_and_date returns a tibble", {
  data("wastd_data")

  x <- survey_hours_per_site_name_and_date(wastd_data$surveys)

  expect_true(tibble::is_tibble(x))
  expect_equal(
    names(x),
    c("season", "turtle_date", "site_name", "hours_surveyed")
  )
})

test_that("survey_hours_per_person returns a tibble", {
  data("wastd_data")

  x <- survey_hours_per_person(wastd_data$surveys)

  expect_true(tibble::is_tibble(x))
  expect_equal(names(x), c("season", "reporter", "hours_surveyed"))
})


test_that("list_survey_count returns a reactable", {
  data("wastd_data")

  x <- list_survey_count(wastd_data$surveys)
  expect_equal(class(x), c("reactable", "htmlwidget"))
})

test_that("list_survey_effort returns a reactable", {
  data("wastd_data")

  x <- list_survey_effort(wastd_data$surveys)
  expect_equal(class(x), c("reactable", "htmlwidget"))
})

test_that("plot_survey_count returns a ggplot", {
  data("wastd_data")
  t <- tempdir()
  fs::dir_ls(t) %>% fs::file_delete()
  suppressWarnings(
    x <- plot_survey_count(wastd_data$surveys)
  )
  expect_equal(class(x), c("gg", "ggplot"))
  expect_false(fs::file_exists(fs::path(t, "TEST_survey_count_place.png")))

  suppressWarnings(
    x <- plot_survey_count(wastd_data$surveys,
      export = TRUE, local_dir = t,
      prefix = "TEST", placename = "PLACE"
    )
  )
  expect_equal(class(x), c("gg", "ggplot"))
  expect_true(fs::file_exists(fs::path(t, "TEST_survey_count_place.png")))
})

test_that("plot_survey_effort returns a ggplot", {
  data("wastd_data")
  t <- tempdir()
  fs::dir_ls(t) %>% fs::file_delete()

  suppressWarnings(
    x <- plot_survey_effort(wastd_data$surveys)
  )
  expect_equal(class(x), c("gg", "ggplot"))
  expect_false(fs::file_exists(fs::path(t, "TEST_survey_effort_place.png")))

  suppressWarnings(
    x <- plot_survey_effort(wastd_data$surveys,
      export = TRUE, local_dir = t,
      prefix = "TEST", placename = "PLACE"
    )
  )
  expect_equal(class(x), c("gg", "ggplot"))
  expect_true(fs::file_exists(fs::path(t, "TEST_survey_effort_place.png")))
})

test_that("survey_hours_heatmap returns a ggplot", {
  data("wastd_data")
  t <- tempdir()
  fs::dir_ls(t) %>% fs::file_delete()

  x <- survey_hours_heatmap(wastd_data$surveys)
  expect_equal(class(x), c("gg", "ggplot"))
  expect_false(fs::file_exists(fs::path(t, "TEST_survey_hours_heatmap_place.png")))

  x <- survey_hours_heatmap(wastd_data$surveys,
    export = TRUE, local_dir = t,
    prefix = "TEST", placename = "PLACE"
  )
  expect_equal(class(x), c("gg", "ggplot"))
  expect_true(fs::file_exists(fs::path(t, "TEST_survey_hours_heatmap_place.png")))
})

test_that("survey_count_heatmap returns a ggplot", {
  data("wastd_data")
  t <- tempdir()
  fs::dir_ls(t) %>% fs::file_delete()

  x <- survey_count_heatmap(wastd_data$surveys)
  expect_equal(class(x), c("gg", "ggplot"))
  expect_false(fs::file_exists(fs::path(t, "TEST_survey_count_heatmap_place.png")))

  x <- survey_count_heatmap(wastd_data$surveys,
    export = TRUE, local_dir = t,
    prefix = "TEST", placename = "PLACE"
  )
  expect_equal(class(x), c("gg", "ggplot"))
  expect_true(fs::file_exists(fs::path(t, "TEST_survey_count_heatmap_place.png")))
})

test_that("survey_season_stats returns a tibble", {
  data("wastd_data")

  x <- survey_season_stats(wastd_data$surveys)
  expect_true(tibble::is_tibble(x))
  expect_false(is.na(x$season))
  expect_false(is.na(x$first_day))
  expect_false(is.na(x$last_day))
  expect_false(is.na(x$season_length_days))

  expect_equal(class(x$season), "numeric")
  expect_equal(class(x$first_day), c("POSIXct", "POSIXt"))
  expect_equal(class(x$last_day), c("POSIXct", "POSIXt"))
  expect_equal(class(x$season_length_days), "numeric")

  expect_equal(
    names(x),
    c(
      "season",
      "first_day",
      "last_day",
      "season_length_days",
      "number_surveys",
      "hours_surveyed"
    )
  )
})

test_that("survey_season_site_stats returns a tibble", {
  data("wastd_data")

  x <- survey_season_site_stats(wastd_data$surveys)
  expect_true(tibble::is_tibble(x))
  expect_equal(
    names(x),
    c(
      "season",
      "site_name",
      "first_day",
      "last_day",
      "season_length_days",
      "number_surveys",
      "hours_surveyed"
    )
  )
})

test_that("survey_show_detail returns a tibble", {
  data("wastd_data")

  x <- survey_show_detail(wastd_data$surveys)
  expect_true(tibble::is_tibble(x))
  expect_equal(
    names(x),
    c(
      "change_url",
      "site_name",
      "season",
      "turtle_date",
      "calendar_date_awst",
      "is_production",
      "start_time",
      "end_time",
      "duration_hours",
      "start_comments",
      "end_comments",
      "status"
    )
  )
})

test_that("duplicate_surveys returns a tibble", {
  data("wastd_data")

  x <- duplicate_surveys(wastd_data$surveys)
  expect_true(tibble::is_tibble(x))

  expect_equal(
    names(x),
    c(
      "season",
      "calendar_date_awst",
      "site_name",
      "site_id",
      "n",
      "wastd"
    )
  )
})


# usethis::use_r("summarise_surveys")
