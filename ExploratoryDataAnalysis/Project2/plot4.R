# Use dplyr and ggplot2
library(dplyr)
library(ggplot2)

# Read the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Create a factor subset of source classification codes for "Coal" and use it
# to filter the main data set
coalSCC <- SCC[grep("Coal", SCC$EI.Sector), 1]
coalNEI <- NEI %>% 
   filter(SCC %in% coalSCC) %>%
   group_by(year) %>% 
   summarize(totalEmissions = sum(Emissions) / 1000)

# Now create the plot to show trend, including line of best fit
png(filename = "plot4.png", bg = "transparent", width = 640, height = 480)
plot4 <- ggplot(coalNEI, aes(year, totalEmissions)) +
   geom_line(color = "green4", size = 1) +
   geom_smooth(color = "black", method = "lm", se = FALSE, linetype = "dotted") +
   ggtitle(expression(atop("Coal Cumbustion-Related Particulate Matter 2.5 Microns and Smaller (PM2.5)", atop(italic("US Totals from 1999 to 2008"), "")))) +
   labs(x = "Year", y = "Total PM2.5 Emissions (x1000 Tons)") + 
   theme_bw(base_family = "Avenir", base_size = 12)
print(plot4)
dev.off()