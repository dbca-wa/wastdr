test_that("gs_getFeature works", {
  # skip if KMI GeoServer is offline or unreachable
  x <- gs_getFeature()
  expect_equal(class(x), "list")
})


# usethis::use_r("gs_getFeature")
