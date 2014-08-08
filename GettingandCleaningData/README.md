## Getting and Cleaning Data - Coursera Project
author: Nikolaos Lamprou
date: August 8, 2014


This work aims to clean and transform the provided raw data into two tidy datasets
- tidyDataset.txt   Including all variables containing means or std of variables, by activity and subject
- avg_tidyDataset.txt   Inclusing the mean of all above measurents by activity and subject

The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

Here are the data for the project:

<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

The ETL process is handled by the script run_analysis.R
A summary of the processes is as follows

### run_analysis.R Script Summary

1. Load necessary packages
2. Import relevant files
3. Map activity labels to activity id for y_test and y_train
4. cbind X_test with corresponding subject and activity
5. cbind X_train with corresponding subject and activity
6. rbind X_train and X_test datasets and assign colnames
7. Select stddev and mean variables from features only
8. Filter combined dataset to extract selected variable data only
9. Order data by subject and activity
10. Write tidy dataset to file
11. Melt cast tidy dataset to calculate mean value of each selected variable per subject and activity
11. Write summary table to file
