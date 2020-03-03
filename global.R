## Author: Jorge F. Cornejo
## Date: Jan 24, 2018
## Goal: Create an intereactive presentation to show how
##       escapment have changed over time at the SASAP.Region level

##### This section download the data from KNB and prepare it for Shiny app
rm(list=ls())

#library(data.table)
library(dplyr)
#library(tidyr)
#require(lubridate)
#require(ggplot2)
#require(ggjoy)
#require(scales)
#library(ggthemes)
#library(shinythemes)
#library(shinyjs)
#library(gridExtra)

# Use the file that produce the data for this app.

#escape <- readRDS(file="meanEscapement.RDS")

# chl <- read.csv(file="data/CHLA.csv", sep=";", dec=",", na.strings = "NaN", stringsAsFactors = F)
#   
# namesSt <-  names(chl) 
# data_long <- pivot_longer(chl, namesSt[4:length(namesSt)])
# 
# rm(chl, namesSt)

load("~/Personales/patriciafaundez/ShinyChla/data/dataChl.RData")
data_long <- rename(data_long, estacion = name, chl = value)

selectYears <- function(data=data_long)
{
    minY <- min(data$Year, na.rm = T)
    maxY <- max(data$Year, na.rm = T)
    output <- c(minY, maxY)
    return(output)
}

R <<- NULL
S <<- NULL
tab <<- 0

estaciones <- unique(data_long$estacion)
