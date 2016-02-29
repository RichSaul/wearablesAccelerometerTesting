# set general project folder
projectDir = getwd()

# set root dataset folder within the project
# set up file references for files in the root dataset folder
datasetDir        = paste(projectDir, "/UCI HAR Dataset/", sep = "")
activityLabelFile = paste(datasetDir, "activity_labels.txt", sep = "")
activityLabels    = read.delim(activityLabelFile, header = FALSE, sep = " ", col.names = c("ActivityNumber","ActivityName"))
featuresFile      = paste(datasetDir, "features.txt", sep = "")
features          = read.delim(featuresFile, header = FALSE, sep = "", col.names = c("FeatureNumber","FeatureName"))
varNames          = features[, 2]
# clean up varNames before importing data, dplyr has problems with () and - in data frame
# column headers, this set of steps is just UGLY!
varNames = sub("\\(", "", varNames)
varNames = sub("\\)", "", varNames)
varNames = sub("\\)", "", varNames)
varNames = sub("mean", "Mean", varNames)
varNames = sub("std", "STD", varNames)
varNames = sub("-", "_", varNames)
varNames = sub("-", "_", varNames)
varNames = sub(",", "",varNames)

# set folder for test data within the dataset
# set up file references for files in the test set
testDir            = paste(datasetDir, "test/", sep = "")
testSubjectsFile   = paste(testDir, "subject_test.txt", sep = "")
testSubjects       = read.delim(testSubjectsFile, header = FALSE, sep = " ", col.names = c("Subject"))
testActivitiesFile = paste(testDir, "y_test.txt", sep = "")
testActivities     = read.delim(testActivitiesFile, header = FALSE, sep = " ", col.names = c("ActivityNumber"))
testDataFile       = paste(testDir, "X_test.txt", sep = "")
testData           = read.delim(testDataFile, header = FALSE, sep = "", col.names = varNames, check.names = FALSE)

# set folder for training data within the dataset
# set up file references for files in the training set
trainDir            = paste(datasetDir, "train/", sep = "")
trainSubjectsFile   = paste(trainDir, "subject_train.txt", sep = "")
trainSubjects       = read.delim(trainSubjectsFile, header = FALSE, sep = " ", col.names = c("Subject"))
trainActivitiesFile = paste(trainDir, "y_train.txt", sep = "")
trainActivities     = read.delim(trainActivitiesFile, header = FALSE, sep = " ", col.names = c("ActivityNumber"))
trainDataFile       = paste(trainDir, "X_train.txt", sep = "")
trainData           = read.delim(trainDataFile, header = FALSE, sep = "", col.names = varNames, check.names = FALSE)

# create new data frames merging the activities and subjects
ActivityName = activityLabels$ActivityName[match(testActivities$ActivityNumber, activityLabels$ActivityNumber)]
joinedTestData = cbind(testSubjects, ActivityName, testData)
ActivityName = activityLabels$ActivityName[match(trainActivities$ActivityNumber, activityLabels$ActivityNumber)]
joinedTrainData = cbind(trainSubjects, ActivityName, trainData)

# create a data frame that now includes both the test and train data sets
fullData = rbind(joinedTestData, joinedTrainData)

# create subset of data that has Subject, Activity, Mean, and STD for each of the 33 variables
regexStr = "-mean\\(\\)|-std\\(\\)"
cols = subset(features, grepl(regexStr,features$FeatureName))
dataCols = cols[[1]]
dataCols = dataCols + 2  # adjust to add labelCols, which features doesn't contain
labelCols = c(1,2)
colsNeeded = append(labelCols, dataCols)
stepFourData = fullData[, colsNeeded]

# export the intermediate Step 4 data set
# this is the data set referred to in step 5 of the assignment as the "data set in step 4" and 
# has all of the characteristics required at the end of step 4.
stepFourFile   = paste(projectDir, "/intermediate-StepFourDataSet.csv", sep = "")
write.csv(stepFourData, stepFourFile, row.names = FALSE)

# setup creation of final tidy data set, we haven't needed dplyr until now...
library(dplyr)
groupBySubject = group_by(stepFourData, Subject, ActivityName)

# create summarized final data set
summaryData = summarize(groupBySubject, 
    mean_tBodyAcc_Mean_X = mean(tBodyAcc_Mean_X),
    mean_tBodyAcc_Mean_Y = mean(tBodyAcc_Mean_Y),
    mean_tBodyAcc_Mean_Z = mean(tBodyAcc_Mean_Z),
    mean_tBodyAcc_STD_X = mean(tBodyAcc_STD_X),
    mean_tBodyAcc_STD_Y = mean(tBodyAcc_STD_Y),
    mean_tBodyAcc_STD_Z = mean(tBodyAcc_STD_Z),
    mean_tGravityAcc_Mean_X = mean(tGravityAcc_Mean_X),
    mean_tGravityAcc_Mean_Y = mean(tGravityAcc_Mean_Y),
    mean_tGravityAcc_Mean_Z = mean(tGravityAcc_Mean_Z),
    mean_tGravityAcc_STD_X = mean(tGravityAcc_STD_X),
    mean_tGravityAcc_STD_Y = mean(tGravityAcc_STD_Y),
    mean_tGravityAcc_STD_Z = mean(tGravityAcc_STD_Z),
    mean_tBodyAccJerk_Mean_X = mean(tBodyAccJerk_Mean_X),
    mean_tBodyAccJerk_Mean_Y = mean(tBodyAccJerk_Mean_Y),
    mean_tBodyAccJerk_Mean_Z = mean(tBodyAccJerk_Mean_Z),
    mean_tBodyAccJerk_STD_X = mean(tBodyAccJerk_STD_X),
    mean_tBodyAccJerk_STD_Y = mean(tBodyAccJerk_STD_Y),
    mean_tBodyAccJerk_STD_Z = mean(tBodyAccJerk_STD_Z),
    mean_tBodyGyro_Mean_X = mean(tBodyGyro_Mean_X),
    mean_tBodyGyro_Mean_Y = mean(tBodyGyro_Mean_Y),
    mean_tBodyGyro_Mean_Z = mean(tBodyGyro_Mean_Z),
    mean_tBodyGyro_STD_X = mean(tBodyGyro_STD_X),
    mean_tBodyGyro_STD_Y = mean(tBodyGyro_STD_Y),
    mean_tBodyGyro_STD_Z = mean(tBodyGyro_STD_Z),
    mean_tBodyGyroJerk_Mean_X = mean(tBodyGyroJerk_Mean_X),
    mean_tBodyGyroJerk_Mean_Y = mean(tBodyGyroJerk_Mean_Y),
    mean_tBodyGyroJerk_Mean_Z = mean(tBodyGyroJerk_Mean_Z),
    mean_tBodyGyroJerk_STD_X = mean(tBodyGyroJerk_STD_X),
    mean_tBodyGyroJerk_STD_Y = mean(tBodyGyroJerk_STD_Y),
    mean_tBodyGyroJerk_STD_Z = mean(tBodyGyroJerk_STD_Z),
    mean_tBodyAccMag_Mean = mean(tBodyAccMag_Mean),
    mean_tBodyAccMag_STD = mean(tBodyAccMag_STD),
    mean_tGravityAccMag_Mean = mean(tGravityAccMag_Mean),
    mean_tGravityAccMag_STD = mean(tGravityAccMag_STD),
    mean_tBodyAccJerkMag_Mean = mean(tBodyAccJerkMag_Mean),
    mean_tBodyAccJerkMag_STD = mean(tBodyAccJerkMag_STD),
    mean_tBodyGyroMag_Mean = mean(tBodyGyroMag_Mean),
    mean_tBodyGyroMag_STD = mean(tBodyGyroMag_STD),
    mean_tBodyGyroJerkMag_Mean = mean(tBodyGyroJerkMag_Mean),
    mean_tBodyGyroJerkMag_STD = mean(tBodyGyroJerkMag_STD),
    mean_fBodyAcc_Mean_X = mean(fBodyAcc_Mean_X),
    mean_fBodyAcc_Mean_Y = mean(fBodyAcc_Mean_Y),
    mean_fBodyAcc_Mean_Z = mean(fBodyAcc_Mean_Z),
    mean_fBodyAcc_STD_X = mean(fBodyAcc_STD_X),
    mean_fBodyAcc_STD_Y = mean(fBodyAcc_STD_Y),
    mean_fBodyAcc_STD_Z = mean(fBodyAcc_STD_Z),
    mean_fBodyAccJerk_Mean_X = mean(fBodyAccJerk_Mean_X),
    mean_fBodyAccJerk_Mean_Y = mean(fBodyAccJerk_Mean_Y),
    mean_fBodyAccJerk_Mean_Z = mean(fBodyAccJerk_Mean_Z),
    mean_fBodyAccJerk_STD_X = mean(fBodyAccJerk_STD_X),
    mean_fBodyAccJerk_STD_Y = mean(fBodyAccJerk_STD_Y),
    mean_fBodyAccJerk_STD_Z = mean(fBodyAccJerk_STD_Z),
    mean_fBodyGyro_Mean_X = mean(fBodyGyro_Mean_X),
    mean_fBodyGyro_Mean_Y = mean(fBodyGyro_Mean_Y),
    mean_fBodyGyro_Mean_Z = mean(fBodyGyro_Mean_Z),
    mean_fBodyGyro_STD_X = mean(fBodyGyro_STD_X),
    mean_fBodyGyro_STD_Y = mean(fBodyGyro_STD_Y),
    mean_fBodyGyro_STD_Z = mean(fBodyGyro_STD_Z),
    mean_fBodyAccMag_Mean = mean(fBodyAccMag_Mean),
    mean_fBodyAccMag_STD = mean(fBodyAccMag_STD),
    mean_fBodyBodyAccJerkMag_Mean = mean(fBodyBodyAccJerkMag_Mean),
    mean_fBodyBodyAccJerkMag_STD = mean(fBodyBodyAccJerkMag_STD),
    mean_fBodyBodyGyroMag_Mean = mean(fBodyBodyGyroMag_Mean),
    mean_fBodyBodyGyroMag_STD = mean(fBodyBodyGyroMag_STD),
    mean_fBodyBodyGyroJerkMag_Mean = mean(fBodyBodyGyroJerkMag_Mean),
    mean_fBodyBodyGyroJerkMag_STD = mean(fBodyBodyGyroJerkMag_STD))

# output final summarized data set, damn tidy enough!
summaryDataFile = paste(projectDir, "/final-IndependentDataSet.txt", sep = "")
write.table(summaryData, summaryDataFile, row.names = FALSE)
