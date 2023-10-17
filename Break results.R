# install.packages("readxl", "purrr")
library(readxl)
library(purrr)

# Yesterday <- format(Sys.Date()-1, "%d_%m_%Y")
Yesterday <- format(Sys.Date()-1, "%d.%m.%Y")
stafflink <- Sys.getenv('USERNAME')
file_path <- paste0("C:/Users/",stafflink,"/Desktop/","RACF SLHD Report ",Yesterday,".xlsx")
# file_path <- paste0("C:/Users/",stafflink,"/Desktop/","SLHD Report ",Yesterday,".xlsx")
sheets <- excel_sheets(file_path)

walk(sheets, ~{
  sheet <- read_excel(file_path, .x)
  write.csv(sheet, paste0("C:/Users/",stafflink,"/Desktop/",.x, " ",Yesterday,".csv"), row.names = FALSE)
})

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

