#' Call the WMATA API
#'
#' Use [httr::GET()] to make a request to the WMATA API and return the unparsed
#' JSON string. This function is used in others devoted to a
#' specific APIs and endpoints.
#'
#' This function was modified from 'zamorarr/wmata' on GitHub:
#' <https://github.com/zamorarr/wmata/blob/master/R/api.r>
#' @param type The API base type to call, one of "Rail" or "Bus".
#' @param endpoint The API endpoint (e.g., "jStations").
#' @param query Additional queries also passed, possibly your key if need be.
#' @param ... Arguments passed to [jsonlite::fromJSON()] for parsing.
#' @inheritParams wmata_key
#' @examples
#' \dontrun{
#' wmata_api("Rail.svc/json/jLines", query = list(LineCode = "RD"))
#' }
#' @return A single JSON string.
#' @importFrom httr accept_json GET add_headers http_type content http_error
#'   status_code
#' @importFrom jsonlite fromJSON
#' @keywords internal
#' @export
wmata_api <- function(path, query = NULL, ..., api_key = wmata_key()) {
  stopifnot(length(path) == 1L)
  ua <- httr::user_agent("https://github.com/kiernann/metro/")
  url <- httr::modify_url("https://api.wmata.com", path = path, query = query)
  resp <- httr::GET(url, ua, httr::add_headers(api_key = api_key))
  if (httr::http_type(resp) != "application/json") {
    stop("API did not return JSON", call. = FALSE)
  }
  raw <- httr::content(resp, as = "text", encoding = "UTF-8")
  parsed <- jsonlite::fromJSON(raw, ...)
  if (httr::http_error(resp)) {
    stop(
      sprintf(
        "WMATA API request failed [%s]\n%s",
        httr::status_code(resp), parsed$Message
      ),
      call. = FALSE,
    )
  }
  parsed
}
