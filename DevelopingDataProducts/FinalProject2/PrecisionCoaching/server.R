# 
# This file contains the shiny server implementation for the Precision Coaching
# application, which is essentially an exploration of the qualitative activity 
# recognition dataset discussed in the following paper:
# 
# http://groupware.les.inf.puc-rio.br/public/papers/2013.Velloso.QAR-WLE.pdf
# 
# It takes the selections from the user interface, selects appropriate columns
# and rows from the dataset and creates a 3-d scatterplot using plotly.
# 
# Author: jrfoster
# 

library(shiny)
library(dplyr)
library(plotly)

# Load the raw data from the saved RDS
pmlRaw <- readRDS("pmlTraining.rds")

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  # Returns a combination of sensor and body position to use as a base column name
  baseColumnName <- reactive({
    paste(input$sensor, "_", input$bodyPosition, sep = "")
  })
  
  # Returns the regex pattern to limit column selection in the dataset
  pattern <- reactive({
    paste("^", baseColumnName(), "|classe|user_name", sep = "")
  })
  
  # Returns a formatted set of classes to use with dplyr %in% in row selection
  classes <- reactive({
    if (length(input$class) == 0) {
      "A"
    } else if (length(input$class) == 1) {
      input$class  
    } else {
      strsplit(input$class, split=" ")
    }
  })
  
  output$baseCol <- renderText({
    baseColumnName()
  })
  
  output$pattern <- renderText({
    pattern()
  })
  
  output$classes <- renderText({
    classes()
  })
  
  observe({
    if(length(input$class) == 0) {
      updateCheckboxGroupInput(session, "class", selected = "A")
    }
  })  
  
  # Render the plotly plot with a limited dataset
  output$distPlot <- renderPlotly({
    
    data <- pmlRaw %>% 
      select(matches(pattern())) %>%
      filter(user_name == tolower(input$subject) & classe %in% classes())
    
    xCol <- as.formula(paste("~", baseColumnName(), "_x", sep = ""))
    yCol <- as.formula(paste("~", baseColumnName(), "_y", sep = ""))
    zCol <- as.formula(paste("~", baseColumnName(), "_z", sep = ""))
    
    data %>%
      plot_ly(x=xCol, y=yCol, z=zCol, color=~classe) %>%
      add_markers()
  })
})
