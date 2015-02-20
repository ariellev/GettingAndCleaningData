run_analysis <- function( dataSetFolder = "UCI HAR Dataset") {
        ## ------------------------
        ##      setting up
        ## ------------------------
	## pre condition - verifying that data set folder exists
	## if not, it will be downloaded and extracted
	if (!file.exists(dataSetFolder)) {
		 message("Couldn't find data set folder. trying out the zip file..")
		 if (!file.exists("dataset.zip")) {
                	message("couldn't find zip. Downloading..")
                	status <- download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile="dataset.zip", method = "curl")
                	if (status != 0) {
                        	## error downloading file
                        	stop(paste("error downloading zip file, status=", status))
               		 }		 
		}
		message("extracting dataset from zip file")
		unzip("dataset.zip")
	}

	## pre condition - packages are installed.
	## installing package "data.table"
	list.of.packages <- c("data.table", "dplyr")
	new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
	if (length(new.packages)) {
		message("installing packages")
		install.packages(new.packages, repos="http://mirrors.softliste.de/cran/")
	}
	require(data.table)
	require(dplyr)

        ## ------------------------
        ##      processing
        ## ------------------------
	
        ## features
        message("processing features")
        path <- file.path(dataSetFolder, "features.txt")
        features <- fread(path)

        ## removing problematic chars
        features$V2 <- gsub('\\(', "", features$V2)
        features$V2 <- gsub('\\)', "", features$V2)
        features$V2 <- gsub('-', "_", features$V2)

	## actvity labels
        message("processing activity labels")
        path <- file.path(dataSetFolder, "activity_labels.txt")
        activity_labels <- read.table(path)

	## reading subject data
        message("processing subject data")
	path <- file.path(dataSetFolder, "train", "subject_train.txt")
	subject <- fread(path, sep="\n", header=FALSE)

	## reading activity data 
        message("processing activity data")
	path <- file.path(dataSetFolder, "train", "y_train.txt")
	activity_nums <- fread(path, sep="\n", header=FALSE)

	## replacing activity numbers with lables
	activity <- sapply(activity_nums$V1, function(x) activity_labels$V2[[x]])
	
	## reading X data
	message("processing X_train.txt")	
	path <- file.path(dataSetFolder, "train", "X_train.txt")
	x <- read.table(path)	
	
	## mapping to x values to feature names	
	names(x) <- features$V2

	## selecting only mean and std variables 
	x <- x[,grepl("mean|std", colnames(x))] 

	d <- cbind(subject, activity, x)
	dt <- data.table(d)
	dt <- rename(dt, subject = V1)
	message("Done.")
	dt %>% group_by(subject, activity) %>% summarise_each(funs(mean))
}
