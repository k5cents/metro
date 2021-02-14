#' Track Circuits
#'
#' Returns a list of all track circuits including those on pocket tracks and
#' crossovers. Each track circuit may include references to its right and left
#' neighbors.
#'
#' Please refer to [this page](https://developer.wmata.com/TrainPositionsFAQ)
#' for additional details.
#'
#' @format A nested tibble with 1 row per train and 9 variables:
#' \describe{
#'   \item{Track}{Track number. 1 and 2 denote "main" lines, while 0 and 3 are
#'   connectors (between different types of tracks) and pocket tracks,
#'   respectively.}
#'   \item{CircuitId}{An internal system-wide uniquely identifiable circuit
#'   number.}
#'   \item{Neighbors}{Data frame containing track circuit neighbor information.
#'   Note that some track circuits have no neighbors in one direction. All track
#'   circuits have at least one neighbor.
#'   * `NeighborType`: Left or Right neighbor group. Generally speaking, left
#'     neighbors are to the west and south, while right neighbors are to the
#'     east/north.
#'   * `CircuitIds`: Data frame containing neighboring circuit IDs as list
#'     column.
#'   }
#' }
#'
#' @examples
#' \dontrun{
#' track_circuits()
#' }
#' @return Data frame containing track circuit information
#' @seealso <https://developer.wmata.com/docs/services/5763fa6ff91823096cac1057/operations/57644238031f59363c586dcb>
#' @family Train Positions
#' @importFrom httr GET content add_headers
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble
#' @export
track_circuits <- function() {
  response <- httr::GET(
    url = "https://api.wmata.com/TrainPositions/TrackCircuits",
    query = list(contentType = "json"),
    httr::add_headers(
      `api_key` = wmata_key(),
      `Content-Type` = "application/json",
      `Accept` = "application/json"
    )
  )
  json <- httr::content(response, as = "text")
  dat <- jsonlite::fromJSON(json, flatten = TRUE)[[1]]
  dat$Neighbors <- lapply(dat$Neighbors, FUN = tibble::as_tibble)
  tibble::as_tibble(dat)
}
