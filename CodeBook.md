### Getting and Cleaning Data Course Project CodeBook

This file describes the variables, the data, and any transformations or work that was performed to clean up the data from the Human Activity Recognition Using Smartphones Data Set.

### Details

Data sources documentation:
 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones      

Data source:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  

* The 'run_analysis.R' script performs the following steps:

(1) Reads the expected input zipfile (getdata%2Fprojectfiles%2FUCI HAR Dataset.zip) into a temporary directory.
(2) Reads the following files from the tempoaray directory: 
    (a) subject_train.txt (b) activity_labels.txt (c) X_train.txt (d) y_train.txt (e) subject_test.txt (f) X_test.txt (g) y_test.txt
(3) Filtered measure varaibles to only include variables that have "std()" and "mean()" designation. The name of this result set was called features, which contained 66 items.

(4) Loads training data into a final dplyr table called 'train_t'
(5) Loads testing data into a final dplyr table called 'test_t'
(6) Then, the two above tables are unioned into one final table called 'merged_train_t'

(7) Groups this 'merged_train_t' by subject and activity and calculates the mean for the all of the mean and standard deviation columns.
(8) Writes final dataset to a file called 'run_analysis.txt'.


    
     
