test_that("wastd_POST returns HTTP 502 on non-existing serializers", {
  testthat::skip_if_not(wastd_works(), message = "WAStD offline or wrong auth")

  expect_warning(
    x <- wastd_POST(
      serializer = "doesnotexist", data = list(),
      # api_url = "http://localhost:8220/api/1/",
      # api_token = Sys.getenv("WASTDR_API_TOKEN_DEV"),
      verbose = TRUE
    )

    # x <- wastd_POST(
    #   serializer = "area", data=list(),
    #   api_url = "http://localhost:8220/api/1/", verbose = TRUE)
  )
  expect_equal(class(x), "wastd_api_response")
  expect_equal(x$status_code, 404)
})

test_that("wastd_POST errors on authentication failure", {
  testthat::skip_if_not(wastd_works(), message = "WAStD offline or wrong auth")

  expect_warning(
    wastd_POST(
      serializer = "",
      data = list(),
      api_token = "",
      api_un = "",
      verbose = TRUE
    )
  )
})

# usethis::use_r("wastd_POST")
