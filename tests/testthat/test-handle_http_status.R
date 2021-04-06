test_that("handle_http_status warns about HTTP error", {
  expect_warning(handle_http_status(httr::GET("http://httpstat.us/401"), verbose = TRUE))
  expect_warning(handle_http_status(httr::GET("http://httpstat.us/404"), verbose = TRUE))
  expect_warning(handle_http_status(httr::GET("http://httpstat.us/500"), verbose = TRUE))

  expect_warning(
    wastd_GET("area", max_records = 1, verbose = TRUE, format = "csv")
  )
})
# usethis::use_r("handle_http_status")
