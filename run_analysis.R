library(data.table)
library(reshape2)

setwd("C:/Users/ax25918/Desktop/Trainning/Coursera/Getting_and_Cleaning_Data/Week 4")

# Activity Labels
Activity_labels = fread("./UCI HAR Dataset/activity_labels.txt")
labels_Activity = data.table(c("Numero","Activity"))
names(Activity_labels) = labels_Activity$V1

#List of all features
features_X = fread("./UCI HAR Dataset/features.txt")
features_Y = data.table("562","activity")
features_subject = data.table("563","Subject")
features = rbind(features_X, features_Y, features_subject)

#clean Variables
rm(features_X)
rm(features_Y)
rm(features_subject)
gc()

#1 Merges the training and the test sets to create one data set.
subject_train = fread("./UCI HAR Dataset/train/subject_train.txt")
x_train = fread("./UCI HAR Dataset/train/X_train.txt")
y_train = fread("./UCI HAR Dataset/train/y_train.txt")
names(y_train) = "V562"
names(subject_train) = "V563"
train_data = cbind(x_train,y_train, subject_train)

subject_test = fread("./UCI HAR Dataset/test/subject_test.txt")
x_test = fread("./UCI HAR Dataset/test/X_test.txt")
y_test = fread("./UCI HAR Dataset/test/y_test.txt")
names(y_test) = "V562"
names(subject_test) = "V563"
test_data = cbind(x_test,y_test, subject_test)

Total_data = rbind(train_data,test_data)

#clean Variables
rm(x_train)
rm(x_test)
rm(y_train)
rm(y_test)
rm(subject_train)
rm(subject_test)
rm(train_data)
rm(test_data)
gc()

#2 Extracts only the measurements on the mean and standard deviation for each measurement.
Posiciones = grep("mean|std",features$V2)

# When with=FALSE j is a character vector of column names or a numeric vector of column positions to select, and the value returned is always a data.table. with=FALSE is often useful in data.table to select columns dynamically.  
Datos_Mean_Std = Total_data[,Posiciones,,,with=FALSE]

#names(Total_data)
#3 Uses descriptive activity names to name the activities in the data set
setkey(Total_data, V562)
setkey(Activity_labels, Numero)
Total_data = Total_data[Activity_labels]

#4 Appropriately labels the data set with descriptive variable names.
features = rbind(features,data.table("564","Activity_name"))
names(Total_data) = features$V2

#Total_data$Activity_name  <- Correct

#5 From the data set in step 4, creates a second, independent tidy data 
# set with the average of each variable for each activity and each subject.
second_tidy <- data.table(melt(Total_data, id.vars = c("Activity_name", "activity", "Subject")))
New_tidy_Data = second_tidy[,mean(value), by=list(variable,Activity_name, Subject)]

New_tidy_Data = as.data.frame.array(New_tidy_Data)

write.table(New_tidy_Data , "NewtidyData.txt",sep = ",", row.name=FALSE)








