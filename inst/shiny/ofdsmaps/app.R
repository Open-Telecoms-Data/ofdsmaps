library(shiny)
library(ofdsmaps)
library(leaflet)

options(
    # whenever there is one account token found, use the cached token
    gargle_oauth_email = TRUE,
    # specify auth tokens should be stored in a hidden directory ".secrets"
    gargle_oauth_cache = ".secrets"
)

# Define UI for application that draws a histogram
ui <- navbarPage("OFDS Visualisation Tool",collapsible = TRUE,
                 id = "inTabset",
             selected = "p1",
                 tabPanel("Map",
                          value = "p1",
                          fluidPage(
                              h1('Open Fibre Data Standard',style = 'color:#044278'),
                              h2('Visualisation tool',style = 'color:darkgrey'),
                              br(),
                              sidebarPanel(selectInput("country", "Select networks to show",
                                                        choices = c('Ghana'='Ghana',
                                                                    'Kenya'='Kenya')),
                                            selectInput("spancol", "Colour spans by",
                                                        choices = c('None' = 'none',
                                                                    'Network name'='networkname',
                                                                    'Physical infrastructure provider'='physicalInfrastructureProvider',
                                                                    'Supplier'='supplier',
                                                                    'Status' = 'status',
                                                                    'Fibre type' = 'fibreType',
                                                                    'Transmission medium' = 'transmissionMedium')),
                                            selectInput("nodecol", "Colour nodes by",
                                                        choices = c('None' = 'none',
                                                                    'Network name'='networkname',
                                                                    'Physical infrastructure provider'='physicalInfrastructureProvider',
                                                                    'Status' = 'status',
                                                                    'Type' = 'type')),
                                            checkboxInput("nodelegend", "Show nodes legend", FALSE),
                                            checkboxInput("spanlegend", "Show spans legend", FALSE),
                                            actionButton("refresh", "Get latest data")
                              ),
                              mainPanel(
                                  p('Click on any node or span in the map to view metadata'),
                                  leafletOutput("ofdsmap",width = '100%', height = 500),
                                  
                              )

                          )
                          ),
                 tabPanel("About",
                          value = 'p2',
                          fluidPage(
                              h1('Open Fibre Data Standard',style = 'color:#044278'),
                              h2('About this app',style = 'color:darkgrey'),
                            br(),
                            HTML("<p>This app is a proof of concept tool, and visualises networks published according to the Open Fibre Data Standard.</p>"),
                            HTML("<p> Source code and information about data sources is available on <a  href = 'https://github.com/Open-Telecoms-Data/ofdsmaps'>Github</a>, where you can also report issues.</p>"),
                            HTML("<p>Developed by <a href = 'https://opendataservices.coop/'>Open Data Services</a></a>.</p>")
                          )
                          ))


# Define server logic required to draw a histogram
server <- function(input, output) {

    observeEvent(input$refresh, {
        file.remove(list.files('data/Ghana',include.dirs = F, full.names = T, recursive = T))
        file.remove(list.files('data/Kenya',include.dirs = F, full.names = T, recursive = T))
        downloadOFDS(input$country,overwrite = TRUE)
    })
    
    output$ofdsmap <- renderLeaflet({
        downloadOFDS(input$country,overwrite = FALSE)
        dd <- readOFDS(dir = paste0('data/',input$country))
        mapOFDS(dd,spancol = input$spancol,nodecol = input$nodecol,nodelegend = input$nodelegend,spanlegend = input$spanlegend)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
