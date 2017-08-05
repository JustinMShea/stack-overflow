
# Define Rmarkdown file path
file <- paste0(getwd(),"/Rmd/Mean Returns in Time Series-Restarting after NA values-rstudio.Rmd")

# Render Github document to github directory
github_dir <- paste0(getwd(),"/github_documents/")
rmarkdown::render(file, output_format = "github_document", output_dir = github_dir)

# Render pdf document to pdf directory
pdf_dir <- paste0(getwd(),"/pdf_documents/")
rmarkdown::render(file, output_format = "pdf_document", output_dir = pdf_dir)

# move auto-generated html file to html_directory and delete from github directory
html_dir <- paste0(getwd(),"/html_documents/")
html_file <- paste0(getwd(),"/github_documents/",grep(".html",list.files(github_dir), value=TRUE))
file.copy(html_file, html_dir)
file.remove(html_file)
