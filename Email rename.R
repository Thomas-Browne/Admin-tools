# library(devtools)
# install_github("hrbrmstr/msgxtractr")
# install.packages('tidyverse')
# install.packages('purrr')

library(tidyverse)
library(msgxtractr)
library(purrr)

path <- paste0("C:/Users/", Sys.getenv('USERNAME'),"/Desktop/")

emails <- list.files(path = path, pattern = ".msg",full.names = TRUE)

walk(emails, ~{
  Email_data <- read_msg(.x)
  attachments <- Email_data$attachments
  
  Sent <- Email_data$headers %>% 
    select(Date)
  Date <- format(dmy_hms(Sent[1,1]), "%y%m%d")
 
  Subject <- Email_data$headers %>% 
    select(Subject)
  Subject <- Subject[1,1]
  Subject <- gsub("\n", " ", Subject)
  Subject <- gsub(":", "-", Subject)
  Subject <- gsub("/", "-", Subject)
  
  Sender <- Email_data$headers %>% 
    select(From) %>% 
    as.character()
  Recipient <- Email_data$headers %>% 
    select(To) %>% 
    as.character()
  Code <- ifelse(grepl('Sydney LHD', Sender, ignore.case = TRUE) & grepl('Sydney LHD', Recipient, ignore.case = TRUE), 'INT',
                 ifelse(grepl('Sydney LHD', Sender, ignore.case = TRUE), 'EMO', 'EMI'))

  
  attachments <- Email_data$attachments
  dir.create(paste0(path,"Extracted attachments"))
  Attachment_path <- paste0(path,"Extracted attachments")
  
   for (i in seq_along(attachments)) {
    # Get the current attachment
    attachment <- attachments[[i]]
    
    if (!grepl("\\.(jpg|png)$", attachment$filename, ignore.case = TRUE)) {
    file_path <- file.path(Attachment_path, paste0(Date," ", attachment$long_filename))
    
    writeBin(attachment$content, file_path)
    }
   }
  
  file.rename(from = .x, to = paste0(path, Date," ", Code, " ", Subject,".msg"))
  
})

Renamed_emails <- list.files(path = path, pattern = ".msg",full.names = TRUE)
dir.create(paste0(path,"Renamed emails"))
file.copy(from = Renamed_emails, to = paste0(path,"Renamed emails"))
file.remove(Renamed_emails)




