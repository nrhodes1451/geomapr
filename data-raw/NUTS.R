library(tidyverse)

# Source https://geoportal.statistics.gov.uk/datasets/nuts-level-3-january-2018-names-and-codes-in-the-united-kingdom
NUTS <- read_csv("data-raw/lookup/LAU2_to_LAU1_to_NUTS3_to_NUTS2_to_NUTS1_January_2018_Lookup_in_United_Kingdom_v3.csv")

# Save data frame
usethis::use_data(NUTS, overwrite = F)