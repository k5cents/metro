
<!-- README.md is generated from README.Rmd. Please edit that file -->

# metro <img src='man/figures/logo.png' align="right" height="139" />

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-stable-green)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![CRAN
status](https://www.r-pkg.org/badges/version/metro)](https://CRAN.R-project.org/package=metro)
![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/gluedown)
[![Codecov test
coverage](https://img.shields.io/codecov/c/github/k5cents/metro/master.svg)](https://app.codecov.io/gh/k5cents/metro?branch=master')
[![R build
status](https://github.com/k5cents/metro/workflows/R-CMD-check/badge.svg)](https://github.com/k5cents/metro/actions)
<!-- badges: end -->

The goal of metro is to return data frames from the Washington
Metropolitan Area Transit Authority API. Nested lists have been
converted to [tidy](https://en.wikipedia.org/wiki/Tidy_data) data frames
when possible.

## Installation

The release version of metro (0.9.1) can be installed from
[CRAN](https://cran.r-project.org/package=metro):

``` r
install.packages("metro")
```

Or install the development version from
[GitHub](https://github.com/k5cents/metro):

``` r
# install.packages("devtools")
devtools::install_github("k5cents/metro")
```

## Key

Usage of the WMATA API requires a developer API key. Such a key can be
obtained by creating a developer account and subscribing to the free
default tier.

The WMATA also provides a [demo
key](https://developer.wmata.com/products/5475f236031f590f380924ff) to
try out the various features of the API. This key should **never** be
used in production, it is rate limited and subject to change at any
time.

``` r
Sys.setenv(WMATA_KEY = "e13626d03d8e4c03ac07f95541b3091b")
```

## Example

``` r
library(metro)
packageVersion("metro")
#> [1] '0.9.3'
```

Functions return data frames for easy analysis.

``` r
next_train(StationCodes = "A01")
#> # A tibble: 6 × 9
#>     Car Destination DestinationCode DestinationName Group Line  LocationCode LocationName   Min
#>   <int> <chr>       <chr>           <chr>           <int> <chr> <chr>        <chr>        <int>
#> 1     6 Glenmont    B11             Glenmont            1 RD    A01          Metro Center     0
#> 2     8 Friendship  <NA>            Friendship          2 RD    A01          Metro Center     3
#> 3     6 Glenmont    B11             Glenmont            1 RD    A01          Metro Center     8
#> 4     8 Friendship  <NA>            Friendship          2 RD    A01          Metro Center    10
#> 5     8 Glenmont    B11             Glenmont            1 RD    A01          Metro Center    15
#> 6     8 Friendship  <NA>            Friendship          2 RD    A01          Metro Center    18
```

### Coordinates

Use coordinates to find station entrances or bus stops near a location.
The [`geodist::geodist()`](https://github.com/hypertidy/geodist)
function is used to calculate distance from the supplied coordinates.

``` r
# Washington Monument coordinates
rail_entrance(Lat = 38.890, Lon = -77.035, Radius = 750)[, -(3:4)]
#> # A tibble: 6 × 5
#>   Name                                        StationCode   Lat   Lon Distance
#>   <chr>                                       <chr>       <dbl> <dbl>    <dbl>
#> 1 12TH ST NW & JEFERSON DR SW                 D02          38.9 -77.0     582.
#> 2 12TH ST SW & INDEPENDENCE AVE SW (ELEVATOR) D02          38.9 -77.0     612.
#> 3 12TH ST SW & INDEPENDENCE AVE SW            D02          38.9 -77.0     626.
#> 4 12TH ST NW & PENNSYLVANIA AVE NW            D01          38.9 -77.0     672.
#> 5 13TH ST NW & PENNSYLVANIA AVE NW (BUILDING) D01          38.9 -77.0     685.
#> 6 12TH ST NW & PENNSYLVANIA AVE NW (ELEVATOR) D01          38.9 -77.0     714.
```

### Dates and Times

Date columns with class `POSIXt` have been shifted from Eastern time to
the UTC time zone (+5 hours).

``` r
bus_position(RouteId = "33")[, 1:8]
#> # A tibble: 6 × 8
#>   VehicleID   Lat   Lon Distance Deviation DateTime            TripID   RouteID
#>   <chr>     <dbl> <dbl>    <dbl>     <dbl> <dttm>              <chr>    <chr>  
#> 1 4566       38.9 -77.0       NA         4 2024-03-11 02:50:44 9684010  33     
#> 2 7122       38.9 -77.1       NA         6 2024-03-11 02:50:45 1031010  33     
#> 3 4794       38.9 -77.1       NA         8 2024-03-11 02:50:44 18769010 33     
#> 4 4589       38.9 -77.1       NA         0 2024-03-11 02:50:50 30442010 33     
#> 5 4786       39.0 -77.1       NA         8 2024-03-11 02:51:00 10847010 33     
#> 6 4781       38.9 -77.0       NA         2 2024-03-11 02:50:43 47206010 33
```

Time values are left in Eastern time and are represented using the class
[`hms`](https://github.com/tidyverse/hms), which counts the seconds
since midnight. If the *last* train on a Saturday leaves at 1:21 AM
(past midnight), this would be represented as `25:21`.

``` r
tail(rail_times(StationCode = "E10"))
#> # A tibble: 6 × 7
#>   StationCode StationName DestinationStation Weekday OpeningTime FirstTime LastTime
#>   <chr>       <chr>       <chr>              <chr>   <time>      <time>    <time>  
#> 1 E10         Greenbelt   F11                Tue     04:50       05:00     23:30   
#> 2 E10         Greenbelt   F11                Wed     04:50       05:00     23:30   
#> 3 E10         Greenbelt   F11                Thu     04:50       05:00     23:30   
#> 4 E10         Greenbelt   F11                Fri     04:50       05:00     26:30   
#> 5 E10         Greenbelt   F11                Sat     06:50       07:00     26:30   
#> 6 E10         Greenbelt   F11                Sun     06:50       07:00     23:30
```

### Data

Some data frames are includes as objects if their functions typically
return the same thing every time.

``` r
metro_lines # rail_lines() for live
#> # A tibble: 6 × 5
#>   LineCode DisplayName StartStationCode EndStationCode InternalDestination
#>   <chr>    <chr>       <chr>            <chr>          <list>             
#> 1 BL       Blue        J03              G05            <chr [0]>          
#> 2 GR       Green       F11              E10            <chr [0]>          
#> 3 OR       Orange      K08              D13            <chr [0]>          
#> 4 RD       Red         A15              B11            <chr [2]>          
#> 5 SV       Silver      N06              G05            <chr [0]>          
#> 6 YL       Yellow      C15              E06            <chr [1]>
```

<!-- refs: start -->
<!-- refs: end -->
