######################
## sprthis function ##
######################
#' Create SPR Workflow package template
#'
#' @param wfName character vector with the new SPR Workflow package name.
#' @param analysis character vector withe the analysis name.
#' @param path A path. If it exists, it is used. If it does not exist, it will be used the temporary path..
#' @param baseurl baseurl for the package
#' 
#' @return Path to the newly created package.
#' 
#' @export sprthis
#' @importFrom BiocManager install
#' @importFrom usethis create_package
#' @importFrom yaml write_yaml
#' 
#' @examples
#' sprthis(wfName = "SPRtest", analysis = "SPRtest", path = tempdir())
sprthis <- function(wfName = "SPRtest", analysis, path = tempdir(), baseurl="<baseurl>") {
  ## Create package
  fields <- list(
    Package = wfName, Title = wfName, Version = "0.9.0",
    Description = paste0("This package provides a pre-configured workflow and reporting template for ", analysis, "."),
    biocViews = "Infrastructure, ...", Imports = "systemPipeR (>= 1.25.0)",
    Suggests = "BiocStyle, knitr, rmarkdown",
    VignetteBuilder = "knitr",
    SystemRequirements = paste0(wfName, " can be used to run external command-line software, but the corresponding tool needs to be installed on a system."),
    License = "Artistic-2.0",
    URL = paste0("https://github.com/systemPipeR/", wfName)
  )
  path <- file.path(path, wfName)
  usethis::create_package(fields = fields, path = path, open = FALSE )
  ## git_ignore
  writeLines(c(
    ".Rproj.user",
    ".Rhistory",
    ".Rdata",
    ".httr-oauth",
    ".DS_Store", 
    "vignettes/*_cache/*",
    "vignettes/*.html"), con = file.path(path, ".gitignore"))
  ## R folder not empty
  writeLines(c(
    "Write functions here"), con = file.path(path, "R/dummyfunction.R"))
  ## skeleton
  path_temp <- file.path(path, "inst/rmarkdown/templates", wfName)
  dir.create(path_temp, recursive = TRUE)
  ## template.yaml
  template <- list(name = wfName, description = wfName, create_dir = TRUE)
  yaml::write_yaml(x = template, file = file.path(path_temp, "template.yml"))
  # directory structure
  file.copy(system.file("extdata", "", package = "SPRthis", mustWork = TRUE), path_temp, recursive = TRUE)
  file.rename(paste0(path_temp, "/extdata"), paste0(path_temp, "/skeleton"))
  file.rename(
    paste0(path_temp, "/skeleton/SPRthis.Rmd"),
    paste0(path_temp, "/skeleton/skeleton.Rmd")
  )
  ## README
  readme <- c(
    paste0("# ", wfName),
    "\n<!-- badges: start -->",
    paste0("![R-CMD-check](https://github.com/systemPipeR/", wfName, "/workflows/R-CMD-check/badge.svg)"),
    "<!-- badges: end -->",
    "\n### Introduction",
    "\n### Installation",
    "```r",
    "if (!requireNamespace(\"BiocManager\", quietly = TRUE)) {",
    "  install.packages(\"BiocManager\") }",
    paste0("BiocManager::install('systemPipeR/", wfName,"')"),
    "```",
    "\n### Usage"
  )
  writeLines(readme, con = file.path(path, "README.md"))
  ## Vignettes
  vig_path <- file.path(path, "vignettes")
  dir.create(vig_path)
  file.copy(system.file("extdata", "SPRthis.Rmd", package = "SPRthis", mustWork = TRUE), vig_path, recursive = TRUE)
  file.rename(file.path(vig_path, "SPRthis.Rmd"), file.path(paste0(vig_path, "/", wfName, ".Rmd")))
  file.copy(system.file("extdata", "bibtex.bib", package = "SPRthis", mustWork = TRUE), vig_path, recursive = TRUE)
  ## Github Actions
  dir.create(paste0(path, "/.github/workflows/"), recursive = TRUE)
  file.copy(
    system.file("github", "R_CMD.yml", package = "SPRthis", mustWork = TRUE),
    paste0(path, "/.github/workflows/R_CMD.yml")
  )
  ## WebPage
  pkgdown <- c(
  paste0("title: ", wfName),
  paste0("url: ", baseurl, "/", wfName),
  "authors:",
  "  <author name>:", 
  paste0("    href: ", baseurl),
  "home:", 
  "  links:",
  "  - text: Download from Github",
  paste0("    href: https://github.com/", "<username>/", wfName), 
  "  - text: Report a bug",
  paste0("    href: https://github.com/", "<username>/", wfName, "/issues"), 
  "template:", 
  "  params:", 
  "    ganalytics: XXXXXXX", 
  "    bootswatch: flatly")
writeLines(pkgdown, con = file.path(path, "_pkgdown.yml"))
  return(path)
}
## Usage:
# sprthis(wfName = "SPRtest3", analysis = "SPRtest3", path = getwd())
# wfName="SPRtest"
# analysis="BLAST"
# path=getwd()

#########################
## update Rmd file  ##
#########################
#' Copying vignette `.Rmd` as R Markdown document template
#'
#' @param rmd vignette *.Rmd path. Usually: "vignettes/<filename>.Rmd"
#' @param templateName template folder name. If `null`, it will add the *.Rmd file name.
#'
#' @return Path to the newly created/update Rmarkdown template.
#' 
#' @export skeleton_update
#' @importFrom crayon blue
#' 
#' @examples
#' path <- file.path(tempdir(), "SPRtest", "vignettes/SPRtest.Rmd")
#' skeleton_update(path)
skeleton_update <- function(rmd, templateName = NULL) {
  path <- normalizePath(rmd)
  dir <- sub("/([^/]*)$", "", sub("/([^/]*)$", "", rmd))
  if (is.null(templateName)) {
    templateName <- systemPipeR:::.getFileName(rmd)
  } else {
    templateName <- templateName
  }
  to <- file.path(paste0(dir, "/inst/rmarkdown/templates/", templateName, "/skeleton"))
  if (!dir.exists(to)) stop("R Markdown document infrastructure doesn't exist.")
  newRmd <- file.path(to, "skeleton.Rmd")
  if (file.exists(newRmd)) {
    unlink(newRmd)
  }
  file.copy(path, to)
  file.rename(file.path(to, basename(rmd)), newRmd)
  cat(crayon::blue(paste(newRmd, "added/updated successfully")), "\n")
  return(newRmd)
}
## Usage:
# rmd <- "vignettes/SPvarseq.Rmd"
# skeleton_update(rmd)
