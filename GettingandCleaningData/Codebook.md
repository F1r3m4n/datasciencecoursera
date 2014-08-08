---
title: "Codebook"
author: "Nikolaos Lamprou"
date: "Friday, August 08, 2014"
output: html_document
---
    
    ###Dataset Information
    The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

###Dataset Variables

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.


Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz.

- tBodyAcc-XYZ
- tGravityAcc-XYZ

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals.

- tBodyAccJerk-XYZ
- tBodyGyro-XYZ
- tBodyGyroJerk-XYZ


Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm.

- tBodyAccMag
- tGravityAccMag
- tBodyAccJerkMag
- tBodyGyroMag
- tBodyGyroJerkMag


Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing the following. (Note the 'f' to indicate frequency domain signals).

- fBodyAcc-XYZ
- fBodyAccJerk-XYZ
- fBodyGyro-XYZ
- fBodyAccMag
- fBodyAccJerkMag
- fBodyGyroMag
- fBodyGyroJerkMag

The set of variables included in the tidy dataset include the following estimates from these signals each denoted by the corresponding suffix:
    
- mean(): Mean value
- std(): Standard deviation

The first two columns contain the the activity performed and the subject who performed them.

- Subject
- Activity
