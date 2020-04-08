# ---------------------------------------------------------------------------- #
# filter_disturbance
#
test_that("filter_disturbance excludes predation from wastd_data$nest_dist", {
  data("wastd_data")

  filtered_data <- wastd_data$nest_dist %>% filter_disturbance()
  filtered_values <- unique(filtered_data$disturbance_cause)

  excluded_values <- c(
    "bandicoot",
    "bird",
    "cat",
    "crab",
    "croc",
    "dingo",
    "dog",
    "fox",
    "goanna",
    "pig"
  )

  for (x in excluded_values)
    expect_false(
      x %in% filtered_values,
      label = glue::glue("{x} found but should have been excluded")
    )
})

test_that("filter_disturbance excludes predation from odkc_data$tracks_dist", {
  data("odkc_data")

  filtered_data <- odkc_data$tracks_dist %>% filter_disturbance()
  filtered_values <- unique(filtered_data$disturbance_cause)

  excluded_values <- c(
    "bandicoot",
    "bird",
    "cat",
    "crab",
    "croc",
    "dingo",
    "dog",
    "fox",
    "goanna",
    "pig"
  )

  for (x in excluded_values)
    expect_false(
      x %in% filtered_values,
      label = glue::glue("{x} found but should have been excluded")
    )
})

test_that("filter_disturbance excludes general predation from odkc_data$dist", {
  data("odkc_data")

  filtered_data <- odkc_data$dist %>% filter_disturbance()
  filtered_values <- unique(filtered_data$disturbanceobservation_disturbance_cause)

  excluded_values <- c(
    "bandicoot",
    "bird",
    "cat",
    "crab",
    "croc",
    "dingo",
    "dog",
    "fox",
    "goanna",
    "pig"
  )

  for (x in excluded_values)
    expect_false(
      x %in% filtered_values,
      label = glue::glue("{x} found but should have been excluded")
    )
})

# ---------------------------------------------------------------------------- #
# filter_predation
#
test_that("filter_predation excludes disturbance from wastd_data$nest_dist", {
  data("wastd_data")

  filtered_data <- wastd_data$nest_dist %>% filter_predation()
  filtered_values <- unique(filtered_data$disturbance_cause)

  excluded_values <- c(
    "human",
    "unknown",
    "tide",
    "turtle",
    "other",
    "vehicle",
    "cyclone"
  )

  for (x in excluded_values)
    expect_false(
      x %in% filtered_values,
      label = glue::glue("{x} found but should have been excluded")
    )
})


test_that("filter_predation excludes all disturbance from odkc_data$tracks_dist", {
  data("odkc_data")

  filtered_data <- odkc_data$tracks_dist %>% filter_predation()
  filtered_values <- unique(filtered_data$disturbance_cause)

  excluded_values <- c(
    "human",
    "unknown",
    "tide",
    "turtle",
    "other",
    "vehicle",
    "cyclone"
  )

  for (x in excluded_values)
    expect_false(
      x %in% filtered_values,
      label = glue::glue("{x} found but should have been excluded")
    )
})

test_that("filter_predation excludes general disturbance from odkc_data$dist", {
  data("odkc_data")

  filtered_data <- odkc_data$dist %>% filter_predation()
  filtered_values <- unique(filtered_data$disturbanceobservation_disturbance_cause)

  excluded_values <- c(
    "human",
    "unknown",
    "tide",
    "turtle",
    "other",
    "vehicle",
    "cyclone"
  )

  for (x in excluded_values)
    expect_false(
      x %in% filtered_values,
      label = glue::glue("{x} found but should have been excluded")
    )
})

# ---------------------------------------------------------------------------- #
# Summary helpers
#
test_that("disturbance_by_season works", {
  data("wastd_data")
  x1 <- wastd_data$nest_dist %>% disturbance_by_season()
  expect_true(tibble::is_tibble(x1))
  expect_equivalent(
    names(x1), c("season", "disturbance_cause", "encounter_type", "n")
  )
})

test_that("nest_disturbance_by_season_odkc works", {
  data("odkc_data")
  x2 <- odkc_data$tracks_dist %>% nest_disturbance_by_season_odkc()
  expect_true(tibble::is_tibble(x2))
  expect_setequal(
    names(x2), c("season", "disturbance_cause", "n", "encounter_type")
  )
})

test_that("general_disturbance_by_season_odkc works", {
  data("odkc_data")
  x3 <- odkc_data$dist %>% general_disturbance_by_season_odkc()
  expect_true(tibble::is_tibble(x3))
  expect_setequal(
    names(x3), c("season", "disturbance_cause", "n", "encounter_type")
  )
})

# usethis::use_r("summarise_dist")
