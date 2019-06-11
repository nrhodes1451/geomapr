library(tidyverse)

# Sample postcode data values
sample_data <- read_csv("data-raw/ukpop.csv")

# Save data frame
usethis::use_data(sample_data, overwrite = T)
