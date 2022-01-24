test_that("map_wastd gatechecks for missing data", {
    expect_error(map_wastd(NULL))
})

test_that("map_wastd returns a leaflet htmlwidget", {
    data("wastd_data")
    themap <- map_wastd(wastd_data)
    testthat::expect_equal(class(themap), c("leaflet", "htmlwidget"))
})
