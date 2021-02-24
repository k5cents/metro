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
#'   \item{InternalDestination}{Intermediate terminal station code(s). During
#'   normal service, some trains on some lines might end their trip prior to the
#'   `StartStationCode` or `EndStationCode.` A good example is on the Red Line
#'   where some trains stop at A11 (Grosvenor) or B08 (Silver Spring). `NA` if
#'   not defined.}
#' }
#'
#' @inheritParams wmata_key
#' @examples
#' \dontrun{
#' rail_lines()
#' }
#' @return A data frame of rail lines.
#' @seealso <https://developer.wmata.com/docs/services/5476364f031f590f38092507/operations/5476364f031f5909e4fe330c>
#' @family Rail Station Information
#' @importFrom tibble add_column as_tibble
#' @export
rail_lines <- function(api_key = wmata_key()) {
  dat <- wmata_api(
    path = "Rail.svc/json/jLines",
    level = 1,
    api_key = api_key
  )
  dat <- utils::type.convert(dat, na.strings = "", as.is = TRUE)
  l <- Map(paste, dat[5], dat[6])
  l <- strsplit(gsub("\\s?NA\\s?", "", l[[1]]), "\\s")
  dat <- tibble::add_column(dat[, -(5:6)], InternalDestination = l, .after = 4)
  tibble::as_tibble(dat)
}
