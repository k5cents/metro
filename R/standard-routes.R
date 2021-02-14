#' Standard Routes
#'
#' Returns an ordered list of mostly revenue (and some lead) track circuits,
#' arranged by line and track number. This data does not change frequently and
#' should be cached for a reasonable amount of time.
#'
#' Please refer to [this page](https://developer.wmata.com/TrainPositionsFAQ)
#' for additional details.
#'
#' @format A nested tibble with 1 row per track and 3 variables:
#' \describe{
#'   \item{LineCode}{Abbreviation for the revenue line. Note that this also
#'   includes **YLRP** (Yellow Line Rush Plus).}
#'   \item{TrackNum}{Track number (1 or 2).}
#'   \item{TrackCircuits}{Array containing ordered track circuit information:
#'   * `CircuitId`: An internal system-wide uniquely identifiable circuit
#'   number.
#'   * `SeqNum`: Order in which the circuit appears for the given line and
#'   track. Sequences go from West to East and South to North.
#'   * `StationCode`: If the circuit is at a station, this value will represent
#'   the station code. Otherwise, it will be be `NA`. Use this value in other
#'   rail-related APIs to retrieve data about a station.
#'   }
#' }
#'
#' @examples
#' \dontrun{
#' standard_routes()
#' }
#' @return A nested data frame of track circuits.
#' @seealso <https://developer.wmata.com/docs/services/5763fa6ff91823096cac1057/operations/57641afc031f59363c586dca>
#' @family Train Positions
#' @importFrom httr GET content add_headers
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble
#' @export
standard_routes <- function() {
  response <- httr::GET(
    url = "https://api.wmata.com/TrainPositions/StandardRoutes",
    query = list(contentType = "json"),
    httr::add_headers(
      `api_key` = wmata_key(),
      `Content-Type` = "application/json",
      `Accept` = "application/json"
    )
  )
  json <- httr::content(response, as = "text")
  dat <- jsonlite::fromJSON(json, flatten = TRUE)[[1]]
  dat$TrackCircuits <- lapply(dat$TrackCircuits, FUN = tibble::as_tibble)
  tibble::as_tibble(dat)
}
