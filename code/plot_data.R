library(cbsodataR)
library(dplyr)
library(stringr)
library(ggplot2)
library(RSQLite)
library(gridExtra)


plot_data <- function(data, subset_data, product, product_name, years_to_plot){
  "
  A function to plot the original data, the quarterly data and the mutations
  
  data (dataframe): the dataframe with the original data, with at least:
    - Perioden: year and month data for example 2024MM01
    - CPI_1: a column with float values
  subset_data (dataframe): the data after mutations:
    - Perioden: a column with quarterly dates for example 2024QQ01
    - CPI_1: a column with float values
    - Kwartaalmutatie: a column with float values
  product (str): the variables which needs to be plotted
  product_name (str): description/name of the variable
  years_to_plot (str): the years for which the data needs to be plotted for example 2023|2024
  "
  data <- filter(data, Bestedingscategorieen == product)
  data <- data[grep(years_to_plot, data$Perioden), ]
  data_cpi <- select(data, Perioden, CPI_1)
  
  data_cpi_year <- data_cpi[grepl("JJ", data_cpi$Perioden), ]
  plot_title = paste("CPI per jaar voor ", product_name)
  plot_cpi_year <- ggplot(data_cpi_year, aes(x = Perioden, y = CPI_1)) +
    geom_point() +
    labs(x = "Perioden", y = "CPI", title = plot_title) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1, size=5))
  grid.arrange(plot_cpi_year)
  
  data_cpi_month <- data_cpi[grepl("MM", data_cpi$Perioden), ]
  plot_title = paste("CPI per maand voor ", product_name)
  plot_cpi_month <- ggplot(data_cpi_month, aes(x = Perioden, y = CPI_1)) +
    geom_point() +
    labs(x = "Perioden", y = "CPI", title = plot_title) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1, size=5))
  grid.arrange(plot_cpi_month)
  
  subset_data <- filter(subset_data, Bestedingscategorieen == product)
  subset_data <- subset_data[grep(years_to_plot, subset_data$Perioden), ]
  subset_data_cpi <- select(subset_data, Perioden, CPI_1)
  plot_title = paste("CPI per kwartaal voor ", product_name)
  plot_cpi_quarterly <- ggplot(subset_data_cpi, aes(x = Perioden, y = CPI_1)) +
    geom_point() +
    labs(x = "Perioden", y = "CPI", title = plot_title) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  grid.arrange(plot_cpi_quarterly)
  
  
  subset_data_quarterlymutations <- select(subset_data, Perioden, Kwartaalmutatie)
  plot_title = paste("Kwaartaalmutaties voor ", product_name)
  plot_quarterlymutations <- ggplot(subset_data_quarterlymutations, aes(x = Perioden, y = Kwartaalmutatie)) +
    geom_point() +
    labs(x = "Perioden", y = "Kwartaalmutatie", title = plot_title) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  grid.arrange(plot_quarterlymutations)
  grid.arrange(plot_cpi_quarterly, plot_quarterlymutations, nrow = 1)
}