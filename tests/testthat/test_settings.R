context("wastdr_settings")

au <- "https://strandings.dpaw.wa.gov.au/api/1/"
at <- "c12345asdfqwer"

testthat::test_that("wastdr_settings can set and get default api_url", {
    wastdr_setup()
    testthat::expect_equal(get_wastdr_api_url(), au)
})

testthat::test_that("wastdr_settings can set and get any api_url", {
    wastdr_setup(api_url = au)
    testthat::expect_equal(get_wastdr_api_url(), au)
})

testthat::test_that("ckanr_settings can set and get any api token", {
    wastdr_setup(api_token = at)
    token_string <- paste("Token", at)
    testthat::expect_equal(token_string, get_wastdr_api_token())
})
