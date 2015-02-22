---
title: "ReadME"
output: html_document
---

--
Contained Files
--
  1. run_analysis.R - an R script that processes observational data collected from Samsung Galaxy S accelerometers and        creates a new dataset representing variable averages per subject-activity pair from a small subset of the original data. (see below for more detail)
  2. cleaningDataCourseProject.txt - a tidy dataset, the output of run_analysis.R
  2. CodeBook.MD - a detailed explanation of the variables and features of the dataset "cleaningDataCourseProject.txt". Also contained is an explanation of the original dataset.
  3. ReadME.MD - this file

--
Run_Analysis.R
--
This script starts with the assumption that the Samsung data is available in the working directory in an unzipped folder labeled "UCI HAR Dataset".

-
Step 1-Assembling Test and Train
-
The script assembles the test and training data (located in the "test" and "train" subfolders) by column binding the respective X,Y and Subject files. The rows of the "features.txt" file are employed as the column labels for the X file.

Through the use of an inner join, the activity ids (marked by an integer between 1 and 6) are replaced with string descriptors from the "activity_labels.txt" file.

-
Step 2-Unification and data selection
-
The two datasets are now joined through row-binding, and all observational values not containing measurements of mean or standard deviation are filtered out through the creation of an index (using a textual search in the column labels):
```{r}
##We pull only our relevant columns, i.e. the variables we wish to group by and all variables containing means or standard deviations
mean_std_index <- grep("std|mean|subject|activity", colnames(combined_data_set) , perl=TRUE, ignore.case=TRUE)

##Filtering out the redundant activity.label column
mean_std_dataset <- select(combined_data_set[,mean_std_index],-activity.label)
```

-
Step 3- Grouping, mean calculation, and output
-
Finally, we group the resulting dataset by activity and subject id, and calculate the mean of each variable for this subject.id-activity pair.

The resulting output is written to the "cleaningDataCourseProject.txt" file.