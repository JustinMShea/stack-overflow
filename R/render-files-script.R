
# Define Rmarkdown file path and directories
file <- "R code inside math notation R Markdown.Rmd"
file_path <- paste0(getwd(),"/Rmd/", file)

github_dir <- paste0(getwd(),"/github_documents/")
pdf_dir <- paste0(getwd(),"/pdf_documents/")
html_dir <- paste0(getwd(),"/html_documents/")


# Render Github document to `github_documents``
rmarkdown::render(file_path, output_format = "github_document", output_dir = github_dir)

# move auto-generated html file to `html_documents` 
html_file <- paste0(getwd(),"/github_documents/",grep(".html",list.files(github_dir), value=TRUE))
file.copy(html_file, html_dir, overwrite = TRUE)
# Delete .html file from github directory
file.remove(html_file)


# Render pdf document to `pdf_documents`
rmarkdown::render(file_path, output_format = "pdf_document", output_dir = pdf_dir)

