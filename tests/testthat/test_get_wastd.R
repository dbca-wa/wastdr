context("get_wastd")

testthat::test_that("get_wastd won't work unauthenticated", {
    wastdr_setup(api_token = "this-is-an-invalid-token")
    testthat::expect_error(get_wastd("animal-encounters"))
})


wastd_api_works <- function(){
    ua <- httr::user_agent("http://github.com/parksandwildlife/turtle-scripts")
    res <- httr::GET(get_wastdr_api_url(), ua,
                     httr::add_headers(c(Authorization = get_wastdr_api_token())))
    res$status_code == 200
}

testthat::test_that("get_wastd works with correct API token", {
    # API token available?
    token <- Sys.getenv("MY_API_TOKEN")
    if (token == "") skip("Environment variable MY_API_TOKEN not set, skipping...")
    wastdr_setup(api_token = token)

    # API accessible?
    if (wastd_api_works() == FALSE) skip("WAStD API is not accessible from here, skipping...")

    ae <- get_wastd("animal-encounters", query = list(limit = 3, format = "json"))
    capture.output(print(ae))
    testthat::expect_equal(ae$response$status_code, 200)
})
