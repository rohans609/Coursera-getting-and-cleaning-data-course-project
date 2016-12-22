library(dplyr)

#Reading the train datasets
x_train <- read.table("train/X_train.txt",header=FALSE)
y_train <- read.table("train/y_train.txt",header=FALSE)
subject_train <- read.table("train/subject_train.txt",header=FALSE)

#Reading the test datasets
x_test <- read.table("test/X_test.txt",header=FALSE)
y_test <- read.table("test/y_test.txt",header=FALSE)
subject_test <- read.table("test/subject_test.txt",header=FALSE)

#Merging the training and test datasets
subject_data <- rbind(subject_train,subject_test)
y_data <- rbind(y_train,y_test)
x_data <- rbind(x_train,x_test)

#Reading the Features
features <- read.table("features.txt",header=FALSE)

#Extract only the measurements on the mean and standard deviation for each measurement
mean_std_measure <- grep("(.+)mean\\(\\)|(.+)std\\(\\)",features$V2)

#Subsetting the x_data based on mean_std_measure
x_data <- x_data[,mean_std_measure]

#Adding Column names to x_data
names(x_data) <- features[mean_std_measure,2]

#Reading the activites label
activities <- read.table("activity_labels.txt",header=FALSE)

#adding descriptive activity names to name the activities in the data set
y_data[, 1] <- activities[y_data[, 1], 2]

#adding column names to y_data and subject_data
names(y_data) <- "activity"
names(subject_data) <- "subject"

#Combining all the datasets to form a table
data <- cbind(x_data, y_data, subject_data)

#Calculating average of each variable for each activity and each subject
tidydata <- aggregate(.~subject+activity,data,mean)
tidydata <- arrange(tidydata,subject,activity)

#Writing the tidydata set to tidydata.txt
write.table(tidydata, file = "tidydata.txt",row.name=FALSE)