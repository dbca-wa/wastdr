context("wastdr_settings")

au <- "https://wastd.dbca.wa.gov.au/api/1/"
at <- "c12345asdfqwer"
un <- "username"
pw <- "password"
old_at <- Sys.getenv("WASTDR_API_TOKEN")
old_un <- Sys.getenv("WASTDR_API_UN")
old_pw <- Sys.getenv("WASTDR_API_PW")

test_that("wastdr_settings can set and get default api_url", {
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

testthat::test_that("wastdr_settings can set and get any api token", {
  wastdr_setup(api_token = at)
  testthat::expect_equal(glue::glue("Token {at}"), get_wastdr_api_token())
  wastdr_setup(api_token = old_at)
})

testthat::test_that("wastdr_settings can set and get any api username", {
  wastdr_setup(api_un = un)
  testthat::expect_equal(un, get_wastdr_api_un())
  wastdr_setup(api_un = old_un)
})

testthat::test_that("wastdr_settings can set and get any api password", {
  wastdr_setup(api_pw = pw)
  testthat::expect_equal(pw, get_wastdr_api_pw())
  wastdr_setup(api_pw = old_pw)
})
