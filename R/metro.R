#' metro: A package for the Washington Metropolitan Area Transit Authority API
#'
#' The Metro Transparent Data Sets API provides developer access to JSON data
#' for the order and location of rail stations by line, train arrival
#' predictions for each station, service alerts, and elevator/escalator status.
#' This package has been developed to make calls to the API using dedicated
#' R functions with copied documentation and identical parameters/arguments. All
#' functions return one or more data frames for easy analysis.
#'
#' @section Endpoints:
#' There are six endpoint categories returning JSON data.
#'
#' 1. Bus Route and Stop Methods, starting with `bus_*`:
#'     * Bus Position: [bus_position()]
#'     * Path details: [bus_path()]
#'     * Routes: [bus_routes()]
#'     * Schedule: [bus_schedule()]
#'     * Schedule at stop: [bus_departs()]
#'     * Stop search: [bus_stops()]
#'
#' 2. Incidents, ending with `*_incidents`:
#'     * Bus Incidents: [bus_incidents()]
#'     * Elevator/Escalator Outages: [elevator_incidents()]
#'     * Rail Incidents: [rail_incidents()]
#'
#' 3. Misc Methods
#'     * Validate API Key: [wmata_validate()]
#'
#' 4. Rail Station Information, starting with `rail_*`:
#'     * Lines: [rail_lines()]
#'     * Parking Information: Not yet covered.
#'     * Path Between Stations: [rail_path()]
#'     * Station Entrances: [rail_entrance()]
#'     * Station Information: [station_info()]
#'     * Station List: [rail_stations()]
#'     * Station Timings: [rail_times()]
#'     * Station to Station Information: [rail_destination()]
#'
#' 5. Real-Time Predictions, starting with `next_*`:
#'     *  Next Buses: [next_bus()]
#'     *  Next Trains: [next_train()]
#'
#' 6. Train Positions:
#'     * Live Train Positions: [rail_positions()]
#'     * Standard Routes: [standard_routes()]
#'     * Track Circuits: [track_circuits()]
#'
#' @docType package
#' @name metro
NULL
#> NULL
