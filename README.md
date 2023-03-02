
<!-- README.md is generated from README.Rmd. Please edit that file -->

# climateChangeInAustralia

<!-- badges: start -->

![GitHub R package
version](https://img.shields.io/github/r-package/v/shaunson26/climateInChangeAustralia)
[![R-CMD-check](https://github.com/Shaunson26/climateInChangeAustralia/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Shaunson26/climateInChangeAustralia/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of climateChangeInAustralia is to create an API to [Climate
Change in Australia](https://www.climatechangeinaustralia.gov.au/)
datasets.

- Links to dataset URLs
- Functions to download data subsets (NetCDF subsets)
- Functions and objects to help with data selection

<!-- -->

    # install.packages("devtools")
    devtools::install_github("Shaunson26/climateChangeInAustralia")

    library(climateChangeInAustralia)

## Source data

> <https://www.climatechangeinaustralia.gov.au/> - Climate information,
> projections, tools and data.

They provide
[datasets](https://www.climatechangeinaustralia.gov.au/en/obtain-data/download-datasets/)
from various
[models](https://www.climatechangeinaustralia.gov.au/en/overview/methodology/list-models/)
and for a number of
[variables](https://www.climatechangeinaustralia.gov.au/en/obtain-data/download-datasets/ccia-file-naming-convention/)
that include

1.  Projected change (compared with 1986-2005) data … +/- values
2.  Plausible future climate data … predicted values
3.  Threshold datasets … number of days above/below extremes e.g. \>30,
    \>35, \>45

Data is accessed via navigation through their web directories, and the
file names have a [naming
convention](https://www.climatechangeinaustralia.gov.au/en/obtain-data/download-datasets/ccia-file-naming-convention/)
describing (for the purpose of this package): variable, model,
representative concentration pathway (RCP, greenhouse gas scenarios) and
time period among other things.

> We crawled through their directories and created a JSON file with the
> links to all datasets. This can be imported as a named nested list for
> ease of navigation to particular datasets using `ccia_dataset_urls()`

``` r
ccia_datasets <- ccia_dataset_urls()

# dataset$variable_1$variable_1_1$datset_name
ccia_datasets$
  projected_change_data$
  Drought$
  `freq-duration`$
  `spi_Amon_ACCESS1-0_historical_r1i1p1_anntot-events_native.nc`
#> [1] "ua6_4/CMIP5/derived/Collections/Projected_Change_Data/Drought/freq-duration/spi_Amon_ACCESS1-0_historical_r1i1p1_anntot-events_native.nc"
```

From there, there are various options to download the data e.g. HTTP,
NetcdfSubset, among others

> Our download functions allow for the 8 ‘access’ types by we will only
> going to deal with NetcdfSubset and HTTP from here on.

The NetcdfSubset access uses a REST API -
`dataset/url?query=parameters`. There is a dataset description XML that
will be used to aid in data queries to avoid HTTP bad requests (ensuring
we make valid queries. nSee examples later on…

### Future gridded change data (native grid)

“These data provide the 20-year averaged monthly, seasonal and annual
changes for four time periods centred on 2030, 2050, 2070 & 2090 using a
time-slice method.”

- Variables include

``` r
names(ccia_datasets$projected_change_data) |>
  cat(sep = '\n')
#> Drought
#> Evapotranspiration
#> Humidity
#> Maximum_Temperature
#> Mean_Temperature
#> Minimum_Temperature
#> Rainfall
#> Solar_Radiation
#> Wind_Speed
#> rootURL
```

- 15 year range brackets … but a single time range value that the data
  was centred on e.g. “2030-01-01”

``` r
names(ccia_datasets$projected_change_data$Mean_Temperature) |>
  cat(sep = '\n')
#> 2015-2034
#> 2020-2039
#> 2025-2044
#> 2030-2049
#> 2035-2054
#> 2040-2059
#> 2045-2064
#> 2050-2069
#> 2055-2074
#> 2060-2079
#> 2065-2084
#> 2070-2089
#> 2075-2094
#> 2080-2099
```

- Multiple ‘seasonal’ variables within time range value … ‘annual’,
  ‘april’, ‘djf’ (months of summer)
- small data files … 0.25 to 10 Mb

### Application-ready datasets (5km grids)

“Application-ready datasets”produce plausible future climate data at
daily, monthly, seasonal and annual time steps on the high-resolution 5
km grid.”

#### Daily time-seris

- Variables include

``` r
names(ccia_datasets$application_ready_daily) |>
  cat(sep = '\n')
#> Solar_Radiation
#> Relative_Humidity
#> Rainfall_(Precipitation)
#> Minimum_Temperature
#> Mean_Temperature
#> Maximum_Temperature
#> Evaporation
#> rootURL
```

- 30 year range brackets … with daily data available

``` r
names(ccia_datasets$application_ready_daily$Mean_Temperature) |>
  cat(sep = '\n')
#> 2075-2104
#> 2056-2085
#> 2036-2065
#> 2016-2045
```

- Usually a single variable within the time range value
- **HUGE** data files 25 Gb … and the servers often timeout … expect to
  be doing multiple time slicing for these!

#### Monthly, seasonal, annual time-seris

- Variables include

``` r
names(ccia_datasets$application_ready_aggregated) |>
  cat(sep = '\n')
#> Rainfall_(Precipitation)
#> Minimum_Temperature
#> Mean_Temperature
#> Maximum_Temperature
#> rootURL
```

- 30 year range brackets … but often a single time range value
  e.g. 2030-01-01

``` r
names(ccia_datasets$application_ready_aggregated$Mean_Temperature) |>
  cat(sep = '\n')
#> 2075-2104
#> 2056-2085
#> 2036-2065
#> 2016-2045
```

- Multiple ‘seasonal’ variables within time range value … ‘annual’,
  ‘april’, ‘djf’ (months of summer)
- small data files … 0.25 to 10 Mb

### Threshold datasets (5km grids)

“These datasets are derived from the gridded application-ready daily
time-series described above. The data have been analysed to find the
number of days (on average) when … max \> 30-45, min \> 20-30, min \<
0-22”

- Variables include

``` r
names(ccia_datasets$application_ready_threshold) |>
  cat(sep = '\n')
#> Minimum_Temperature
#> Maximum_Temperature
#> rootURL
```

- 30 year range brackets …

``` r
names(ccia_datasets$application_ready_threshold$Maximum_Temperature) |>
  cat(sep = '\n')
#> 2075-2104
#> 2056-2085
#> 2036-2065
#> 2016-2045
```

- `mon` monthly centered (time dimension) for 2 variables (\>34, \>35)
- `clim` annual, monthly, seasonal (as variables) .. possibly year range
  centered

``` r
# These can get a bit confusing
names(ccia_datasets$application_ready_threshold$Maximum_Temperature$`2016-2045`) |>
  cat(sep = '\n')
#> mon
#> clim
```

- Multiple ‘seasonal’ variables within `clim` time range value …
  ‘annual’, ‘april’, ‘djf’ (months of summer)
- **Big** data files … 700 Mb - 2 Gb … expect to slice times

## Example use

With the dataset URL list

``` r
ccia_datasets <- ccia_dataset_urls()
```

Navigate the list object to a file name (ends in `.nc`). This returns a
relative URL

``` r
# ara = application ready aggregated
ara_mean_temp_2016_access1_rcp45 <- 
  ccia_datasets$
  application_ready_aggregated$
  Mean_Temperature$
  `2016-2045`$
  `tas_aus_ACCESS1-0_rcp45_r1i1p1_CSIRO-MnCh-wrt-1986-2005-Scl_v1_mon_seasavg_2016-2045_clim.nc`

ara_mean_temp_2016_access1_rcp45
#> [1] "oa-aus5km/Climate_Change_in_Australia_User_Data/Application_Ready_Data_Gridded_Aggregates/Mean_Temperature/2016-2045/tas_aus_ACCESS1-0_rcp45_r1i1p1_CSIRO-MnCh-wrt-1986-2005-Scl_v1_mon_seasavg_2016-2045_clim.nc"
```

We then create a `httr2` request object using
`ccia_create_dataset_request_url()`, and that we will build upon. There
are different access types to the file (they have different URL paths).
In this package, we use `"NetcdfSubset"` and the following functions
expect an intial request object build with this. We *can* build other
access URLs - `ccia_access_types` lists the 8 access types available.

``` r
ara_mean_temp_2016_access1_rcp45_req <- 
  ccia_create_dataset_request_url(dataset_relative_url = ara_mean_temp_2016_access1_rcp45, 
                             access_type = ccia_access_types$NetcdfSubset)

ara_mean_temp_2016_access1_rcp45_req
#> <httr2_request>
#> GET
#> https://data-cbr.csiro.au/thredds/ncss/catch_all/oa-aus5km/Climate_Change_in_Australia_User_Data/Application_Ready_Data_Gridded_Aggregates/Mean_Temperature/2016-2045/tas_aus_ACCESS1-0_rcp45_r1i1p1_CSIRO-MnCh-wrt-1986-2005-Scl_v1_mon_seasavg_2016-2045_clim.nc
#> Body: empty
```

Now we have the URL to the `"NetcdfSubset"` dataset but we need to
append some queries to subset the data. Generally we need to add queries
for

- the dataset variable(s)
- the time span
- lat/lon

The datasets can have few or many ‘internal’ variables (the ‘names’ of
the columns holding the data values, and whether there are multiple
‘columns’ of these). **We have the option of using `all` for all**
variables - which is usually safe for small data calls, or we can can
investigate the dataset using it’s “dataset description” - an XML we
download from a complete URL (minus query parameters). This is achieved
using `ccia_get_dataset_netcdf_subset_info()`

``` r
ara_mean_temp_2016_access1_rcp45_info <-
  ccia_get_dataset_netcdf_subset_info(ara_mean_temp_2016_access1_rcp45_req)

ara_mean_temp_2016_access1_rcp45_info
#> $vars
#> # A tibble: 19 × 4
#>    name          desc                                    shape        type 
#>    <chr>         <chr>                                   <chr>        <chr>
#>  1 tas_annual    Daily Mean Near-Surface Air Temperature time lat lon float
#>  2 tas_april     Daily Mean Near-Surface Air Temperature time lat lon float
#>  3 tas_august    Daily Mean Near-Surface Air Temperature time lat lon float
#>  4 tas_december  Daily Mean Near-Surface Air Temperature time lat lon float
#>  5 tas_djf       Daily Mean Near-Surface Air Temperature time lat lon float
#>  6 tas_february  Daily Mean Near-Surface Air Temperature time lat lon float
#>  7 tas_january   Daily Mean Near-Surface Air Temperature time lat lon float
#>  8 tas_jja       Daily Mean Near-Surface Air Temperature time lat lon float
#>  9 tas_july      Daily Mean Near-Surface Air Temperature time lat lon float
#> 10 tas_june      Daily Mean Near-Surface Air Temperature time lat lon float
#> 11 tas_mam       Daily Mean Near-Surface Air Temperature time lat lon float
#> 12 tas_march     Daily Mean Near-Surface Air Temperature time lat lon float
#> 13 tas_may       Daily Mean Near-Surface Air Temperature time lat lon float
#> 14 tas_mjjaso    Daily Mean Near-Surface Air Temperature time lat lon float
#> 15 tas_ndjfma    Daily Mean Near-Surface Air Temperature time lat lon float
#> 16 tas_november  Daily Mean Near-Surface Air Temperature time lat lon float
#> 17 tas_october   Daily Mean Near-Surface Air Temperature time lat lon float
#> 18 tas_september Daily Mean Near-Surface Air Temperature time lat lon float
#> 19 tas_son       Daily Mean Near-Surface Air Temperature time lat lon float
#> 
#> $TimeSpan
#> $TimeSpan$begin
#> [1] "2031-01-01T00:00:00Z"
#> 
#> $TimeSpan$end
#> [1] "2031-01-01T00:00:00Z"
```

The `vars$name` represents the ‘columns’ of the data, and the `TimeSpan`
the time ranges (some times there are strange time points - monthly
centered, year range centered). Obtaining the dataset description will
help in avoiding a bad request, however, the server will return useful
messages (these are printed to the console when it happens). We use the
data here to create a query to add to the request.

Requests use a REST API structure `dataset/url?query=parameter` and the
function `ccia_add_netcdf_subset_query()` helps here. In this example,
we pick the 4 ‘3 month periods’ (seasons in Australia), use the single
time value for this data, and a bounding box of coordinates.

``` r
ara_mean_temp_2016_access1_rcp45_req_query <-
  ara_mean_temp_2016_access1_rcp45_req |>
  ccia_add_netcdf_subset_query(vars = c('tas_djf', 'tas_mam', 'tas_jja', 'tas_son'),
                          bbox = c(151, -33, 151.1, -32.9))

ara_mean_temp_2016_access1_rcp45_req_query
#> <httr2_request>
#> GET
#> https://data-cbr.csiro.au/thredds/ncss/catch_all/oa-aus5km/Climate_Change_in_Australia_User_Data/Application_Ready_Data_Gridded_Aggregates/Mean_Temperature/2016-2045/tas_aus_ACCESS1-0_rcp45_r1i1p1_CSIRO-MnCh-wrt-1986-2005-Scl_v1_mon_seasavg_2016-2045_clim.nc?var=tas_djf&var=tas_mam&var=tas_jja&var=tas_son&north=-32.9&west=151&east=151.1&south=-33&disableProjSubset=on&horizStride=1&accept=netcdf4
#> Headers:
#> • Accept: 'application/x-netcdf4'
#> Body: empty
```

Then we perform the request and save the object using
`ccia_perform_query()`. The return value is the file path

``` r
temp_file_nc <- tempfile(fileext = '.nc')

ara_mean_temp_2016_access1_rcp45_req_filepath <-
  ara_mean_temp_2016_access1_rcp45_req_query |>
  ccia_perform_query(destfile = temp_file_nc)
#> file downloaded to: C:\Users\Shaunus\AppData\Local\Temp\RtmpcXUHPx\file33c0540e31ec.nc
```

Using the `stars` package

``` r
temp_file_nc |>
  stars::read_ncdf()
#> no 'var' specified, using tas_djf, tas_mam, tas_jja, tas_son
#> other available variables:
#>  time, lat, lon
#> Will return stars object with 9 cells.
#> No projection information found in nc file. 
#>  Coordinate variable units found to be degrees, 
#>  assuming WGS84 Lat/Lon.
#> stars object with 3 dimensions and 4 attributes
#> attribute(s):
#>                 Min.  1st Qu.   Median     Mean  3rd Qu.     Max.
#> tas_djf [C] 23.05265 23.59020 23.85466 23.78922 24.03512 24.39494
#> tas_mam [C] 17.69464 18.27954 18.51566 18.37682 18.60132 18.84821
#> tas_jja [C] 11.69961 12.29776 12.42071 12.30569 12.48870 12.64273
#> tas_son [C] 17.47395 18.06643 18.30319 18.15960 18.37647 18.62576
#> dimension(s):
#>      from to  offset delta  refsys         values x/y
#> lon     1  3 150.975  0.05  WGS 84           NULL [x]
#> lat     1  3 -33.025  0.05  WGS 84           NULL [y]
#> time    1  1      NA    NA POSIXct 2031-01-01 UTC
```
