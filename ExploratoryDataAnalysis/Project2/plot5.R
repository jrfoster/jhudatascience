# Use dplyr and ggplot2
library(dplyr)
library(ggplot2)

# Read the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Create a factor subset of source classification codes for "Motor Vehicle" and use it
# to filter the main data set.  To identify motor vehicles we use the data.category "Onroad"
mvSCC <- SCC[SCC$Data.Category == "Onroad", 1]
mvNEI <- NEI %>% 
   filter(SCC %in% mvSCC & fips == "24510") %>%
   group_by(year) %>% 
   summarize(totalEmissions = sum(Emissions) / 1000)

# Now create the plot to show trend, including line of best fit
png(filename = "plot5.png", bg = "transparent", width = 640, height = 480)
plot5 <- ggplot(mvNEI, aes(year, totalEmissions)) +
   geom_line(color = "green4", size = 1) +
   geom_smooth(color = "black", method = "lm", se = FALSE, linetype = "dotted") +
   ggtitle(expression(atop("Motor Vehicle-Related Particulate Matter 2.5 Microns and Smaller (PM2.5)", atop(italic("Baltimore City Totals from 1999 to 2008"), "")))) +
   labs(x = "Year", y = "Total PM2.5 Emissions (x1000 Tons)") + 
   theme_bw(base_family = "Avenir", base_size = 12)
print(plot5)
dev.off()