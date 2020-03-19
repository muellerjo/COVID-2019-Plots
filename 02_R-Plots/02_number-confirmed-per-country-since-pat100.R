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
                     DATALOG$country == "US"|
                     DATALOG$country == "Switzerland"
                   ,]
#germany

number<-ggplot(germany, aes(x=days100, y=Confirmed, group=country, color=country))+
  scale_y_continuous(labels=function(x) format(x, big.mark = ".", scientific = FALSE))+
  geom_line(aes())+ labs(title= "COVID-2019 | Number of Confirmed Cases",
                         #subtitle = "Confirmed cases in percent of population since 100 confirmed case",
                         y="# of Cases", 
                         x = "Days since 100 confirmed case",
                         caption="@muellertag \n Data Source: https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data")


plot(number)

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
  paste('plot-export/confirmed-number-since-pat-100/100x50_',lastdate,'-savedat-',format(Sys.time(), "%Y-%m-%d_%H-%M"),"-02_confirmed-number.pdf",sep=""),
  plot = last_plot(),
  device = NULL,
  path = NULL,
  scale = 2,
  width = 100, height = 50, units = "mm",
  dpi = 300,
  limitsize = TRUE
)