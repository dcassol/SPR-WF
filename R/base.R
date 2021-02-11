#' Title Create SPR Workflow package template
#'
#' @param wfName character vector with the new SPR Workflow package name. 
#' @param analysis character vector withe the analysis name.
#' @param path A path. If it exists, it is used. If it does not exist, it will be used the temporary path..
#'
#' @return Path to the newly created package.
#' @export sprthis
#' @import 
#' usethis
#' yaml
#' @examples
#' sprthis(wfName="SPR-test", analysis="BLAST", path=tempdir())
sprthis <- function(wfName="SPR-WF", analysis, path=tempdir()){
  path <- normalizePath(path)
## Create package
  fields <- list(Package=wfName, Title=wfName, Version="0.9.0",
                 Description=paste0("This package provides a pre-configured workflow and reporting template for ", analysis, "."),
                 biocViews="Infrastructure, ...", Imports="systemPipeR (>= 1.25.0)",
                 Suggests="BiocStyle, knitr, rmarkdown",
                 VignetteBuilder="knitr",
                 SystemRequirements=paste0(wfName, " can be used to run external command-line software, but the corresponding tool needs to be installed on a system."),
                 License="Artistic-2.0",
                 URL=paste0("https://github.com/systemPipeR/", wfName))
  usethis::create_package(fields = fields, path=path)
  ## skeleton
  path_temp <- file.path(path, "inst/rmarkdown/templates", wfName)
  dir.create(path_temp, recursive = TRUE)
  ## template.yaml
  template <- list(name=wfName, description=wfName, create_dir=TRUE)
  yaml::write_yaml(x = template, file=file.path(path_temp, "template.yml"))
  # directory structure
  skeleton <- file.path(path_temp, "skeleton")
  dir.create(skeleton)
  file.copy(system.file("extdata/", "", package="SPRthis", mustWork=TRUE), skeleton, recursive=TRUE)
  file.rename(file.path(skeleton, "SPRthis.Rmd"), file.path(skeleton, "skeleton.Rmd"))
  ## README
  readme <- c(paste0("# ", wfName),
              "\n<!-- badges: start -->",
              "![R-CMD-check](https://github.com/dcassol/SPR-WF/workflows/R-CMD-check/badge.svg)",
              "<!-- badges: end -->",
              "\n### Introduction",
              "\n### Installation",
              "```r", 
              "if (!requireNamespace(\"BiocManager\", quietly = TRUE)) {",
              "  install.packages(\"BiocManager\") }",
              paste0("BiocManager::install(\"systemPipeR/\", wfName)"),
              "```",
              "\n### Usage"
    
  )
  writeLines(readme, con=file.path(path, "README.md"))
  ##Vignette
  dir.create(file.path(path, "vignette"))
  file.copy(system.file("extdata/", "SPRthis.Rmd", package="SPRthis", mustWork=TRUE), file.path(path, "vignette"), recursive=TRUE)
  file.copy(system.file("extdata/", "bibtex.bib", package="SPRthis", mustWork=TRUE), file.path(path, "vignette"), recursive=TRUE)
  ## Github Actions
  
}
