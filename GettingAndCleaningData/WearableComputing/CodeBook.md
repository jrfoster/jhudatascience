Tidy Data CodeBook
===
Overview
---
This document contains information about the source data from which the tidy data are produced and information about the final data produced.  Information in this document borrows heavily from the [UCI HAR study documentation](https://www.elen.ucl.ac.be/Proceedings/esann/esannpdf/es2013-84.pdf).  Also, note that the reader should consult the README in this repository for operational information, as well as the README and features_info.txt in the original HAR dataset package for further descriptions of data elements.

The data have been extracted from the Human Activity Recognition (HAR) dataset.  The Human Activity Recognition dataset was built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.  The data are a public domain dataset, but its use requires an acknowledgement [1].

The original experiments were conducted with a group of 30 volunteers between the ages of 19-48 years. Each person performed six activities (WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist.  The original dataset was randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.  The partitioning strategy is important because it directly implies that the two datasets (test and train) are mutually exclusive and can therefore be combined simply by appending (union) the rows of the training set to the rows of the test set.

The data are combined from several files from the original dataset, with only certain features extracted, as described below and with more descriptive column headers and activity names.  The transformed raw data were then aggregated to calculate means for each subject->activity grouping.  The following diagram gives a rough depiction of how the files were combined to produce the raw data prior to aggregation.

![File Map](filemap.png)

The data are given in a comma-separated file, with quoted strings.  The file contains a single header row and consists of 180 observations of 68 variables, which are further defined below.

Data Type Definitions
---
The following data type definitions are utilized in this dictionary

| Code | Term | Definition |
| --- | --- | --- |
| c | classification | A coded classification, such M for Male, or F for Female |
| d | decimal | Numeric data containing a decimal point with varying precision and scale |
| i | integer | Numeric data (integer) containing no decimal point (whole number) |
 
Data Elements
---
The authors of the study collected triaxial linear acceleration and angular velocity signals using the phone accelerometer and gyroscope at a sampling rate of 50Hz. These signals were preprocessed for noise reduction with a median filter and a 3rd order low-pass Butterworth filter with a 20 Hz cutoff frequency. The acceleration signal, which has gravitational and body motion components, was separated using another Butterworth low-pass filter into body acceleration and gravity. 

Additional time signals were obtained by calculating from the triaxial signals the Euclidean magnitude and time derivatives (jerk da/dt and angular acceleration dw/dt).  Thus, a total of 17 signals were obtained with this method, which are listed below.  '-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

 - tBodyAcc-XYZ
 - tBodyAccJerk-XYZ
 - tBodyGyro-XYZ
 - tBodyGyroJerk-XYZ
 - tBodyAccMag
 - tGravityAccMag
 - tBodyAccJerkMag
 - tBodyGyroMag
 - tBodyGyroJerkMag
 - fBodyAcc-XYZ
 - fBodyAccJerk-XYZ
 - fBodyGyro-XYZ
 - fBodyAccMag
 - fBodyAccJerkMag
 - fBodyGyroMag
 - fBodyGyroJerkMag

From each sampled window described above a vector of features was obtained. Standard measures previously used in HAR literature such as the mean, correlation, signal magnitude area (SMA) and autoregression coefficients were employed for the feature mapping. A new set of features was also employed in order to improve the learning performance, including energy of different frequency bands, frequency skewness, and angle between vectors (e.g. mean body acceleration and y vector). Listed below are all the measures applied to the time and frequency domain signals.

| Function | Description |
| --- | --- |
| mean | Mean value |
| std | Standard deviation |
| mad | Median absolute value |
| max | Largest values in array |
| min | Smallest value in array |
| sma | Signal magnitude area |
| energy | Average sum of the squares |
| iqr | Interquartile range |
| entropy | Signal Entropy |
| arCoeff | Autorregresion coefficients |
| correlation | Correlation coefficient |
| maxFreqInd | Largest frequency component |
| meanFreq | Frequency signal weighted average |
| skewness | Frequency signal Skewness |
| kurtosis | Frequency signal Kurtosis |
| energyBand | Energy of a frequency interval |
| angle | Angle between two vectors |

With this, a total of 561 features were derived.

From this 561-feature vector were chosen those corresponding to the mean (mean) and standard deviation (std) for the measurements utilizing a regular expression to create a 66-element vector.

Therefore, each observation (row) in this new data set consists of the following variables (columns).  Note, that '-XYZ' denotes three individual variables, one for each axes X, Y and Z.

**Subject (i)**<br>
An integer in the range between 1 and 30 identifying the volunteer who performed the activity and whose data are recorded in the observation.  The source of the data is the union of the subject\_test.txt and subject\_train.txt

**ActivityLabel (c)**<br>
A string identifying the activity Subject performed to generate the data in the observation.  Values for this variable are one of the following (WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING, STANDING or LAYING).  The source of this data is the union of the y\_test.txt and y\_train.txt expressed as a factor using data from the activity\_labels.txt file.

**tBodyAcc-mean()-XYZ (d)**<br>
**tBodyAcc-std()-XYZ (d)**<br>
**tGravityAcc-mean()-XYZ (d)**<br>
**tGravityAcc-std()-XYZ (d)**<br>
The estimated mean and standard deviation for the acceleration signal, separated into body and gravity acceleration signals.

**tBodyAccJerk-mean()-XYZ (d)**<br>
**tBodyAccJerk-std()-XYZ (d)**<br>
**tBodyGyro-mean()-XYZ (d)**<br>
**tBodyGyro-std()-XYZ (d)**<br>
**tBodyGyroJerk-mean()-XYZ (d)**<br>
**tBodyGyroJerk-std()-XYZ (d)**<br>
The estimated mean and standard deviation for the jerk signals derived from the body linear acceleration and angular velocity.

**tBodyAccMag-mean() (d)**<br>
**tBodyAccMag-std() (d)**<br>
**tGravityAccMag-mean() (d)**<br>
**tGravityAccMag-std() (d)**<br>
**tBodyAccJerkMag-mean() (d)**<br>
**tBodyAccJerkMag-std() (d)**<br>
**tBodyGyroMag-mean() (d)**<br>
**tBodyGyroMag-std() (d)**<br>
**tBodyGyroJerkMag-mean() (d)**<br>
**tBodyGyroJerkMag-std() (d)**<br>
The estimated mean and standard deviation for The magnitude of the three-dimensional signals calculated using the Euclidean norm.

**fBodyAcc-mean()-XYZ (d)**<br>
**fBodyAcc-std()-XYZ (d)**<br>
**fBodyAccJerk-mean()-XYZ (d)**<br>
**fBodyAccJerk-std()-XYZ (d)**<br>
**fBodyGyro-mean()-XYZ (d)**<br>
**fBodyGyro-std()-XYZ (d)**<br>
**fBodyAccMag-mean() (d)**<br>
**fBodyAccMag-std() (d)**<br>
**fBodyBodyAccJerkMag-mean() (d)**<br>
**fBodyBodyAccJerkMag-std() (d)**<br>
**fBodyBodyGyroMag-mean() (d)**<br>
**fBodyBodyGyroMag-std() (d)**<br>
**fBodyBodyGyroJerkMag-mean() (d)**<br>
**fBodyBodyGyroJerkMag-std() (d)**<br>
The estimated mean and standard deviation for the Fast Fourier Transform (FFT) applied to some of the original time signals.

Acknowledgement
---
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012



> Written with [StackEdit](https://stackedit.io/).