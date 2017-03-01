Exploratory Data Analysis - Project 2
===================
This repository contains files related to the second project of the Coursera Exploratory Data Analysis course.  Basically, its a bunch of R files that produce graphs from an EPA dataset containing data about fine particulate matter.

Introduction
-----
Fine particulate matter (PM2.5) is an ambient air pollutant for which there is strong evidence that it is harmful to human health. In the United States, the Environmental Protection Agency (EPA) is tasked with setting national ambient air quality standards for fine PM and for tracking the emissions of this pollutant into the atmosphere. Approximatly every 3 years, the EPA releases its database on emissions of PM2.5. This database is known as the National Emissions Inventory (NEI). You can read more information about the NEI at the [EPA National Emissions Inventory web site](http://www.epa.gov/ttn/chief/eiinformation.html).

For each year and for each type of PM source, the NEI records how many tons of PM2.5 were emitted from that source over the course of the entire year. The data that you will use for this assignment are for 1999, 2002, 2005, and 2008.

Data
----------
The data for this assignment are available from the course web site as a [single zip file](https://d396qusza40orc.cloudfront.net/exdata/data/NEI_data.zip).

Assignment
-----
The overall goal of this assignment is to explore the National Emissions Inventory database and see what it say about fine particulate matter pollution in the United states over the 10-year period 1999–2008. You may use any R package you want to support your analysis.

Questions
-----
You must address the following questions and tasks in your exploratory analysis. For each question/task you will need to make a single plot. Unless specified, you can use any plotting system in R to make your plot.

 1. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.
 2. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot answering this question.
 3. Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.
 4. Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?
 5. How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
 6. Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?

Notes
-----
For the most part, the questions are fairly straightforward, however, a couple of notes are necessary to understand some of the decisions I made in doing the analysis and in producing the graphs.

*Use of Lines of Best Fit*

In most of the graphs I have included a line of best fit using a simple linear model of the data.  I included these to show the overall trend because I felt that some of the data either introduced peaks/valleys or were either sparse at some points.  Including these linear models makes it clear as to the overall trend of the data.

*Identifying Motor Vehicle Data*

There was some discussion in the groups about how best to do this, as well as some mention that it didn't really matter, as long as there was good rationale behind the decision.  In looking at the SCC data there appeared to be many different approaches that one could take.  I considered utilizing a regular expression on EI.Sector (looking for "Mobile") but doing so included several categories of things that were not motor vehicles (e.g. such as boats, planes and trains as well as lawnmowers, forklifts and mining equipment) which, in my opinion, deviate from the definition of a motor vehicle. Generally speaking, motor vehicles typically operate on roads, can travel more than 25mph, are self-propelled and can transport people or materials. In the end I settled on utilizing Data.Category == 'Onroad" because it included most of what would typically be considered motor vehicles.  One interesting note is that the Code of Federal Regulations (CFR) contains a definition of a [motor vehicle](https://www.law.cornell.edu/cfr/text/40/85.1703)

*Identifying Coal Cumbustion Sources*

Similarly, in identifying sources of coal combustion I considered a few approaches, but in the end, settled on using a regular expression and looking for the word "Coal" in EI.Sector in a case sensitive manner.

Running the Code
----
To reproduce the graphs as I have checked them in, complete the following steps:

 1. Get a copy of whatever R code you want to run from this repository, place it in a directory on your computer and make that directory your working directory for R (i.e. `setwd()`)
 2. Download the zip file containing the data and unzip it into your working directory preserving any folder names
 3. Source the R file you want to run (i.e. `source("plot1.R")`

*Note that as a side effect in your R global environment one or more data/values will be created and a png file will be created in your working directory.*

Resources
----

 1. [Clearinghouse for Inventories & Emissions Factors](http://www3.epa.gov/ttnchie1/eiinformation.html)
 2. [R Graphics Cookbook](http://www.cookbook-r.com/Graphs/)
 3. [ggplot2](http://ggplot2.org/)