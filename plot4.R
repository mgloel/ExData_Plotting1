# Plot4.R

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
# Plot 4
par(mfrow=c(2,2))
plot(df$datetime,df$Global_active_power, type='l', ylab="Global Active Power (kilowatts)", xlab="")
plot(df$datetime,df$Voltage, type='l', ylab="Voltage", xlab="")
plot(df$datetime,df$Sub_metering_1, type='l', col="black", ylab="Energy sub metering", xlab="")
lines(df$datetime,df$Sub_metering_2, type='l', col="red", ylab="Energy sub metering", xlab="")
lines(df$datetime,df$Sub_metering_3, type='l', col="blue", ylab="Energy sub metering", xlab="")
legend("topright", pch=21, col = c("black", "red", "blue"), legend = c("SM. 1", "SM. 2", "SM. 3"), cex=0.3)
plot(df$datetime,df$Global_reactive_power, type='l', ylab="Global Reactive Power", xlab="")

# saving
dev.copy(png,'./plot4.png')
dev.off()
