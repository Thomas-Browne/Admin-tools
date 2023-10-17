# install.packages("pdftools")
library(pdftools)

# Specify the file location of the pdfs you want to combine (defaults to your desktop)
File_location <- paste0("C:/Users/", Sys.getenv("USERNAME"),"/Desktop")


Name <- "Test results" # Name output file

# Searches for PDFs
PDFs_to_merge <- list.files(File_location, pattern = ".pdf", full.names = TRUE)

# Combine PDFs
pdftools::pdf_combine(PDFs_to_merge, output = paste0(File_location,"/", Name, ".pdf"))


