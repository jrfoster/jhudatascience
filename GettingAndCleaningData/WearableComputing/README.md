Wearable Computing
==
Overview
--
This repository contains the deliverables related to the course project for the Coursera "Getting and Cleaning Data" class.  The purpose of this project is to demonstrate our ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.  

For the project we were to create a driver program that does the following:
 1. Merges the training and the test sets to create one data set.
 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
 3. Uses descriptive activity names to name the activities in the data set
 4. Appropriately labels the data set with descriptive variable names. 
 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The data for this project come from the [Human Activity Recognition Study](https://www.elen.ucl.ac.be/Proceedings/esann/esannpdf/es2013-84.pdf).

This [paper](http://vita.had.co.nz/papers/tidy-data.pdf) contains more information on what constitutes a "tidy" dataset.

Artifacts
--
In this repository you will find the following artifacts:

| Name | Description |
| --- | --- |
| README.md | This file |
| CodeBook.md | The code book describing the tidy data |
| run_analysis.R | The driver program to produce the tidy data |

Requirements
--
To be able to execute the driver program to produce the tidy data, you must have the following:
 1. A local copy of this repository. 
 2. An environment in which to source and execute the R program, such as RStudio, or the R Console, available from [CRAN](https://cran.r-project.org/).
 2. The public dataset from the [Human Activity Recognition Study](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

Producing the Tidy DataSet
--
To create the dataset, perform the following steps:

 1. Download the [UCI HAR Dataset](https://d396qusza40orc.cloudfront.net/getdata/projectfiles/UCI%20HAR%20Dataset.zip) to your computer.
 2. Unzip the dataset into your R working directory, preserving the zip file's directory structure.
 3. Copy run_analysis.R into your R working directory.
 4. In the R console, source the driver program `source(run_analysis.R)`
 5. Execute the driver program, optionally specifying the data directory and whether or not to produce the raw data `run_analysis()`
 6. Verify that the file finalTidyData.txt is created in the working directory.

Function Documentation
--
Generally speaking, the driver program is self-contained, and requires the base R packages plus the [data.table R package](https://cran.r-project.org/web/packages/data.table/index.html).  The program itself will install this package if it is not already present in your R environment.

To run the driver program, simply execute the function run_analysis() in the R console. 

    run_analysis(datadir = "UCI HAR Dataset", outputraw = FALSE)

| Argument | Description |
| --- | --- |
| datadir | The top-level directory of the UCI HAR Dataset, assumed to be in the working directory. Default value is "UCI HAR Dataset" | 
| outputraw | A flag to indicate if you also wish to write the raw data in addition to the aggregated dataset.  This can be useful for testing purposes. Default value is FALSE. |


Details
---
The function requires data.table, and will install it, plus its dependencies, if not present in the environment.  If unable to install or load this package, the function will halt.

The function requires the HAR dataset, and will make a small attempt to verify that its actually there by checking for datadir within the current working directory, along with datadir/test and datadir/train.  If any of those directories are not present, the function will halt.

The program combines the test and training datasets for observations, activities and subjects into separate single datasets by using read.table to read the source files from disk and rbind to create a union of the rows read for each dataset.  Activities are loaded as factors to facilitate later labeling with appropriate text.  As data is loaded and combined, the source data structures are removed from memory to conserve resources.

Feature extraction was performed using a simple regular expression for identifying all features that are either a mean or a standard deviation, according to the study documentation.  The regex used is `.*-mean[(]|.*-std[(]` which essentially extracts all columns with "mean(" or "std(" in the name.  Features were read from features.txt and the regex was applied to create the desired feature vector.  This vector was used to subset the combined observation data into a 66-variable set of observations.  For more information on this feature extraction, please see the CodeBook.

To obtain meaningful activity names, the combined activity data was labeled with the contents of the activity_labels.txt using standard R factors.

Column names were derived by using the regex-derived vector on the feature descriptions read from features.txt and applied as colNames on the combined observation data.

The final raw dataset was produced using cbind to combine the union-ed subject, activity label and observation subset.

The aggregation to calculate means for each subject and activity was performed using the data.table package, largely for performance reasons.  I did investigate the reshape2 package and the melt/cast functionality, and while it was functional, it didn't perform as well as the data.table aggregations and it felt inefficient to have to transpose the data to another format just for the purposes of aggregation.  

Note that the final dataset is in wide format.

Testing Performed
---
The steps were performed with the outputraw parameter set to TRUE.  A table was created in MySQL corresponding to the dataset and the data from the raw dataset was loaded using LOAD TABLE.  Several aggregate queries to produce means were run for various subject/activity combinations and for several variables and the results were visually compared to the final tidy data set.  No anomalies were discovered, but the testing was not exhaustive.

> Written with [StackEdit](https://stackedit.io/).