##################
# Load Libraries #
##################
library(dplyr)
library(data.table)

#########################
# Set general variables #
#########################
dataDir = "./data"
url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
fileName = "DataSet.zip"
filePath = paste(dataDir,"/",fileName,sep = "")

testSetLocation = paste(dataDir,"/UCI HAR Dataset/test/X_test.txt",sep = "")
subjectTestSetLocation = paste(dataDir,"/UCI HAR Dataset/test/subject_test.txt",sep = "")
labelTestSetLocation = paste(dataDir,"/UCI HAR Dataset/test/y_test.txt",sep = "")

trainingSetLocation = paste(dataDir,"/UCI HAR Dataset/train/X_train.txt",sep = "")
subjectTainingSetLocation = paste(dataDir,"/UCI HAR Dataset/train/subject_train.txt",sep = "")
labelTainingSetLocation = paste(dataDir,"/UCI HAR Dataset/train/y_train.txt",sep = "")

featuresLocation = paste(dataDir,"/UCI HAR Dataset/features.txt",sep = "")
activityLabelsLocation = paste(dataDir,"/UCI HAR Dataset/activity_labels.txt",sep = "")

subSetFileName = "Step5Subset.txt"

###################################
# Create data directory if needed #
###################################
if (!file.exists(dataDir)) {
  dir.create(file.path(dataDir))
}

#################
# Doenload data #
#################
download.file(url = url,destfile = filePath)

unzip(zipfile = filePath,overwrite = TRUE,exdir = dataDir)

#############
# Load data #
#############
trainingSet <- fread(trainingSetLocation,header = FALSE)
subjectTrainingSet <- fread(subjectTainingSetLocation,header = FALSE)
labelTrainingSet <- fread(labelTainingSetLocation,header = FALSE)

testSet <- fread(testSetLocation,header = FALSE)
subjectTestSet <- fread(subjectTestSetLocation,header = FALSE)
labelTestSet <- fread(labelTestSetLocation,header = FALSE)

featuresSet <- fread(featuresLocation,header = FALSE, sep = " ")
activityLabels <- fread(activityLabelsLocation, header = FALSE)

##############
# Set labels #
##############

`names<-`(subjectTestSet,c("Subject"))
`names<-`(subjectTrainingSet,c("Subject"))

`names<-`(labelTestSet,c("Label.ID"))
`names<-`(labelTrainingSet,c("Label.ID"))

`names<-`(activityLabels,c("Label.ID","Label.Name"))

`names<-`(testSet,featuresSet$V2)
`names<-`(trainingSet,featuresSet$V2)


##############
# Merge data #
##############

labelTestSetMerged <- join(labelTestSet,activityLabels)
labelTrainingSetMerged <- join(labelTrainingSet,activityLabels)

fullTestSet <- cbind(subjectTestSet,labelTestSetMerged,testSet)
fullTrainingSet <- cbind(subjectTrainingSet,labelTrainingSetMerged,trainingSet)

completeSet <- tbl_df(rbind(fullTrainingSet,fullTestSet))

colIndex <- c(1,3,which(grepl("mean\\(\\)|std\\(\\)",colnames(completeSet))))

subSet <- completeSet[,colIndex]

subSet2 <- subSet %>% group_by(Subject,Label.Name) %>% summarise_each(funs(mean))

# Write subSet2 #

write.table(subSet2,row.names = FALSE,file = subSetFileName)
