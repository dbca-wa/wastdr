test_that("download_odkc_turtledata_2019 works", {
  testthat::skip_if(Sys.getenv("WASTDR_SKIP_SLOW_TESTS", unset = FALSE) == TRUE,
    message = "Skip slow running tests"
  )

  ruODK::ru_setup(
    url = ruODK::get_default_url(),
    un = ruODK::get_default_un(),
    pw = ruODK::get_default_pw(),
    odkc_version = 0.7,
    verbose = ruODK::get_ru_verbose()
  )
  testthat::skip_if_not(odkc_works(), message = "ODKC offline or wrong auth")


  x <- suppressWarnings(
    download_odkc_turtledata_2019(
      local_dir = tempdir(),
      download = FALSE,
      verbose = TRUE # pin for debugging GHA error
    )
  )
  expect_equal(class(x), "odkc_turtledata")
  expect_equal(length(x), 19) # This will change if we add more data
  xout <- capture.output(print(x))
  expect_true(stringr::str_detect(xout[[1]], "ODKC Turtle Data"))
  expect_true(stringr::str_detect(xout[[2]], "Areas"))
  expect_equal(length(xout), 9) # This will change if we add more data
})

# usethis::use_r("download_odkc_turtledata_2019")
