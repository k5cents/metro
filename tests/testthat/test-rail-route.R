test_that("standard route returns all circuits", {
  skip_if_no_key()
  Sys.sleep(0.11)
  r <- standard_routes()
  expect_length(r, 5)
  expect_s3_class(r, "data.frame")
})
