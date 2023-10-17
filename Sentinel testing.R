# Sentinel Testing

# Press Ctrl + A, then Ctrl + Enter to run.
# Note: Requires syncing Sentinel testing data: 
# browseURL("https://nswhealth.sharepoint.com/:f:/r/sites/SLHDPHU-SLHD/Shared%20Documents/Epi/Reports/Acute%20Respiratory%20Illness%20Surveillance%20Monthly%20Situation%20Report/2023/Sentinel%20testing%20data?csf=1&web=1&e=OGRNH5")

#install.packages("readxl")
#install.packages("purrr")
library(readxl)
library(tidyverse)


# Code --------------------------------------------------------------------

path = paste0("C:/Users/",Sys.getenv('USERNAME'),"/Desktop")
Sentinel_files <- list.files(path = path,
                             pattern = "*.xlsx", full.names = TRUE)
date_range <- str_extract_all(Sentinel_files, "\\d+\\.\\d+\\.\\d+")
sheets <- excel_sheets(Sentinel_files)

walk(sheets, ~{
  sheet <- read_excel(Sentinel_files, .x)
  write.csv(sheet, paste0("C:/Users/",Sys.getenv('USERNAME'),"/NSW Health Department/SLHD PHU - Documents/Epi/Reports/Acute Respiratory Illness Surveillance Monthly Situation Report/2023/Sentinel testing data/Processed/", str_to_title(.x), " ", date_range[[1]][1], " - ", date_range[[1]][2],".csv"), row.names = FALSE)
})
destination_dir <- paste0("C:/Users/",Sys.getenv('USERNAME'),"/NSW Health Department/SLHD PHU - Documents/Epi/Reports/Acute Respiratory Illness Surveillance Monthly Situation Report/2023/Sentinel testing data/Raw/")
file.copy(from = Sentinel_files, to = destination_dir)

if (file.exists(Sentinel_files)) {
  if (winDialog(type = c("yesno"), message = "The file has been saved in the Teams folder. Would you like to delete the file on your desktop?") == "YES") {
    # Delete file if the user selects "YES"
    file.remove(Sentinel_files)
  }
}
