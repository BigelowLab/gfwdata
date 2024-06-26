#' Generate a template stars object
#' 
#' @export
#' @param bb 4 element named numeric or bbox-class
#' @param dx num, grid cell size in x
#' @param dy num, grid cell size in y
#' @param crs CRS projection
#' @return stars object
raster_template = function(bb = c(xmin = -180, xmax = 180, yim = -90, ymax = 90),
                         dx = 0.1, dy = 0.1,
                         crs = 4326){
  if (!inherits(bb, "bbox")) bb = sf::st_bbox(bb, crs = crs)
  stars::st_as_stars(bb, dx = dx, dy = dx)
}

#' Read a single mmsi daily CSV file.
#' 
#' mmsi-daily-csvs-10-v2-2020
#' 
#' @export
#' @param date Date, POSIXt or (character as YYYY-mm-dd) to read
#' @param path char, the path to the data
#' @param form char, one of 'raw', 'sf' or 'stars'
#' @return table (tibble), sf POINT or stars object depending upon \code{form}
read_mmsi_daily = function(date = "2020-01-01",
                           path = gfw_path("mmsi-daily-csvs-10-v2-2020"),
                           form = c('raw', 'sf', 'stars')[1]){
  if (!inherits(date, "character")) date  = format(date, "%Y-%m-%d")
  filename = file.path(path, paste0(date, ".csv"))
  
  x = readr::read_csv(filename, col_types = "Dnnnnn")
  
  if (tolower(form[1]) %in% c("sf", "stars")){
    x = sf::st_as_sf(x, 
                     coords = c("cell_ll_lon", "cell_ll_lat"),
                     crs = 4326)
    if (tolower(form[1]) ==  "stars"){
      x = stars::st_rasterize(dplyr::select(x, -dplyr::all_of("date")))
    }
  }
  
  x
}