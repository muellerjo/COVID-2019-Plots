library(ggplot2)
library(scales)
library(reshape2)

# Setting files location as home location
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)

#Reading CSV
DATALOG <- read.csv("../01_ETLOutput-CSV/03_complete-data-pop-days100.CSV")


germany <- DATALOG[DATALOG$country == "Germany" |
                     DATALOG$country == "Italy"| 
                     DATALOG$country == "Spain"| 
                     DATALOG$country == "United Kingdom"| 
                     DATALOG$country == "US"|
                     DATALOG$country == "Switzerland"
                   ,]
#germany

ggplot(germany, aes(x=days100, 
                    y=MortalityPercent, 
                    group=country, 
                    color=country))+
  geom_line(aes())+
  labs(title= "COVID-2019 | Mortality",
       #subtitle = "Confirmed cases in percent of population since 100 confirmed case",
       y="% Mortality", 
       x = "Days since 100 confirmed case",
       caption="@muellertag \n Data Source: https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data")