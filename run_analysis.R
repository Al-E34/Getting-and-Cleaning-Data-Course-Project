## create data dir ##
if(!file.exists("./data")){dir.create("./data")}
## downloard files
URL1="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(URL1,
              destfile="./data/Dataset.zip"
              )
## Unzip files
unzip(zipfile ="./data/Dataset.zip"
      ,exdir = "./data")

## read X & Y & subject-Train ####
X_train<-read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train<-read.table("./data/UCI HAR Dataset/train/subject_train.txt")

## read X & Y & subject_test##
X_test<-read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test<-read.table("./data/UCI HAR Dataset/test/subject_test.txt")

## read features ##
features<-read.table("./data/UCI HAR Dataset/features.txt")
## read activity_labels ###
activity_labels<-read.table("./data/UCI HAR Dataset/activity_labels.txt")

## assign colume names X-train
colnames(X_train) <- features[,2] 
colnames(y_train) <-"activity"
colnames(subject_train) <- "subject"

## assign column names X-test
colnames(X_test) <- features[,2] 
colnames(y_test) <- "activity"
colnames(subject_test) <- "subject"

## merge train & test  Data##
train_all <- cbind(y_train, subject_train, X_train)
test_all <- cbind(y_test, subject_test, X_test)

## stack train & test data into one set##
setAllInOne<-rbind(train_all,test_all)

## Reading column names
Reading_column_names<-colnames(setAllInOne)

## Create vector for defining ID, mean and standard deviation
vector_ID_std_mean<-Reading_column_names[grepl("activity",Reading_column_names)
                                         |grepl("subject",Reading_column_names)
                                         |grepl("mean",Reading_column_names)
                                         |grepl("std",Reading_column_names)
                                         ]
## create subset
ID_std_mean<-setAllInOne[,vector_ID_std_mean]

## Using descriptive activity names to name the activities in the data set
 
df1<-merge(activity_labels,ID_std_mean,by="activity")
 
## Creating a second, independent tidy data set with the average of each variable 
## for each activity and each subject
Df3<-aggregate( df1[,4:length(df1)], df1[,1:3], FUN = mean )

seconTidyDat<-Df3[order(Df3$activity,Df3$subject),]
write.table(seconTidyDat, "seconTidyDat.txt", row.name=FALSE)