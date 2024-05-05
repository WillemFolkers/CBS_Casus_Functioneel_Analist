library(cbsodataR)
library(dplyr)
library(stringr)
library(ggplot2)
library(RSQLite)
library(gridExtra)


prepare_data <- function(data){
  "
  Function to remove transforms mont data to quarterly data and adds previous quarter
  
  input
  data (dataframe): a dataframe with at least the following columns:
    - Bestedingscategorieen: with extra information about the data
    - Perioden: with months for example 2024MM01
    - CPI_1: with float values
  
  return
  data (dataframe): a dataframe with:
    - Bestedingscategorieen: with extra information about the data
    - Perioden: with only periods transformed to quarterly data
    - CPI_1: with float values
    - previous_CPI_1: with float values from previous quarter
  "
  data$Perioden <- gsub("MM01|MM02|MM03", "QQ01", data$Perioden)
  data$Perioden <- gsub("MM04|MM05|MM06", "QQ02", data$Perioden)
  data$Perioden <- gsub("MM07|MM08|MM09", "QQ03", data$Perioden)
  data$Perioden <- gsub("MM10|MM11|MM12", "QQ04", data$Perioden)
  data <- data %>%
    group_by(Bestedingscategorieen, Perioden) %>%
    summarise(CPI_1 = mean(CPI_1), .groups = "drop")
  data <- data[order(data$Bestedingscategorieen, data$Perioden), ]
  data <- data %>% mutate(previous_CPI_1 = lag(CPI_1))
  data <- as.data.frame(data)
  return(data)
}