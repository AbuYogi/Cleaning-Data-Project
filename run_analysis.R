library(dplyr)
library(reshape2)


##Loading in the activity labels and features files. The features files contains the column names for the X files
activity_labels <- read.delim("UCI HAR Dataset/activity_labels.txt",sep=" ",col.names = c("id","activity"), header = FALSE)
features <- read.delim("UCI HAR Dataset/features.txt",sep= " ", header = FALSE)

##Loading in the test files and placing them togther (they have the identical number of rows , so we just bind by column)
x_test <- read.delim("UCI HAR Dataset/test/x_test.txt",sep="", col.names = features[,2],header = FALSE)
y_test <- read.delim("UCI HAR Dataset/test/y_test.txt",sep="", col.names = c("activity.label"),header = FALSE)
subject_test<- read.delim("UCI HAR Dataset/test/subject_test.txt",sep="", col.names = c("subject.id"),header = FALSE)
##bringing it all together
test_temp <- cbind (subject_test,y_test,x_test)
##joining with the activity labels tabel to insert the name of the activity each measurement is taken on
test_full <- inner_join(test_temp,activity_labels,by = c("activity.label"= "id"))

##Loading in the training files and placing them togther (they have the identical number of rows , so we just bind by column)
x_train <- read.delim("UCI HAR Dataset/train/x_train.txt",sep="", col.names = features[,2],header = FALSE)
y_train <- read.delim("UCI HAR Dataset/train/y_train.txt",sep="", col.names = c("activity.label"), header = FALSE)
subject_train<- read.delim("UCI HAR Dataset/train/subject_train.txt",sep="", col.names = c("subject.id"),header = FALSE)
##bringing it all together
train_temp <- cbind (subject_train,y_train,x_train)
##joining with the activity labels tabel to insert the name of the activity each measurement is taken on
train_full <- inner_join(train_temp,activity_labels,by = c("activity.label"= "id"))

##Here we unite the two data sets by placing one after the other
combined_data_set <- rbind(test_full,train_full)

##We pull only our relevant columns, i.e. the variables we wish to group by and all variables containing means or standard deviations
mean_std_index <- grep("std|mean|subject|activity", colnames(combined_data_set) , perl=TRUE, ignore.case=TRUE)

##Filtering out the redundant activity.label column
mean_std_dataset <- select(combined_data_set[,mean_std_index],-activity.label)

##Converting the subject.id from an integer to a factor to ensure proper grouping
mean_std_dataset$subject.id<-as.factor(mean_std_dataset$subject.id)

##Here we group by activity and subject and return a mean for every other variable
grouped_dataset <- mean_std_dataset %>% group_by(activity,subject.id) %>% summarise_each(funs(mean))

##Our output
write.table(grouped_dataset,"cleaningDataCourseProject.txt", row.names=FALSE )