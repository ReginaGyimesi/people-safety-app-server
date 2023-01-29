# People's Safety Application Scotland and England

### Files of the repository

    ├── utils.R

This file loads the packages and the commonly used functions. Run this script before any other script you want to evaluate.

    ├── main.R

This file loads the API on port 8000.

    ├── plumber.R

This file is responsible for all the available endpoints. 

    ├── 01-extract_scot.R
    
This file extracts the Scottish recorded crimes with the help of [opendatascot](https://github.com/DataScienceScotland/opendatascot) package. The local authority codes are joined with their names with the help of [2011 Data Zone Lookup](https://statistics.gov.scot/data/data-zone-lookup).

    ├── 02-clean_scot.R
    
Next, this file evaluates the most commonly committed crimes and their occurrences, the danger severity scores, and the score category.

    ├── 03-extract_en.R
    
Reads in 11 months of crime data from 01/2022 to 11/2022 utilising the [English governmental crime database](https://data.police.uk/data/). In addition, it reads in the [LSOA population](https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/lowersuperoutputareamidyearpopulationestimates), and post codes with their respective LSOA names ([Postcode to Output Area to Lower Layer Super Output Area Lookup](https://geoportal.statistics.gov.uk/datasets/postcode-to-output-area-to-lower-layer-super-output-area-to-middle-layer-super-output-area-to-local-authority-district-may-2022-lookup-in-the-uk-1/about)).

**_NOTE:_** [Postcode to Output Area to Lower Layer Super Output Area Lookup](https://geoportal.statistics.gov.uk/datasets/postcode-to-output-area-to-lower-layer-super-output-area-to-middle-layer-super-output-area-to-local-authority-district-may-2022-lookup-in-the-uk-1/about) is not included in this repository. Before pulling, please make sure that you have the mentioned file downloaded and present in the [data/raw_data](data/raw_data) path.

    ├── 04-clean_en.R
    
This file produces the same format as for the Scottish data frame. It contains the crime ratio,  most commonly committed crimes and their occurrences, the danger severity scores, and the score category. 

    ├── 06-neigbours_scot.R
    ├── 07-neigbours_en.R
    
Reads in the [Scottish local authority shape files](https://www.data.gov.uk/dataset/8e3a4564-8081-42ec-8772-03ade11d4acf/local-authority-boundaries-scotland) and [English LSOA shape files](https://www.data.gov.uk/dataset/fa883558-22fb-4a1a-8529-cffdee47d500/lower-layer-super-output-area-lsoa-boundaries). Produces a list of neigbouring areas and each neighbour has their longitude and latitude of their central point.

    ├── find_point_in_shape.R

This includes functions to find out if a point is present in a given shape. At the end, these didn't make the cut to the final API.

Pull requests are highly welcome. If you have any questions please reach out on [regina.gyimesi.2019@uni.strath.ac.uk](mailto:regina.gyimesi.2019@uni.strath.ac.uk).