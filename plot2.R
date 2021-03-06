#Dataset URL
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

#Download the dataset
if(!file.exists("./household_power_consumption.txt.zip")) {
    download.file(url, destfile="household_power_consumption.txt.zip", method="curl")
    unzip("household_power_consumption.txt.zip")
}

#Define path to household_power_consumption.txt file
file <- "./household_power_consumption.txt"

if(file.exists(file)) {
    #Read the file into a data frame
    df <- read.table(file, header = TRUE, sep = ";", na.strings = "?", stringsAsFactors = FALSE)
    
    #Convert Date column to Date/Time class
    df$Date <- as.Date(df$Date,"%d/%m/%Y")
    
    #Subset the dataframe as we're only interested in dates 2007-02-01 and 2007-02-02
    dataset <- subset(df, Date == "2007-02-01" | Date == "2007-02-02")
    
    dataset$datetime <- with(dataset, paste(Date, Time, sep=" "))
    dataset$datetime <- as.POSIXct(strptime(dataset$datetime, "%Y-%m-%d %H:%M:%S"))
    
    #Select png as a graphics device
    png("plot2.png", width=480,height=480)
    
    #Create the plot
    plot(dataset$datetime, dataset$Global_active_power, type="l", ylab="Global Active Power (kilowatts)", xlab="")
    
    dev.off()
} else {
    print (paste(file, "does not exist"))
}
