test_that("entrace returns empty and warns for short radius", {
  skip_if_no_key()
  Sys.sleep(0.11)
  s <- expect_message(bus_stops(38, -77, 0))
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
  expect_false(any(is.na(s$Distance)))
  expect_type(s$Routes, "list")
  expect_true(is.vector(s$Routes[[1]]))
})

test_that("all entrances returned without radius", {
  skip_if_no_key()
  Sys.sleep(0.11)
  # white house
  s <- bus_stops(38.897957, -77.036560)
  expect_length(s, 6)
  expect_s3_class(s, "data.frame")
  expect_false(any(is.na(s$Distance)))
  expect_gt(nrow(s), 9000) # all
})

test_that("distances not returned without coordinates", {
  skip_if_no_key()
  Sys.sleep(0.11)
  s <- bus_stops()
  expect_length(s, 6)
  expect_s3_class(s, "data.frame")
  expect_true(all(is.na(s$Distance)))
})

test_that("empty tibble returned without bus stops", {
  skip_if_no_key()
  Sys.sleep(0.11)
  s <- mockr::with_mock(
    .env = as.environment("package:metro"),
    `no_data_now` = function(x) TRUE,
    expect_message(bus_stops())
  )
  expect_equal(nrow(s), 0)
  expect_s3_class(s, "data.frame")
})
