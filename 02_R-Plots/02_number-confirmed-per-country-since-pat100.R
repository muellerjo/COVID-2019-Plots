library(ggplot2)
library(scales)
library(reshape2)

DATALOG <- read.csv("../01_ETLOutput-CSV/03_complete-data-pop-days100.CSV")


germany <- DATALOG[DATALOG$country == "Germany" |
                     DATALOG$country == "Italy"| 
                     DATALOG$country == "Spain"| 
                     DATALOG$country == "United Kingdom"| 
                     DATALOG$country == "France"| 
                     DATALOG$country == "US"|
                     DATALOG$country == "Switzerland"
                   ,]
#germany

ggplot(germany, aes(x=days100, y=Confirmed, group=country, color=country))+
  #scale_y_continuous(trans='log2')+
  geom_line(aes())+ labs(title= "COVID-2019 | Confirmed",
                         #subtitle = "Confirmed cases in percent of population since 100 confirmed case",
                         y="# of Cases", 
                         x = "Days since 100 confirmed case",
                         caption="@muellertag \n Data Source: https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data")


#Plot exportieren--------------------------------------------------------------
ggsave(
  #paste( "plot-export/",Sys.Date(),"-03_mortality.pdf", sep=""),
  paste('plot-export/confirmed-number-since-pat-100/DINa4/',lastdate,'-savedat-',format(Sys.time(), "%Y-%m-%d_%H-%M"),"-02_confirmed-number.pdf",sep=""),
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
  paste('plot-export/confirmed-number-since-pat-100/500x500/',lastdate,'-savedat-',format(Sys.time(), "%Y-%m-%d_%H-%M"),"-02_confirmed-number.pdf",sep=""),
  plot = last_plot(),
  device = NULL,
  path = NULL,
  scale = 2,
  width = 100, height = 50, units = "mm",
  dpi = 300,
  limitsize = TRUE
)