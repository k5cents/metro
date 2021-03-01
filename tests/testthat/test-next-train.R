test_that("all next trains from null", {
  skip_if_no_key()
  Sys.sleep(0.11)
  n <- next_train(NULL)
  expect_s3_class(n, "data.frame")
  expect_length(n, 9)
  expect_gt(length(unique(n$LocationCode)), 1)
  expect_type(n$Min, "integer")
  expect_type(n$Car, "integer")
})

test_that("next trains from one station", {
  skip_if_no_key()
  Sys.sleep(0.11)
  n <- next_train("A08")
  expect_s3_class(n, "data.frame")
  expect_length(n, 9)
  if (nrow(n) > 0) {
    expect_equal(length(unique(n$LocationCode)), 1)
    expect_type(n$Min, "integer")
    expect_type(n$Car, "integer")
  }
})

test_that("next trains from multiple stations", {
  skip_if_no_key()
  Sys.sleep(0.11)
  n <- next_train(StationCodes = sample(metro_stations$StationCode, 10))
  expect_s3_class(n, "data.frame")
  expect_length(n, 9)
  if (nrow(n) > 0) {
    expect_gt(length(unique(n$LocationCode)), 1)
    expect_type(n$Min, "integer")
    expect_type(n$Car, "integer")
  }
})

test_that("empty tibble returned without next train", {
  skip_if_no_key()
  Sys.sleep(0.11)
  n <- mockr::with_mock(
    .env = as.environment("package:metro"),
    `no_data_now` = function(x) TRUE,
    expect_message(next_train())
  )
  expect_equal(nrow(n), 0)
  expect_s3_class(n, "data.frame")
})
