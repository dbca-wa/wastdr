test_that("multiplication works", {
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
