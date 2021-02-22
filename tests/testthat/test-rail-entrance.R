test_that("entrace returns empty and warns for short radius", {
  skip_if_no_key()
  Sys.sleep(0.11)
  e <- expect_warning(rail_entrance(38, -77, 0))
  expect_length(e, 7)
  expect_s3_class(e, "data.frame")
  expect_equal(nrow(e), 0)
})

test_that("entrances found for single location", {
  skip_if_no_key()
  Sys.sleep(0.11)
  # white house
  e <- rail_entrance(38.897957, -77.036560, 1000)
  expect_length(e, 7)
  expect_s3_class(e, "data.frame")
  expect_false(any(is.na(e$Distance)))
})

test_that("all entrances returned without radius", {
  skip_if_no_key()
  Sys.sleep(0.11)
  # white house
  e <- rail_entrance(38.897957, -77.036560)
  expect_length(e, 7)
  expect_s3_class(e, "data.frame")
  expect_false(any(is.na(e$Distance)))
  expect_gt(nrow(e), 200) # all
})

test_that("distances not returned without coordinates", {
  skip_if_no_key()
  Sys.sleep(0.11)
  e <- rail_entrance()
  expect_length(e, 7)
  expect_s3_class(e, "data.frame")
  expect_true(all(is.na(e$Distance)))
})
