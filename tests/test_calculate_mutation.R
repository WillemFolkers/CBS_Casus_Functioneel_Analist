library(testthat)

source("../code/calculate_mutation.R")

test_that("calculate_mutations: checks mutation on wether or not the calculations are correct", {
  input_data <- data.frame(
    Bestedingscategorieen = c("CPI011600", "CPI011600", "CPI011600", "CPI011600"),
    Perioden = c("2024QQ01", "2024QQ02", "2024QQ03", "2024QQ04"),
    CPI_1 = c(5, 10, 15, 30),
    previous_CPI_1 = c(NA, 5, 10, 15)
  )
  expected_data <- data.frame(
    Bestedingscategorieen = c("CPI011600", "CPI011600", "CPI011600", "CPI011600"),
    Perioden = c("2024QQ01", "2024QQ02", "2024QQ03", "2024QQ04"),
    CPI_1 = c(5, 10, 15, 30),
    Kwartaalmutatie = c(NA, 100, 50, 100)
  )
  result <- calculate_mutation(input_data)
  expect_equal(result, expected_data)
})