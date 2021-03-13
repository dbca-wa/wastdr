test_that("filter_odkc_turtledata works", {
    data("odkc_data")
    # Get an area_name that exists in the packaged data
    an <- odkc_data$tracks$area_name[[1]]

    # Filter
    x <- odkc_data %>% filter_odkc_turtledata(area_name = an)

    testthat::expect_s3_class(x, "odkc_data")
})
