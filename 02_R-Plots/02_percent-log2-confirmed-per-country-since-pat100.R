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
                     DATALOG$country == "Japan"|
                     #DATALOG$country == "South Korea"|
                     DATALOG$country == "US"|
                     DATALOG$country == "Switzerland"
                   ,]
#germany


#Leztes Datum der Datens?tze in der Variable lastsave speichern
#data$date <- as.POSIXct(data$datetime,format="%Y-%m-%d",tz=Sys.timezone())
DATALOG$date2<-as.Date(DATALOG$date)
lastdate <- max(DATALOG$date2)


plt_percent_log2<-ggplot(germany, aes(x=days100, y=PercentOfPopulationConfirmedDecimal, group=country, color=country))+
  scale_y_continuous(trans='log2',labels = scales::percent_format(accuracy = 0.01))+
  #scale_y_continuous()+
  geom_line(aes())+ labs(title= "COVID-2019 | Confirmed",
                         subtitle = paste("Logarithmic y-axis (log2) | ","Last dataset: ",lastdate,sep=""),
                         y="log2 % of population", 
                         x = "Days since 100 confirmed case",
                         caption="@muellertag \n Data Source: https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data")


plot(plt_percent_log2)

#Plot exportieren--------------------------------------------------------------
ggsave(
  #paste( "plot-export/",Sys.Date(),"-03_mortality.pdf", sep=""),
  paste('plot-export/confirmed-percent-log2/',lastdate,'-savedat-',format(Sys.time(), "%Y-%m-%d_%H-%M"),"-02_confirmed-percent-log2.pdf",sep=""),
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
  paste('plot-export/confirmed-percent-log2/100x50_',lastdate,'-savedat-',format(Sys.time(), "%Y-%m-%d_%H-%M"),"-02_confirmed-percent-log2.pdf",sep=""),
  plot = last_plot(),
  device = NULL,
  path = NULL,
  scale = 2,
  width = 100, height = 50, units = "mm",
  dpi = 300,
  limitsize = TRUE
)