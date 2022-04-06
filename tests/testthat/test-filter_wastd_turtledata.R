test_that("filter_wastd_turtledata returns a valid wastd_data object", {
  data("wastd_data")
  # Get an area_name that exists in the packaged data
  an <- wastd_data$tracks %>%
    tidyr::drop_na(area_name) %>%
    dplyr::select(area_name) %>%
    .[1, ] %>%
    unlist()
  x <- wastd_data %>% filter_wastd_turtledata(area_name = an)
  testthat::expect_s3_class(x, "wastd_data")
})

test_that("filter_wastd_turtledata requires a wastd_data object", {
  nonsense <- list()
  testthat::expect_error(
    nonsense %>% filter_wastd_turtledata()
  )
})

test_that("filter_wastd_turtledata returns all areas by default", {
  data("wastd_data")
  testthat::expect_message(
    x <- wastd_data %>% filter_wastd_turtledata(verbose = TRUE)
  )
})

test_that("filter_wastd_turtledata returns all areas when asked", {
  data("wastd_data")
  testthat::expect_message(
    x <- wastd_data %>%
      filter_wastd_turtledata(area_name = "All turtle programs", verbose = TRUE)
  )
})

test_that("filter_wastd_turtledata returns data outside areas when asked", {
  data("wastd_data")
  # testthat::expect_message(
  x <- wastd_data %>%
    filter_wastd_turtledata(area_name = wastd_data$tracks$area_name[[1]])
  # )
  # Data have all areas as NA
  testthat::expect_true(length(unique(x$tracks$area_name)) == 1)
  testthat::expect_true(length(unique(x$animals$area_name)) == 1)
})

test_that("filter_wastd_turtledata filters one season", {
  data(wastd_data)
  first_season <- wastd_data$tracks$season[[1]]
  x <- wastd_data %>% filter_wastd_turtledata(seasons = c(first_season))
  testthat::expect_s3_class(x, "wastd_data")
  seasons_present <- unique(x$tracks$season)
  testthat::expect_true(first_season %in% seasons_present)
})

test_that("filter_wastd_turtledata filters multiple seasons", {
  data(wastd_data)
  first_season <- wastd_data$tracks$season[[1]]
  x <- wastd_data %>% filter_wastd_turtledata(seasons = c(first_season, 2020))
  testthat::expect_s3_class(x, "wastd_data")
  seasons_present <- unique(x$tracks$season)
  testthat::expect_true(first_season %in% seasons_present)
})

# usethis::use_r("filter_wastd_turtledata")  # nolint
