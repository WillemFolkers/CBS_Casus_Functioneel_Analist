library(cbsodataR)
library(dplyr)
library(stringr)
library(ggplot2)
library(RSQLite)
library(gridExtra)

source("code/calculate_mutation.R")
source("code/clean_data.R")
source("code/plot_data.R")
source("code/prepare_data.R")


product_list = list('CPI011600', 'CPI011700') # 'CPI011600': Fruit, 'CPI011700': Groenten
years_to_plot = "2020|2021|2022|2023|2024" # years to plot data for
list_of_dataframes = list()
data <- cbs_get_data("83131NED") # cbs_get_data: a function to get cbs data for a certain table
cleaned_data <- clean_data(data, product_list)
for (product in product_list){
  product_data <- filter(data, Bestedingscategorieen == product)
  cleaned_product_data <- filter(cleaned_data, Bestedingscategorieen == product)
  prepared_product_data <- prepare_data(cleaned_product_data)
  mutation_product_data <- calculate_mutation(prepared_product_data)
  list_of_dataframes <- c(list_of_dataframes, list(mutation_product_data))
}
data_quarterlymutations <- bind_rows(list_of_dataframes)

# add the data to a database
con <- dbConnect(SQLite(), "Kwartaalmutaties.db")
dbWriteTable(con, "83131NED", data_quarterlymutations, overwrite = TRUE)


# plot the data - change codes and name when needed
plot_data(data, data_quarterlymutations, "CPI011600", "Fruit", years_to_plot)
plot_data(data, data_quarterlymutations, "CPI011700", "Groenten", years_to_plot)