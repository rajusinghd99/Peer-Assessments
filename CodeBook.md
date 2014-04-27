xtest<-read.table("./UCI HAR Dataset/test/X_test.txt") # Reading X_test.txt into R #
ytest<-read.table("./UCI HAR Dataset/test/y_test.txt")  # Reading y_test.txt into R #
mergedatatest<-cbind(xtest,ytest)    # merging X_test.txt and y_test.txt into R #

xtrain<-read.table("./UCI HAR Dataset/train/X_train.txt")  # Reading X_train.txt into R #
ytrain<-read.table("./UCI HAR Dataset/train/y_train.txt")   # Reading y_train.txt into R #
mergedatatrain<-cbind(xtrain,ytrain)     # merging X_train.txt and y_train.txt into R #

mergedata<-rbind(mergedatatest,mergedatatrain)   # merging mergedatatest and mergedatatrain into R #
feature<-xtest<-read.table("./UCI HAR Dataset/features.txt")   # Reading features.txt into R #
mean<-grep("mean()", feature[,2])     #Identifying variables with "mean()"#
std<- grep("std()", feature[,2])    #Identifying variables with "std()"#
meanstd<- append(c(mean), c(std))     #Creating a vector with variables with "std()" and "mean()"#

keydata<-mergedata[,c(meanstd)]
keydata<-cbind(keydata,mergedata[,562])

subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")
subject<-rbind(subject_test,subject_train)

keydata2<-cbind(subject,keydata)

x<-as.numeric(meanstd)
y<-feature[,2][c(x)]
y<-as.character(y)
names(keydata2)[2:80]<-y
names(keydata2)[1]<-"SubjectId"
names(keydata2)[81]<-"Activity"

keydata2$Activity <- as.character(keydata2$Activity)
keydata2$Activity[keydata2$Activity  == "1"] <- "WALKING"
keydata2$Activity[keydata2$Activity  == "2"] <- "WALKING_UPSTAIRS"
keydata2$Activity[keydata2$Activity  == "3"] <- "WALKING_DOWNSTAIRS"
keydata2$Activity[keydata2$Activity  == "4"] <- "SITTING"
keydata2$Activity[keydata2$Activity  == "5"] <- "STANDING"
keydata2$Activity[keydata2$Activity  == "6"] <- "LAYING"

library(reshape2)
keydata4<-melt(keydata2,id.vars=c("SubjectId","Activity"))
keydata5<-dcast(keydata4, SubjectId + Activity ~ variable,mean)
write.table(keydata4,file="tidydata.txt")
