##README
<br/>
#### Running the script 
function prototype
```R
run_analysis <- function( dataSetFolder = "UCI HAR Dataset", zipFile = "dataset.zip") {
..
}
```
<br/>
source run_analysis.R and call the function _**run_analysis()**_ 
```R
source("run_analysis.R")
dt <- run_analysis()
```
<br/>
During script execution you will get the following output to your R console:
```R
------------------------
      run_analysis      
------------------------
         setup          
------------------------
------------------------
    processing data     
------------------------
reading features
reading activity labels
------------------------
group=train
------------------------
processing subject data
processing activity data
processing feature data
------------------------
group=test
------------------------
processing subject data
processing activity data
processing feature data
------------------------
 writing data to files	 
------------------------
smartphone_dataset_wide.txt
smartphone_dataset_long.txt
------------------------
Done.
------------------------
```
<br/>
Printing out the data table
```R
       subject         activity                   feature       value
    1:       1           LAYING           tBodyAcc_mean_X  0.22159824
    2:       1           LAYING           tBodyAcc_mean_Y -0.04051395
    3:       1           LAYING           tBodyAcc_mean_Z -0.11320355
    4:       1           LAYING            tBodyAcc_std_X -0.92805647
    5:       1           LAYING            tBodyAcc_std_Y -0.83682741
   ---                                                               
14216:      30 WALKING_UPSTAIRS          fBodyGyroMag_std -0.15147228
14217:      30 WALKING_UPSTAIRS     fBodyGyroMag_meanFreq -0.45663867
14218:      30 WALKING_UPSTAIRS     fBodyGyroJerkMag_mean -0.77397445
14219:      30 WALKING_UPSTAIRS      fBodyGyroJerkMag_std -0.79134943
14220:      30 WALKING_UPSTAIRS fBodyGyroJerkMag_meanFreq -0.07143987
```

In addition the scripts writes two fiels to you working directory. Notice that the wide data set is given additionaly. 
```R
smartphone_dataset_long.txt
smartphone_dataset_wide.txt
```
<br/>
To read the data set from the working direcory, do something like:
```R
dt_long <- read.table("smartphone_dataset_long.csv", header=TRUE)
```

####2. script steps 
##### setup and validation
1. if _dataSetFolder_ does not exist, then it will be extracted from _zipFile_. 
2. If the _zipFile_ does not exist, it will download from _https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip_
3. Loading of libraries: data.table, dplyr, reshape2. If a package is not found, then it will be downloaded from a CRAN repostiory.
 
##### processing
1. features are read from "feature.txt". Problematic characters incompatible with R are replaced or removed.
2. activity labels are read from "activity_labels.txt"
3. Looping over "train" and "test" folders, and:
  1. reading subject data
  2. reading activities. replacing numeric values with labels
  3. reading X data, applying col names from step 1, and subsetting over all mean and std cols using grepl
  4. binding the columns of step i - iv
4. binding rows of "train" and "test"

##### post processing and writing artifacts
Processing the intermediate data resulted by the previous step and bringing it to the wished form.
<br/>
* Grouping by subject and activity and summarizing using a mean function
```
dt <- dt %>% group_by(subject, activity) %>% summarise_each(funs(mean))
```
* writing wide data set to file
* Reshaping wide data set by calling melt function. Renaming variable columns to feature
```
m <- melt(dt,id=c("subject", "activity"), measre.vars=3:81)
dt <- m %>% arrange(subject, activity) %>% rename(feature=variable)
```
* writing long data set to file
