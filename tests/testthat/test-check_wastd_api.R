test_that("wastd_works return FALSE if unauthenticated", {
  expect_false(wastd_works(api_token = "invalid", api_un = "invalid"))
})

test_that("odkc_works return FALSE if unauthenticated", {
    expect_false(odkc_works(url = "http://httpstat.us/401"))
})

# usethis::use_r("check_wastd_api")
