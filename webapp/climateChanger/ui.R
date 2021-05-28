#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shinyWidgets)
library(plotly)
library(shiny)
load("countriesInMap.RDATA")

ui <- navbarPage(title="Climate Change R",
    
    
                tabPanel("Summary", p("This is a webapp for the datasets and R codes of 'Exploring Climate Change Data with R', 
                                      a book chapter authored by Nuno Guimaraes, Kimmo Vehkalahti, Pedro Campos, and Joachim Engel, 
                                      to be published in 2021.(work in progress - more details to be added later)")
                                      ), 
                tabPanel("Figure 1", plotlyOutput("plot")), 
                tabPanel("Figure 2", plotlyOutput("plot2")),
                tabPanel("Figure 3", plotlyOutput("plot3")),
                tabPanel("Figure 4", plotlyOutput("plot4")),
                tabPanel("Figure 5", plotlyOutput("plot5")),
                tabPanel("Maps",  fluidRow(
                    column(4,
                           wellPanel(
                               sliderInput("slider2", "Year Range",
                                           min = 1743, max = 2013, value = c(1743,2013),sep = ""),
                               selectInput("select_region", h3("Select Region"), 
                                           choices = list("USA" = "USA", "World" = "world","Custom"="custom"), selected = 1),
                              
                               conditionalPanel(
                                 condition = "input.select_region=='custom'",
                                 pickerInput(
                                   inputId = "countries_selected",
                                   multiple=TRUE,
                                   label = "Select Countries", 
                                   choices = as.vector(countries),
                                   options = list(
                                     `live-search` = TRUE)
                                 )
                               ),
                               
                                selectInput("select_type", h3("Select Type Function"), 
                                           choices = list("Average" = "average", "Max" = "max"), selected = 1),
                               actionButton("activeButton", "Apply")
                               
                           )),
                    column(8,
                           plotlyOutput("maps")
                           )
                          
                    )
                ))
               
