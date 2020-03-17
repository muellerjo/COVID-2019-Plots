library(ggplot2)
library(scales)
library(reshape2)

# Setting files location as home location-----------------------------------------
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)

#Reading CSV
DATALOG <- read.csv("../01_ETLOutput-CSV/03_complete-data-pop-days100.CSV")


#Leztes Datum der Datensätze in der Variable lastsave speichern
#data$date <- as.POSIXct(data$datetime,format="%Y-%m-%d",tz=Sys.timezone())
DATALOG$date2<-as.Date(DATALOG$date)
lastdate <- max(DATALOG$date2)





#Filtering data for wanted countries----------------------------------------------
germany <- DATALOG[DATALOG$country == "Germany" |
                     DATALOG$country == "Italy"| 
                     DATALOG$country == "Spain"| 
                     DATALOG$country == "United Kingdom"| 
                     DATALOG$country == "US"|
                     #DATALOG$country == "France"|
                     DATALOG$country == "Switzerland"
                   ,]
#germany



ggplot(germany, aes(x=days100, 
                    y=MortalityPercent, 
                    group=country, 
                    color=country))+
  geom_line(aes())+
  labs(title= "COVID-2019 | Case Fatality Ratio (CFR)",
       subtitle = paste("(CFR = No. of Deaths / No. of confirmed cases) \n",'Last dataset:',lastdate,sep=""),
       y="CFR [%]", 
       x = "Days since 100 confirmed case",
       caption=paste("@muellertag | Created at ",format(Sys.time(), "%Y-%m-%d_%H-%M"),
       "\n Data Source: https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data"))

#Plot exportieren--------------------------------------------------------------
ggsave(
  #paste( "plot-export/",Sys.Date(),"-03_mortality.pdf", sep=""),
  #paste('plot-export/',lastdate,'-savedat-',format(Sys.time(), "%Y-%m-%d_%H-%M"),"_mortality.pdf",sep=""),
  paste('plot-export/mortality/',lastdate,'-savedat-',format(Sys.time(), "%Y-%m-%d_%H-%M"),"_mortality.pdf",sep=""),
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
  paste('plot-export/mortality/','100x50_',lastdate,'-savedat-',format(Sys.time(), "%Y-%m-%d_%H-%M"),"_mortality.pdf",sep=""),
  plot = last_plot(),
  device = NULL,
  path = NULL,
  scale = 2,
  width = 100, height = 50, units = "mm",
  dpi = 300,
  limitsize = TRUE
)