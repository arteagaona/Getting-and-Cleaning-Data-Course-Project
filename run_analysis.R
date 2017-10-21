#1. Merge the training and the test sets to create one data set.
#1.1 Downloading and unzipping the data ZIP file...
if(!file.exists("./data")){dir.create("./data")}
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "./data/project.zip")
unzip("./data/project.zip", exdir = "./data")

library(dplyr)

#1.2 Reading the necessary files for our project...

#Loading the training data (volunteer's ID number, activities and measurements)
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")

#Loading the test data (volunteer's ID number, activities and measurements)
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")

#1.3 Merging training data...

#We use str() function to check out the characteristics of each data frame
str(subject_train)
str(y_train)
str(x_train)

#From above we can observe there are 7352 observations in each data frame.
#So we are going to combine the three data frames in a column-wise fashion.
train_data <- cbind(subject_train, y_train, x_train)

#1.4 Merging test data...(same as 1.3)
str(subject_test)
str(y_test)
str(x_test)

#We can observe there are 2947 observations in each data frame.
#We combine them using cbind() function.
test_data <- cbind(subject_test, y_test, x_test)

#1.5 Merging train_data and test_data...
#checking both data frames characteristics...
str(train_data)
str(test_data)

#Each data frame has exactly the same 563 variables, so we can merge them
# in a row-wise fashion using rbind().
merged_data <- rbind(train_data, test_data)

#----------------------------------------------------------------------------------------

#2. Extract only the measurements on the mean and standard deviation for each measurement

#2.1 We load the features.txt file. This file contains the variable names for
#x_train and x_test.
features <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)

#2.2 We extract the indexes of those variables referring to mean and standard deviation measures.
#Note that we add a vector of 2's, because we have two additional columns in merged_data...
#... which are the first two columns -one referring to the volunteers's number ID and the...
#... latter referring to the activity each volunteer carried out-.
mean_std_indexes <- grep("mean\\(\\)|std\\(\\)", features$V2) + 2

#2.3 Subsetting the desired columns.
merged_data <- merged_data[,c(1,2,mean_std_indexes)]

#2.4 We change the current variable names for the ones in features.txt file.
#The first two columns refer to Subject and Activity, respectively.
colnames(merged_data) <- c("Subject", "Activity", features$V2[mean_std_indexes - 2])

#--------------------------------------------------------------------------------------------

#3. Use descriptive activity names to name the activities in the data set.

#3.1 We load the activity_labels.txt file which contains the names of every activity carried out.
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)

#3.2 We change the contents of the Activity variable replacing the activity number for its name.
for(i in 1:length(merged_data$Activity)) {
   merged_data$Activity[i] <- activity_labels$V2[which(merged_data$Activity[i] == activity_labels$V1)]
}

#--------------------------------------------------------------------------------------------

#4. Appropriately label the data set with descriptive variable names.
names(merged_data) <- gsub("^t", "Time", names(merged_data))
names(merged_data) <- gsub("^f", "Frequency", names(merged_data))
names(merged_data) <- gsub("\\(", "", names(merged_data)) #Removing parenthesis
names(merged_data) <- gsub("\\)", "", names(merged_data)) #Removing parenthesis
names(merged_data) <- gsub("-","\\.", names(merged_data)) #Replacing dashes with dots
names(merged_data) <- gsub("Mag", "Magnitude", names(merged_data))
names(merged_data) <- gsub("Acc", "Accelerometer", names(merged_data))
names(merged_data) <- gsub("Gyro", "Gyroscope", names(merged_data))
names(merged_data) <- gsub("std", "Standard", names(merged_data))

#--------------------------------------------------------------------------------------------

#5. From the data set in step 4, creates a second, independent tidy data set with the average 
#... of each variable for each activity and each subject.

#Using the dplyr package, we grouped merged_data dataframe by Subject and Activity
#Then we use summarise_all function to calculate the average for every variable
# and so creating a new tidy data set.
tidy_data <- tbl_df(merged_data) %>% group_by(Subject, Activity) %>% summarise_all(funs(mean))

#Saving as a text file
write.table(tidy_data, "./data/tidy_data.txt", row.names = FALSE)