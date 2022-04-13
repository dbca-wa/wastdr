test_that("ggplot_hatchling_misorientation works", {
  data(wastd_data)
  suppressWarnings(
    p1 <- wastd_data %>%
      filter_wastd_turtledata(area_name = "Thevenard Island") %>%
      ggplot_hatchling_misorientation()
  )
  testthat::expect_s3_class(p1, "ggplot")

  suppressWarnings(
    p2 <- wastd_data %>%
      filter_wastd_turtledata(area_name = "Thevenard Island") %>%
      ggplot_hatchling_misorientation() %>%
      plotly::ggplotly()
  )
  testthat::expect_s3_class(p2, "plotly")
  testthat::expect_s3_class(p2, "htmlwidget")
})
test_that("ggplot_hatchling_misorientation works with missing data", {
  data(wastd_data)

  x <- wastd_data %>% filter_wastd_turtledata(area_name = "blub")

  testthat::expect_warning(
    p1 <- x %>% ggplot_hatchling_misorientation()
  )
  testthat::expect_null(p1)

  testthat::expect_warning(
    p2 <- x %>%
      ggplot_hatchling_misorientation() %>%
      plotly::ggplotly()
  )
  testthat::expect_s3_class(p2, "shiny.tag")
})
