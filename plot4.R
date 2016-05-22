#Dataset URL
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

#Download the dataset
if(!file.exists("./household_power_consumption.txt.zip")) {
    download.file(url, destfile="household_power_consumption.txt.zip", method="curl")
    unzip("household_power_consumption.txt.zip")
}

#Define absolute path to household_power_consumption.txt file
file <- "./household_power_consumption.txt"

if(file.exists(file)) {
    #Read the file into a data frame
    df <- read.table(file, header = TRUE, sep = ";", na.strings = "?", stringsAsFactors = FALSE)
    
    #Convert Date column to Date/Time class
    df$Date <- as.Date(df$Date,"%d/%m/%Y")
    
    #Subset the dataframe as we're only interested in dates 2007-02-01 and 2007-02-02
    dataset <- subset(df, Date == "2007-02-01" | Date == "2007-02-02")
    
    #Create a datetime column by concat Date and Time, then convert to datetime object
    dataset$datetime <- with(dataset, paste(Date, Time, sep=" "))
    dataset$datetime <- as.POSIXct(strptime(dataset$datetime, "%Y-%m-%d %H:%M:%S"))
    
    #Select png as a graphics device
    png("plot4.png", width=480,height=480)
    
    #Setup a 4,4 panel and set margins
    par(mfrow=c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0))
    
    #Create plot in 1,1
    plot(dataset$datetime, dataset$Global_active_power, type="l", ylab="Global Active Power", xlab="")
    
    #Create plot in 1,2
    plot(dataset$datetime, dataset$Voltage, type="l", ylab="Voltage", xlab="datetime")
    
    #Create plot in 2,1
    plot(dataset$datetime, dataset$Sub_metering_1, type="n", ylab="Energy sub metering", xlab="")
    points(dataset$datetime, dataset$Sub_metering_1, type="l")
    points(dataset$datetime, dataset$Sub_metering_2, col="red", type="l")
    points(dataset$datetime, dataset$Sub_metering_3, col="blue", type="l")
    legend("topright", bty="n", lty=c(1,1), col=c("black","red", "blue"),legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
    
    #Create plot in 2,2
    plot(dataset$datetime, dataset$Global_reactive_power, type="l", ylab="Global_reactive_power", xlab="datetime")
    
    dev.off()
} else {
    print (paste(file, "does not exist"))
}

