library(readxl)
library(lubridate)
library(tidyverse)
library(furrr)


Start <- as.Date("2023-01-01")
End <- as.Date("2023-06-26")

RACF_start <- as.Date(Start, format = "%d %B %Y")
RACF_end <- as.Date(End, format = "%d %B %Y")


all_handovers <- list.files(path = paste0("C:/Users/",Sys.getenv('USERNAME'),"/NSW Health Department/PHU Outreach RACF - Documents/PHU RACF handover/Archive/2023"), pattern = "RACF handover.*\\.xlsx", full.names = TRUE)


# COVID-19 ----------------------------------------------------------------

COVID_handover_data_fn <- function(x) {
  if (grepl("\\d{2} \\w+ \\d{4}", x)) {
    date_str <- str_extract(x, "\\d{2} \\w+ \\d{4}")
    date <- as.Date(date_str, format = "%d %B %Y")
    if (date >= RACF_start & date <= RACF_end) {
      read_excel(x, sheet = 'Team 1') %>% 
        dplyr::select(Lockdown = "Lockdown status",
                      Residents = "No. of positive residents",
                      Hosp = "Number of hospitalisations attributable to disease",
                      Deaths = "Number of deaths attributable to disease",
                      Closed = "Date Closed") %>% 
        dplyr::filter(Lockdown == "Red lockdown"|
                        Lockdown == "Yellow monitoring"|
                        Lockdown == "Purple monitoring"|
                        Lockdown == "Amber monitoring",
                      is.na(Closed)) %>% 
        dplyr::bind_rows(read_excel(x, sheet = 'Team 2') %>% 
                           dplyr::select(Lockdown = "Lockdown status",
                                         Residents = "No. of positive residents",
                                         Hosp = "Number of hospitalisations attributable to disease",
                                         Deaths = "Number of deaths attributable to disease",
                                         Closed = "Date Closed") %>% 
                           dplyr::filter(Lockdown == "Red lockdown"|
                                           Lockdown == "Yellow monitoring"|
                                           Lockdown == "Purple monitoring"|
                                           Lockdown == "Amber monitoring",
                                         is.na(Closed))) %>% 
        dplyr::bind_rows(read_excel(x, sheet = 'Team 3') %>% 
                           dplyr::select(Lockdown = "Lockdown status",
                                         Residents = "No. of positive residents",
                                         Hosp = "Number of hospitalisations attributable to disease",
                                         Deaths = "Number of deaths attributable to disease",
                                         Closed = "Date Closed") %>% 
                           dplyr::filter(Lockdown == "Red lockdown"|
                                           Lockdown == "Yellow monitoring"|
                                           Lockdown == "Purple monitoring"|
                                           Lockdown == "Amber monitoring",
                                         is.na(Closed))) %>% 
        dplyr::bind_rows(read_excel(x, sheet = 'Team 4') %>% 
                           dplyr::select(Lockdown = "Lockdown status",
                                         Residents = "No. of positive residents",
                                         Hosp = "Number of hospitalisations attributable to disease",
                                         Deaths = "Number of deaths attributable to disease",
                                         Closed = "Date Closed") %>% 
                           dplyr::filter(Lockdown == "Red lockdown"|
                                           Lockdown == "Yellow monitoring"|
                                           Lockdown == "Purple monitoring"|
                                           Lockdown == "Amber monitoring",
                                         is.na(Closed))) %>% 
        dplyr::summarise(Cases = sum(Residents, na.rm = TRUE),
                         Hospitalisations = sum(Hosp, na.rm = TRUE),
                         Deaths = sum(Deaths, na.rm = TRUE)) %>% 
        dplyr::mutate(Date = date)
    }
  }
}

no_cores <- availableCores() - 1
plan(multicore, workers = no_cores)

COVID_RACF_list <- future_map(all_handovers,COVID_handover_data_fn)

COVID_RACF_data <- bind_rows(handover_data) %>% 
  dplyr::select(Date, Cases:Deaths) %>% 
  dplyr::arrange(Date)

# Influenza ---------------------------------------------------------------


FLU_handover_data_fn <- function(x) {
  if (grepl("\\d{2} \\w+ \\d{4}", x)) {
    date_str <- str_extract(x, "\\d{2} \\w+ \\d{4}")
    date <- as.Date(date_str, format = "%d %B %Y")
    if (date >= RACF_start & date <= RACF_end) {
      read_excel(x, sheet = 'Team 1') %>% 
        dplyr::select(Lockdown = "Lockdown status",
                      Residents = "No. of positive residents",
                      Hosp = "Number of hospitalisations attributable to disease",
                      Deaths = "Number of deaths attributable to disease",
                      Closed = "Date Closed") %>% 
        dplyr::filter(Lockdown == "Influenza - FluCARE" |
                        Lockdown == "Influenza - Not on FluCARE",
        is.na(Closed)) %>% 
        dplyr::bind_rows(read_excel(x, sheet = 'Team 2') %>% 
                           dplyr::select(Lockdown = "Lockdown status",
                                         Residents = "No. of positive residents",
                                         Hosp = "Number of hospitalisations attributable to disease",
                                         Deaths = "Number of deaths attributable to disease",
                                         Closed = "Date Closed") %>% 
                           dplyr::filter(Lockdown == "Influenza - FluCARE" |
                                           Lockdown == "Influenza - Not on FluCARE",
                                         is.na(Closed))) %>%
        dplyr::bind_rows(read_excel(x, sheet = 'Team 3') %>% 
                           dplyr::select(Lockdown = "Lockdown status",
                                         Residents = "No. of positive residents",
                                         Hosp = "Number of hospitalisations attributable to disease",
                                         Deaths = "Number of deaths attributable to disease",
                                         Closed = "Date Closed") %>% 
                           dplyr::filter(Lockdown == "Influenza - FluCARE" |
                                           Lockdown == "Influenza - Not on FluCARE",
                                         is.na(Closed))) %>% 
        dplyr::bind_rows(read_excel(x, sheet = 'Team 4') %>% 
                           dplyr::select(Lockdown = "Lockdown status",
                                         Residents = "No. of positive residents",
                                         Hosp = "Number of hospitalisations attributable to disease",
                                         Deaths = "Number of deaths attributable to disease",
                                         Closed = "Date Closed") %>% 
                           dplyr::filter(Lockdown == "Influenza - FluCARE" |
                                           Lockdown == "Influenza - Not on FluCARE",
                                         is.na(Closed))) %>% 
        dplyr::summarise(Cases = sum(Residents, na.rm = TRUE),
                         Hospitalisations = sum(Hosp, na.rm = TRUE),
                         Deaths = sum(Deaths, na.rm = TRUE)) %>% 
        dplyr::mutate(Date = date)
    }
  }
}

no_cores <- availableCores() - 1
plan(multicore, workers = no_cores)

FLU_data <- future_map(all_handovers, FLU_handover_data_fn)

FLU_RACF_data <- bind_rows(FLU_data) %>% 
  dplyr::select(Date, Cases:Deaths) %>% 
  dplyr::arrange(Date)


# RSV ---------------------------------------------------------------------

RSV_handover_data_fn <- function(x) {
  if (grepl("\\d{2} \\w+ \\d{4}", x)) {
    date_str <- str_extract(x, "\\d{2} \\w+ \\d{4}")
    date <- as.Date(date_str, format = "%d %B %Y")
    if (date >= RACF_start & date <= RACF_end) {
      read_excel(x, sheet = 'Team 1') %>% 
        dplyr::select(Lockdown = "Lockdown status",
                      Residents = "No. of positive residents",
                      Hosp = "Number of hospitalisations attributable to disease",
                      Deaths = "Number of deaths attributable to disease",
                      Closed = "Date Closed") %>% 
        dplyr::filter(Lockdown == "RSV - FluCARE" |
                        Lockdown == "RSV - Not on FluCARE",
                      is.na(Closed)) %>% 
        dplyr::bind_rows(read_excel(x, sheet = 'Team 2') %>% 
                           dplyr::select(Lockdown = "Lockdown status",
                                         Residents = "No. of positive residents",
                                         Hosp = "Number of hospitalisations attributable to disease",
                                         Deaths = "Number of deaths attributable to disease",
                                         Closed = "Date Closed") %>% 
                           dplyr::filter(Lockdown == "RSV - FluCARE" |
                                           Lockdown == "RSV - Not on FluCARE",
                                         is.na(Closed))) %>%
        dplyr::bind_rows(read_excel(x, sheet = 'Team 3') %>% 
                           dplyr::select(Lockdown = "Lockdown status",
                                         Residents = "No. of positive residents",
                                         Hosp = "Number of hospitalisations attributable to disease",
                                         Deaths = "Number of deaths attributable to disease",
                                         Closed = "Date Closed") %>% 
                           dplyr::filter(Lockdown == "RSV - FluCARE" |
                                           Lockdown == "RSV - Not on FluCARE",
                                         is.na(Closed))) %>% 
        dplyr::bind_rows(read_excel(x, sheet = 'Team 4') %>% 
                           dplyr::select(Lockdown = "Lockdown status",
                                         Residents = "No. of positive residents",
                                         Hosp = "Number of hospitalisations attributable to disease",
                                         Deaths = "Number of deaths attributable to disease",
                                         Closed = "Date Closed") %>% 
                           dplyr::filter(Lockdown == "RSV - FluCARE" |
                                           Lockdown == "RSV - Not on FluCARE",
                                         is.na(Closed))) %>% 
        dplyr::summarise(Cases = sum(Residents, na.rm = TRUE),
                         Hospitalisations = sum(Hosp, na.rm = TRUE),
                         Deaths = sum(Deaths, na.rm = TRUE)) %>% 
        dplyr::mutate(Date = date)
    }
  }
}

no_cores <- availableCores() - 1
plan(multicore, workers = no_cores)

RSV_data <- future_map(all_handovers, RSV_handover_data_fn)


RSV_RACF_data <- bind_rows(RSV_data) %>% 
  dplyr::select(Date, Cases:Deaths) %>% 
  dplyr::arrange(Date)