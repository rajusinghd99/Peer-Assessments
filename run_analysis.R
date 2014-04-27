xtest<-read.table("./UCI HAR Dataset/test/X_test.txt")
ytest<-read.table("./UCI HAR Dataset/test/y_test.txt")
mergedatatest<-cbind(xtest,ytest)

xtrain<-read.table("./UCI HAR Dataset/train/X_train.txt")
ytrain<-read.table("./UCI HAR Dataset/train/y_train.txt")
mergedatatrain<-cbind(xtrain,ytrain)

mergedata<-rbind(mergedatatest,mergedatatrain)
feature<-xtest<-read.table("./UCI HAR Dataset/features.txt")
mean<-grep("mean()", feature[,2])
std<- grep("std()", feature[,2])
meanstd<- append(c(mean), c(std))

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
