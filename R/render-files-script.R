
# Define Rmarkdown file path and directories
name <- "multiple time series graphs in one plot disregarding empty fields.Rmd"
file <- paste0(getwd(),"/Rmd/", name)

github_dir <- paste0(getwd(),"/github_documents/")
pdf_dir <- paste0(getwd(),"/pdf_documents/")
html_dir <- paste0(getwd(),"/html_documents/")

# Render Github document to github directory
rmarkdown::render(file, output_format = "github_document", output_dir = github_dir)

# Render pdf document to pdf directory
rmarkdown::render(file, output_format = "pdf_document", output_dir = pdf_dir)

# move auto-generated html file to html_directory and delete from github directory
html_file <- paste0(getwd(),"/github_documents/",grep(".html",list.files(github_dir), value=TRUE))
file.copy(html_file, html_dir, overwrite = TRUE)

file.remove(html_file)
