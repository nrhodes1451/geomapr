# geomapr

[NUTS2-level](https://en.wikipedia.org/wiki/Nomenclature_of_Territorial_Units_for_Statistics)  heatmaps using UK postcode data.

## Example

```r
library(geomapr)

my_map <- geomap(
  mapdata = sample_data, # Population figures at Postcode District level for England and Wales from the 2011 census data
  series = "population"
)

my_map # It may take a minute or two for the map to render

```
<p align="center">
  <img height="400" src="https://github.com/nrhodes1451/geomapr/blob/master/images/heatmap.png">
</p>
