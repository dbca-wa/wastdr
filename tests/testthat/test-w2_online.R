test_that("w2_online returns FALSE with missing credentials", {
  expect_false(w2_online(db_drv=NULL))
})
