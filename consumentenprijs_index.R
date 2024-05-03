library(cbsodataR)
library(dplyr)
library(stringr)
library(ggplot2)
library(RSQLite)
library(gridExtra)


clean_data <- function(data, product_list){
  data$Bestedingscategorieen <- gsub("\\s+", "", data$Bestedingscategorieen)
  data <- data %>% filter(Bestedingscategorieen %in% product_list)
  data <- data[grepl("MM", data$Perioden), ]
  data <- select(data, Bestedingscategorieen, Perioden, CPI_1)
  return(data)
}


prepare_data <- function(data){
  data$Perioden <- gsub("MM01|MM02|MM03", "QQ01", data$Perioden)
  data$Perioden <- gsub("MM04|MM05|MM06", "QQ02", data$Perioden)
  data$Perioden <- gsub("MM07|MM08|MM09", "QQ03", data$Perioden)
  data$Perioden <- gsub("MM10|MM11|MM12", "QQ04", data$Perioden)
  data <- data %>%
    group_by(Bestedingscategorieen, Perioden) %>%
    summarise(CPI_1 = mean(CPI_1), .groups = "drop")
  data <- data[order(data$Bestedingscategorieen, data$Perioden), ]
  data <- data %>% mutate(previous_CPI_1 = lag(CPI_1))
  return(data)
}


calculate_mutation <- function(data){
  data <- data %>% mutate(Kwartaalmutatie = (CPI_1 - previous_CPI_1)/CPI_1*100)
  data <- select(data, Bestedingscategorieen, Perioden, CPI_1, Kwartaalmutatie)
  return(data)
}

plot_data <- function(data, subset_data, product, years_to_plot){
  data <- filter(data, Bestedingscategorieen == product)
  data <- data[grep(years_to_plot, data$Perioden), ]
  data_cpi <- select(data, Perioden, CPI_1)
  
  data_cpi_year <- data_cpi[grepl("JJ", data_cpi$Perioden), ]
  plot_cpi_year <- ggplot(data_cpi_year, aes(x = Perioden, y = CPI_1)) +
    geom_point() +
    labs(x = "Perioden", y = "CPI", title = "CPI Year data") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1, size=5))
  grid.arrange(plot_cpi_year)
  
  data_cpi_month <- data_cpi[grepl("MM", data_cpi$Perioden), ]
  plot_cpi_month <- ggplot(data_cpi_month, aes(x = Perioden, y = CPI_1)) +
    geom_point() +
    labs(x = "Perioden", y = "CPI", title = "CPI Month data") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1, size=5))
  grid.arrange(plot_cpi_month)
  
  subset_data <- filter(subset_data, Bestedingscategorieen == product)
  subset_data <- subset_data[grep(years_to_plot, subset_data$Perioden), ]
  subset_data_cpi <- select(subset_data, Perioden, CPI_1)
  plot_cpi_quarterly <- ggplot(subset_data_cpi, aes(x = Perioden, y = CPI_1)) +
    geom_point() +
    labs(x = "Perioden", y = "CPI", title = "CPI") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  grid.arrange(plot_cpi_quarterly)
  
  
  subset_data_quarterlymutations <- select(subset_data, Perioden, Kwartaalmutatie)
  plot_quarterlymutations <- ggplot(subset_data_quarterlymutations, aes(x = Perioden, y = Kwartaalmutatie)) +
    geom_point() +
    labs(x = "Perioden", y = "Kwartaalmutatie", title = "Kwaartaalmutaties") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  grid.arrange(plot_quarterlymutations)
  grid.arrange(plot_cpi_month, plot_cpi_quarterly, plot_quarterlymutations, nrow = 1)
}

product_list = list('CPI011600', 'CPI011700') # 'CPI011600': Fruit, 'CPI011700': Groenten
years_to_plot = "2020|2021|2022|2023|2024" # years to plot data for
list_of_dataframes = list()
data <- cbs_get_data("83131NED")
cleaned_data <- clean_data(data, product_list)
for (product in product_list){
  product_data <- filter(data, Bestedingscategorieen == product)
  cleaned_product_data <- filter(cleaned_data, Bestedingscategorieen == product)
  prepared_product_data <- prepare_data(cleaned_product_data)
  mutation_product_data <- calculate_mutation(prepared_product_data)
  list_of_dataframes <- c(list_of_dataframes, list(mutation_product_data))
}
data_quarterlymutations <- bind_rows(list_of_dataframes)

con <- dbConnect(SQLite(), "Kwartaalmutaties.db")
dbWriteTable(con, "83131NED", data_quarterlymutations, overwrite = TRUE)


plot_data(data, data_quarterlymutations, product_list[1], years_to_plot)
plot_data(data, data_quarterlymutations, product_list[2], years_to_plot)