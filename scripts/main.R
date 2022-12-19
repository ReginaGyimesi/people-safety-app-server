library(tidyverse)
library(plumber)

pr("~/people-safety-app-scotland-server/scripts/plumber.R") %>%
  pr_run(port = 8000)


