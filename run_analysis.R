activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
activity_labels[,2] <- as.character(activity_labels[,2])
measurement <- read.table("UCI HAR Dataset/ features.txt ")
measurement[,2] <- as.character(measurement[,2])
measurementRequired <- grep(".*mean.*|.*std.*", measurement[,2])#Extracts only the measurements on the mean and standard deviation for each measurement.

measurementRequired.names <- measurement[measurementRequired,2]
measurementRequired.names = gsub('-mean', 'Mean', measurementRequired.names)#replace all occurance of -mean with Mean
measurementRequired.names = gsub('-std', 'Std', measurementRequired.names)#replace all occurance of -std with Std
measurementRequired.names <- gsub('[-()]', '', measurementRequired.names)#replace all occurance of [-()] with null('')
train <- read.table("UCI HAR Dataset/train/X_train.txt")[measurementRequired]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train) #Merges the training  data sets.
test <- read.table("UCI HAR Dataset/test/X_test.txt")[measurementRequired]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)#Merges  the test data sets to create one data set.
combinedData <- rbind(train, test)#Merges the training and the test sets to create one data set.
colnames(combinedData) <- c("subject", "activity", measurementRequired.names)
combinedData$activity <- factor(combinedData$activity, levels = activity_labels[,1], labels = activity_labels[,2])
combinedData$subject <- as.factor(combinedData$subject)
combinedData.melted <- melt(combinedData, id = c("subject", "activity"))
combinedData.mean <- dcast(combinedData.melted, subject + activity ~ variable, mean)
write.table(combinedData.mean, "tidy.txt", row.names=FALSE, quote=FALSE, sep="\t")#Creates an independent tidy data set with the average of each variable for each activity and each subject.
tidy=read.csv("Tidy.txt",sep="\t",header=TRUE )
str(tidy)
