# 
# This file contains the shiny server implementation for the Bank Marketing Campaign 
# Success Predictor which utilizes the UCI Machine Learning Bank Marketing dataset.
# 
# It takes the selections from the user interface and generates a prediction based
# on a gradient boosting model on the liklihood of success of a marketing campaign.
# 
# Author: jrfoster
# 
library(shiny)
library(caret)
library(gbm)


# Define server logic required to make the prediction
shinyServer(function(input, output) {
  
  getPrediction <- reactive({
    load("./gbmModel.RData")
    
    # Create a dataframe with the new data from the input panel
    newDf <- data.frame(poutcome = as.factor(tolower(input$poutcome)), 
                        previous=input$previous, 
                        campaign=input$campaign, 
                        age=input$age, 
                        balance=as.numeric(input$balance))
    
    # Get the prediction from the model
    prediction <- predict(gbmModel, newdata=newDf, type="prob")
    prediction[2]
  })
  
  output$predictionText <- renderText({
    
    paste("<span style=\"font-size:16px\">Estimated Probability:<span style=\"font-weight:bold\">", "  ", round(unname(getPrediction()),5), "</span></span>")
    
  })
  
  output$plot <- renderPlot({
    
    # Create a function to return the gradient colors for the probability scale
    colfunc<-colorRampPalette(c("red2","gold","yellow","chartreuse3"))
    
    # Show the gradient scale so the user can get a visual of the range
    par(mar=c(0,0,0,0))
    plot(x=1:100,y=rep(0,100), col=(colfunc(100)), ylim=c(-.1,.1), pch=19, cex=2, xlab="", ylab="", axes=FALSE)
    
    # Now overlay something to show where the user's score actually is
    points(x=round(unname(getPrediction()* 100)), y=0, ylim=c(-.1,.1), col="black", pch=19, cex=2)
    
  })
})
