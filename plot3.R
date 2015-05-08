# Plot3.R

library(dplyr)
library(ggplot2)
library(lubridate)
library(png)
library(sqldf)


# Read and transform data -------------------------------------------------
# Download date
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileURL,"./data.zip", method="curl")
unzip("data.zip")

# Read only data from specific dates
df <- read.csv.sql("household_power_consumption.txt", sql = "SELECT * FROM file WHERE Date = '1/2/2007' OR Date = '2/2/2007'", header = TRUE, sep = ";")

gsub("?", NA, df)
# Convert date and time from character
Sys.setlocale("LC_TIME", "C")
df$datetime <- paste(df$Date, df$Time)
df$datetime <- strptime(df$datetime, "%d/%m/%Y %H:%M:%S")

df$Date <- as.Date(dmy(df$Date))
df$Time <- hms(df$Time)


# Convert to numeric
df$Global_active_power <- as.numeric(as.character(df$Global_active_power))


# Plotting and saving -----------------------------------------------------
# Plot 3
par(mfrow=c(1,1))

plot(df$datetime,df$Sub_metering_1, type='l', col="black", ylab="Energy sub metering", xlab="")
lines(df$datetime,df$Sub_metering_2, type='l', col="red", ylab="Energy sub metering", xlab="")
lines(df$datetime,df$Sub_metering_3, type='l', col="blue", ylab="Energy sub metering", xlab="")
legend("topright", pch='-', lwd=1.5,col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), cex=0.8)
# saving
dev.copy(png,'./plot3.png')
dev.off()
