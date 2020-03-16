library(ggplot2)
library(scales)
library(reshape2)

DATALOG <- read.csv("../01_ETLOutput-CSV/03_complete-data-pop-days1.CSV")

#DATALOG$x..Confirmed <- (DATALOG$Confirmed / (DATALOG$.pop2020*1000))*100

#ggplot(DATALOG, aes(x=days, y=Confirmed, group=country, color=country))+ geom_line(aes())

germany <- DATALOG[DATALOG$country == "Germany" |
                     DATALOG$country == "Italy"| 
                     DATALOG$country == "Spain"| 
                     DATALOG$country == "Switzerland"
                   ,]
#germany

ggplot(germany, aes(x=days1, y=PercentOfPopulationConfirmed, group=country, color=country))+
  geom_line(aes())+ labs(title= "COVID-2019",
                         subtitle = "Confirmed cases in percent of population",
                         y="% of population", 
                         x = "Days since first confirmed case",
                         caption="@muellertag \n Data Source: https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data")