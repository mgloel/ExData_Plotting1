# Plot1.R

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
df$Date <- as.Date(dmy(df$Date))
df$Time <- hms(df$Time)

# Convert to numeric
df$Global_active_power <- as.numeric(as.character(df$Global_active_power))


# Plotting and saving -----------------------------------------------------
# Plot 1
hist(df$Global_active_power, main="Global Active Power", xlab="Global Active Power", ylab="Frequency",ylim=c(0,1200), col="red")

# saving
dev.copy(png,'./plot1.png')
dev.off()
