test_that("wastd_works returns FALSE if unauthenticated", {
  suppressWarnings(
    expect_false(
      wastd_works(api_url = "http://httpstat.us/401")
    )
  )
})

test_that("odkc_works returns FALSE if unauthenticated", {
  expect_false(odkc_works(url = "http://httpstat.us/401"))
})

# usethis::use_r("check_wastd_api")
