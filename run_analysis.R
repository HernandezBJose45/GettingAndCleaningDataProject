## Read the data into R

features <- read.table("./UCI HAR Dataset/features.txt", 
                       col.names = c("n", "functions"))

X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", 
                      col.names = features$functions)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt",
                      col.names = "labels")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt",
                            col.names = "subject")

X_test <- read.table("./UCI HAR Dataset/test/X_test.txt",
                     col.names = features$functions)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt",
                      col.names = "labels")
subject_test <- read.table("./UCI HAR Dataset/test/y_test.txt",
                           col.names = "subject")

## Step 1: Merging the test and training datasets into one

train <- cbind(subject_train, y_train, X_train)
test <- cbind(subject_test, y_test, X_test)

Dataset <- rbind(train, test)

## Step 2: Extract only the mean and standard deviation measurements

instances <- grep("labels|subject|\\.mean\\.|\\.std\\.", names(Dataset))

Dataset <- Dataset[, instances]

## Step 3: Uses descriptive activity names to name the activities in the data set

activities <- read.table("./UCI HAR Dataset/activity_labels.txt",
                         col.names = c("code", "activity"))
Dataset$labels <- activities[Dataset$labels, 2]

## Step 4: Appropriately label the data set with descriptive variable names

names(Dataset) <- gsub("labels", "activity", names(Dataset))
names(Dataset) <- gsub("^tBody", "TimeBody", names(Dataset))
names(Dataset) <- gsub("^tGravity", "TimeGravity", names(Dataset))
names(Dataset) <- gsub("^(fBody|fBodyBody)", "FreqBody", names(Dataset))
names(Dataset) <- gsub("Acc", "Acceleration", names(Dataset))
names(Dataset) <- gsub("\\.mean\\.\\.\\.|\\.mean\\.\\.", "_Mean", names(Dataset))
names(Dataset) <- gsub("\\.std\\.\\.\\.|\\.std\\.\\.", "_STD", names(Dataset))

## Step 5: Create independent data set with the average of each variable for
## each activity and subject
library(dplyr)

SummaryData <- Dataset %>%
        group_by(subject, activity) %>%
        summarize_all(mean)

## Writing a text file from the previous data set created

write.table(SummaryData, "Step5.txt", row.names = FALSE)
