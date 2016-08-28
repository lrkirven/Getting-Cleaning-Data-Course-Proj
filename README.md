### Introduction

This is the final assignment of the Getting and Cleaning data course.  The purpose of this project is to demonstrate the ability to collect, work with, and clean a dataset. The goal is to prepare tidy data that can be used for later analysis. 

###  Executing of the targeted script

Run the 'run_analysis.R' script (preferably from R studio). The script will attempt to load the expected zipfile (getdata%2Fprojectfiles%2FUCI HAR Dataset.zip) from your current working directory.  The result should generate a 'run_analysis.txt' text file containing the resulting dataset  with the average of each variable for each activity and each subject from the Human Activity Recognition Using Smartphones Data Set.


###  Reload the resulting dataset back into R

data <- read.table("run_analysis.txt", header = TRUE)
View(data)

