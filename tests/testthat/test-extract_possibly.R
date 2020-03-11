context("extract_possibly")

lol <- list(
  field1 = 1,
  field2 = 2,
  field3 = list(
    field4 = 4,
    field5 = 5,
    field6 = list(
      field7 = 7,
      field8 = 8
    )
  )
)

test_that("extract_possibly returns list", {
  fa <- extract_possibly(lol, "field1")
  testthat::expect_type(fa, "list")

  fb <- extract_possibly(lol, "field3")
  testthat::expect_type(fb, "list")

  fc <- extract_possibly(lol, "field7")
  testthat::expect_type(fc, "list")
})

test_that("extract_possibly extracts only top level fields", {
  fa <- extract_possibly(lol, "field1")
  testthat::expect_true("field1" %in% names(fa))

  fb <- extract_possibly(lol, "field4")
  testthat::expect_false("field4" %in% names(fb))

  fc <- extract_possibly(lol, "field7")
  testthat::expect_false("field7" %in% names(fc))
})

test_that("extract_possibly extracts only top level values", {
  fa <- extract_possibly(lol, "field1")
  testthat::expect_equal(fa$field1, 1)

  fb <- extract_possibly(lol, "field4")
  testthat::expect_equal(fb[[1]], NULL)

  fc <- extract_possibly(lol, "field7")
  testthat::expect_equal(fc[[1]], NULL)
})

# usethis::use_r("extract_possibly")
