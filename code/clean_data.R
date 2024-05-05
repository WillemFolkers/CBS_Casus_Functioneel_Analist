library(cbsodataR)
library(dplyr)
library(stringr)
library(ggplot2)
library(RSQLite)
library(gridExtra)


clean_data <- function(data, product_list){
  "
  Function to remove unnecessary data, and clean data for calculations
  
  input
  data (dataframe): a dataframe with at least the following columns:
    - Bestedingscategorieen: with extra information about the data
    - Perioden: with months for example 2024MM01
    - CPI_1: with float values
  product_list (list): a list with a selection of bestedingscategorieen
  
  return
  data (dataframe): a dataframe with:
    - Bestedingscategorieen: with extra information about the data
    - Perioden: with only months left
    - CPI_1: with float values
  "
  data$Bestedingscategorieen <- gsub("\\s+", "", data$Bestedingscategorieen)
  data <- data %>% filter(Bestedingscategorieen %in% product_list)
  data <- data[grepl("MM", data$Perioden), ]
  data <- select(data, Bestedingscategorieen, Perioden, CPI_1)
  return(data)
}