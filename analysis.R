setwd("C:/Users/Master/Documents/Coursera/Data_Science/3Getting_and_Cleaning_Data/Project/My_solution")
train = read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
train[,562] = read.csv("UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)
train[,563] = read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)

test = read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
test[,562] = read.csv("UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
test[,563] = read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)

activityLabels = read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)

# Read features and substitute names
features = read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)
features[,2] = gsub('-mean', 'Mean', features[,2])
features[,2] = gsub('-std', 'Std', features[,2])
features[,2] = gsub('[-()]', '', features[,2])

# Merge training and test
fulldata = rbind(train, test)

# Get only the data on mean and std. dev.
relCols <- grep(".*Mean.*|.*Std.*", features[,2])
features <- features[relCols,]
# Now add the last two columns (subject and activity)
relCols <- c(relCols, 562, 563)
fulldata <- fulldata[,relCols]
# Add the column names (features) to fulldata
colnames(fulldata) <- c(features$V2, "Activity", "Subject")
colnames(fulldata) <- tolower(colnames(fulldata))

currentActivity = 1
for (currentActivityLabel in activityLabels$V2) {
    fulldata$activity <- gsub(currentActivity, currentActivityLabel, fulldata$activity)
    currentActivity <- currentActivity + 1
}

fulldata$activity <- as.factor(fulldata$activity)
fulldata$subject <- as.factor(fulldata$subject)

tidy = aggregate(fulldata, by=list(activity = fulldata$activity, subject=fulldata$subject), mean)
tidy[,90] = NULL
tidy[,89] = NULL
write.table(tidy, "tidy.txt", sep="\t")