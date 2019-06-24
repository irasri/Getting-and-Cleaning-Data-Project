library(dplyr)
getwd()

### Loading the libraries and the reading the txt files into tables

# Read features description 
features <- read.table("./features.txt") 

# Read activity labels 
activity_labels <- read.table("./activity_labels.txt")

# Read the train data
subject_train <- read.table("./train/subject_train.txt")
x_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")


# Read the test data 
subject_test <-read.table("./test/subject_test.txt")
x_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")


### 1 : Merges the training and the test sets to create one data set.
x_data   <- rbind(x_train, x_test)
y_data  <- rbind(y_train, y_test) 
subject_data <- rbind(subject_train, subject_test) 

###Appropriately label the data set with descriptive variable names.
colnames <- features[,2]
colnames(x_data) <- colnames
colnames(y_data) <- "activity"
colnames(subject_data) <- "subject"

### Extracts only the measurements on the mean and standard deviation for each measurement.
x_data <- x_data[,grep(".*mean|std", names( x_data ))]


### Uses descriptive activity names to name the activities in the data set
y_data$activity<- factor(y_data$activity,
                           levels = 1:6,
                           labels = activity_labels$V2)


###tidy data set with the average of each variable for each activity and each subject.

x_data <- cbind(subject_data, y_data, x_data)
tidy_data <- x_data %>% group_by(activity, subject) %>% summarize_each(funs(mean))

write.table(tidy_data, file = "./tidydata.txt", row.names = FALSE, col.names = TRUE)


