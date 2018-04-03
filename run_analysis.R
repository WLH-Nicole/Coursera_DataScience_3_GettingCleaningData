
# 0. Load libraries, download and unzip file to working directory
library(reshape2); sessionInfo()$otherPkgs$reshape2$Version

dir <- setwd("/Users/wlhsu/Desktop/Coursera/3. Getting and Cleaning Data/project"); dir

fileName <- "UCI_HAR_Dataset.zip"

if(!file.exists(fileName)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileURL, fileName, method = "curl")
        unzip(fileName)
}

# 1. Merges the training and the test sets to create one data set.
X_train <- read.table("UCI HAR Dataset/train/X_train.txt"); dim(X_train)
X_test  <- read.table("UCI HAR Dataset/test/X_test.txt"); dim(X_test)
X       <- rbind(X_train, X_test); dim(X)

Y_train <- read.table("UCI HAR Dataset/train/Y_train.txt"); dim(Y_train)
Y_test  <- read.table("UCI HAR Dataset/test/Y_test.txt"); dim(Y_test)
Y       <- rbind(Y_train, Y_test); dim(Y)

Subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt"); dim(Subject_train)
Subject_test  <- read.table("UCI HAR Dataset/test/subject_test.txt"); dim(Subject_test)
Subject       <- rbind(Subject_train, Subject_test); dim(Subject)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table("UCI HAR Dataset/features.txt"); dim(features)
head(features,3)

feaMeanSD <- grep("(mean|std)\\(\\)", features[, 2]); length(feaMeanSD)
head(feaMeanSD,10)

XMeanSD <- X[, feaMeanSD]; dim(XMeanSD)

# 3. Uses descriptive activity names to name the activities in the data set.
activity <- read.table("UCI HAR Dataset/activity_labels.txt"); dim(activity)
head(activity)

Y[, 1] = activity[Y[ , 1], 2]

# 4. Appropriately labels the data set with descriptive activity names.
names(Subject) <- "subject"
table(Subject)

names(Y) <- "activity"
table(Y)

names(XMeanSD) <- features[feaMeanSD, 2]
head(names(XMeanSD),3)

names(XMeanSD) <- gsub("[\\(\\)-]", "", names(XMeanSD))
head(names(XMeanSD),3)

names(XMeanSD) <- gsub("^f", "frequencyDomain", names(XMeanSD))
names(XMeanSD) <- gsub("^t", "timeDomain", names(XMeanSD))
names(XMeanSD) <- gsub("Acc", "Accelerometer", names(XMeanSD))
names(XMeanSD) <- gsub("Gyro", "Gyroscope", names(XMeanSD))
names(XMeanSD) <- gsub("Mag", "Magnitude", names(XMeanSD))
names(XMeanSD) <- gsub("Freq", "Frequency", names(XMeanSD))
names(XMeanSD) <- gsub("mean", "Mean", names(XMeanSD))
names(XMeanSD) <- gsub("std", "StandardDeviation", names(XMeanSD))

names(XMeanSD) <- gsub("BodyBody", "Body", names(XMeanSD))
head(names(XMeanSD))

tidy <- cbind(Subject, Y, XMeanSD); dim(tidy)
write.table(tidy, "tidy.txt", col.names = TRUE, row.names = FALSE, quote = FALSE)

# 5. Create a second, independent tidy set with the average of each variable for each activity and each subject
tidy.melt  <- melt(data = tidy, id = c("subject", "activity"))
tidy.mean  <- dcast(data = tidy.melt, subject + activity ~ variable, fun.aggregate = mean); dim(tidy.mean) 

write.table(tidy.mean, "tidy_mean.txt",  col.names = TRUE, row.names = FALSE, quote = FALSE)

