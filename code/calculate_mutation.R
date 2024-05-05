library(cbsodataR)
library(dplyr)
library(stringr)
library(ggplot2)
library(RSQLite)
library(gridExtra)


calculate_mutation <- function(data){
  "
  Function to calculate mutation calculations
  
  input
  data (dataframe): a dataframe with at least the following columns:
    - Bestedingscategorieen: with extra information about the data
    - Perioden: with only periods transformed to quarterly data for example 2024QQ01
    - CPI_1: with float values
    - previous_CPI_1: with float values from previous quarter
  
  return
  data (dataframe): a dataframe with:
    - Bestedingscategorieen: with extra information about the data
    - Perioden: with only periods transformed to quarterly data
    - CPI_1: with float values
    - Kwartaalmutatie: a column with the quarterly mutations
  "
  data <- data %>% mutate(Kwartaalmutatie = (CPI_1 - previous_CPI_1)/ previous_CPI_1 * 100)
  data <- select(data, Bestedingscategorieen, Perioden, CPI_1, Kwartaalmutatie)
  return(data)
}