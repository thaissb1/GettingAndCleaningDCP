library(dplyr)

# reading general information
setwd("/Users/thaissb1/Desktop/DSCert/GCData/Assign4/UCI HAR Dataset")
activity.labels <- read.table("activity_labels.txt", header=F)
features <- read.table("features.txt", header=F) #reading features doc

#reading train data set
setwd("/Users/thaissb1/Desktop/DSCert/GCData/Assign4/UCI HAR Dataset/train")
train.data <- read.table("X_train.txt", header=F) #features for each subject and each activity
train.subject <- read.table("subject_train.txt", header=F) #reading subjects
train.act <- read.table("y_train.txt", header=F) #reading labels activities

#reading test data set
setwd("/Users/thaissb1/Desktop/DSCert/GCData/Assign4/UCI HAR Dataset/test")
test.data <- read.table("X_test.txt", header=F) #features for each subject and each activity
test.subject <- read.table("subject_test.txt", header=F) #subjects
test.act <- read.table("y_test.txt", header=F) #labels activities

#merging train and test data sets
data <- rbind(train.data, test.data)
names(data) <- features[,2]

#item 2 Extracting only the measures on the mean and std for each measurement
clean.data <- data[,which(grepl("mean|std", names(data)))]

#item 3 mudar nomes das variaveis
act.data <- merge(activity.labels, rbind(train.act, test.act), by.x="V1", by.y="V1")[,2]

#item 4 descriptive acivity names to name the activities in the data set 
names(clean.data) <- gsub("-",".", names(clean.data))

#merging all data
tidy <- cbind(rbind(train.subject,test.subject), act.data, clean.data)
names(tidy)[1] <- "Subject"
names(tidy)[2] <- "Activity"

#item 5 calculating the average of each variable for each activity and each subject 
tidy %>% 
     group_by(Subject, Activity) %>% 
     summarise_all(mean)
     