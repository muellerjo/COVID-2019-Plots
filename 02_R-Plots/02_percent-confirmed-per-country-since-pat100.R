library(ggplot2)
library(scales)
library(reshape2)

this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)


DATALOG <- read.csv("../01_ETLOutput-CSV/03_complete-data-pop-days100.CSV")






germany <- DATALOG[DATALOG$country == "Germany" |
                     DATALOG$country == "Italy"| 
                     DATALOG$country == "Spain"| 
                     DATALOG$country == "United Kingdom"| 
                     #DATALOG$country == "France"| 
                     #DATALOG$country == "Japan"|
                     #DATALOG$country == "South Korea"
                     DATALOG$country == "US"|
                     DATALOG$country == "Switzerland"
                   ,]

germany$date2<-as.Date(germany$date)
#germany <- germany[germany$date2 <= '2020-03-18',]
#germany <- germany[germany$days100 <= 2,]
#germany


#Leztes Datum der Datens?tze in der Variable lastsave speichern
#data$date <- as.POSIXct(data$datetime,format="%Y-%m-%d",tz=Sys.timezone())

lastdate <- max(germany$date2)



percent<-ggplot(germany, 
                 aes(x=days100, 
                     y=PercentOfPopulationConfirmedDecimal, 
                     group=country, color=country))+
  scale_y_continuous(labels = scales::percent_format(accuracy = 0.01))+
  #scale_y_continuous(labels = scales::percent_format(accuracy = 0.01))+
  geom_line(aes())+ 
  #scale_size(range = c(2, 40), guide="none")+
  #scale_size_manual(values = c(5, 1))+
  labs(title= "COVID-2019 | Confirmed",
       subtitle = paste("Last dataset: ",lastdate),
       y="% of population",
       x = "Days since 100 confirmed case",
       caption="@muellertag \n Data Source: https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data")

plot(percent)

#Plot exportieren--------------------------------------------------------------
ggsave(
  #paste( "plot-export/",Sys.Date(),"-03_mortality.pdf", sep=""),
  paste('plot-export/confirmed-percent-since-pat-100/',lastdate,'-savedat-',format(Sys.time(), "%Y-%m-%d %H-%M-%S"),"-02_confirmed-percent.pdf",sep=""),
  plot = last_plot(),
  device = NULL,
  path = NULL,
  scale = 1,
  width = 297, height = 210, units = "mm",
  dpi = 300,
  limitsize = TRUE
)

#Plot exportieren--------------------------------------------------------------
ggsave(
  #paste( "plot-export/",Sys.Date(),"-03_mortality.pdf", sep=""),
  paste('plot-export/confirmed-percent-since-pat-100/100x50_',lastdate,'-savedat-',format(Sys.time(), "%Y-%m-%d_%H-%M-%S"),"-02_confirmed-percent.pdf",sep=""),
  plot = last_plot(),
  device = NULL,
  path = NULL,
  scale = 2,
  width = 100, height = 50, units = "mm",
  dpi = 300,
  limitsize = TRUE
)