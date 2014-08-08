# Coursera Getting and Cleaning Data Project
# Author: Nikolaos Lamprou
# Date: 08/08/2014

# Original Data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# Original Data Description: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

# Script Summary

#load necessary packages
#import files
#map activity labels to activity id for y_test and y_train
#cbind X_test with corresponding subject and activity
#cbind X_train with corresponding subject and activity
#rbing X_train and X_test datasets and assign colnames
#select stddev and mean variables from features only
#filter combined dataset to extract selected variable data only
#order data by subject and activity
#write tidy dataset to file
#melt cast tidy dataset to calculate mean value of each selected variable per subject and activity
#write summary table to file



#Load necessary packages
library(reshape2)

#Import all relevant files from UCI HAR Dataset directory
print("Importing Files.")
path_test<-"./UCI HAR Dataset/test/"
path_train<-"./UCI HAR Dataset/train/"
path_general<-"./UCI HAR Dataset/"
paths<-list(path_test,path_train,path_general)
for(path in paths)
{
    files<-list.files(path, pattern="*.txt") 
    for(file in files){
        if(!(file  %in% c("features_info.txt","README.txt")) ){
            perpos <- which(strsplit(file, "")[[1]]==".")
            assign(
                gsub(" ","",substr(file, 1, perpos-1)),
                read.table(paste(path,file,sep = ""),quote="\""))
            print(paste("Imported:",file))
        }
    }
}
print("Importing Files: Done")


# Bind subject and activity metadata onto dataset
print("Processing Data")
#Test Data
activity_test<- data.frame(activity = factor(y_test$V1, labels = activity_labels$V2))
comb_test<- cbind(subject_test,activity_test, X_test)
#Train Data
activity_train<- data.frame(activity = factor(y_train$V1, labels = activity_labels$V2))
comb_train<- cbind(subject_train,activity_train, X_train)

#Combine test and train datasets
print("Combining test and train datasets")
comb_all<- rbind(comb_test, comb_train)
features$V2<-as.character(features$V2)
colnames(comb_all)<- c("Subject","Activity", features[,2])


#Filter out requested variables' data
print("Filtering dataset to extract required data")
filter<-features$V2[grep("mean\\(\\)|std\\(\\) ",features$V2)]
tidy_data<-comb_all[c("Subject","Activity", filter)]

#Reorder tidy dataset
tidy_data<-tidy_data[order(tidy_data$Subject,tidy_data$Activity),]


# Write Tidy Dataset to File
print("Writing Tidy Dataset to file: tidyDataset.txt...")
write.table(tidy_data, file=paste(path_general,"tidyDataset.txt",sep=""), row.names=FALSE,quote = FALSE)
message("Getting and Cleaning Data process complete. Tidy Dataset at tidyDataset.txt")

#Melt and Cast tidy dataset
tidy_data_melt<-melt(tidy_data,id=c("Subject","Activity"),measure.vars=filter)
tidy_data_avg<-dcast(tidy_data_melt, Activity + Subject ~ variable, mean)

# Write Summary Tidy Dataset to File
print("Writing Summary Tidy Dataset to file: avg_tidyDataset.txt...")
write.table(tidy_data_avg, file=paste(path_general,"avg_tidyDataset.txt",sep=""), row.names=FALSE,quote = FALSE)
message("Averaging Data process complete.Summary Tidy Dataset at avg_tidyDataset.txt")


