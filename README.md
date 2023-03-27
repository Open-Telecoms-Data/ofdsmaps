# Open Fibre Data Standard visualisation tool (prototype)

This repository contains R code and a shiny app for generating maps from multiple networks published according to the Open Fibre Data Standard.

## Installation

To download the latest version of this repository, run:

```
devtools::install_github('Open-Telecoms-Data/ofdsmaps@main')
```

## Adding and removing data

The shiny app reads data files from this public Google drive folder. If you have permissions to edit this folder, you can upload or delete files to add or remove networks from the app.

## Front end development

A shiny app is located in `inst/shiny/ofdsmaps`, and can be edited from within there. To run the app locally, clone this repository, navigate to the `ofdsmaps` folder, and run:

```
shiny::runApp('inst/shiny/ofdsmaps')
```

To deploy on shinyapps.io, install and configure the `rsconnect` library to access the 'opendataservices' account on shiny.io (see [here](https://shiny.rstudio.com/articles/shinyapps.html) for guidance), then run:

```
rsconnect::deployApp('inst/shiny/ofdsmaps',account = 'opendataservices')
```
