# metro 0.9.1

* Covered most [JSON endpoints](https://developer.wmata.com/docs/services/) 
  as tidy data frames. Buses stops, train stations, next bus or
  trains, incidents, paths, routes, circuits. (#1)
* `httr::RETRY()` in `wmata_api()` does not retry on 401, 404, etc. The purpose
  of this change is to primarily retry on 429 errors when too many requests have
  been made on a rate-limited subscription. Waiting should successfully retry.
* Stops, Stations, Routes, and Lines saved as exported objects.
* All functions accept `api_key` argument. (#5)
* Calls are made using `httr::RETRY()` to deal with issues like rate limit. (#8)
* Use the documentation and parameters in the official API documentation. (#7)
* Convert all dates to `POSIXct` with UTC time zone.
* Convert times to `hms` columns with values past midnight. (#6)
* Removed `parking_*()` functions until a data frames can be made.
* Removed `rail_path()` helper function. Keep only endpoint functions.
* Removed ability to automatically scrape demo API key.
* Removed package startup message about API key. (#2)
* Invalid URLs are removed from function documentation.
