require(dplyr)


#Defining the directory locations for root, test and training data
pathfile<-file.path(getwd(),"UCI HAR Dataset")
pathfiletest<-file.path(pathfile, "test")
pathfiletrain<-file.path(pathfile, "train")

#Get Test Data
xtest<-read.table(file.path(pathfiletest,"X_test.txt"))
ytest<-read.table(file.path(pathfiletest,"Y_test.txt"))
subjecttest<-read.table(file.path(pathfiletest,"subject_test.txt"))

#Get Training Data
xtrain<-read.table(file.path(pathfiletrain,"X_train.txt"))
ytrain<-read.table(file.path(pathfiletrain,"Y_train.txt"))
subjecttrain<-read.table(file.path(pathfiletrain,"subject_train.txt"))

#Get activity labels 

activity_labels <- read.table(file.path(pathfile,"activity_labels.txt"))
colnames(activity_labels)<- c("Id", "Activity")

#Get features labels
featurelabels<-read.table(file.path(pathfile,"features.txt"),colClasses = c("character"))

#Point 1: Merges the training and the test sets to create one data set.

traindata<-cbind(cbind(xtrain, subjecttrain), ytrain)
testdata<-cbind(cbind(xtest, subjecttest), ytest)
sensordata<-rbind(traindata, testdata)

sensorlabels<-rbind(rbind(featurelabels, c(562, "Subject")), c(563, "Id"))[,2]
names(sensordata)<-sensorlabels

#Point 2: Extracts only the measurements on the mean and standard deviation for each measurement.
sensordatameanstd <- sensordata[,grepl("mean\\(\\)|std\\(\\)|Subject|Id", names(sensordata))]

#Point 3:Uses descriptive activity names to name the activities in the data set
sensordatameanstd <- join(sensordatameanstd, activitylabels, by = "Id", match = "first")
sensordatameanstd <- sensordatameanstd[,-1]

#Point 4: Appropriately labels the data set with descriptive variable names. 
names(sensordatameanstd) <- gsub("([()])","",names(sensordatameanstd))
#norm names
names(sensordatameanstd) <- make.names(names(sensordatameanstd))

#Point 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

finaldata<-ddply(sensordatameanstd, c("Subject","Activity"), numcolwise(mean))

#Final: Data set as a txt file created with write.table() using row.name=FALSE

write.table(finaldata, file = "getdata_project_output.txt", row.name=FALSE)