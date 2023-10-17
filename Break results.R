# install.packages("readxl", "purrr")
#Histop@thRACF23
library(readxl)
library(lubridate)
library(purrr)

# Yesterday <- format(Sys.Date()-1, "%d_%m_%Y")
Yesterday <- format(Sys.Date()-1, "%d.%m.%Y")
Date <- format(Sys.Date()-1, "%y%m%d")
stafflink <- Sys.getenv('USERNAME')
file_path <- list.files(paste0("C:/Users/",stafflink,"/Desktop/"), pattern = paste0("2023.xlsx"), full.names = TRUE)

sheets <- excel_sheets(file_path)

walk(sheets, ~{
  sheet <- read_excel(file_path, .x)
  write.csv(sheet, paste0("C:/Users/",stafflink,"/Desktop/", Date," ", .x, " ",Yesterday,".csv"), row.names = FALSE)
})
file.rename(from = file_path, to = paste0("C:/Users/",stafflink,'/Desktop/', Date, " SLHD RACF Report ", Yesterday, ".xlsx"))
file_path <- list.files(paste0("C:/Users/",stafflink,"/Desktop/"), pattern = paste0(Date, " SLHD RACF Report"), full.names = TRUE)
file.copy(file_path, "Q:/PANDEMIC/Novel Coronavirus 2019/2023/SLHD major follow-ups/RACF/Results from Histopath")

if (file.exists(file_path)) {
  if (winDialog(type = "yesno", message = "Results broken and saved on the desktop. Do you want to delete the original file?") == "YES") {
    if(winDialog(type = "yesno", message = "Close R?") == "YES") {
      q(save = "no") & file.remove(file_path)
    } else { 
      file.remove(file_path)}
  } else {
    if(winDialog(type = "yesno", message = "Close R?") == "YES") {
      q(save = "no")
    }
  }
}

