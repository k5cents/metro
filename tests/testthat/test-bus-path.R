test_that("bus paths return list of shapes and stop", {
  skip_if_no_key()
  Sys.sleep(0.11)
  p <- bus_path("10A")
  expect_type(p, "list")
  expect_length(p, 4)
  expect_s3_class(p$shape, "data.frame")
  expect_s3_class(p$stops, "data.frame")
})
