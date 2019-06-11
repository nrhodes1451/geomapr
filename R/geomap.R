#' @import tidyverse
#' @import maps
#' @import mapdata
#' @import rgeos
#' @import maptools
#' @import rgdal
#' @import XML
#' @import RCurl
#' @import rlist
#' @import scales
#' @importFrom magrittr %>%

#' @title geomap
#' @description Creates a NUTS2-level ggmap from UK Postcode data
#' @param mapdata Data frame of postcode values to be plotted
#' @param series The name of the data series to plot
#' @param match_on Optional. The name of the postcode level to join against. Must be one of:
#' \describe{
#'   \item{postcode_area}{e.g. SW}
#'   \item{postcode_district}{e.g. SE1}
#'   \item{postcode_region}{e.g. SE10}
#'   \item{postcode}{e.g. SE1 0SW}
#' }
#' @return ggmap object
#' @examples geomap(sample_data, "population")
#' @export
geomap <- function(mapdata, series, match_on=NULL){
  pc_fields <- c(
    "postcode",
    "postcode_sector",
    "postcode_district",
    "postcode_area"
  )
  if(!is.null(match_on)){
    if(!(match_on %in% pc_fields)){
      stop("Invalid postcode match key")
    }
  }
  else if(is.null(match_on)){
    match_on <- pc_fields[which(pc_fields %in% names(mapdata))]
    if(length(match_on)>0){
      match_on <- match_on[1]
    }
    else{
      stop("No valid postcode match key found. Consult the documentation for more details")
    }
  }

  mapdata <- mapdata[c(match_on, series)]
  names(mapdata)[2] <- "value"

  mapdata <- mapdata %>%
    dplyr::left_join(
      postcodes[c("NUTS318CD", match_on)] %>% unique, by=match_on) %>%
    dplyr::select(NUTS318CD, value) %>%
    dplyr::group_by(NUTS318CD) %>%
    dplyr::summarise_all(list(sum))

  before <- mapdata$value %>% sum
  mapdata <- mapdata %>% dplyr::filter(!is.na(NUTS318CD))
  after <- mapdata$value %>% sum

  message(paste0("Merged with ", round(100 * after / before, 2),
                 "% match rate"))

  mapdata <- mapdata %>% dplyr::left_join(NUTS) %>%
    dplyr::select(NUTS218NM, value) %>%
    dplyr::group_by(NUTS218NM) %>%
    dplyr::summarise_all(list(sum)) %>%
    dplyr::rename(id = NUTS218NM)

  mapdata <- shapefiles %>% dplyr::left_join(mapdata)

  # Create the heatmap using the ggplot2 package
  gg <- ggplot2::ggplot() +
    ggplot2::geom_polygon(data = mapdata,
                          ggplot2::aes(x = long,
                                       y = lat,
                                       group = group,
                                       fill = value),
                          color = "#FFFFFF",
                          size = 0.05)
  gg <- gg +
    ggplot2::scale_fill_gradient2(low = "white",
                                  mid = "yellow",
                                  high = "red",
                                  na.value = "grey",
                                  space = "Lab")
  gg <- gg + ggplot2::coord_fixed(1)
  gg <- gg + ggplot2::theme_minimal()
  gg <- gg + ggplot2::theme(panel.grid.major = ggplot2::element_blank(),
                            panel.grid.minor = ggplot2::element_blank(),
                            legend.position = 'none')
  gg <- gg + ggplot2::theme(
    axis.title.x = ggplot2::element_blank(),
    axis.text.x = ggplot2::element_blank(),
    axis.ticks.x = ggplot2::element_blank())
  gg <- gg + ggplot2::theme(
    axis.title.y = ggplot2::element_blank(),
    axis.text.y = ggplot2::element_blank(),
    axis.ticks.y = ggplot2::element_blank())

  return(gg)
}
