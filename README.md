## Getting and Cleaning Data Course Project 1 
####  (Coursera - Data Science specialization)   

### Description
> The purpose of this project is to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. 

> This repo includes: 1) a tidy data set, <span style="color:red">tidy_mean.txt</span>, as described below, 2) a R script called <span style="color:red">run_analysis.R</span> performing the analysis, and 3) a code book called <span style="color:red">CodeBook.md</span> that describes the variables, the data, and any transformations or work that performed to clean up the data 4) this <span style="color:red">README.md</span> repo explains how all of the scripts work and how they are connected.

### Data
> The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
> http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

> Here are the data for the project:
> https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

### Data Information
> The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed 6 activities (<span style="color:green">WALKING</span>, <span style="color:green">WALKING_UPSTAIRS</span>, <span style="color:green">WALKING_DOWNSTAIRS</span>, <span style="color:green">SITTING</span>, <span style="color:green">STANDING</span>, <span style="color:green">LAYING</span>) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

> The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. For each record it is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration (*g*'s, 9.81 m.s⁻²).
- Triaxial Angular velocity from the gyroscope (radians per second, rad.s⁻¹). 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

### The source code <span style="color:red">run_analysis.R </span> does the following:
0. Load libraries, download and unzip file to working directory
1. Merges the training and the test sets to create one data set
2. Extracts only the measurements on the mean and standard deviation for each measurement
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

```
##############################################################################
# 0. Load libraries, download and unzip file to working directory.
##############################################################################

library(reshape2); sessionInfo()$otherPkgs$reshape2$Version ## "1.4.2"
date() ## "Mon Apr  2 12:55:17 2018"

dir <- setwd("/Users/wlhsu/Desktop/Coursera/3. Getting and Cleaning Data/project")

fileName <- "UCI_HAR_Dataset.zip"

if(!file.exists(fileName)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileURL, fileName, method = "curl")
        unzip(fileName)
}

##############################################################################
# 1. Merges the training and the test sets to create one data set
##############################################################################

# read and merge Values data
X_train <- read.table("UCI HAR Dataset/train/X_train.txt"); dim(X_train) ## 7352  561
X_test  <- read.table("UCI HAR Dataset/test/X_test.txt"); dim(X_test)    ## 2947  561
X       <- rbind(X_train, X_test); dim(X)                                ## 10299 561

# read and merge Activity data
Y_train <- read.table("UCI HAR Dataset/train/Y_train.txt"); dim(Y_train) ## 7352    1
Y_test  <- read.table("UCI HAR Dataset/test/Y_test.txt"); dim(Y_test)    ## 2947    1
Y       <- rbind(Y_train, Y_test); dim(Y)                                ## 10299   1

# read and merge Subject data
Subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt"); dim(Subject_train) ## 7352    1
Subject_test  <- read.table("UCI HAR Dataset/test/subject_test.txt"); dim(Subject_test)    ## 2947    1
Subject       <- rbind(Subject_train, Subject_test); dim(Subject)                          ## 10299   1


##############################################################################
# 2. Extracts only the measurements on the mean and standard deviation for each measurement
##############################################################################

# Read features
features <- read.table("UCI HAR Dataset/features.txt"); dim(features)  ## 561   2
head(features,3)
##   V1                V2
##1  1 tBodyAcc-mean()-X
##2  2 tBodyAcc-mean()-Y
##3  3 tBodyAcc-mean()-Z

# Extract feature vector with mean and standard deviation only
feaMeanSD <- grep("(mean|std)\\(\\)", features[, 2]); length(feaMeanSD) ## 66
head(feaMeanSD,10)
##[1]  1  2  3  4  5  6 41 42 43 44

# Extract Values dataset - X with only mean and standard deviation recorder
XMeanSD <- X[, feaMeanSD]; dim(XMeanSD)
## [1] 10299    66

##############################################################################
# 3. Uses descriptive activity names to name the activities in the data set
##############################################################################

# Read activity names
activity <- read.table("UCI HAR Dataset/activity_labels.txt"); dim(activity) ## 6 2
head(activity)
##  V1                 V2
##1  1            WALKING
##2  2   WALKING_UPSTAIRS
##3  3 WALKING_DOWNSTAIRS
##4  4            SITTING
##5  5           STANDING
##6  6             LAYING

# change corresponding activity names in activity dataset - Y
Y[, 1] = activity[Y[ , 1], 2]


##############################################################################
# 4. Appropriately labels the data set with descriptive activity names
##############################################################################
=============================================
# a. subject dataset - Subject
=============================================
names(Subject) <- "subject"
table(Subject)
Subject
##   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19 
## 347 302 341 317 302 325 308 281 288 294 316 320 327 323 328 366 368 364 360 

##  21  22  23  24  25  26  27  28  29  30
## 354 408 321 372 381 409 392 376 382 344 383 
=============================================
# b. Activity dataset - Y
=============================================
# change column names 
names(Y) <- "activity"
table(Y)
##   LAYING   SITTING   STANDING   WALKING  WALKING_DOWNSTAIRS   WALKING_UPSTAIRS 
##     1944      1777       1906      1722               1406               1544 

=============================================
# c. Values dataset with mean and SD - XMeanSD
=============================================
# c1. change column names of "XMeanSD" dataset
names(XMeanSD) <- features[feaMeanSD, 2]
head(names(XMeanSD),3)
## [1] "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z"

# c2. remove special characters of "XMeanSD" dataset
names(XMeanSD) <- gsub("[\\(\\)-]", "", names(XMeanSD))
head(names(XMeanSD),3)
## [1] "tBodyAcc-mean-X" "tBodyAcc-mean-Y" "tBodyAcc-mean-Z"

# c3. expand abbreviations and clean up names 
names(XMeanSD) <- gsub("^f", "frequencyDomain", names(XMeanSD))
names(XMeanSD) <- gsub("^t", "timeDomain", names(XMeanSD))
names(XMeanSD) <- gsub("Acc", "Accelerometer", names(XMeanSD))
names(XMeanSD) <- gsub("Gyro", "Gyroscope", names(XMeanSD))
names(XMeanSD) <- gsub("Mag", "Magnitude", names(XMeanSD))
names(XMeanSD) <- gsub("Freq", "Frequency", names(XMeanSD))
names(XMeanSD) <- gsub("mean", "Mean", names(XMeanSD))
names(XMeanSD) <- gsub("std", "StandardDeviation", names(XMeanSD))

# c4. correct typo
names(XMeanSD) <- gsub("BodyBody", "Body", names(XMeanSD))
head(names(XMeanSD))
## [1] "timeDomainBodyAccelerometer-Mean-X"              "timeDomainBodyAccelerometer-Mean-Y"             
## [3] "timeDomainBodyAccelerometer-Mean-Z"              "timeDomainBodyAccelerometer-StandardDeviation-X"
## [5] "timeDomainBodyAccelerometer-StandardDeviation-Y" "timeDomainBodyAccelerometer-StandardDeviation-Z"


=============================================
# d. make tidy dataset 
=============================================
tidy <- cbind(Subject, Y, XMeanSD); dim(tidy)  ## 10299    68
write.table(tidy, "tidy.txt", col.names = TRUE, row.names = FALSE, quote = FALSE)


##############################################################################
# 5. Create a second, independent tidy set with the average of each variable
#    for each activity and each subject
##############################################################################
# group by subject and activity and summarise using mean
# Melt data frame for reshaping
tidy.melt  <- melt(data = tidy, id = c("subject", "activity"))

#Reshape into tidy data frame by mean using the reshape2 package
tidy.mean  <- dcast(data = tidy.melt, subject + activity ~ variable, fun.aggregate = mean)
dim(tidy.mean)  ## 180  68

# output file "tidy_mean.txt"
write.table(tidy.mean, "tidy_mean.txt",  col.names = TRUE, row.names = FALSE, quote = FALSE)

```



