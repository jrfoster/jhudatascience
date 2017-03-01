# 
# This file contains the shiny UI implementation for the Precision Coaching
# application, which is essentially an exploration of the qualitative activity 
# recognition dataset discussed in the following paper:
# 
# http://groupware.les.inf.puc-rio.br/public/papers/2013.Velloso.QAR-WLE.pdf
# 
# It presents a list of options for which sets of variables to display and compare
# in a 3-d scatterplot
# 
# Author: jrfoster
#

library(shiny)
library(plotly)

# Define UI for application that draws a 3d scatterplot
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Precision Coaching Concept Application"),
  
  # Sidebar with checkboxes and radio buttons to select what to plot 
  sidebarLayout(
    
    sidebarPanel(
      
      tags$head(tags$style("#distPlot{height:90vh !important;}")),
      
      selectInput("subject", 
                   label = "View which test subject?",
                   choices = c("Carlitos", "Pedro", "Adelmo", "Charles", "Eurico", "Jeremy")),
      
      radioButtons("sensor", 
                   label = "Which sensor do you want to examine?", 
                   choices = c("Gyroscope" = "gyros", "Acceleration," = "accel", "Magnetometer" = "magnet")),
      
      radioButtons("bodyPosition", 
                   label = "At which body location?", 
                   choices = c("belt", "dumbbell", "arm", "forearm")),
      
      checkboxGroupInput("class",
                         label = "Which Exercise Classification?",
                         choices = c("A - Correct" = "A", "B - Throwing Elbows Out" = "B", 
                                     "C - Lifting Halfway" = "C", "D - Lowering Halfway" = "D", "E - Throwing Hips Out" = "E"),
                         selected = "A")
    ),
    
    # Show the scatterplot
    mainPanel(
      tabsetPanel(
        tabPanel("Data Explorer", plotlyOutput("distPlot", width="100%")),
        tabPanel("User Guide", includeHTML("./documentation/userdoc.html"))
      )
    )
  )
))
