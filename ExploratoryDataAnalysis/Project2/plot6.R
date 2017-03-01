# Use dplyr and ggplot2
library(ggplot2)
library(dplyr)

# Read the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Create a subset of source classification codes for "Motor Vehicle" and use it
# to filter the main data set.  To identify motor vehicles we use the data.category "Onroad"
mvSCC <- SCC[SCC$Data.Category == "Onroad", 1]
mvNEI <- NEI %>% 
   filter(SCC %in% mvSCC & (fips == "24510" | fips == "06037")) %>%
   group_by(fips, year) %>% 
   summarize(totalEmissions = sum(Emissions) / 1000)

# Factor-ize the fips column so we can use it as a facet
mvNEI$fips <- factor(mvNEI$fips, levels = c("06037","24510"), labels = c("Los Angeles County","Baltimore City"))

# Now create the plot to show trend, including line of best fit
png(filename = "plot6.png", bg = "transparent", width = 640, height = 480)
plot6 <- ggplot(mvNEI, aes(year, totalEmissions, color = fips)) +
   geom_line(size = 1) +
   facet_wrap(~ fips) +
   geom_smooth(color = "black", method = "lm", se = FALSE, linetype = "dotted") +
   ggtitle(expression(atop("Motor Vehicle-Related Particulate Matter 2.5 Microns and Smaller (PM2.5)", atop(italic("Los Angeles County and Baltimore City Totals from 1999 to 2008"), "")))) +
   labs(x = "Year", y = "Total PM2.5 Emissions (x1000 Tons)") + 
   theme_bw(base_family = "Avenir", base_size = 12)
print(plot6)
dev.off()