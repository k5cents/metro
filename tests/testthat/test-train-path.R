test_that("rail path returned on same line", {
  skip_if_no_key()
  Sys.sleep(0.1)
  p <- rail_path("A08", "A02")
  expect_length(p, 5)
  expect_s3_class(p, "data.frame")
  expect_type(p$order, "integer")
  expect_type(p$distance, "integer")
})

test_that("rail path errors for stations on different lines", {
  skip_if_no_key()
  Sys.sleep(0.1)
  expect_error(rail_path("A02", "N01"))
})

test_that("total path distance can be easily summed", {
  skip_if_no_key()
  Sys.sleep(0.1)
  d <- path_distance("A02", "A08")
  expect_type(d, "integer")
  expect_length(d, 1)
})
