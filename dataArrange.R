## File to transform data from XLS format to CSV and from Wide to Long.

rm(list = ls())

library("readxl")
library("stringr")
library(tidyr)
library(dplyr)

# xls files

ordenaLosDatos <- function(file, hasPromedio = T)
{
  my_data <- read_excel(file, na = "NaN")
  if(hasPromedio)
  {
    my_data <- my_data %>% 
              select(-promedio)
  }
  names <- names(my_data)
  names(my_data) <- gsub("St. ", "St_", names)
  
  my_data <- as.data.frame(my_data)
  
  chlorofila <- pivot_longer(my_data, names(my_data)[4:length(names)])
  chlorofila$date <- ISOdate(chlorofila$AÑO, chlorofila$MES, chlorofila$DIA)
  chlorofila <- mutate(chlorofila, estacion = name)
  chlorofila$newSt <- as.numeric(gsub("St_", "", chlorofila$estacion))
  
  chlorofila <- dplyr::arrange(chlorofila, date, newSt)
  return(chlorofila)
}

micro_35_37 <- ordenaLosDatos(file = "data/CHLA_MICRO_35-37Lat.xls", hasPromedio = T)
write.csv(micro_35_37, file="data/micro_35_37.csv")

micro_37_38 <- ordenaLosDatos(file = "data/CHLA_MICRO_37-38_Lat.xls", hasPromedio = F)
write.csv(micro_37_38, file="data/micro_37_38.csv")

np_35_37 <- ordenaLosDatos(file = "data/CHLA_N-P_35-37.xls", hasPromedio = F)
write.csv(np_35_37, file="data/np_35_37.csv")

np_37_38 <- ordenaLosDatos(file = "data/CHLA_N-P_37-38.xls", hasPromedio = F)
write.csv(np_37_38, file="data/np_37_38.csv")

