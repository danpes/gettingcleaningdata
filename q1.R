
setwd('C:\\Users\\daniele.pes\\Desktop\\coursera\\Getting Cleaning Data\\w1')
fUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv'
download.file(fUrl, destfile="./data.csv")
data <- read.table("./data.csv", sep=",", header=TRUE)

# --> QUESTION 1
# refer to code book: https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
# Property value
# bb .N/A (GQ/rental unit/vacant, not for sale only)
# 01 .Less than $ 10000
# 02 .$ 10000 - $ 14999
# ...
# 23 .$750000 - $999999
# 24 .$1000000+
sum(!is.na(data$VAL[data$VAL==24])) 

# --> QUESTION 2
# The tidy data principles:
# each variable you measure should be in one column
# each different observation of that variable should be in a different row
# there should be one table for each "kind" of variable
# if you have multiple tables, they should include a column in the table that allows them to be linked
# include a row at the top each file with variable name
# make variable names human readable (AgeAtDiagnosis instead of AgeDx)
# in general, data should be saved in one file per table
# --> ANSWER: Tidy data has one variable per column.

# --> QUESTION 3
setwd('C:\\Users\\daniele.pes\\Desktop\\coursera\\Getting Cleaning Data\\w1')
fUrl <-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
# take care of 'wb' (download in binary mode, otherwise read.xlsx will fail)
download.file(fUrl,destfile="./gngap.xlsx", mode='wb')
# NOTE: xlsx needs for Java to be installed and available at JAVA_HOME system variable
# have to install xlsx package in R Studio
library(xlsx)
dat <- read.xlsx("./gngap.xlsx",sheetIndex=1, header=TRUE, colIndex=7:15, rowIndex=18:23)
sum(dat$Zip*dat$Ext,na.rm=T) 

# --> QUESTION 4
# have to install XML package in R Studio
library(XML)
fUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
# had some trouble in parsing the source file --> fixed it thanks to http://stackoverflow.com/questions/23584514/error-xml-content-does-not-seem-to-be-xml-r-3-1-0
library(RCurl)
xData <- getURL(fUrl)
data <- xmlTreeParse(xData, useInternal=TRUE) #useInternal is necessary, to avoid the error described in http://stackoverflow.com/questions/24118546/unable-to-find-an-inherited-method-for-function-savexml-for-signature-charac
rNode<-xmlRoot(data)
sum(xpathSApply(rNode, "//zipcode", xmlValue)==21231)

# --> QUESTION 5
# have to install data.table package in R Studio
library(data.table)
setwd('C:\\Users\\daniele.pes\\Desktop\\coursera\\Getting Cleaning Data\\w1')
fUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fUrl, destfile="./hIdaho.csv")
DT <- fread("./hIdaho.csv")
system.time(rowMeans(DT)[DT$SEX==1]); system.time(rowMeans(DT)[DT$SEX==2])              #1
system.time(tapply(DT$pwgtp15,DT$SEX,mean))                                             #2
system.time(mean(DT$pwgtp15,by=DT$SEX))                                                 #3
system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))                                      #4
system.time(DT[,mean(pwgtp15),by=SEX])                                                  #5
system.time(mean(DT[DT$SEX==1,]$pwgtp15));system.time(mean(DT[DT$SEX==2,]$pwgtp15))     #6

# just compared my solution with this one, found at https://github.com/benjamin-chan/GettingAndCleaningData/blob/master/Quiz1/quiz1.md
check <- function(y, t) {
    message(sprintf("Elapsed time: %.10f", t[3]))
    print(y)
}
t <- system.time(y <- rowMeans(DT)[DT$SEX == 1]) + system.time(rowMeans(DT)[DT$SEX == 2])                #1
check(y, t)
t <- system.time(y <- tapply(DT$pwgtp15, DT$SEX, mean))                                                  #2
check(y, t)
t <- system.time(y <- mean(DT$pwgtp15, by = DT$SEX))                                                     #3
check(y, t)
t <- system.time(y <- sapply(split(DT$pwgtp15, DT$SEX), mean))                                           #4
check(y, t)
t <- system.time(y <- DT[, mean(pwgtp15), by = SEX])                                                     #5
check(y, t)
t <- system.time(y <- mean(DT[DT$SEX == 1, ]$pwgtp15)) + system.time(mean(DT[DT$SEX == 2, ]$pwgtp15))    #6
check(y, t)
