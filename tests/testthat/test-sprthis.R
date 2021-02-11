test_that("check output", {
  pkg <- sprthis(wfName="SPRtest", analysis="SPRtest", path=tempdir())
  expect_type(pkg, "character")
})
