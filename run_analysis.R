library(dplyr)


x_train <- read.table("train/X_train.txt");
y_train <- read.table("train/y_train.txt");
subject_train <- read.table("train/subject_train.txt")
names(y_train) <- c("activity")
names(subject_train) <- c("subject")

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")
names(y_test) <- c("activity")
names(subject_test) <- c("subject")


feature_list <- read.table("features.txt")
mean_std_features <- grepl("std|mean\\(\\)", feature_list$V2)

name_of_features <- feature_list[mean_std_features,2]

name_of_features <- gsub("\\()","",name_of_features)
name_of_features <- gsub("-std$","StdDev",name_of_features)
name_of_features <- gsub("-mean","Mean",name_of_features)
name_of_features <- gsub("^(t)","time",name_of_features)
name_of_features <- gsub("^(f)","freq",name_of_features)
name_of_features <- gsub("([Gg]ravity)","Gravity",name_of_features)
name_of_features <- gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",name_of_features)
name_of_features <- gsub("[Gg]yro","Gyro",name_of_features)
name_of_features <- gsub("AccMag","AccMagnitude",name_of_features)
name_of_features <- gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",name_of_features)
name_of_features <- gsub("JerkMag","JerkMagnitude",name_of_features)
name_of_features <- gsub("GyroMag","GyroMagnitude",name_of_features)

x_train <- x_train[, mean_std_features]
x_test <- x_test[, mean_std_features]
names(x_train) <- name_of_features
names(x_test) <- name_of_features
activity_label <- read.table('activity_labels.txt')

combined <- rbind(cbind(x_train,y_train, subject_train), cbind(x_test, y_test, subject_test))
combined$activity <- activity_label[combined$activity, 2];

combined <- tbl_df(combined)

combined2 <- group_by(combined, subject, activity)
average_data <- summarise_each(combined2, funs(mean))

write.table(average_data, "average_data.txt", row.name=FALSE)

rm(x_test, x_train, y_test, y_train, subject_test, subject_train, combined2, combined)