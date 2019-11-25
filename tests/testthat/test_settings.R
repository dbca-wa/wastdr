context("wastdr_settings")

au <- "https://tsc.dbca.wa.gov.au/api/1/"
at <- "c12345asdfqwer"
un <- "username"
pw <- "password"

testthat::test_that("wastdr_settings can set and get default api_url", {
  wastdr_setup()
  testthat::expect_equal(get_wastdr_api_url(), au)
  s <- wastdr_settings()
  capture.output(print(s))
  testthat::expect_s3_class(s, "wastdr_settings")
})

testthat::test_that("wastdr_settings can set and get any api_url", {
  wastdr_setup(api_url = au)
  testthat::expect_equal(get_wastdr_api_url(), au)
})

testthat::test_that("ckanr_settings can set and get any api token", {
  wastdr_setup(api_token = at)
  testthat::expect_equal(at, get_wastdr_api_token())
})

testthat::test_that("ckanr_settings can set and get any api username", {
  wastdr_setup(api_un = un)
  testthat::expect_equal(un, get_wastdr_api_un())
})

testthat::test_that("ckanr_settings can set and get any api password", {
  wastdr_setup(api_pw = pw)
  testthat::expect_equal(pw, get_wastdr_api_pw())
})
