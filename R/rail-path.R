#' Path Between Stations
#'
#' Returns a set of ordered stations and distances between two stations on the
#' _same line_.
#'
#' Note that this method is not suitable on its own as a pathfinding solution
#' between stations.
#'
#' @format A tibble 1 row per arrival with 6 variables:
#' \describe{
#'   \item{LineCode}{Two-letter abbreviation for the line (e.g.: RD, BL, YL, OR,
#'   GR, or SV) this station's platform is on.}
#'   \item{StationCode}{Station code for this station. Use this value in other
#'   rail-related APIs to retrieve data about a station.}
#'   \item{StationName}{Full name for this station, as shown on the WMATA
#'   website.}
#'   \item{SeqNum}{Ordered sequence number.}
#'   \item{DistanceToPrev}{Distance in meters to the previous station in the
#'   list, ordered by `SeqNum`. Converted from feet, rounded to the nearest
#'   meter.}
#' }
#'
#' @param FromStationCode Station code for the origin station. Use the Station
#'   List method to return a list of all station codes.
#' @param ToStationCode Station code for the destination station. Use the
#'   Station List method to return a list of all station codes.
#' @inheritParams wmata_key
#' @examples
#' \dontrun{
#' rail_path("A01", "A08")
#' }
#' @return A data frame of stations on rail path.
#' @seealso <https://developer.wmata.com/docs/services/5476364f031f590f38092507/operations/5476364f031f5909e4fe330e>
#' @family Rail Station Information
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble
#' @export
rail_path <- function(FromStationCode, ToStationCode, api_key = wmata_key()) {
  dat <- wmata_api(
    path = "Rail.svc/json/jPath",
    query = list(
      FromStationCode = FromStationCode,
      ToStationCode = ToStationCode
    ),
    flatten = TRUE,
    level = 1,
    api_key = api_key
  )
  if (length(dat) == 0) {
    stop("Stations not on the same line? See `rail_stations()`.", call. = FALSE)
  }
  dat$DistanceToPrev <- as.integer(round(dat$DistanceToPrev / 3.2808))
  tibble::as_tibble(dat)
}
