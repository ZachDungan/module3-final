# Getting and Cleaning Data Final Project

# Set working directory 
setwd("~/R/module3-final")

# Packages
library(dplyr)

# Create data frames
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

# 1. Merge the test and train data set together
train <- cbind(y_train, subject_train, x_train)
test <- cbind(y_test, subject_test, x_test)
data_full <- rbind(train, test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
data_mean_std <- data_full %>%
  select(subject, code, contains("mean"), contains("std"))

# 3. Uses descriptive activity names to name the activities in the data set
data_mean_std$code <- activities[data_mean_std$code, 2] 

# rename data frame 
df <- data_mean_std

# 4. Appropriately labels the data set with descriptive variable names. 
names(df)

names(df)[1] = "Subject"
names(df)[2] = "Activity Name"

names(df) <- gsub("Acc", "Accelerometer", names(df))
names(df) <- gsub("Gyro", "Gyroscope", names(df))
names(df) <- gsub("BodyBody", "Body", names(df))
names(df) <- gsub("Mag", "Magnitude", names(df))
names(df) <- gsub("^t", "Time", names(df))
names(df) <- gsub("^f", "Frequency", names(df))
names(df) <- gsub("tBody", "TimeBody", names(df))
names(df) <- gsub("-mean()", "Mean", names(df), ignore.case = TRUE)
names(df) <- gsub("-std()", "STD", names(df), ignore.case = TRUE)
names(df) <- gsub("-freq()", "Frequency", names(df), ignore.case = TRUE)
names(df) <- gsub("angle", "Angle", names(df))
names(df) <- gsub("gravity", "Gravity", names(df))

names(df)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

final_data <- df %>% 
  group_by(Subject, `Activity Name`) %>%
  summarise_all(mean)

write.table(final_data, "FinalData.txt", row.names = FALSE)