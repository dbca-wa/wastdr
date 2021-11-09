test_that("download_w2_data works", {
  testthat::skip_if_not(
    DBI::dbCanConnect(
      odbc::odbc(),
      Driver   = Sys.getenv("W2_DRV"),
      Server   = Sys.getenv("W2_SRV"),
      Database = Sys.getenv("W2_DB"),
      UID      = Sys.getenv("W2_UN"),
      PWD      = Sys.getenv("W2_PW"),
      Port     = Sys.getenv("W2_PT")
    ),
    message = "Turtle tagging db not accessible or configured."
  )

  x <- download_w2_data()

  testthat::expect_s3_class(x, "wamtram_data")
  testthat::expect_equal(length(x), 32,
    label = "wamtram_data should have 32 elements"
  )
})
