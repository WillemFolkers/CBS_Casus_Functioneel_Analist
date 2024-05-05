library(testthat)

source("../code/clean_data.R")

test_that("clean_data: checks if unnecessary data gets removed", {
  product_list = list('CPI011600', 'CPI011700')
  input_data <- data.frame(
    Bestedingscategorieen = c("CPI011600", "CPI011600", "CPI011700", "CPI011700", "CPI011800", "CPI011800"),
    Perioden = c("2024JJ01", "2024MM01", "2024MM01", "2024MM02", "2024MM01", "2024MM01"),
    CPI_1 = c(25, 30, 35, 40, 45, 50),
    Mutatie = c(25, 30, 35, 40, 45, 50)
  )
  expected_data <- data.frame(
    Bestedingscategorieen = c("CPI011600", "CPI011700", "CPI011700"),
    Perioden = c("2024MM01", "2024MM01", "2024MM02"),
    CPI_1 = c(30, 35, 40)
  )
  result <- clean_data(input_data, product_list)
  expect_equal(result, expected_data)
})