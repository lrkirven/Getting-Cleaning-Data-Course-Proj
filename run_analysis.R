library(dplyr)

# A function to tidy feature names
mygsub <- function(pattern, replacement, x, ...) {
  if (length(pattern)!=length(replacement)) {
    stop("pattern and replacement does not have the same length.")
  }
  result <- x
  for (i in 1:length(pattern)) {
    result <- gsub(pattern[i], replacement[i], result, ...)
  }
  result
}

zipfile <- "getdata%2Fprojectfiles%2FUCI HAR Dataset.zip"
# temp path to access zipfile
tmpdir <- tempdir()
fns <- unzip(zipfile, junkpaths = TRUE, exdir = tmpdir)
rowCounts <- 1:7352

# 561 features
feasuresFile <- grep("/features.txt", fns, value = TRUE)
featuresDF <- read.csv(feasuresFile, header = FALSE, sep = " ", col.names = c("featureid", "featuredescription"))
featureIndices <- grep("mean\\(\\)|std\\(\\)", featuresDF$featuredescription)
features <- grep("mean\\(\\)|std\\(\\)", featuresDF$featuredescription, value = TRUE)
features <- mygsub(c(",","-","\\)","\\("), c("","","",""), features)
features <- tolower(features)

# 1 WALKING -- 2 WALKING_UPSTAIRS -- 3 WALKING_DOWNSTAIRS -- 4 SITTING -- 5 STANDING -- 6 LAYING
activityLabelFile <- grep("/activity_labels.txt", fns, value = TRUE)
activityDF <- read.csv(activityLabelFile, header = FALSE, sep = " ", col.names = c("activityid", "activitydescription"))
activity_t <- tbl_df(activityDF)

# Load train data

# 7352 rows
trainSubjectFile <- grep("/subject_train.txt", fns, value = TRUE)
trainSubjectDF <- read.table(trainSubjectFile, header = FALSE, col.names = c("subjectid"))
trainSubject_t <- tbl_df(trainSubjectDF)
trainSubject_t <- mutate(trainSubject_t, window = row_number())

# 7352 rows, 561 columns
xTrainFile <- grep("/X_train.txt", fns, value = TRUE)
xTrainDF <- read.table(xTrainFile, header = FALSE)
xTrainDF <- select(xTrainDF, featureIndices)
colnames(xTrainDF) <- features
xTrain_t <- tbl_df(xTrainDF)
xTrain_t <- mutate(xTrain_t, window = row_number())

# 7352 rows
yTrainFile <- grep("/y_train.txt", fns, value = TRUE)
yTrainDF <- read.table(yTrainFile, header = FALSE, col.names = c("activityid"))
yTrain_t <- tbl_df(yTrainDF)
yTrain_t <- mutate(yTrain_t, window = row_number())

# joined table
train_t <- inner_join(xTrain_t, yTrain_t, by = "window")
train_t <- inner_join(train_t, trainSubject_t, by = "window")
train_t <- inner_join(train_t, activity_t, by = "activityid")

# Load test data

# 2947 rows
testSubjectFile <- grep("/subject_test.txt", fns, value = TRUE)
testSubjectDF <- read.table(testSubjectFile, header = FALSE, col.names = c("subjectid"))
testSubject_t <- tbl_df(testSubjectDF)
testSubject_t <- mutate(testSubject_t, window = row_number())

# 2947 rows; 561 columns
xTestFile <- grep("/X_test.txt", fns, value = TRUE)
xTestDF <- read.table(xTestFile, header = FALSE)
xTestDF <- select(xTestDF, featureIndices)
colnames(xTestDF) <- features
xTest_t <- tbl_df(xTestDF)
xTest_t <- mutate(xTest_t, window = row_number())

# 2947 rows
yTestFile <- grep("/y_test.txt", fns, value = TRUE)
yTestDF <- read.table(yTestFile, header = FALSE, col.names = c("activityid"))
yTest_t <- tbl_df(yTestDF)
yTest_t <- mutate(yTest_t, window = row_number())

# joined table
test_t <- inner_join(xTest_t, yTest_t, by = "window")
test_t <- inner_join(test_t, testSubject_t, by = "window")
test_t <- inner_join(test_t, activity_t, by = "activityid")

# merged table
test_t <- select(test_t, contains("subjectid"), contains("activitydescription"), contains("mean"), contains("std"))
train_t <- select(train_t, contains("subjectid"), contains("activitydescription"), contains("mean"), contains("std"))
merged_train_t <- bind_rows(train_t, test_t)

by_activity_n_subject <- group_by(merged_train_t, subjectid, activitydescription)
res <- summarise_each(by_activity_n_subject, funs(mean), contains("mean"), contains("std"))
write.table(res, "run_analysis.txt", row.name=FALSE) 

# clean up
unlink(tmpdir, recursive = TRUE, force = TRUE)



