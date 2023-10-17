install.packages("pdftools")
library(pdftools)

# File has to be saved on your desktop
file_name <- "3408_001.pdf"


file_to_split <- paste0("C:/Users/", Sys.getenv("USERNAME"),"/Desktop/", file_name)
destination <- paste0("C:/Users/", Sys.getenv("USERNAME"),"/Desktop/")


pdf_split(file_to_split, output = destination)