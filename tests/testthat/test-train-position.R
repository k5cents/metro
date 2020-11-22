test_that("current train positions found", {
  skip_if_no_key()
  Sys.sleep(0.1)
  p <- train_positions()
  expect_length(p, 9)
  expect_s3_class(p, "data.frame")
  expect_type(p$cars, "integer")
  expect_type(p$normal, "logical")
})
