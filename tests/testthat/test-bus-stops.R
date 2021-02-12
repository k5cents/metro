test_that("entrace returns empty and warns for short radius", {
  skip_if_no_key()
  Sys.sleep(0.11)
  s <- expect_warning(bus_stops(38, -77, 0))
  expect_length(s, 6)
  expect_s3_class(s, "data.frame")
  expect_equal(nrow(s), 0)
})

test_that("entrances found for single location", {
  skip_if_no_key()
  Sys.sleep(0.11)
  # white house
  s <- bus_stops(38.897957, -77.036560, 1000)
  expect_length(s, 6)
  expect_s3_class(s, "data.frame")
  expect_false(any(is.na(s$distance)))
  expect_type(s$routes, "list")
  expect_true(is.vector(s$routes[[1]]))
})

test_that("all entrances returned without radius", {
  skip_if_no_key()
  Sys.sleep(0.11)
  # white house
  s <- bus_stops(38.897957, -77.036560)
  expect_length(s, 6)
  expect_s3_class(s, "data.frame")
  expect_false(any(is.na(s$distance)))
  expect_gt(nrow(s), 9000) # all
})

test_that("distances not returned without coordinates", {
  skip_if_no_key()
  Sys.sleep(0.11)
  s <- bus_stops()
  expect_length(s, 6)
  expect_s3_class(s, "data.frame")
  expect_true(all(is.na(s$distance)))
})
