test_that("download_wastd_users works", {
  x <- download_wastd_users()
  testthat::expect_s3_class(x, "tbl_df")
  testthat::expect_equivalent(
    names(x),
    c(
      "pk",
      "username",
      "name",
      "nickname",
      "aliases",
      "affiliation",
      "email",
      "is_active",
      "role",
      "phone"
    )
  )
})

# usethis::use_r("download_wastd_users") # nolint
