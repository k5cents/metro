test_that("multiplication works", {
  p <- bus_path("10A")
  expect_type(p, "list")
  expect_length(p, 4)
  expect_s3_class(p$shape, "data.frame")
  expect_s3_class(p$stops, "data.frame")
})
