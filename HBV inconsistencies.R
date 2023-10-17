library(tidyverse)
library(dbplyr)
library(janitor)


date_today <- format(Sys.Date(), "%Y%m%d")
ncres_access = 'semi'
user <- Sys.getenv('USERNAME')

con <- DBI::dbConnect(
  odbc::odbc(),
  driver = "SQL Server",
  server = "virtapp-dbs020.nswhealth.net,1433",
  database = "ncres",
  trusted_connection = "yes"
)

ncres <- dplyr::tbl(con, paste0("ncres_", ncres_access))

ncres_hbv <- ncres %>%
  dplyr::filter(condition == 'Hepatitis B - Unspecified') %>% 
  dplyr::collect() 


### Look at recent misclassifications
ncres_hbv %>% 
  dplyr::filter(lhd_2010_code == "X700" | 
                  owning_jurisdiction == "Camperdown",
                !(lhd_2010_code == "X700" & 
                    owning_jurisdiction == "Camperdown"),
                earliest_notification_date >= "2023-01-01") %>% 
  dplyr::select(case_id, earliest_notification_date, 
                lhd_2010_code, owning_jurisdiction) %>% 
  dplyr::mutate(Link = paste0('https://ncims.health.nsw.gov.au/main.do?CaseID=', case_id)) %>% 
  readr::write_csv(glue::glue(
    'C:/Users/{user}/NSW Health Department/SLHD PHU - Documents/CD team/',
    'Hepatitis B Pathways to Care/{date_today}-LHD_Inconsistencies.csv'))

