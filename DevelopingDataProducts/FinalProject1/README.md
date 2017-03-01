
#Introduction

This repository contains the artifacts for the final project for the Coursera Developing Data Products course.  The application and associated "pitch" presentation are for a Marketing Campaign Success Predictor application that could allow a marketing department to not only tailor aspects of a campaign to different demographics, but also better equip a telemarketer to take the right approach given the likelihood of success.


##Application
The application in this repository is basically a driver for a Gradient Boosting Machine model derived from the [UCI Bank Marketing Dataset](https://archive.ics.uci.edu/ml/datasets/Bank+Marketing).  Based on the values selected, the application shows the relative probability of success and shows that score on a color-gradient scale.

![screenshot](https://github.com/jrfoster/ddpProject/blob/master/Capture.PNG)

##Model Generation
If you are curious about how the model was generated, the file [ModelGen.R](https://github.com/jrfoster/ddpProject/blob/master/ModelGen.R) contains the code I used to create the model and save the various aspects that I would need to use for the application and associated "pitch" presentation: specifically the RData file containing the model and the testing dataset I used to generate the performance data in the presentation.

Several approaches were taken to identify a reasonable set of predictors, including principal component analysis, correlation-based "best first", forward search and information gain.  Based on those methods, five features were selected and the model trained on a training set comprised of 70% of the overall data and tested against the remaining 30%.

I also tried several different models (K-Nearest Neighbors, Random Forest, Neural Network) and played around quite a bit with the tuning grid for each, with the same predictors.  In the end, I settled on the GBM model because it was fastest to generate and overall had the best performance, at least in terms of accuracy.

It should be noted that there is some degree of overfitting in the model, but for the purposes of this assignment, I think it can be disregarded.

> Written with [StackEdit](https://stackedit.io/).