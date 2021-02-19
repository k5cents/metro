#' Rail Lines
#'
#' Returns information about all rail lines.
#'
#' @format A tibble 1 row per line with 6 variables:
#' \describe{
#'   \item{LineCode}{Two-letter abbreviation for the line (e.g.: RD, BL, YL, OR,
#'   GR, or SV).}
#'   \item{DisplayName}{Full name of line color.}
#'   \item{StartStationCode}{Start station code. For example, will be F11
#'   (Branch Avenue) for the Green Line, A15 (Shady Grove) for the Red Line,
#'   etc. Use this value in other rail-related APIs to retrieve data about a
#'   station.}
#'   \item{EndStationCode}{End station code. For example, will be E10
#'   (Greenbelt) for the Green Line, B11 (Glenmont) for the Red Line, etc. Use
#'   this value in other rail-related APIs to retrieve data about a station.}
#'   \item{InternalDestination1}{Intermediate terminal station code. During
#'   normal service, some trains on some lines might end their trip prior to the
#'   `StartStationCode` or `EndStationCode.` A good example is on the Red Line
#'   where some trains stop at A11 (Grosvenor) or B08 (Silver Spring). `NA` if
#'   not defined.}
#'   \item{InternalDestination2}{Similar to `InternalDestination1`.}
#' }
#' @examples
#' \dontrun{
#' rail_lines()
#' }
#' @return A data frame of rail lines.
#' @seealso <https://developer.wmata.com/docs/services/5476364f031f590f38092507/operations/5476364f031f5909e4fe330c>
#' @family Rail Station Information
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble
#' @export
rail_lines <- function() {
  json <- wmata_api(type = "Rail", endpoint = "jLines")
  dat <- jsonlite::fromJSON(json)[[1]]
  dat <- utils::type.convert(dat, na.strings = "", as.is = TRUE)
  tibble::as_tibble(dat)
}
