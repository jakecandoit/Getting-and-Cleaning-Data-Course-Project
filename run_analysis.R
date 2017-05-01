library(plyr)
library(dplyr)
library(tidyr)

#reading files
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt")
x_test<-read.table("UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("UCI HAR Dataset/test/y_test.txt")

subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt")
x_train<-read.table("UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("UCI HAR Dataset/train/y_train.txt")

##read the labels
features<-read.table("UCI HAR Dataset/features.txt")
activity_labels<-read.table("UCI HAR Dataset/activity_labels.txt")

#merging tables
joinedtest<-cbind(subject_test,y_test,x_test)
joinedtrain<-cbind(subject_train,y_train,x_train)
df<-rbind(joinedtest,joinedtrain)

#renaming column headers
names(df)<-c("id","activity",as.character(features[,2]))

#changing data in activity column to descriptive activity names
df[,2]<-mapvalues(df[,2], from = as.integer(activity_labels[,1]), to = as.character(activity_labels[,2]))

#subsetting only mean and std columns
df<-cbind(df[,1:2],df[,grepl("mean\\()|std\\()",names(df))])

#reshaping data
temp<-gather(df,"feature","measurement",3:(ncol(df)))
temp2<-separate(temp,feature,into=c("feature","variable","axis"),sep="-",fill="right")

#fixing characters
temp2[,4]<-gsub("\\()","",temp2[,4])

#tidy data output
tidy_data<-temp2

#tidy summary data
summary<-ddply(tidy_data,.(id,activity,variable),summarise,average=mean(measurement))

tidy_data