#Wearables Accelerometer Testing - README.md file

There are six files in this repository:

    - run_analysis.R

    - clearMemory.R

    - intermediate-StepFourDataSet.csv

    - final-IndependentDataSet.txt

    - CodeBook.md

    - README.md

The run_analysis.R file starts with the UCI HAR data set's raw files.  It loads the features (column names), activity names, test data set, and train data set into R memory space.  The script merges the test and train data sets, then creates a subset that includes only columns related to mean() and std().  At this point, the script creates and exports the intermediate-StepFourDataSet.csv file.  Then the script summarizes the variables in the step four data set by subject and activity and writes this into the final-IndependentDataSet.txt final.

The clearMemory.R file simply removes every variable created by run_analysis.R, allowing a fresh run without any existing information getting in the way.

The intermediate-StepFourDataSet.csv file is the data at the state it needs to be before starting step five of the assignment.  It may not have been necessary to export this data, but the instructions were not entirely clear in this regard.

The final-IndependentDataSet.txt file is the final, summarized version of the data that has a mean() for every mean() and std() variable reported in the original UCI HAR data set.  There is one row for each combination of subject and activity.

CodeBook.md describes the variables in the final-IndependentDataSet.txt and intermediate-StepFourDataSet.csv files. 

README.md is this file.
