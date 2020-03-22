library(ggplot2)
library(scales)
library(reshape2)

library(gganimate)

#install.packages("ggthemes") # Install 

library(ggthemes) # Load

theme_set(theme_bw())

this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)


DATALOG <- read.csv("../01_ETLOutput-CSV/03_complete-data-pop-days100.CSV")


data <- DATALOG[DATALOG$country == "Germany" |
                     DATALOG$country == "Italy"| 
                     DATALOG$country == "Spain"| 
                     DATALOG$country == "United Kingdom"| 
                     #DATALOG$country == "France"| 
                     #DATALOG$country == "Japan"|
                     DATALOG$country == "South Korea"|
                     DATALOG$country == "US"
                   #DATALOG$country == "Switzerland"
                   ,]

data$date2<-as.Date(germany$date)
#data <- data[data$date2 <= '2020-03-18',]
#germany <- germany[germany$days100 <= 2,]
#germany


#Leztes Datum der Datens?tze in der Variable lastsave speichern
#data$date <- as.POSIXct(data$datetime,format="%Y-%m-%d",tz=Sys.timezone())

lastdate <- max(germany$date2)

p <- ggplot(
  data,
  aes(days100, 
      PercentOfPopulationConfirmedDecimal, 
      group = country, 
      color = country)) +
  geom_line() +
  #scale_color_viridis_d() +
  labs(
    #title= "COVID-2019 | Confirmed",
       subtitle = paste("Last dataset: ",lastdate),
       x = "Days since 100 confirmed Cases", 
       y = "% of population",
       caption=paste("@muellertag | Created at ",format(Sys.time(), "%Y-%m-%d %H:%M:%S"),
                     "\n Data Source: https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data")) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 0.01))+
  theme(legend.position = "right")

p+transition_reveal(date2) +
  ggtitle('COVID-19 | Confirmed',
          subtitle = 'Frame {frame} of {nframes}')+
  #labs(title = "Year: {format(frame_time, '%Y-%M-%D')}")+
  view_follow()

#animate(p, heigth=300, width=600)

