test_that("key is is proper character if exists", {
  skip_if_no_key()
  key <- wmata_key()
  expect_length(key, 1)
  expect_type(key, "character")
})

test_that("key returns empty if not found", {
  old_key <- Sys.getenv("WMATA_KEY")
  Sys.unsetenv("WMATA_KEY")
  expect_warning(nzchar(wmata_key()))
  Sys.setenv("WMATA_KEY" = old_key)
})

test_that("key can be validated", {
  skip_if_no_key()
  expect_true(wmata_validate(Sys.getenv("WMATA_KEY")))
})
