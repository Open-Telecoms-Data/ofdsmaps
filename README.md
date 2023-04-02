# Open Fibre Data Standard visualisation tool (prototype)

This repository contains R code and a [Shiny](https://shiny.rstudio.com/) app for generating maps from multiple networks published according to the Open Fibre Data Standard.

## Install the app

```R
devtools::install_github('Open-Telecoms-Data/ofdsmaps@main')
```

## Run the app

```R
shiny::runApp('inst/shiny/ofdsmaps')
```

## Add or remove data

The app reads data from a public [Google Drive folder](https://drive.google.com/drive/folders/1ChYMCTO8UDpQGsbPkVxIbZtTxfBCZ4KZ). If you have permission to edit the folder, you can upload or delete files to add or remove networks from the app.

## Development

### Set up your development environment

You can set up your development environment on your local machine or using GitHub codespaces. If you need to [generate a new Google Drive authentication token](#generate-a-new-google-drive-authentication-token), you should use your local machine.

#### Local machine

1. [Download and install R](https://cloud.r-project.org/)
1. In an R console, install packages

    ```R
    install.packages('devtools')
    install.packages('shiny')
    install.packages('rsconnect')
    install.packages('leaflet')
    ```

#### GitHub Codespaces

1. Go to [GitHub Codespaces](https://github.com/codespaces) and click **New Codespace**
1. Select the 'Open-Telecoms-Data/ofdsmaps' repository and click **Create Codespace**
1. In your codespace, add an R container configuration:
    1. Open the **command palette** (F1) and type or select:
        1. 'Codespaces: Add dev container configuration files'
        1. 'Create a new configuration'
        1. 'Show all definitions'
        1. 'R (rocker/r-ver base)'
        1. '4 (default)'
        1. 'geospatial'
    1. Click **OK**. Do not install additional features.
1. Rebuild the container: Click **Rebuild Now** or type or select 'Codespaces: Full rebuild container' in the command palette

### Edit files

The R scripts for downloading, reading and plotting OFDS data are located in `/R`.

The R script for the Shiny app is located in `/inst/shiny/ofdsmaps`.

### Preview your changes

1. [Install the app](#install-the-app)
2. [Run the app](#run-the-app)

### Commit your changes

Commit your changes to the GitHub repository.

### Deploy your changes

#### One-time setup

Configure `rsconnect` to deploy to [ShinyApps.io](https://www.shinyapps.io):

1. Log in to the [ShinyApps.io admin dashboard](https://www.shinyapps.io/admin/#/dashboard). You can find credentials in the co-op password database.
1. Open the [tokens screen](https://www.shinyapps.io/admin/#/tokens) and click **Show**.
1. Click **Show secret**, copy the `rsconnect` command to your R console and run it.

#### Generate a new Google Drive authentication token

You need only complete this step if there are authentication issues in the deployed app. You must use a [development environment on your local machine](#local-machine) to complete this step.

The app uses a [project-level oAuth cache](https://gargle.r-lib.org/articles/non-interactive-auth.html#project-level-oauth-cache) to authenticate to Google Drive. To clear the cache and generate a new token:

1. Delete the contents of `/.secrets`
1. Quit any running R console sessions:

    ```R
    quit()
    ```

1. [Run the app](#run-the-app)
1. In the app, click **Get latest data**
1. Authenticate using your Google account and grant permission for the app to ‘See, edit, create, and delete all of your Google Drive files’

#### Deploy the app

1. [Install the app from GitHub](#install-the-app).
2. Deploy the app:

    ```R
    rsconnect::deployApp('inst/shiny/ofdsmaps',account = 'opendataservices')
    ```
