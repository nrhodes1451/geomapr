# Load shapefile
shapefile <- rgdal::readOGR(dsn="data-raw/shapefiles", layer="NUTS_Level_2_January_2018_Full_Clipped_Boundaries_in_the_United_Kingdom")

# Reshape for ggplot2 using the Broom package
shapefiles <- broom::tidy(shapefile, region="nuts218nm")
shapefiles$id <- shapefiles$id %>%
  str_replace("West Wales",
              "West Wales and The Valleys")

# Save data frame
usethis::use_data(shapefiles, overwrite = T)
