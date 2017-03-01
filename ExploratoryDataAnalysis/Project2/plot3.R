# Use dplyr and ggplot2
library(dplyr)
library(ggplot2)

# Read the data
NEI <- readRDS("summarySCC_PM25.rds")

# Factor-ize the type column so we can use it as a facet
NEI$type <- factor(NEI$type)

# Create a summary of the total Baltimore City emissions by year
baltimore_summary <- NEI %>% 
   filter(fips == "24510") %>%
   group_by(type, year) %>% 
   summarize(totalEmissions = sum(Emissions) / 1000)

# Now create the plot to show trend, including line of best fit
png(filename = "plot3.png", bg = "transparent", width = 640, height = 480)
plot3 <- ggplot(baltimore_summary, aes(year, totalEmissions)) +
   geom_line(color = "green4", size = 1) +
   facet_wrap( ~ type, ncol=2) + 
   geom_smooth(color = "black", method = "lm", se = FALSE, linetype = "dotted") +
   ggtitle(expression(atop("Particulate Matter 2.5 Microns and Smaller (PM2.5)", atop(italic("Baltimore City Totals from 1999 to 2008"), "")))) +
   labs(x = "Year", y = "Total PM2.5 Emissions (x1000 Tons)") + 
   theme_bw(base_family = "Avenir", base_size = 12)
print(plot3)
dev.off()