test_that("multiplication works", {
  skip_if_no_key()
  Sys.sleep(0.1)
  r <- bus_routes()
  expect_length(r, 3)
  expect_s3_class(r, "data.frame")
})
