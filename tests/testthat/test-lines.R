Sys.sleep(1)
test_that("all lines are returned", {
  l <- rail_lines()
  expect_length(l, 4)
  expect_equal(nrow(l), 6)
  expect_s3_class(l, "tbl")
})
