## Author: Jorge F. Cornejo
## Date: Jan 24, 2018
## Goal: Create an intereactive presentation to show how
##       escapment have changed over time at the SASAP.Region level

##### This section download the data from KNB and prepare it for Shiny app
rm(list=ls())

library(data.table)
library(dplyr)
require(lubridate)
require(ggplot2)
require(ggjoy)
require(scales)
library(ggthemes)
library(shinythemes)
library(shinyjs)
library(gridExtra)

# Use the file that produce the data for this app.

escape <- readRDS(file="meanEscapement.RDS")


selectYears <- function(data=escape)
{
    minY <- min(data$sampleYear, na.rm = T)
    maxY <- max(data$sampleYear, na.rm = T)
    output <- c(minY, maxY)
    return(output)
}

R <<- NULL
S <<- NULL
tab <<- 0
