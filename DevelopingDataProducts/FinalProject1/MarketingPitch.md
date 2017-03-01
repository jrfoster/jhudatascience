<style>
.small-code pre code {
  font-size: 1em;
}
.reveal h1, .reveal h2, .reveal h3 {
  word-wrap: normal;
  -moz-hyphens: none;
}
</style>

Bank Marketing Campaign Success Predictor
========================================================
author: jrfoster
date: 20 February, 2017
autosize: true
transition: rotate



Background
========================================================
Marketing in banks faces some significant challenges
- Regaing customer trust in light of reputation damage done in the last few years
- Erosion of customer satisfaction and loyalty: no more customers for life
- Difficulties going digital due to level of planning and compliance

Embracing analytics and tailoring campaigns based on facts can help!

Campaign Success Predictor Application
========================================================
This concept application uses the <a href="https://archive.ics.uci.edu/ml/datasets/Bank+Marketing" target="_blank">Bank Marketing Dataset</a> to do the following
- Create a predictive model of success based on current customers and past experience
- Allow different users to accomplish different goals
  - Marketing managers can see what works for their customer base and what doesn't
  - Telephone marketers can tailor approach based on customer

Prediction Model Overview
========================================================
class: small-code
- Gradient Boosting Machine model based on five variables
 - 10-fold Cross Validation
- Feature extraction based on several methods
  - Principal Component Analysis
  - Best First
  - Forward Search
  - Information Gain
  
***

```r
load("./BankMarketing/gbmModel.RData")
test <- readRDS("TestingData.rds")
pred <- predict(gbmModel, test)
conf <- confusionMatrix(test$y, pred)
acc <- unname(conf$overall[1])
oosEror <- 1- acc
kappa <- unname(conf$overall[2])
trAcc <- unname(gbmModel$results$Accuracy)
table <- data.frame(acc, oosEror, kappa, trAcc)
kable(table, digits=5, col.names=c("Testing Accuracy", "Out-Of-Sample Error", "Kappa", "Training Accuracy"))
```



| Testing Accuracy| Out-Of-Sample Error|   Kappa| Training Accuracy|
|----------------:|-------------------:|-------:|-----------------:|
|          0.89441|             0.10559| 0.25891|           0.89203|

Application Screen Shot
========================================================
The image below provides a glimpse at the application

![screenshot](./capture.png)

Conclusion
========================================================
An application of this nature could have the following benefits
- It could help a person performing telephone marketing to adapt their approach
- It could help a marketing manager tailor a campaign based on known information

If you're ready to give it a try
- <a href="https://jrfoster.shinyapps.io/BankMarketing/" target="_blank">ShinyApps.io</a> deployment of the application
  
If you want to see some code
- <a href="https://github.com/jrfoster/ddpProject" target="_blank">GitHub</a> repo containing code for this presentation and the application itself
