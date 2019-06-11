# geomapr

NUTS2-level heatmaps using UK postcode data.

## Example

```r
library(geomapr)

my_map <- geomap(
  mapdata = sample_data, # Population figures at Postcode District level for England and Wales from the 2011 census data
  series = "population"
)

my_map # It may take a minute or two for the map to render

```
