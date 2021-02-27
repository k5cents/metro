#' Find a WMATA API key
#'
#' @description
#' All calls to the WMATA API must be accompanied by a personal API key. A free
#' key can be obtained by subscribing to the default tier:
#'
#' 1. Sign up for a free WMATA developer account: <https://developer.wmata.com/>
#' 2. Log in and subscribe to the free default tier.
#' 3. Copy the primary or secondary key from your profile.
#' 4. Pass your API key to a function through one of three ways:
#'     1. Use [Sys.setenv()] to temporarily set define `WMATA_KEY`.
#'     2. Pass your key as a string to the `api_key` argument of any function.
#'     3. Store the the WMATA key as a line like `WMATA_KEY=xxxyyyzzz` in your
#'     `.Renviron` file, to be called by [wmata_key()] via [Sys.getenv()].
#'
#' The WMATA also provides a demonstration key. This key should **never** be
#' used in production applications, it is rate limited and subject to change at
#' _any_ time. The key can be found on the WMATA products page when not
#' signed into a developer account.
#'
#' The [wmata_validate()] function can be used to verify a key is valid.
#'
#' @details
#' Default tier sufficient for most casual developers. Rate limited to 10
#' calls/second and 50,000 calls per day. This product contains 8 APIs and all
#' APIs needed for the functions in this package:
#' * Bus Route and Stop Methods
#' * GTFS (unused)
#' * Incidents
#' * Misc Methods
#' * Rail Station Information
#' * Real-Time Bus Predictions
#' * Real-Time Rail Predictions
#' * Train Positions
#'
#' @param api_key Subscription key which provides access to this API. Defaults
#'   `Sys.getenv("WMATA_KEY")` via [wmata_key()].
#' @return For [wmata_key()], a 32 character alphanumeric API key. For
#'   [wmata_validate()], either `TRUE` for a valid key or an error if invalid.
#' @seealso <https://developer.wmata.com/docs/services/5923434c08d33c0f201a600a/operations/5923437c031f5914d0204bcf>
#' @family Misc Methods
#' @importFrom httr GET accept_json add_headers http_error content stop_for_status
#' @export
wmata_key <- function(api_key = Sys.getenv("WMATA_KEY")) {
  stopifnot(is.character(api_key), length(api_key) == 1)
  if (identical(api_key, "")) {
    warning("No WMATA API key found, see help(wmata_key)", call. = FALSE)
  }
  return(api_key)
}

#' @rdname wmata_key
#' @export
wmata_validate <- function(api_key = wmata_key()) {
  val <- httr::GET(
    url = "https://api.wmata.com/Misc/Validate",
    httr::accept_json(),
    httr::add_headers(
      `api_key` = api_key
    )
  )
  if (httr::http_error(val)) {
    msg <- httr::content(val)
    stop(msg$message, call. = FALSE)
  } else {
    TRUE
  }
}
