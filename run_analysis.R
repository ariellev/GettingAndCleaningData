run_analysis <- function( dataSetFolder = "UCI HAR Dataset", zipFile = "dataset.zip") {
        message("------------------------")	
        message("      run_analysis      ")
        message("------------------------")
        message("         setup          ")
        message("------------------------")
        ## ------------------------
        ##      setting up
        ## ------------------------
	## pre condition - verifying that data set folder exists
	## if not, it will be downloaded and extracted
	if (!file.exists(dataSetFolder)) {
		 message("Couldn't find data set folder. Trying out the zip file..")
		 if (!file.exists(zipFile)) {
                	message("Couldn't find zip. Downloading...")
			status <- download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile=zipFile, method = "curl")
                	if (status != 0) {
                        	## error downloading file
                        	stop(paste("error downloading zip file, status=", status))
               		 }		 
		}
		message("extracting dataset from zip file")
		unzip(zipFile)
		dataSetFolder <- "UCI HAR Dataset"
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
        message("------------------------")
        message("    processing data     ")
        message("------------------------")

        ## ------------------------
        ##      processing
        ## ------------------------
	
        ## features
        message("reading features")
        path <- file.path(dataSetFolder, "features.txt")
        features <- fread(path)

        ## removing problematic chars
        features$V2 <- gsub('\\(', "", features$V2)
        features$V2 <- gsub('\\)', "", features$V2)
        features$V2 <- gsub('-', "_", features$V2)

	## actvity labels
        message("reading activity labels")
        path <- file.path(dataSetFolder, "activity_labels.txt")
        activity_labels <- read.table(path)

	research_groups <- c("train", "test")
        mat_list <- list()
	
	for ( c in research_groups) {
                message      ("------------------------")
		message(paste("group=", c, sep=""))
                message	     ("------------------------")
		## reading subject data
        	message("processing subject data")
		path <- file.path(dataSetFolder, c, paste("subject_", c, ".txt", sep=""))
		subject <- fread(path, sep="\n", header=FALSE)

		## reading activity data 
        	message("processing activity data")
		path <- file.path(dataSetFolder, c, paste("y_", c, ".txt", sep=""))
		activity_nums <- fread(path, sep="\n", header=FALSE)

		## replacing activity numbers with lables
		activity <- sapply(activity_nums$V1, function(x) activity_labels$V2[[x]])
	
		## reading X data
		message("processing feature data")			
		path <- file.path(dataSetFolder, c, paste("X_", c, ".txt", sep=""))
		message(path)
		x <- read.table(path)	
	
		## mapping to x values to feature names	
		names(x) <- features$V2

		## selecting only mean and std variables 
		x <- x[,grepl("mean|std", colnames(x))] 
		
		mat_list[[c]] <- cbind(subject, activity, x)
	}
	d <- rbind(mat_list[["train"]], mat_list[["test"]])
	dt <- data.table(d)
	dt <- rename(dt, subject = V1)
        message("------------------------")
	message("Done.")
        message("------------------------")
	dt %>% arrange(subject, activity) %>% group_by(subject, activity) %>% summarise_each(funs(mean))
}
