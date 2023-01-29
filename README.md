# People's Safety Application Scotland and England

### Files of the repository

    ├── utils.R

This file loads the packages and the commonly used functions. Run this script before any other script you want to evaluate.

    ├── main.R

This file loads the API on port 8000.

    ├── plumber.R

This file is responsible for all the available endpoints. 

    ├── 01-extract_scot.R
    
The data was extracted with the help of [opendatascot](https://github.com/DataScienceScotland/opendatascot) package and the local authority codes were joined with their names ([2011 Data Zone Lookup](https://statistics.gov.scot/data/data-zone-lookup)). The crime names are also formatted in this step.

    ├── 02-clean_scot.R
    
Next, the most commonly committed crimes and their numbers, the danger severity scores, and the score category were assigned. 

    ├── 03-extract_en.R
    
-

    ├── 04-clean_en.R
    
-

    ├── 06-neigbours_scot.R
    ├── 07-neigbours_en.R
    
-

    ├── find_point_in_shape.R

