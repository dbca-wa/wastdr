test_that("filter_odkc_turtledata works", {
  data("odkc_data")
  # Get an area_name that exists in the packaged data
  an <- odkc_data$tracks$area_name[[1]]

  # Filter
  x <- odkc_data %>% filter_odkc_turtledata(area_name = an)

  testthat::expect_s3_class(x, "odkc_data")
})

test_that("filter_odkc_turtledata requires a odkc_data object", {
  nonsense <- list()
  testthat::expect_error(
    nonsense %>% filter_odkc_turtledata()
  )
})

test_that("filter_odkc_turtledata returns all areas by default", {
  data("odkc_data")
  testthat::expect_message(
    x <- odkc_data %>% filter_odkc_turtledata(verbose = TRUE)
  )
})

test_that("filter_odkc_turtledata returns all areas when asked", {
  data("odkc_data")
  testthat::expect_message(
    x <- odkc_data %>%
      filter_odkc_turtledata(
        area_name = "All turtle programs",
        verbose = TRUE
      )
  )
})

test_that("filter_odkc_turtledata returns data outside areas when asked", {
  data("odkc_data")
  testthat::expect_message(
    x <- odkc_data %>%
      filter_odkc_turtledata(
        area_name = "Other",
        verbose = TRUE
      )
  )
  # Data have all areas as NA
  # testthat::expect_true(unique(x$tracks$area_name) == character(0))
  testthat::expect_true(is.na(unique(x$mwi$area_name)))
})

# usethis::use_r("filter_odkc_turtledata")  # nolint
