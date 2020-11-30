test_that("multiplication works", {
  n <- next_bus(stop = 2000474)
  expect_s3_class(n, "data.frame")
  expect_length(n, 6)
})
