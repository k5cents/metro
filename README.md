
<!-- README.md is generated from README.Rmd. Please edit that file -->

# metro <img src='man/figures/logo.png' align="right" height="139" />

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html)
[![CRAN
status](https://www.r-pkg.org/badges/version/metro)](https://CRAN.R-project.org/package=metro)
[![Codecov test
coverage](https://codecov.io/gh/kiernann/metro/branch/master/graph/badge.svg)](https://codecov.io/gh/kiernann/metro?branch=master)
[![R build
status](https://github.com/kiernann/metro/workflows/R-CMD-check/badge.svg)](https://github.com/kiernann/metro/actions)
<!-- badges: end -->

The goal of metro is to return data frames from the Washington
Metropolitan Area Transit Authority API. Nested lists have been
converted to [tidy](https://en.wikipedia.org/wiki/Tidy_data) data frames
when possible.

## Installation

You can install the development version of metro from
[GitHub](https://github.com/kiernann/metro):

``` r
# install.packages("devtools")
devtools::install_github("kiernann/metro")
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

As of February 2021, the demo key can be used like this:

``` r
Sys.setenv("WMATA_KEY" = "e13626d03d8e4c03ac07f95541b3091b")
```

## Example

``` r
library(metro)
```

Functions return data frames for easy analysis.

``` r
rail_stations(LineCode = "RD")
#> # A tibble: 27 x 10
#>    StationCode StationName    StationTogether LineCodes   Lat   Lon Street    City  State Zip  
#>    <chr>       <chr>          <chr>           <list>    <dbl> <dbl> <chr>     <chr> <chr> <chr>
#>  1 A01         Metro Center   C01             <chr [1]>  38.9 -77.0 607 13th… Wash… DC    20005
#>  2 A02         Farragut North <NA>            <chr [1]>  38.9 -77.0 1001 Con… Wash… DC    20036
#>  3 A03         Dupont Circle  <NA>            <chr [1]>  38.9 -77.0 1525 20t… Wash… DC    20036
#>  4 A04         Woodley Park-… <NA>            <chr [1]>  38.9 -77.1 2700 Con… Wash… DC    20008
#>  5 A05         Cleveland Park <NA>            <chr [1]>  38.9 -77.1 3599 Con… Wash… DC    20008
#>  6 A06         Van Ness-UDC   <NA>            <chr [1]>  38.9 -77.1 4200 Con… Wash… DC    20008
#>  7 A07         Tenleytown-AU  <NA>            <chr [1]>  38.9 -77.1 4501 Wis… Wash… DC    20016
#>  8 A08         Friendship He… <NA>            <chr [1]>  39.0 -77.1 5337 Wis… Wash… DC    20015
#>  9 A09         Bethesda       <NA>            <chr [1]>  39.0 -77.1 7450 Wis… Beth… MD    20814
#> 10 A10         Medical Center <NA>            <chr [1]>  39.0 -77.1 8810 Roc… Beth… MD    20814
#> # … with 17 more rows
```

Use coordinates to find station entrances or bus stops near a location.

``` r
# White House coordinates
rail_entrance(Lat = 38.8979, Lon = -77.0365, Radius = 500)
#> # A tibble: 3 x 7
#>   Name          StationCode StationTogether Description                      Lat   Lon Distance
#>   <chr>         <chr>       <chr>           <chr>                          <dbl> <dbl>    <dbl>
#> 1 WEST ENTRANC… C02         <NA>            Building entrance from the so…  38.9 -77.0     383.
#> 2 EAST ENTRANC… C03         <NA>            Building entrance from the so…  38.9 -77.0     430.
#> 3 EAST ENTRANC… C02         <NA>            Building entrance from the so…  38.9 -77.0     499.
```

Dates use the UTC time zone but times use EST. Times are represented
using the [`hms`](https://github.com/tidyverse/hms/issues/28) class,
which counts the seconds since midnight (sometimes this means AM times
are over 24 hours).

``` r
bus_position(RouteId = "L2")
#> # A tibble: 2 x 13
#>   VehicleID   Lat   Lon Distance Deviation DateTime            TripID RouteID DirectionText
#>   <chr>     <dbl> <dbl>    <dbl>     <dbl> <dttm>              <chr>  <chr>   <chr>        
#> 1 7112       39.0 -77.1       NA         5 2021-02-23 05:05:16 19091… L2      SOUTH        
#> 2 7120       38.9 -77.0       NA         1 2021-02-23 05:05:08 19091… L2      NORTH        
#> # … with 4 more variables: TripHeadsign <chr>, TripStartTime <dttm>, TripEndTime <dttm>,
#> #   BlockNumber <chr>
```

``` r
rail_times(StationCode = "A07")
#> # A tibble: 14 x 7
#>    StationCode StationName   DestinationStation Weekday OpeningTime FirstTime LastTime
#>    <chr>       <chr>         <chr>              <chr>   <time>      <time>    <time>  
#>  1 A07         Tenleytown-AU A15                Mon     05:14       05:46     23:51   
#>  2 A07         Tenleytown-AU B11                Mon     05:14       05:24     23:19   
#>  3 A07         Tenleytown-AU A15                Tue     05:14       05:46     23:51   
#>  4 A07         Tenleytown-AU B11                Tue     05:14       05:24     23:19   
#>  5 A07         Tenleytown-AU A15                Wed     05:14       05:46     23:51   
#>  6 A07         Tenleytown-AU B11                Wed     05:14       05:24     23:19   
#>  7 A07         Tenleytown-AU A15                Thu     05:14       05:46     23:51   
#>  8 A07         Tenleytown-AU B11                Thu     05:14       05:24     23:19   
#>  9 A07         Tenleytown-AU A15                Fri     05:14       05:46     25:21   
#> 10 A07         Tenleytown-AU B11                Fri     05:14       05:24     24:49   
#> 11 A07         Tenleytown-AU A15                Sat     07:14       07:46     25:21   
#> 12 A07         Tenleytown-AU B11                Sat     07:14       07:24     24:49   
#> 13 A07         Tenleytown-AU A15                Sun     08:14       08:46     23:21   
#> 14 A07         Tenleytown-AU B11                Sun     08:14       08:24     22:49
```

Functions that always return the same data have that data saved as
objects.

``` r
metro_stops # bus_stops() for live
#> # A tibble: 9,044 x 5
#>    StopID  Name                                                Lon   Lat Routes   
#>    <chr>   <chr>                                             <dbl> <dbl> <list>   
#>  1 1000001 SHEPHERD PKY SW + SHEPHERD PKY SW                 -77.0  38.8 <chr [3]>
#>  2 1000003 SHEPHERD PKY SW + DC VILLAGE LN                   -77.0  38.8 <chr [3]>
#>  3 1000004 M L KING AVE + JOLIET ST                          -77.0  38.8 <chr [5]>
#>  4 1000005 SHEPHERD PKWY + FIRE DEPT TRNG CTR                -77.0  38.8 <chr [3]>
#>  5 1000006 SHEPHERD PKY SW + FIRE DEPARTMENT TRAINING CENTER -77.0  38.8 <chr [3]>
#>  6 1000007 IRVINGTON ST SW + MARTIN LUTHER KING JR AVE SW    -77.0  38.8 <chr [6]>
#>  7 1000008 IRVINGTON ST + IVANHOE ST                         -77.0  38.8 <chr [6]>
#>  8 1000009 SOUTHERN AVE SE + S CAPITOL ST SE                 -77.0  38.8 <chr [1]>
#>  9 1000010 MARTIN LUTHER KING JR AVE SW + #4660              -77.0  38.8 <chr [5]>
#> 10 1000012 MARTIN LUTHER KING JR AVE SW + BLUE PLAINS DR SW  -77.0  38.8 <chr [6]>
#> # … with 9,034 more rows
```

<!-- refs: start -->
<!-- refs: end -->
