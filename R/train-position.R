#' Live Train Positions
#'
#' Returns uniquely identifiable trains in service and what track circuits they
#' currently occupy. Will return an empty set of results when no positions are
#' available.
#'
#' Please refer to [this page](https://developer.wmata.com/TrainPositionsFAQ)
#' for additional details.
#'
#' @format A tibble with 1 row per train and 9 variables:
#' \describe{
#'   \item{TrainId}{Uniquely identifiable internal train identifier.}
#'   \item{TrainNumber}{_Non-unique_ train identifier, often used by WMATA's
#'   Rail Scheduling and Operations Teams, as well as over open radio
#'   communication.}
#'   \item{CarCount}{Number of cars. Can sometimes be 0 when there is no data
#'   available.}
#'   \item{DirectionNum}{The direction of movement regardless of which track the
#'   train is on. Valid values are 1 or 2. Generally speaking, trains with
#'   direction 1 are northbound/eastbound, while trains with direction 2 are
#'   southbound/westbound.}
#'   \item{CircuitId}{The circuit identifier the train is currently on. This
#'   identifier can be referenced from the Standard Routes method.}
#'   \item{DestinationStationCode}{Destination station code. Can be `NA`. Use
#'   this value in other rail-related APIs to retrieve data about a station.
#'   Note that this value may _sometimes_ differ from the destination station
#'   code returned by our Next Trains methods.}
#'   \item{LineCode}{Two-letter abbreviation for the line (e.g.: RD, BL, YL, OR,
#'   GR, or SV). May also be `NA` in certain cases.}
#'   \item{SecondsAtLocation}{Approximate "dwell time". This is not an exact
#'   value, but can be used to determine how long a train has been reported at
#'   the same track circuit.}
#'   \item{ServiceType}{Service Type of a train, can be any of the following
#'   Service Types:
#'   * `NoPassengers`: This is a non-revenue train with no passengers on board.
#'     Note that this designation of `NoPassengers` does not necessarily
#'     correlate with PIDS "No Passengers". As of 08/22/2016, this functionality
#'     has been reinstated to include all non-revenue vehicles, with minor
#'     exceptions.
#'   * `Normal`: This is a normal revenue service train.
#'   * `Special`: This is a special revenue service train with an unspecified
#'     line and destination. This is more prevalent during scheduled track
#'     work.
#'   * `Unknown`: This often denotes cases with unknown data or work vehicles.
#'   }
#' }
#' @examples
#' \dontrun{
#' train_positions()
#' }
#' @return
#' @seealso <https://developer.wmata.com/docs/services/5763fa6ff91823096cac1057/operations/5763fb35f91823096cac1058>
#' @family Train Positions
#' @importFrom httr GET content add_headers
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble
#' @export
train_positions <- function() {
   response <- httr::GET(
     url = "https://api.wmata.com/TrainPositions/TrainPositions",
     query = list(contentType = "json"),
     httr::add_headers(
        `api_key` = wmata_key(),
        `Content-Type` = "application/json",
        `Accept` = "application/json"
     )
   )
   json <- httr::content(response, as = "text")
   dat <- jsonlite::fromJSON(json, flatten = TRUE)[[1]]
   tibble::as_tibble(dat)
}
