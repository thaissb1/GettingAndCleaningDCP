library(dplyr)

# reading general information
activity.labels <- read.table("activity_labels.txt", header=F)
features <- read.table("features.txt", header=F) #reading features doc

#reading train data set
train.data <- read.table("X_train.txt", header=F) #features for each subject and each activity
train.subject <- read.table("subject_train.txt", header=F) #reading subjects
train.act <- read.table("y_train.txt", header=F) #reading labels activities

#reading test data set
test.data <- read.table("X_test.txt", header=F) #features for each subject and each activity
test.subject <- read.table("subject_test.txt", header=F) #subjects
test.act <- read.table("y_test.txt", header=F) #labels activities

#merging train and test data sets
data <- rbind(train.data, test.data)
names(data) <- features[,2]

#item 2 Extracting only the measures on the mean and std for each measurement
clean.data <- data[,which(grepl("mean|std", names(data)))]

#item 3 using descriptive activity names to name the activities in the data set
act.data <- merge(activity.labels, rbind(train.act, test.act), by.x="V1", by.y="V1")[,2]

#item 4 appropriately labels the data set with descriptive variable names
names(clean.data) <- gsub("-",".", names(clean.data))

#merging all data
data.full <- cbind(rbind(train.subject,test.subject), act.data, clean.data)
names(data.full)[1] <- "Subject"
names(data.full)[2] <- "Activity"

#item 5 calculating the average of each variable for each activity and each subject 
tidy.data <- data.full %>% 
     group_by(Subject, Activity) %>% 
     summarise_all(mean)

#creating a file for tidy data
write.csv(tidy.data, file="tidy_data.csv")
