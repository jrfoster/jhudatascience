# Use dplyr
library(dplyr)

# Read the data
NEI <- readRDS("summarySCC_PM25.rds")

# Create a summary of the total US emissions by year
us_summary <- NEI %>% 
   group_by(year) %>% 
   summarize(totalEmissions = sum(Emissions) / 1000)

# Now create the plot to show 
png(filename = "plot1.png", bg = "transparent", width = 640, height = 480)
with(us_summary, 
     plot(year, totalEmissions, 
          xaxt = "n",
          pch = 18,
          main = "Particulate Matter 2.5 Microns and Smaller (PM2.5)",
          xlab = "Year", 
          ylab = "Total PM2.5 Emissions - All Sources (x1000 Tons)",
          type = "b",
          col = "blue"))
mtext("US Totals from 1999 to 2008")
axis(1, at = seq(1999, 2008, by = 3))
dev.off()