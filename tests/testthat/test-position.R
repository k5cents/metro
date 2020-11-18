test_that("current train positions found", {
  p <- train_positions()
  expect_length(p, 9)
  expect_s3_class(p, "data.frame")
  expect_type(p$cars, "integer")
  expect_type(p$normal, "logical")
})
