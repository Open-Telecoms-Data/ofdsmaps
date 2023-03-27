# Open Fibre Data Standard visualisation tool (prototype)

This repository contains R code and a shiny app for generating maps from multiple networks published according to the Open Fibre Data Standard.

## Installation

Clone this repository, navigate to the `ofdsmaps` directory, then run:

```
devtools::install_github('Open-Telecoms_Data/ofdsmaps@main')
```

## Front end development

A shiny app is located in `inst/shiny/ofdsmaps`, and can be edited from within there. To run the app, run:

```
shiny::runApp('inst/shiny/ofdsmaps')
```

To deploy on shinyapps.io (assuming you have permissions), run:

```
rsconnect::deployApp('inst/shiny/ofdsmaps',account = 'opendataservices')
```
