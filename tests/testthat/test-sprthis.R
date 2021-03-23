testPath <- sprthis(wfName = "SPRtest", analysis = "SPRtest", path = tempdir())
test_that("testing outputs", {
  expect_type(class(testPath), "character")
})


