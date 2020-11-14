
<!-- README.md is generated from README.Rmd. Please edit that file -->

# metro <img src='man/figures/logo.png' align="right" height="139" />

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/metro)](https://CRAN.R-project.org/package=metro)
[![Codecov test
coverage](https://codecov.io/gh/kiernann/metro/branch/master/graph/badge.svg)](https://codecov.io/gh/kiernann/metro?branch=master)
[![R build
status](https://github.com/kiernann/metro/workflows/R-CMD-check/badge.svg)](https://github.com/kiernann/metro/actions)
<!-- badges: end -->

The goal of metro is to return data frames from the Washington
Metropolitan Area Transit Authority API. User need a WMATA API key, see
below for more details.

## Installation

You can install the development version of metro from
[GitHub](https://github.com/kiernann/metro):

``` r
# install.packages("devtools")
devtools::install_github("kiernann/metro")
```

## Key

Usage of the WMATA API requires a developer API key. Such a key can be
obtained by creating a developer account and subscribing to the default
tier, which allows 10 calls per second and full access to all eight
APIs.

The WMATA also provides a demo key which should **not** be used in
production. This key is severely rate limited and is subject to change
at any time. It is only suitable for trying out the various features of
the API. As of November 13, 2020 this is the demo key you can use:

    e13626d03d8e4c03ac07f95541b3091b

## Example

``` r
library(metro)
```

All functions return data frames for easy analysis.

``` r
rail_stations(line = "RD")
#> # A tibble: 27 x 10
#>    station name                  txfer lines      lat   lon street             city     state   zip
#>    <chr>   <chr>                 <chr> <list>   <dbl> <dbl> <chr>              <chr>    <chr> <int>
#>  1 A01     Metro Center          C01   <chr [1…  38.9 -77.0 607 13th St. NW    Washing… DC    20005
#>  2 A02     Farragut North        <NA>  <chr [1…  38.9 -77.0 1001 Connecticut … Washing… DC    20036
#>  3 A03     Dupont Circle         <NA>  <chr [1…  38.9 -77.0 1525 20th St. NW   Washing… DC    20036
#>  4 A04     Woodley Park-Zoo/Ada… <NA>  <chr [1…  38.9 -77.1 2700 Connecticut … Washing… DC    20008
#>  5 A05     Cleveland Park        <NA>  <chr [1…  38.9 -77.1 3599 Connecticut … Washing… DC    20008
#>  6 A06     Van Ness-UDC          <NA>  <chr [1…  38.9 -77.1 4200 Connecticut … Washing… DC    20008
#>  7 A07     Tenleytown-AU         <NA>  <chr [1…  38.9 -77.1 4501 Wisconsin Av… Washing… DC    20016
#>  8 A08     Friendship Heights    <NA>  <chr [1…  39.0 -77.1 5337 Wisconsin Av… Washing… DC    20015
#>  9 A09     Bethesda              <NA>  <chr [1…  39.0 -77.1 7450 Wisconsin Av… Bethesda MD    20814
#> 10 A10     Medical Center        <NA>  <chr [1…  39.0 -77.1 8810 Rockville Pi… Bethesda MD    20814
#> # … with 17 more rows
```

Functions that typically return the same data have that data saved as
objects.

``` r
metro::lines
#> # A tibble: 6 x 4
#>   line  name   start end  
#>   <chr> <chr>  <chr> <chr>
#> 1 BL    Blue   J03   G05  
#> 2 GR    Green  F11   E10  
#> 3 OR    Orange K08   D13  
#> 4 RD    Red    A15   B11  
#> 5 SV    Silver N06   G05  
#> 6 YL    Yellow C15   E06
```

<!-- refs: start -->

<!-- refs: end -->
