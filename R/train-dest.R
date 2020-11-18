#' Station to station
#'
#' Returns a distance, fare information, and estimated travel time between any
#' two stations, including those on different lines. Omit both parameters to
#' retrieve data for all stations. Omit one parameter to return all combinations
#' to or from the provided station.
#'
#' * `peak_fee`: Fare during peak times (weekdays from opening to 9:30 AM and
#' 3-7 PM, and weekends from midnight to closing).
#' * `off_fee`: Fare during off-peak times.
#' * `min_fee`: Reduced fare for senior citizens or people with disabilities.

#' @inheritParams rail_path
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble
#' @export
rail_destination <- function(from = NULL, to = NULL) {
  json <- wmata_api(
    type = "Rail", endpoint = "jSrcStationToDstStationInfo",
    query = list(
      FromStationCode = from,
      ToStationCode = to
    )
  )
  df <- jsonlite::fromJSON(json, flatten = TRUE)[[1]]
  names(df) <-
    c("station", "dest", "miles", "minutes", "peak_fee", "off_fee", "min_fee")
  tibble::as_tibble(df)
}
