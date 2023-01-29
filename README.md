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
    
Next, this file evaluates the most commonly committed crimes and their numbers, the danger severity scores, and the score category.

    ├── 03-extract_en.R
    
This files reads in 11 months of crime data from 01/2022 to 11/2022 utilising the [English governmental crime database](https://data.police.uk/data/). In addition, it reads in the [LSOA population](https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/lowersuperoutputareamidyearpopulationestimates) and post codes with their respective LSOA names ([Postcode to Output Area to Lower Layer Super Output Area Lookup](https://geoportal.statistics.gov.uk/datasets/postcode-to-output-area-to-lower-layer-super-output-area-to-middle-layer-super-output-area-to-local-authority-district-may-2022-lookup-in-the-uk-1/about)).

**_NOTE:_** [Postcode to Output Area to Lower Layer Super Output Area Lookup](https://geoportal.statistics.gov.uk/datasets/postcode-to-output-area-to-lower-layer-super-output-area-to-middle-layer-super-output-area-to-local-authority-district-may-2022-lookup-in-the-uk-1/about) is not included in this repository. Before pulling, please make sure that you have the mentioned file downloaded and present in the [data/raw_data](data/raw_data) path.

    ├── 04-clean_en.R
    


    ├── 06-neigbours_scot.R
    ├── 07-neigbours_en.R
    
-

    ├── find_point_in_shape.R

