test_that("map_wamtram gatechecks for missing data", {
    expect_error(map_wamtram(NULL))
})

test_that("map_wamtram returns a leaflet htmlwidget", {
    testthat::skip(message = "TODO: include W2 data")
    # testthat::skip_if_not(require("etlTurtleNesting"))
    # data("w2_data", package="etlTurtleNesting")
    # themap <- map_wamtram(w2_data)
    # testthat::expect_equal(class(themap), c("leaflet", "htmlwidget"))
})
