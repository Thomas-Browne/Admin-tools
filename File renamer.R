library(dplyr)
library(purrr)
path <- paste0("C:/Users/", Sys.getenv('USERNAME'),"/Desktop/")
dir.create(paste0(path,"Files to rename"))

if (file.exists(paste0(path,'Files to rename'))) {
  if (winDialog(type = "okcancel", message = "Move all files you'd like to rename into the 'Files to rename' folder. Click Ok to continue") == "OK") {
    Files <- list.files(paste0(path,'Files to rename'), full.names = TRUE) 
    
    walk(Files, ~{
      Modified <- file.info(.x)$mtime %>% 
        as.Date()
      Modified <- format(Modified, "%y%m%d")
      Name <- basename(.x) %>% as.character()
      
      file.rename(from = .x, to = paste0(path,"Files to rename/ ", Modified," ", Name))
      file.rename(from = paste0(path,"Files to rename/"), to = paste0(path,"Renamed files/"))
    }) } else { 
      stop('User cancelled the operation')
    }
}

