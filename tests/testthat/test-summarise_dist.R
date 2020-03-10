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
