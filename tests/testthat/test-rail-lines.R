test_that("all lines are returned", {
  skip_if_no_key()
  Sys.sleep(0.11)
  l <- rail_lines()
  expect_length(l, 6)
  expect_equal(nrow(l), 6)
  expect_s3_class(l, "data.frame")
})
