# SPRthis

<!-- badges: start -->
![R-CMD-check](https://github.com/dcassol/SPRthis/workflows/R-CMD-check/badge.svg)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
<!-- badges: end -->

### Introduction

This package expends [usethis](https://github.com/r-lib/usethis) package, providing automation to create [systemPipeR](https://github.com/tgirke/systemPipeR) workflows templates.

#### Installation 

To install `SPRthis` using from `BiocManager` the following code:

```r
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}

BiocManager::install("dcassol/SPRthis")
```

#### Usage

```r
sprthis(wfName="SPRtest", analysis="SPRtest", path=tempdir())

# ✓ Setting active project to '/tmp/Rtmpui2LJa'
# ✓ Creating 'R/'
# ✓ Writing 'DESCRIPTION'
# Package: SPRtest
# Title: SPRtest
# Version: 0.9.0
# Authors@R (parsed):
#     * First Last <first.last@example.com> [aut, cre] (YOUR-ORCID-ID)
# Description: This package provides a pre-configured
#     workflow and reporting template for SPRtest.
# License: Artistic-2.0
# URL: https://github.com/systemPipeR/SPRtest
# Imports:
#     systemPipeR (>= 1.25.0)
# Suggests:
#     BiocStyle,
#     knitr,
#     rmarkdown
# VignetteBuilder:
#     knitr
# biocViews: Infrastructure, ...
# Encoding: UTF-8
# LazyData: true
# Roxygen: list(markdown = TRUE)
# RoxygenNote: 7.1.1
# SystemRequirements: SPRtest can be used to run external
#     command-line software, but the corresponding tool needs to be
#     installed on a system.
# ✓ Writing 'NAMESPACE'
# ✓ Writing 'SPRtest.Rproj'
# ✓ Adding '^SPRtest\\.Rproj$' to '.Rbuildignore'
# ✓ Adding '.Rproj.user' to '.gitignore'
# ✓ Adding '^\\.Rproj\\.user$' to '.Rbuildignore'
# ✓ Opening '/tmp/Rtmpui2LJa/' in new RStudio session
# ✓ Setting active project to '/SPRthis'
# [1] TRUE
```

```
<pre>
SPS_xx/  
├── server.R               <span class="text-success">|</span> 
├── global.R               <span class="text-success">| Most important server, UI and global files, unless special needs, `global.R` is the only file you need to edit manually</span>   
├── ui.R                   <span class="text-success">|</span>  
├── deploy.R               <span class="text-info">| Deploy helper file</span>  
├── config                 <span class="text-success">| Important app config files. Do not edit them if you don't know</span>  
│   ├── sps.db             <span class="text-gray">| SPS database</span> 
│   ├── sps_options.yaml   <span class="text-gray">| SPS default option list</span> 
│   └── tabs.csv           <span class="text-gray">| SPS tab information</span> 
├── data                   <span class="text-primary">| App example data files</span> 
│   ├── xx.csv             
├── R                      <span class="text-primary">| All SPS additional tab files and helper R function files</span> 
│   ├── tab_xx.R            
├── README.md              
├── results                <span class="text-gray">| Not in use for this current version, you can store some data been generated from the app</span> 
│   └── README.md          
└── www                    <span class="text-primary">| Internet resources</span>  
    ├── about              <span class="text-gray">| About tab information</span> 
    │   └── xx.md          
    ├── css                <span class="text-info">| CSS files</span>  
    │   └── sps.css         
    ├── img                <span class="text-info">| App image resources</span>    
    │   └── xx.png         
    ├── js                 <span class="text-info">| Javascripts</span>
    │   └── xx.js           
    ├── loading_themes     <span class="text-info">| Loading screen files</span> 
    │   └── xx.html         
    └── plot_list          <span class="text-info">| Image files for plot gallery</span>  
        └── plot_xx.jpg      
</pre>
```
