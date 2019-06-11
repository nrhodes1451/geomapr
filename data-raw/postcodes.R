library(tidyverse)

# Load lookup file
# source http://ec.europa.eu/eurostat/tercet/flatfilesChangeNutsVersion.do
lookup <- read.csv("data-raw/lookup/pc2018_uk_NUTS-2016_v2.0.csv", quote = "'", sep = ";", stringsAsFactors = F) %>%
  as_tibble %>%
  separate(CODE, c("c1", "c2")) %>%
  mutate(postcode_area = str_extract(c1, "[A-Z]+"),
         postcode_district = c1,
         postcode_sector = paste0(c1, substring(c2,1,1)),
         postcode = paste(c1, c2)) %>%
  select(-c1, -c2)

postcodes <- read_csv("data-raw/lookup/NUTS_Level_3_2015_to_NUTS_Level_3_2018_Lookup_in_the_United_Kingdom.csv") %>%
  select(NUTS315CD, NUTS318CD) %>%
  rename(NUTS3 = NUTS315CD) %>%
  left_join(lookup) %>%
  select(-NUTS3)

# Save data frame
usethis::use_data(postcodes, overwrite = T)