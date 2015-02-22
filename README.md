##README
<br/>
#### Running the script 
The function gets 2 optional parameters specifying the location of the data set folder or zip file.
```R
run_analysis <- function( dataSetFolder = "UCI HAR Dataset", zipFile = "dataset.zip") {
..
}
```
<br/>
Source run_analysis.R and call the function _**run_analysis()**_ 
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
dt

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

In addition the script writes two files to you working directory. Notice that the wide data set is given additionaly. 
```R
smartphone_dataset_long.txt
smartphone_dataset_wide.txt
```
<br/>
To read the data set from the working direcory, do something like:
```R
dt_long <- read.table("smartphone_dataset_long.txt", header=TRUE)
```

####2. script steps 
##### setup and validation
This script makes no assumptions over the samsung data. <br/>
1. If _dataSetFolder_ does not exist, then it will be extracted from _zipFile_. <br/>
2. If the _zipFile_ does not exist, it will download from _https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip_ <br/>
3. The script loads required libraries autonomously: data.table, dplyr, reshape2. If a package is not found, then it will be downloaded from a CRAN repostiory.
 
##### processing
1. Feature names are read from "feature.txt". Problematic characters incompatible with R  such as parenthesis are replaced or removed.
2. Activity labels are read from "activity_labels.txt"
3. Looping over "train" and "test" folders, and:
  1. Reading subject data
  2. Reading activities. replacing numeric values with labels
  3. Reading X data, applying col names to the features (from step 1), and subsetting over all mean and std cols using grepl
  4. Binding the columns of step i - iv
  5. Saving the intermediate set into a list of matrices.
4. Binding matrices rows together into a single data set: "train" and "test" are now combined

##### post processing and writing artifacts
Once the data is combined we can bring it to the wished form.
<br/>
* Grouping by subject and activity and summarizing using a mean function
```
dt <- dt %>% group_by(subject, activity) %>% summarise_each(funs(mean))
```
* Writing wide data set to file
* Reshaping wide data set by calling melt function. Renaming variable columns to feature
```
m <- melt(dt,id=c("subject", "activity"), measre.vars=3:81)
dt <- m %>% arrange(subject, activity) %>% rename(feature=variable)
```
* Writing long data set to file

### Please Notice
There might be a small chance, that for a some usages of dplyr on a Mac OS, code migh run into a segmentation fault.
I found the following thread saying it has to deal with a bug in R
http://comments.gmane.org/gmane.comp.lang.r.manipulatr/683

