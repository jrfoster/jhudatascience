# 
# This file contains the shiny UI implementation for the exploration of the
# UCI Machine Learning Bank Marketing dataset.
# 
# It collects the values from the user necessary to make a prediction using
# the previously created gradient boosting model
# 
# Author: jrfoster
# 

library(shiny)

# Define UI for application that makes a prediction
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Bank Marketing Campaign Success Predictor"),
  
  # Sidebar with a drop-downs and sliders for the predictor variables
  sidebarLayout(
    sidebarPanel(
      selectInput("poutcome", 
                  label = "Outcome of last campaign", 
                  choices=c("Success","Failure","Other","Unknown")),
      sliderInput("previous", 
                  label = "Number of contacts in last campaign", 
                  min=0, max=10,
                  value=1),
      sliderInput("campaign", 
                  label = "Number of contacts this campaign", 
                  min=0, max=10,
                  value=3),
      sliderInput("age",
                  label = "Customer age (years)",
                   min = 18, max = 95,
                   value = 40),
      sliderInput("balance", 
                label = "Average Daily Balance",
                min=-10000, max=25000, step=100,
                value=1500)
    ),
    
    # Show the prediction and the associated estimated probability
    mainPanel(
      tabsetPanel(
        tabPanel("Campaign Success Predictor", 
                 h3("Estimated Likelihood of Success"), 
                 plotOutput("plot", height = "75px", width = "100%"), 
                 uiOutput("predictionText")),
        tabPanel("User Guide", includeHTML("./documentation/userdoc.html"))
    ))
  )
))
