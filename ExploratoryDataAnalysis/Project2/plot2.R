# Use dplyr
library(dplyr)

# Read the data
NEI <- readRDS("summarySCC_PM25.rds")

# Create a summary of the total Baltimore City emissions by year
baltimore_summary <- NEI %>% 
   filter(fips == "24510") %>%
   group_by(year) %>% 
   summarize(totalEmissions = sum(Emissions) / 1000)

# Create a linear model from the summary to produce a line of best fit
baltimoreLm <- lm(baltimore_summary$totalEmissions ~ year, baltimore_summary)

# Now create the plot to show trend, including line of best fit
png(filename = "plot2.png", bg = "transparent", width = 640, height = 480)
with(baltimore_summary, 
     plot(year, totalEmissions, 
          xaxt = "n",
          pch = 18,
          main = "Particulate Matter 2.5 Microns and Smaller (PM2.5)",
          xlab = "Year", 
          ylab = "Total PM2.5 Emissions - All Sources (x1000 Tons)",
          type = "b",
          col = "blue"))
mtext("Baltimore City Totals from 1999 to 2008")
axis(1, at = seq(1999, 2008, by = 3))
abline(baltimoreLm, lty = "dotted")
dev.off()