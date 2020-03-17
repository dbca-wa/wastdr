test_that("filter_disturbance excludes all predation from wastd data", {
  data("wastd_data")

  x <- wastd_data$nest_dist %>% filter_disturbance()
  xn <- unique(x$disturbance_cause)

  expect_false("bandicoot" %in% xn)
  expect_false("bird" %in% xn)
  expect_false("cat" %in% xn)
  expect_false("crab" %in% xn)
  expect_false("croc" %in% xn)
  expect_false("dingo" %in% xn)
  expect_false("dog" %in% xn)
  expect_false("fox" %in% xn)
  expect_false("goanna" %in% xn)
  expect_false("pig" %in% xn)
})

test_that("filter_predation excludes all disturbance from wastd data", {
  data("wastd_data")

  x <- wastd_data$nest_dist %>% filter_predation()
  xn <- unique(x$disturbance_cause)

  expect_false("human" %in% xn)
  expect_false("unknown" %in% xn)
  expect_false("tide" %in% xn)
  expect_false("turtle" %in% xn)
  expect_false("other" %in% xn)
  expect_false("vehicle" %in% xn)
  expect_false("cyclone" %in% xn)
})


test_that("filter_disturbance excludes all predation from odkc data", {
  data("odkc_data")

  x <- odkc_data$tracks_dist %>% filter_disturbance()
  xn <- unique(x$disturbance_cause)

  expect_false("bandicoot" %in% xn)
  expect_false("bird" %in% xn)
  expect_false("cat" %in% xn)
  expect_false("crab" %in% xn)
  expect_false("croc" %in% xn)
  expect_false("dingo" %in% xn)
  expect_false("dog" %in% xn)
  expect_false("fox" %in% xn)
  expect_false("goanna" %in% xn)
  expect_false("pig" %in% xn)
})

test_that("filter_predation excludes all disturbance from odkc data", {
  data("odkc_data")

  x <- odkc_data$tracks_dist %>% filter_predation()
  xn <- unique(x$disturbance_cause)

  expect_false("human" %in% xn)
  expect_false("unknown" %in% xn)
  expect_false("tide" %in% xn)
  expect_false("turtle" %in% xn)
  expect_false("other" %in% xn)
  expect_false("vehicle" %in% xn)
  expect_false("cyclone" %in% xn)
})


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
