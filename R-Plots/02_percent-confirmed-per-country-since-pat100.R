library(ggplot2)
library(scales)
library(reshape2)

DATALOG <- read.csv("C:/Users/Mueller/Dropbox/Privat-Hobby/IT/GitHubRepos/COVID-2019-Plots/03_complete-data-pop-days100.CSV")


germany <- DATALOG[DATALOG$country == "Germany" |
                     DATALOG$country == "Italy"| 
                     DATALOG$country == "Spain"| 
                     DATALOG$country == "United Kingdom"| 
                     DATALOG$country == "France"| 
                     DATALOG$country == "US"|
                     DATALOG$country == "Switzerland"
                   ,]
#germany

ggplot(germany, aes(x=days100, y=PercentOfPopulationConfirmed, group=country, color=country))+
  geom_line(aes())+ labs(title= "COVID-2019",
                         subtitle = "Confirmed cases in percent of population since 100 confirmed case",
                         y="% of population", 
                         x = "Days since 100 confirmed case",
                         caption="@muellertag \n Data Source: https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data")