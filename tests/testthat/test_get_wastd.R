context("get_wastd")

testthat::test_that("get_wastd won't work unauthenticated", {
    wastdr_setup(api_token = "this-is-an-invalid-token")
    testthat::expect_error(get_wastd("animal-encounters"))
})
