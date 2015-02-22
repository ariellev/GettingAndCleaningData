Feb 21 st, 2015  
Getting and cleaning data   
Johns Hopkins University   
Cousera

Ariel Lev
<br/>
<br/>
<br/>
#HUMAN ACTIVITY RECOGNITION USING SMARTPHONE
<br/>
##DATA COLLECTION DESCRIPTION
<br/>

  _if you are familiar with the experiment you may skip this phase and start at_ [CLEANING THE DATA](https://github.com/ariellev/GettingAndCleaningData/blob/master/CodeBook.md#cleaning-the-data)
<br/>

###EXPERIMENT

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. 
Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) 
wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, 
we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. 
The experiments have been video-recorded to label the data manually. 
The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for 
generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in 
fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). 
The sensor acceleration signal, which has gravitational and body motion components, 
was separated using a Butterworth low-pass filter into body acceleration and gravity. 
The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency 
was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. 
See 'features_info.txt' for more details.

<br/>
###FEATURES

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. 
These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. 
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency 
of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration 
signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz.

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals 
(tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were 
calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).
Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, 
fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to 
indicate frequency domain signals).
These signals were used to estimate variables of the feature vector for each pattern:'-XYZ' 
is used to denote 3-axial signals in the X, Y and Z directions.

<br/>
###CLEANING THE DATA

The raw data as received was distributed among several files (features, activities, data). I combined this data all together into a single data set, by: 

1.	Merging train and test data together to have all observations in one place.
2.	Applying activity labels in order to increase readability.
3.	Sub-setting the raw feature set so it contains only the mean and standard deviation values as required. 
4.	Modifying feature names containing incompatible characters with R (e.g. parenthesis). Characters were either replaced or removed. 
5.	Summarizing the raw feature values by subject and activity using an average function as required.
6.	Melting the 79 size feature vector into a dedicated column to bring the dataset into a long form.

Finally, the question of how the data is being served has apparentely more then one answer. I decided to arrange the observations by subject and activity to reflect a causation relation of a “Subject who performs an activity which produces data”. <br/>
The artifact of this phase is primary the file “smartphone_dataset_long.txt” containing a 14220 x 4 data set. In order to produce the long format, the wide is being calculated intermediately during script execution. Subsequently I thought it would make sense, especially when no extra costs are involved, to provide also the wide format (180 x 81). 

<br/>
<br/>
##CODE BOOK
<br/>

| VAR.      |  COL. | DESCRIPTION                                                   | TYPE  | VALUES  |
|---        |---    |---                                                            |---    |---      |
|  SUBJECT  |   1   | AN IDENTIFIER OF THE SUBJECT WHO CARRIED OUT THE EXPERIMENT   | INT   | 1 - 30  |
|  ACTIVITY |   2   | AN ACTIVITY PERFORMED BY THE SUBJECT                          | STR   | LAYING <br/> SITTING<br/> STANDING<br/> WALKING<br/> WALKING_DOWNSTAIRS<br/> WALKING_UPSTAIRS|
|  FEATURE  |   3   | MEAN AND STANDARD DEVIATION FEATURE NAMES.                    | STR   | 79 DISTINCT FEATURE NAMES, DERIVED FROM THE RAW FEATURE SET BY:   <br/> 1. PARENTHESIS REMOVAL <br/> 2. SUBTITUTE OF DASHES "-" WITH UNDERDCORES "_"  <br/> <br/> EXAMPLE: <br/>tBodyAcc-mean()-X <br/>WAS CONVERTED TO <br/>tBodyAcc_mean_X| |
|  VALUE    |   4   | FEATURE VALUE                                                 | FLOAT | AN AVERAGE OVER THE RAW FEATURE VALUES, NORMALIZED AND BOUNDED WITHIN [-1,1]        |
