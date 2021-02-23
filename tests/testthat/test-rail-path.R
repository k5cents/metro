test_that("rail path returned on same line", {
  skip_if_no_key()
  Sys.sleep(0.11)
  p <- rail_path("A08", "A02")
  expect_length(p, 5)
  expect_s3_class(p, "data.frame")
  expect_type(p$DistanceToPrev, "integer")
})

test_that("rail path errors for stations on different lines", {
  skip_if_no_key()
  Sys.sleep(0.11)
  expect_error(rail_path("A02", "N01"))
})
