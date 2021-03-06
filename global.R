## Author: Jorge F. Cornejo
## Date: March 3, 2020
## Goal: Create an intereactive aplication to explore Chlorophyll data. This
##       aplication is based on the shiny app called escapement_explorer on 
##       github https://github.com/cornejotux/escapement_explorer

##### Load the libraries and format the data
rm(list=ls())

library(dplyr)

 library(data.table)
 require(ggplot2)
 require(ggjoy)

 require(lubridate)
 require(scales)
 library(ggthemes)
 library(shinythemes)
 library(shinyjs)
 library(gridExtra)

 # chl <- read.csv(file="data/CHLA.csv", sep=";", dec=",", na.strings = "NaN", stringsAsFactors = F)
 # 
 # 
 # namesSt <-  names(chl) 
 # chlorofila <- pivot_longer(chl, namesSt[4:length(namesSt)])
 # chlorofila$date <- ISOdate(chlorofila$Year, chlorofila$MES, chlorofila$DIA)
 # 
 # rm(chl, namesSt)

#load("data/dataChl.RData")

micro35 <- read.csv(file = "data/micro_35_37.csv", stringsAsFactors = F)[-1]
micro37 <- read.csv(file = "data/micro_37_38.csv", stringsAsFactors = F)[-1]
np35 <- read.csv(file = "data/np_35_37.csv", stringsAsFactors = F)[-1]
np37 <- read.csv(file = "data/np_37_38.csv", stringsAsFactors = F)[-1]
total35 <- read.csv(file = "data/total_35_37.csv", stringsAsFactors = F)[-1]
total37 <- read.csv(file = "data/total_37_38.csv", stringsAsFactors = F)[-1]

## Archivo con el orden de las estaciones
orden35 <- read.csv(file="data/Estaciones_ordenadas_3537.csv", sep=";", dec=",")
orden37 <- read.csv(file="data/Estaciones_ordenadas_3738.csv", sep=";", dec=",")

## Ahora se combinan los datos con el archivo con el orden de las estaciones
micro35 <- left_join(micro35, orden35, by=c("newSt"="EST"))


### Esto es lo que se debe cambiar!!
### Asignar el set de datos que se quiere usar a Chlorofila

chlorofila <- micro35 ## <--- Aqui se seleccionan los datos!!

##############################

chlorofila <- rename(chlorofila, chl = value, Year = names(chlorofila)[1])
chlorofila$date <- ISOdate(chlorofila$Year, chlorofila$MES, chlorofila$DIA)
chlorofila <- select(chlorofila, Year, MES, DIA, estacion, Orden, newSt, chl, date)

## Calculate de average value by day across all the stations


selectYears <- function(data=escape)
{
    minY <- min(chlorofila$Year, na.rm = T)
    maxY <- max(chlorofila$Year, na.rm = T)
    output <- c(minY, maxY)
    return(output)
}

tab <<- 0
