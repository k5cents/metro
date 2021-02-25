#' Call the WMATA API
#'
#' Use [httr::GET()] to make a request to the WMATA API and return the parsed
#' list from the JSON data. The function uses [httr::RETRY()], so the call will
#' repeat up to three times if there is a failure (often from a rate limit).
#'
#' This function was modified from 'zamorarr/wmata' on GitHub:
#' <https://github.com/zamorarr/wmata/blob/master/R/api.r>
#' @param type The API base type to call, one of "Rail" or "Bus".
#' @param endpoint The API endpoint (e.g., "jStations").
#' @param query Additional queries also passed, possibly your key if need be.
#' @param ... Arguments passed to [jsonlite::fromJSON()] for parsing.
#' @param level If parsed JSON is a list, select only this element. Useful if
#'   the list is length one containing a data frame or some other object.
#' @inheritParams wmata_key
#' @examples
#' \dontrun{
#' wmata_api("Rail.svc/json/jLines", query = list(LineCode = "RD"))
#' }
#' @return A single JSON string.
#' @importFrom httr RETRY accept_json add_headers user_agent http_type content
#'   http_error status_code
#' @importFrom jsonlite fromJSON
#' @keywords internal
#' @export
wmata_api <- function(path, query = NULL, ..., level, api_key = wmata_key()) {
  resp <- httr::RETRY(
    verb = "GET",
    url = "https://api.wmata.com",,
    path = path,
    query = query,
    httr::accept_json(),
    httr::add_headers(api_key = api_key),
    httr::user_agent("https://github.com/kiernann/metro/"),
    terminate_on = c(400:417)
  )
  if (httr::http_type(resp) != "application/json") {
    stop("API did not return JSON", call. = FALSE)
  }
  raw <- httr::content(resp, as = "text", encoding = "UTF-8")
  parsed <- jsonlite::fromJSON(raw, ...)
  if (httr::http_error(resp) && "message" %in% names(parsed)) {
    stop(
      sprintf(
        "WMATA API request failed [%s]\n%s",
        httr::status_code(resp), parsed$message
      ),
      call. = FALSE
    )
  }
  if (!missing(level) && is.list(parsed)) {
    parsed <- parsed[[level]]
  }
  parsed
}
