test_that("cost found for station parking", {
  skip_if_no_key()
  c <- parking_cost(line = "RD")
  expect_length(c, 3)
  expect_s3_class(c, "data.frame")
})

test_that("spots found for station parking", {
  skip_if_no_key()
  s <- parking_spots(line = "BL")
  expect_length(s, 3)
  expect_s3_class(s, "data.frame")
  expect_type(s$all_day, "logical")
})
