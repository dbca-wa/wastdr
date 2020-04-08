sf_as_tbl
test_that("sf_as_tbl returns a tibble", {
  data("wastd_data")

  x <- sf_as_tbl(wastd_data$sites)

  expect_true(tibble::is_tibble(x))
})



test_that("nesting_type_by_season_species returns a tibble", {
  data("wastd_data")

  x <- nesting_type_by_season_species(wastd_data$tracks)
  expect_true("season" %in% names(wastd_data$tracks))
  expect_true("species" %in% names(wastd_data$tracks))
  expect_true("nest_age" %in% names(wastd_data$tracks))
  expect_true("nest_type" %in% names(wastd_data$tracks))


  expect_true(tibble::is_tibble(x))
  expect_true("season" %in% names(x))
  expect_true("species" %in% names(x))
})

test_that("nesting_type_by_season_age_species returns a tibble", {
  data("wastd_data")

  x <- nesting_type_by_season_age_species(wastd_data$tracks)
  expect_true("season" %in% names(wastd_data$tracks))
  expect_true("species" %in% names(wastd_data$tracks))
  expect_true("nest_age" %in% names(wastd_data$tracks))
  expect_true("nest_type" %in% names(wastd_data$tracks))

  expect_true(tibble::is_tibble(x))

  expect_true("season" %in% names(x))
  expect_true("species" %in% names(x))
  expect_true("nest_age" %in% names(x))
})


test_that("nesting_type_by_area_season_species returns a tibble", {
  data("wastd_data")

  x <- nesting_type_by_area_season_species(wastd_data$tracks)

  expect_true(tibble::is_tibble(x))
  expect_true("area_name" %in% names(x))
  expect_true("season" %in% names(x))
  expect_true("species" %in% names(x))
})


test_that("nesting_type_by_area_season_age_species returns a tibble", {
  data("wastd_data")

  x <- nesting_type_by_area_season_age_species(wastd_data$tracks)

  expect_true(tibble::is_tibble(x))
  expect_true("area_name" %in% names(x))
  expect_true("season" %in% names(x))
  expect_true("species" %in% names(x))
  expect_true("nest_age" %in% names(x))
})

test_that("nesting_type_by_site_season_species returns a tibble", {
  data("wastd_data")

  x <- nesting_type_by_site_season_species(wastd_data$tracks)

  expect_true(tibble::is_tibble(x))
  expect_true("area_name" %in% names(x))
  expect_true("site_name" %in% names(x))
  expect_true("season" %in% names(x))
  expect_true("species" %in% names(x))
})


test_that("nesting_type_by_site_season_age_species returns a tibble", {
  data("wastd_data")

  x <- nesting_type_by_site_season_age_species(wastd_data$tracks)

  expect_true(tibble::is_tibble(x))
  expect_true("area_name" %in% names(x))
  expect_true("site_name" %in% names(x))
  expect_true("season" %in% names(x))
  expect_true("species" %in% names(x))
  expect_true("nest_age" %in% names(x))
})



test_that("nesting_type_by_season_week_age_species returns a tibble", {
  data("wastd_data")

  x <- nesting_type_by_season_week_age_species(wastd_data$tracks)

  expect_true(tibble::is_tibble(x))
  expect_true("season" %in% names(x))
  expect_true("season_week" %in% names(x))
  expect_true("iso_week" %in% names(x))
  expect_true("species" %in% names(x))
  expect_true("nest_age" %in% names(x))
})


test_that("nesting_type_by_season_week_site_species returns a tibble", {
  data("wastd_data")

  x <- nesting_type_by_season_week_site_species(wastd_data$tracks)

  expect_true(tibble::is_tibble(x))
  expect_true("site_name" %in% names(x))
  expect_true("season" %in% names(x))
  expect_true("season_week" %in% names(x))
  expect_true("iso_week" %in% names(x))
  expect_true("species" %in% names(x))
})


test_that("nesting_type_by_season_day_species returns a tibble", {
  data("wastd_data")

  x <- nesting_type_by_season_day_species(wastd_data$tracks)

  expect_true(tibble::is_tibble(x))
  expect_true("season" %in% names(x))
  expect_true("turtle_date" %in% names(x))
  expect_true("species" %in% names(x))
  expect_true("nest_type" %in% names(x))
  expect_true("n" %in% names(x))
})

test_that("nesting_type_by_season_calendarday_species returns a tibble", {
  data("wastd_data")

  x <-
    nesting_type_by_season_calendarday_species(wastd_data$tracks)

  expect_true(tibble::is_tibble(x))
  expect_true("season" %in% names(x))
  expect_true("calendar_date_awst" %in% names(x))
  expect_true("species" %in% names(x))
})

test_that("nesting_type_by_season_week_species returns a tibble", {
  data("wastd_data")

  x <- nesting_type_by_season_week_species(wastd_data$tracks)

  expect_true(tibble::is_tibble(x))
  expect_true("season" %in% names(x))
  expect_true("season_week" %in% names(x))
  expect_true("iso_week" %in% names(x))
  expect_true("species" %in% names(x))
})

test_that("nesting_type_by_season_calendarday_age_species returns a tibble", {
  data("wastd_data")

  x <-
    nesting_type_by_season_calendarday_age_species(wastd_data$tracks)

  expect_true(tibble::is_tibble(x))
  expect_true("season" %in% names(x))
  expect_true("calendar_date_awst" %in% names(x))
  expect_true("species" %in% names(x))
  expect_true("nest_age" %in% names(x))
})


# track_success
test_that("track_success returns a tibble", {
  data("wastd_data")

  x <- track_success(wastd_data$tracks)

  expect_true(tibble::is_tibble(x))
  expect_true("season" %in% names(x))
  expect_true("turtle_date" %in% names(x))
  expect_true("species" %in% names(x))
})


test_that("track_success_by_species returns a tibble", {
  data("wastd_data")

  x <- track_success(wastd_data$tracks) %>% track_success_by_species()

  expect_true(tibble::is_tibble(x))
  expect_true("season" %in% names(x))
  expect_true("species" %in% names(x))
  expect_true("mean_nesting_success" %in% names(x))
  expect_true("sd_nesting_success" %in% names(x))
})


test_that("ggplot_track_success_by_date returns a ggplot", {
  data("wastd_data")
  sp <- unique(wastd_data$tracks$species)[1]

  x <- track_success(wastd_data$tracks) %>%
    ggplot_track_success_by_date(sp, local_dir = tempdir(), export = TRUE)

  expect_equal(class(x), c("gg", "ggplot"))
})


test_that("ggplot_track_success_by_date returns a ggplot with export=FALSE", {
  data("wastd_data")
  sp <- unique(wastd_data$tracks$species)[1]

  x <- track_success(wastd_data$tracks) %>%
    ggplot_track_success_by_date(sp,
      local_dir = tempdir(),
      export = FALSE
    )

  expect_equal(class(x), c("gg", "ggplot"))
})

test_that("ggplot_track_successrate_by_date returns a ggplot", {
  data("wastd_data")
  sp <- unique(wastd_data$tracks$species)[1]

  x <- track_success(wastd_data$tracks) %>%
    ggplot_track_successrate_by_date(sp,
      local_dir = tempdir(),
      export = TRUE
    )

  expect_equal(class(x), c("gg", "ggplot"))
})

test_that(
  "ggplot_track_successrate_by_date returns a ggplot with export=FALSE",
  {
    data("wastd_data")
    sp <- unique(wastd_data$tracks$species)[1]

    x <- track_success(wastd_data$tracks) %>%
      ggplot_track_successrate_by_date(sp,
        local_dir = tempdir(),
        export = FALSE
      )

    expect_equal(class(x), c("gg", "ggplot"))
  }
)

test_that("summarise_hatching_and_emergence_success returns a tibble", {
  data("wastd_data")

  x <- summarise_hatching_and_emergence_success(wastd_data$nest_excavations)
  # Test data can collapse variables if all NULL
  # egg_count
  # egg_count_calculated
  expect_true(tibble::is_tibble(x))
  expect_true("count" %in% names(x))
  expect_true("clutch_size_fresh" %in% names(x))
  expect_true("clutch_size_mean" %in% names(x))
  expect_true("clutch_size_sd" %in% names(x))
  expect_true("clutch_size_min" %in% names(x))
  expect_true("clutch_size_max" %in% names(x))
  expect_true("hatching_success_mean" %in% names(x))
  expect_true("hatching_success_sd" %in% names(x))
  expect_true("hatching_success_min" %in% names(x))
  expect_true("hatching_success_max" %in% names(x))
  expect_true("emergence_success_mean" %in% names(x))
  expect_true("emergence_success_sd" %in% names(x))
  expect_true("emergence_success_min" %in% names(x))
  expect_true("emergence_success_max" %in% names(x))
})

test_that("hatching_emergence_success_area returns a tibble", {
  data("wastd_data")

  x <- hatching_emergence_success_area(wastd_data$nest_excavations)

  expect_true(tibble::is_tibble(x))

  expect_true("encounter_area_name" %in% names(x))
  expect_true("season" %in% names(x))
  expect_true("species" %in% names(x))
  expect_true("count" %in% names(x))
  expect_true("clutch_size_fresh" %in% names(x))
  expect_true("clutch_size_mean" %in% names(x))
  expect_true("clutch_size_sd" %in% names(x))
  expect_true("clutch_size_min" %in% names(x))
  expect_true("clutch_size_max" %in% names(x))
  expect_true("hatching_success_mean" %in% names(x))
  expect_true("hatching_success_sd" %in% names(x))
  expect_true("hatching_success_min" %in% names(x))
  expect_true("hatching_success_max" %in% names(x))
  expect_true("emergence_success_mean" %in% names(x))
  expect_true("emergence_success_sd" %in% names(x))
  expect_true("emergence_success_min" %in% names(x))
  expect_true("emergence_success_max" %in% names(x))
})


test_that("hatching_emergence_success_site returns a tibble", {
  data("wastd_data")

  x <- hatching_emergence_success_site(wastd_data$nest_excavations)

  expect_true(tibble::is_tibble(x))

  expect_true("encounter_site_name" %in% names(x))
  expect_true("season" %in% names(x))
  expect_true("species" %in% names(x))
  expect_true("count" %in% names(x))
  expect_true("clutch_size_fresh" %in% names(x))
  expect_true("clutch_size_mean" %in% names(x))
  expect_true("clutch_size_sd" %in% names(x))
  expect_true("clutch_size_min" %in% names(x))
  expect_true("clutch_size_max" %in% names(x))
  expect_true("hatching_success_mean" %in% names(x))
  expect_true("hatching_success_sd" %in% names(x))
  expect_true("hatching_success_min" %in% names(x))
  expect_true("hatching_success_max" %in% names(x))
  expect_true("emergence_success_mean" %in% names(x))
  expect_true("emergence_success_sd" %in% names(x))
  expect_true("emergence_success_min" %in% names(x))
  expect_true("emergence_success_max" %in% names(x))
})

# usethis::use_r("summarise_tracks")
