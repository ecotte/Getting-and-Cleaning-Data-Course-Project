# Getting-and-Cleaning-Data-Course-Project

For this project we use the data from the accelerometers from the Samsung Galaxy S smartphone.

	For more information about the Data go to:
		http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

	The original data can be found here:
		https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Scripts

The run_analysis.R contains all the step needed to download an process the data to create a sub set containing the average of each reading grouped be each activity and subject.

## Libraries

The libraries used where:

-dplyr
-data.table

## Script steps

1. Download original data
2. Load all the data needed
3. Set the labels for each column
4. Merge all the data in a single data set
5. Select only the mean and standar deviation readings
6. Group get the average of each reading grouped by Subject and Label name