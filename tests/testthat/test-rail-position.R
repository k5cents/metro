test_that("current train positions found", {
  skip_if_no_key()
  Sys.sleep(0.11)
  p <- train_positions()
  expect_length(p, 9)
  expect_s3_class(p, "data.frame")
  expect_type(p$CarCount, "integer")
})
