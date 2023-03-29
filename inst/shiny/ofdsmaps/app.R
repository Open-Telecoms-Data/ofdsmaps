library(shiny)
library(ofdsmaps)
library(leaflet)

options(
    gargle_oauth_email = TRUE,
    gargle_oauth_cache = ".secrets"
)

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
                                                                    'Phase'='phase',
                                                                    'Physical infrastructure provider'='physicalInfrastructureProvider',
                                                                    'Supplier'='supplier',
                                                                    'Status' = 'status',
                                                                    'Fibre type' = 'fibreType',
                                                                    'Transmission medium' = 'transmissionMedium')),
                                            selectInput("nodecol", "Colour nodes by",
                                                        choices = c('None' = 'none',
                                                                    'Network name'='networkname',
                                                                    'Phase'='phase',
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
                            h2('Visualisation tool',style = 'color:darkgrey'),
                            h3('About this app'),
                            HTML('<p>This app is a proof of concept tool, and visualises networks published according to the Open Fibre Data Standard. Source code and information about data sources is available on <a  href = "https://github.com/Open-Telecoms-Data/ofdsmaps">Github</a>. The app has been developed by <a href = "https://opendataservices.coop/">Open Data Services</a>.</p>'),
                            h3('About the Open Fibre Data Standard'),
                            HTML('<p>The <a href="https://worldbank.org">World Bank</a>, the <a href="https://itu.int">International Telecommunications Union</a> (ITU), <a href="https://mozilla.com">Mozilla Corporation</a>, the <a href="https://isoc.org">Internet Society</a> (ISOC), <a href="https://liquid.tech">Liquid Intelligent Technologies</a>, <a href="https://www.csquared.com">CSquared</a>, and <a href="https://www.digitalcouncil.africa/">Digital Council Africa</a> are partnering to promote the collaborative development of open data standards for describing telecommunications infrastructure. The first challenge we have taken on is that of terrestrial fibre optic infrastructure.</p>'),
                            HTML('<p>The current version of the Open Fibre Data Standard is available from the following:</p><ul><li><a href="https://github.com/Open-Telecoms-Data/open-fibre-data-standard">Github</a></li><li><a href="https://open-fibre-data-standard.readthedocs.io/en/latest/">ReadTheDocs</a></li></ul>'),
                            h3('How to get in touch'),
                            HTML('<ul><li>To report a problem with the app, please log an issue on the <a href="https://github.com/Open-Telecoms-Data/ofdsmaps/issues">GitHub repository</a></li><li>For general enquiries, please <a href="mailto:openfibre@opendataservices.coop">email us</a></li></ul>')
                          )
                          ))


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

shinyApp(ui = ui, server = server)
