# README: To use this code, prepare all received emails that you'd like to rename onto your desktop. 

# library(devtools)
# install_github("hrbrmstr/msgxtractr")
# install.packages('tidyverse')
# install.packages('purrr')

# Load necessary libraries
library(tidyverse)
library(msgxtractr)
library(purrr)

# Define a list of Public Health Unit (PHU) email addresses
PHU <- tolower(c("Alice.Morgan1@health.nsw.gov.au", "SLHD-CDTeam@health.nsw.gov.au", "Amanda.Chang@health.nsw.gov.au", "Andrew.Ingleton@health.nsw.gov.au", "Andrew.Penman@health.nsw.gov.au", "Antoinette.DiLeo@health.nsw.gov.au", "Catherine.Glover1@health.nsw.gov.au", "David.Kennedy6@health.nsw.gov.au", "Elenor.Kerr@health.nsw.gov.au", "Erin.Spike@health.nsw.gov.au", "Francesca.Figg@health.nsw.gov.au", "George.Johnson@health.nsw.gov.au", "Haylee.Sneesby@health.nsw.gov.au", "Isabel.Hess@health.nsw.gov.au", "Jessica.Ng@health.nsw.gov.au", "Jimmy.Yu@health.nsw.gov.au", "Jody.Houston@health.nsw.gov.au", "Johanne.Cochrane@health.nsw.gov.au", "Joseph.Vanbuskirk1@health.nsw.gov.au", "Jyoti.Pun@health.nsw.gov.au", "Kathleen.McKay@health.nsw.gov.au", "Katie.Graham1@health.nsw.gov.au", "Kleete.Simpson@health.nsw.gov.au", "Kwendy.Cavanagh@health.nsw.gov.au", "Kylie.Wright@health.nsw.gov.au", "Lauren.Wolf@health.nsw.gov.au", "Leena.Gupta@health.nsw.gov.au", "Lena.Waldner@health.nsw.gov.au", "Lisa.Brazier@health.nsw.gov.au", "Luke.Knibbs@health.nsw.gov.au", "Maria.Gomez2@health.nsw.gov.au", "Maria.Nguyen1@health.nsw.gov.au", "Matthew.Austin@health.nsw.gov.au", "Muzhgan.Soultani@health.nsw.gov.au", "Rachel.Wolfenden@health.nsw.gov.au", "Sandra.Bourke1@health.nsw.gov.au", "Sarah.Hay@health.nsw.gov.au", "Shamila.Phillip@health.nsw.gov.au", "Sonia.Dahiya@health.nsw.gov.au", "Sophie.Dwyer@health.nsw.gov.au", "Sophie.Harper@health.nsw.gov.au", "Syeda.Toufique@health.nsw.gov.au", "SYLVIA.TANG@health.nsw.gov.au", "Tamasin.Norris@health.nsw.gov.au", "Tasnuba.Pervez@health.nsw.gov.au", "Thomas.Browne@health.nsw.gov.au", "Troy.Mcneill@health.nsw.gov.au", "VendulaBlaya.Novakova@health.nsw.gov.au", "William.Burns1@health.nsw.gov.au", "Wyman.Kwong@health.nsw.gov.au", "Zeina.Najjar@health.nsw.gov.au"))

# Set the path to the desktop of the current user
path <- paste0("C:/Users/", Sys.getenv('USERNAME'),"/Desktop/")

# List all files with a ".msg" extension in the specified path
emails <- list.files(path = path, pattern = ".msg",full.names = TRUE)

# Process each email file
walk(emails, ~{
  # Read the email data from the current file
  Email_data <- read_msg(.x)
  attachments <- Email_data$attachments
  
  # Extract the sent date from the email headers
  Sent <- Email_data$headers %>%
    select(Date)
  Date <- format(dmy_hms(Sent[1,1]), "%y%m%d")
  
  # Process the email subject
  Subject <- Email_data[["subject"]]
  Subject <- gsub("\n", " ", Subject)
  Subject <- gsub(":", "-", Subject)
  Subject <- gsub("/", "-", Subject)
  
  # Process the sender's email address
  Sender <- Email_data$headers %>% 
    select(From) %>% 
    as.character() %>% str_extract_all("(?<=<)(.*?)(?=>)") %>% 
    tolower()
  
  # Process the recipient's email address
  Recipient <- Email_data$headers %>% 
    select(To) %>% 
    as.character() %>% str_extract_all("(?<=<)(.*?)(?=>)")
  Recipient <- gsub("^c\\(\"|\"\\)$", "", Recipient)
  Recipient <- strsplit(Recipient, "\", \"") 
  Recipient <- unlist(Recipient) %>% tolower()
  
  # Code <- ifelse(grepl('Sydney LHD', Sender, ignore.case = TRUE) & grepl('Sydney LHD', Recipient, ignore.case = TRUE), 'INT', # Marks according to SLHD
  #                ifelse(grepl('Sydney LHD', Sender, ignore.case = TRUE), 'EMO', 'EMI'))
  
  # Determine the code based on sender and recipient
  Code <- ifelse(Sender %in% PHU & Recipient[1] %in% PHU, 'INT', # Marks according to PHU
                 ifelse(Sender %in% PHU, 'EMO', 'EMI'))
  
  # Create a directory for extracted attachments
  attachments <- Email_data$attachments
  dir.create(paste0(path,"Extracted attachments"))
  Attachment_path <- paste0(path,"Extracted attachments")
  
  # Process each attachment in the email
  for (i in seq_along(attachments)) {
    # Get the current attachment
    attachment <- attachments[[i]]
    
    # Save non-image attachments to the specified directory
    if (!grepl("\\.(jpg|png)$", attachment$filename, ignore.case = TRUE)) {
      file_path <- file.path(Attachment_path, paste0(Date," ", attachment$long_filename))
      
      # ifelse(!grepl("\\.(jpg|png)$", attachment$filename, ignore.case = TRUE), {
      #   file_path <- file.path(Attachment_path, paste0(Date," ", attachment$long_filename))
      #   writeBin(attachment$content, file_path)
      # }, NULL)
      # 
      
      writeBin(attachment$content, file_path)
    }
  }
  
  # Rename the current email file based on date, code, and subject
  file.rename(from = .x, to = paste0(path, 
                                     Date,
                                     " ", Code, " ", Subject,".msg"))
})

# List the renamed email files
Renamed_emails <- list.files(path = path, pattern = ".msg",full.names = TRUE)

# Create a directory for renamed emails
dir.create(paste0(path,"Renamed emails"))

# Copy renamed email files to the "Renamed emails" directory
file.copy(from = Renamed_emails, to = paste0(path,"Renamed emails"), overwrite = T)

# Remove the original renamed email files
file.remove(Renamed_emails)