library(ggplot2)
library(scales)
library(reshape2)

# Setting files location as home location-----------------------------------------
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)

#Reading CSV
DATALOG <- read.csv("../01_ETLOutput-CSV/03_complete-data-pop-days100.CSV")

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
       subtitle = "(CFR = No. of Deaths / No. of confirmed cases)",
       y="CFR [%]", 
       x = "Days since 100 confirmed case",
       caption="@muellertag \n Data Source: https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data")

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