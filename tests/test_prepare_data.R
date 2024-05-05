library(testthat)

source("../code/prepare_data.R")

test_that("prepare_data: checks if month data gets transformed to quarterly data and adds previous quarter", {
  input_data <- data.frame(
    Bestedingscategorieen = c("CPI011600", "CPI011600", "CPI011600", "CPI011600", "CPI011600", "CPI011600"),
    Perioden = c("2024MM01", "2024MM02", "2024MM03", "2024MM04", "2024MM05", "2024MM06"),
    CPI_1 = c(25, 30, 35, 40, 45, 50)
  )
  expected_data <- data.frame(
    Bestedingscategorieen = c("CPI011600", "CPI011600"),
    Perioden = c("2024QQ01", "2024QQ02"),
    CPI_1 = c(30, 45),
    previous_CPI_1 = c(NA, 30)
  )
  result <- prepare_data(input_data)
  print(expected_data)
  print(result)
  expect_equal(result, expected_data, ignore.attributes = TRUE)
})