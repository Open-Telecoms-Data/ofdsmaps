library(shiny)
library(ofdsmaps)
library(leaflet)
library(viridis)

# Define UI for application that draws a histogram
ui <- navbarPage(HTML("<b>Open Fibre Data Standard</b> Visualisation Tool"),collapsible = TRUE,
                 id = "inTabset",
             selected = "p1",
                 tabPanel("Map",
                          value = "p1",
                          
                          tags$head(
                            # Include our custom CSS
                            includeCSS("styles.css")
                          ),
                          fluidPage(
                            leafletOutput("ofdsmap",width = '100%', height = 500),
                            absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                          draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                                          width = 330, height = "auto",
                                          selectInput("folder", "Select networks to show", choices = c('Ghana'='Ghana','Kenya'='Kenya')),
                                          selectInput("spancol", "Colour spans by",
                                                      choices = c('Network name'='networkname',
                                                                  'Physicial infrastructure provider'='physicalInfrastructureProvider',
                                                                  'Status' = 'status',
                                                                  'Fibre type' = 'fibreType')),
                                          selectInput("nodecol", "Colour nodes by",
                                                      choices = c('Network name'='networkname',
                                                                  'Physicial infrastructure provider'='physicalInfrastructureProvider',
                                                                  'Status' = 'status',
                                                                  'Access point?' = 'accessPoint')),
                                          checkboxInput("nodelegend", "Show nodes legend", FALSE),
                                          checkboxInput("spanlegend", "Show spans legend", FALSE)
                                          
                                          ),

                          )
                          ),
                 tabPanel("About",
                          value = 'p2',
                          fluidPage(
                            h2('About this app',style = 'color:#044278'),
                            br(),
                            HTML("<p>This app is a proof of concept tool, and visualises networks published according to the Open Fibre Data Standard.</p>"),
                            HTML("<p> Source code and information about data sources is available on <a  href = 'https://github.com/OpenDataServices'>Github</a>, where you can also report issues.</p>"),
                            HTML("<p>Developed by <a href = 'https://opendataservices.coop/'>Open Data Services</a></a>.</p>")
                          )
                          ))


# Define server logic required to draw a histogram
server <- function(input, output) {

    output$ofdsmap <- renderLeaflet({
        # generate bins based on input$bins from ui.R
        dd <- readOFDS(paste0('data-raw/',input$folder))
        mapOFDS(dd,spancol = input$spancol,nodecol = input$nodecol,nodelegend = input$nodelegend,spanlegend = input$spanlegend)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
