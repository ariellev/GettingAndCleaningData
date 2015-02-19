run_analysis <- function() {
	if (!file.exists(".data")) {
		dir.create(".data")
		message("creating data directory")
	}
	if (!file.exists(".data/dataset.zip")) {
		message("downloading zip file")
        	status <- download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile=".data/dataset.zip", method = "curl")		
		if (status != 0) {
			## error downloading file
			stop(paste("error downloading zip file, status=", status))
		}
	}
	
	message("extracting dataset from zip file")
	unzip(".data/dataset.zip", exdir=".data")

	## installing package "data.table"
	list.of.packages <- c("data.table", "dplyr")
	new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
	if (length(new.packages)) {
		message("installing packages")
		install.packages(new.packages, repos="http://mirrors.softliste.de/cran/")
	}
	require(data.table)
	require(dplyr)

	cols1 <- c("subject", "y", "X")
        cols2 <- c("body_acc_x" ,"body_acc_y" ,"body_acc_z" ,"body_gyro_x" ,"body_gyro_y" ,"body_gyro_z" ,"total_acc_x" ,"total_acc_y" ,"total_acc_z")	
	l <- list()
	for (c in cols1) {
		path <- paste(".data/UCI HAR Dataset/train/", c, "_train.txt", sep="")	
		message(path)
		l[[c]] <- fread(path, sep="\n")		
		if (length(l[[c]]) != 7352) {
			l[[c]] <- append(l[[c]], 123)
		}
	}
	df <- data.frame(l)
	## 7351 obs
	## subject_*.txt - subjects performing an activity 
	## y_*.txt - activity labels
	## x_*.txt - values set
	## replace activity numbers with labels
	## datset:
	## subject, activity, set
	
	## fread can be much faster
	##        	   User      System verstrichen 
      	## fread 	   0.355       0.018       0.378
	## read.table      8.486       0.059       8.468
  
	## fread(".data/UCI HAR Dataset/train/X_train.txt", sep="\n")
	## labels <- read.table(".data/UCI HAR Dataset/train/test/y_test.txt", sep="\t")
	message("Done.") 
	df
}
