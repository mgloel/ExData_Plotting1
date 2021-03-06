# Plot2.R

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
# Plot 2
plot(df$datetime,df$Global_active_power, type='l', ylab="Global Active Power (kilowatts)", xlab="")
# saving
dev.copy(png,'./plot2.png')
#dev.off()
