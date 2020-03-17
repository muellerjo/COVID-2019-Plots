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

ggplot(germany, aes(x=days100, y=PercentOfPopulationConfirmedDecimal, group=country, color=country))+
  scale_y_continuous(trans='log2',labels = percent)+
  #scale_y_continuous()+
  geom_line(aes())+ labs(title= "COVID-2019 | Confirmed",
                         subtitle = "Logarithmic y-axis (log2)",
                         y="log2 % of population", 
                         x = "Days since 100 confirmed case",
                         caption="@muellertag \n Data Source: https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data")


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