library(shiny)
library(leaflet)

vars <- c(
    "All" = "all",
    "Positive" = "pos",
    "Negative" = "neg"
)

cords <- c(
    "UK" = "UK",
    "France" = "France",
    "Greece" = "Greece",
    "USA" = "USA"
)


shinyUI(navbarPage("TwitterApp", id="nav",
                   
                   tabPanel("Tweet Search",
                            
                            fluidRow(
                                column(12,
                                       wellPanel(
                                           h4("Search Twitter For Tweets"),
                                           h6("Search for tweets that contain one or more terms of interest")
                                       ),align="center"
                                )                  
                            ),
                            
                            fluidRow(
                                column(4,
                                       
                                       wellPanel(
                                           h4("Search Criteria"),
                                           textInput("search", label = h5("Text input"), value = ""),
                                           dateRangeInput('dateRange',
                                                          label = h5("Specify Date Range"),
                                                          start = Sys.Date() - 7, end = Sys.Date() ,
                                                          min = Sys.Date() - 7, max = Sys.Date(),
                                                          separator = " to ", format = "dd/mm/yy",
                                                          startview = 'month', language = 'en', weekstart = 1
                                           ),
                                           selectInput("coords", h5("Geographic Location"), cords,selected="UK"),
                                           sliderInput("maxtweets",label = h5("Maximum Tweets to be Returned"),100,2000,100,step=100),
                                           actionButton("searchButton","Search"),
                                           br(),br()
                                       )
                                ),
                                column(4,
                                       wellPanel(
                                           h4("Entered Search Criteria"),
                                           br(),br(),
                                           textOutput('outSearch'),
                                           br(),br(),br(),
                                           textOutput('outDate1'),
                                           textOutput('outDate2'),
                                           br(),br(),br(),
                                           textOutput('outLocation'),
                                           br(),br(),br(),
                                           textOutput('outMaxtweets')
                                       )
                                ),
                                column(4,
                                       wellPanel(
                                           h4("Returned Results"),
                                           br(),br(),
                                           textOutput('outNum'),
                                           br(),br(),br(),
                                           textOutput('outSentP'),
                                           br(),
                                           textOutput('outSentN'),
                                           br(),
                                           textOutput('outSentNu'),
                                           br()
                                       ))
                            )
                   ),
                   
                   tabPanel("Tweet Details",
                            
                            fluidRow(
                                column(12,
                                       wellPanel(
                                           h4("Details of Returned Tweets"),
                                           h6("A table containing tweets with some metadata and a sentiment score")
                                       ),align="center"
                                )           
                            ),
                            fluidRow(
                                column(12,
                                       dataTableOutput("tweettable"),
                                       align="center"
                                )
                            )           
                   ),
                   tabPanel("Sentiment Analysis",
                            
                            fluidRow(
                                column(12,
                                       wellPanel(
                                           h4("Sentiment Analysis of Tweets"),
                                           h6("A breakdown of the sentiment for the terms searched")
                                       ),align="center"
                                )
                            ),
                            fluidRow(
                                column(4,
                                       wellPanel(
                                           plotOutput("sentHist1")                        
                                       )),
                                column(8,
                                       wellPanel(
                                           plotOutput("sentHist2") 
                                       )) 
                            )     
                   ),
                   tabPanel("Tweet Map",
                            div(class="outer",
                                
                                tags$head(
                                    # Include our custom CSS
                                    includeCSS("styles.css"),
                                    includeScript("gomap.js")
                                ),
                                
                                leafletMap("map", width="100%", height="100%",
                                           initialTileLayer = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
                                           initialTileLayerAttribution = HTML('Maps by <a href="http://www.mapbox.com/">Mapbox</a>'),
                                           options=list(
                                               center = c(54.65, -6),
                                               zoom = 6
                                               #maxBounds = list(list(47,-12), list(63,5)) # Show UK only
                                           )
                                ),
                                
                                # Shiny versions prior to 0.11 should use class="modal" instead.
                                absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                              draggable = TRUE, top = 80, left = "auto", right = 10, bottom = "auto",
                                              width = 230, height = "auto",
                                              
                                              h2("Map"),
                                              h5("Select tweets to display"),
                                              selectInput("color", "Color", vars,selected="all"),
                                              hr(),
                                              h5("Key"),
                                              uiOutput("mapKey")
                                              
                                )
                            )   
                   )
))











