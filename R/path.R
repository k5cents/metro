#' Path between rail stations
#'
#' Returns a set of ordered stations and distances between two stations on the
#' same line.
#'
#' Note that this method is not suitable on its own as a pathfinding solution
#' between stations. Distance is converted from feet to round meters.
#' @param from Station code for the origin station.
#' @param to Station code for the destination station.
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble
#' @export
rail_path <- function(from, to) {
  json <- wmata_api(
    path = "Rail.svc/json/jPath",
    query = list(FromStationCode = from, ToStationCode = to)
  )
  df <- jsonlite::fromJSON(json, simplifyVector = TRUE)[[1]]
  if (length(df) == 0) {
    stop("stations not on the same line, see rail_stations()")
  }
  names(df) <- c("line", "station", "name", "order", "distance")
  df$distance <- as.integer(round(df$distance / 3.281))
  tibble::as_tibble(df[, c(1, 4, 2:3, 5)])
}

#' @rdname rail_path
#' @export
path_distance <- function(from, to) {
  path <- rail_path(from, to)
  sum(path$distance)
}
