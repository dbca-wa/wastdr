test_that("skip_test_if_wastd_offline works", {
  x <- skip_test_if_wastd_offline()
  expect_true(TRUE) # If we make it this far, above has worked

  # This will redirect to MS SSO and return 200
  skip_test_if_wastd_offline(api_token = "", api_un = "")
})



# usethis::use_r("check_wastd_api")
