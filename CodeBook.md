# Getting and Cleaning Data Course Project CodeBook
This CodeBook describes the followed process to clean the data set provided for the Coursera's *Getting and Cleaning Data* Course Project.

## I) run_analysis.R 
### 1. Merge the test sets to create one data set.
To generate `run_analysis.R` script, the following data set files were needed:
* `subject_train.txt` - Contains the ID numbers [1-30] of the volunteers selected for training.
* `y_train.txt` - Numbers of the activities [1-6] carried out by the volunteers selected for training.
* `X_train.txt` - All the measurements corresponding to the volunteers selected for training.
* `subject_test.txt` - Contains the ID numbers [1-30] of the volunteers selected for testing.
* `y_test.txt` - Numbers of the activities [1-6] carried out by the volunteers selected for testing.
* `X_test.txt` - All the measurements corresponding to the volunteers selected for testing.
* `features.txt` - The names of the variables corresponding for each measurement.
* `activity_labels.txt` - The names for every activity carried out by the volunteers.

We started merging the training data and testing data as two separate data frames called `train_data` and `test_data`, respectively. Then we merged both data frames into a single one data set named `merged_data`.

### 2. Extract only the measurements on the mean and standard deviation for each measurement.
We used the `features.txt` file which contains the following variable names corresponding to `X_train.txt` and `X_test.txt` measurements:

These signals were used to estimate variables of the feature vector for each pattern:  
*-XYZ* is used to denote 3-axial signals in the *X*, *Y* and *Z* directions.
* `tBodyAcc-XYZ`
* `tGravityAcc-XYZ`
* `tBodyAccJerk-XYZ`
* `tBodyGyro-XYZ`
* `tBodyGyroJerk-XYZ`
* `tBodyAccMag`
* `tGravityAccMag`
* `tBodyAccJerkMag`
* `tBodyGyroMag`
* `tBodyGyroJerkMag`
* `fBodyAcc-XYZ`
* `fBodyAccJerk-XYZ`
* `fBodyGyro-XYZ`
* `fBodyAccMag`
* `fBodyAccJerkMag`
* `fBodyGyroMag`
* `fBodyGyroJerkMag`

The set of variables that were estimated from these signals were:
* `mean()` - Mean value
* `std()` - Standard deviation
* `mad()` - Median absolute deviation
* `max()` - Largest value in array
* `min()` - Smallest value in array
* `sma()` - Signal magnitude area
* `energy()` - Energy measure. Sum of the squares divided by the number of values
* `iqr()` - Interquartile range
* `entropy()` - Signal entropy
* `arCoeff()` - Autorregresion coefficients with Burg order equal to 4
* `correlation()` - Correlation coefficient between two signals
* `maxInds()` - index of the frequency component with largest magnitude
* `meanFreq()` - Weighted average of the frequency components to obtain a mean frequency
* `skewness()` - skewness of the frequency domain signals
* `kurtosis()` - kurtosis of the frequency domain signals
* `bandsEnergy()` - Energy of the frequency interval within the 64 bins of the FFT of each window
* `angle()` - Angle between to vectors

Using *grep()* function we subsetted the indexes whose observations correspond to `mean()` and `std()` variables and their respective signals. The resulting vector of indexes has been stored in `mean_std_indexes` variable. 

From `merged_data` data frame we subsetted the column indexes in `mean_std_variables` and changed the column names by the ones in the `features.txt` file.

The first two columns in `merged_data` got renamed as *Subject* and *Activity*, respectively, referring to the contents of `subject_train.txt`, `subject_test.txt`, `y_train.txt` and `y_test.txt`.

### 3. Use descriptive activity names to name the activities in the data set.
Using the `activity_labels.txt` file , we replaced the numbers of the *Activity* column in `merged_data` by the literal names of each activity.

### 4. Appropriately label the data set with descriptive variable names.
In `merged_data`, the following variable names are tags were changed:
* `t` tag was replaced by `Time`
* `f` tag was replaced by `Frequency`
* `()` parenthesis were replaced by the empty character `""`
* `-` dashes were replaced by dots `.`
* `Mag` was replaced by `Magnitude`
* `Acc` was replaced by `Accelerometer`
* `Gyro` was replaced by `Gyroscope`
* `std` was replaced by `Standard Deviation`

## II) tidy_data.txt

### 5. Create a second, independent tidy data set with the average of each variable name for each activity and each subject.
`group_by()` function from `dplyr` package was used to group `merged_data` by *Activity* and *Subject*. Then, we used the `summarise_all()` function to get the mean for each variable. There are thirty volunteers and six activities carried out by each one of them, so the resulting data set has 180 observations and the very same variables as `merged_data`. This new data set has been named `tidy_data`. 