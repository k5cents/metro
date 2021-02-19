#' Rail Station to Station Information
#'
#' Returns a distance, fare information, and estimated travel time between any
#' two stations, including those on different lines. Omit both parameters to
#' retrieve data for all stations.
#'
#' @format A tibble 1 row per  with  variables:
#' \describe{
#'   \item{SourceStation}{Origin station code. Use this value in other
#'   rail-related APIs to retrieve data about a station.}
#'   \item{DestinationStation}{Destination station code. Use this value in other
#'   rail-related APIs to retrieve data about a station.}
#'   \item{CompositeMiles}{Average of distance traveled between two stations and
#'   straight-line distance (as used for WMATA fare calculations). For more
#'   details, please refer to WMATA's [Tariff on Fares][1].}
#'   \item{RailTime}{Estimated travel time (schedule time) in minutes between
#'   the source and destination station. This is not correlated to minutes
#'   (`Min`) in Real-Time Rail Predictions.}
#'   \item{PeakTime}{Fare during peak times (weekdays from opening to 9:30 AM
#'   and 3-7 PM (EST), and weekends from midnight to closing).}
#'   \item{OffPeakTime}{Fare during off-peak times (times other than the ones
#'   described below).}
#'   \item{SeniorDisabled}{Reduced fare for [senior citizens or people with
#'   disabilities.][2]}
#' }
#'
#' [1]: https://www.wmata.com/about/records/public_docs/upload/Tariff-on-Fares-Annotated-2-12-18.pdf#page=6
#' [2]: http://www.wmata.com/fares/reduced.cfm
#'
#' @param FromStationCode Station code for the origin station. Use the
#'   [rail_stations()] function to return a list of all station codes.
#' @param ToStationCode Station code for the destination station. Use the
#'   [rail_stations()] function to return a list of all station codes.
#' @examples
#' \dontrun{
#' rail_destination("A01", "A08")
#' }
#' @return A data frame containing station to station information
#' @seealso <https://developer.wmata.com/docs/services/5476364f031f590f38092507/operations/5476364f031f5909e4fe3313>
#' @family Rail Station Information
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble
#' @export
rail_destination <- function(FromStationCode = NULL, ToStationCode = NULL) {
  json <- wmata_api(
    type = "Rail", endpoint = "jSrcStationToDstStationInfo",
    query = list(
      FromStationCode = FromStationCode,
      ToStationCode = ToStationCode
    )
  )
  dat <- jsonlite::fromJSON(json, flatten = FALSE)[[1]]
  dat <- cbind(dat[-length(dat)], dat$RailFare)
  tibble::as_tibble(dat)
}
