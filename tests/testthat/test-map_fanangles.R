test_that("map_fanangles returns a leaflet map", {
  data(wastd_data)
  themap <- map_fanangles(wastd_data)
  testthat::expect_equal(class(themap), c("leaflet", "htmlwidget"))
})

test_that("map_fanangles gatechecks for missing data", {
  expect_error(map_fanangles(NULL))
})
# use_r("map_fanangles")  # nolint
