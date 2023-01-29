library(tidyverse)
library(plumber)

pr("~/people-safety-app-scotland-server/plumber.R") %>%
  pr_run(port = 8000)
