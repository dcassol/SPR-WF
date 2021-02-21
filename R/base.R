######################
## sprthis function ##
######################
#' Create SPR Workflow package template
#'
#' @param wfName character vector with the new SPR Workflow package name.
#' @param analysis character vector withe the analysis name.
#' @param path A path. If it exists, it is used. If it does not exist, it will be used the temporary path..
#'
#' @return Path to the newly created package.
#' @export sprthis
#' @examples
#' sprthis(wfName = "SPRtest", analysis = "SPRtest", path = tempdir())
#' @importFrom usethis create_package
#' @importFrom yaml write_yaml
sprthis <- function(wfName = "SPRtest", analysis, path = tempdir()) {
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
  usethis::create_package(fields = fields, path = path)
  path <- normalizePath(path)
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
  return(path)
}
## Usage:
# wfName="SPRtest"
# analysis="BLAST"
# path=paste0(tempdir(), "/SPRtest")

######################
## update function ##
######################
#' Copying vignette Rmd as R Markdown document template
#'
#' @param rmd vignette *.Rmd path. Usually: "vignettes/<filename>.Rmd"
#'
#' @return Path to the newly created/update Rmarkdown template.
#' @export skeleton_update
#' @examples
#' sprthis(wfName = "SPRtest", analysis = "SPRtest", path = tempdir())
#' path <- file.path(tempdir(), "vignettes/SPRtest.Rmd")
#' skeleton_update(path)
skeleton_update <- function(rmd) {
  path <- normalizePath(rmd)
  dir <- sub("/([^/]*)$", "", sub("/([^/]*)$", "", rmd))
  to <- paste0(dir, "/inst/rmarkdown/templates/",
               dir(paste0(dir, "/inst/rmarkdown/templates/")), "/skeleton")
  if (!dir.exists(to)) stop("R Markdown document infrastructure doesn't exist.")
  newRmd <- file.path(to, "skeleton.Rmd")
  if (file.exists(newRmd)) {
    unlink(newRmd)
  }
  file.copy(path, to)
  file.rename(file.path(to, basename(rmd)), newRmd)
  return(newRmd)
}
## Usage:
# rmd <- "vignettes/systemPipeBLAST.Rmd"
