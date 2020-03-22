#require(data.table)

#library(tibble)
library(dplyr)
library(ggplot2)
#library(TTR)

this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)

DATALOG <- read.csv("../01_ETLOutput-CSV/03_complete-data-pop-days100.CSV")

#read.csv(file="result1", sep=" ", colClasses=c("NULL", NA, NA))

moddat = DATALOG[,c('date', 'country', 'Confirmed')]; 


data <- moddat[moddat$country == "Germany" 
               #| moddat$country == "Italy"
               ,]

#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union


#data$date <- as.POSIXct(data$date)

data<-data %>%
  group_by(country) %>%
  arrange(date) %>%
  mutate(diff = Confirmed - lag(Confirmed, default = first(Confirmed))) %>%
  mutate(diffpercent = Confirmed / lag(Confirmed, default = first(Confirmed)) -1 )  

#data<-data %>%
#  group_by(country) %>%
#  arrange(date) %>%
#  mutate(diffpercent = Confirmed / lag(Confirmed, default = first(Confirmed)) -1 )

data$date<-as.Date(data$date)

#add moving average
#data$sma <-SMA(data$diffpercent, n = 0)


number<-ggplot(data, aes
               (x=date, 
                 y=diffpercent, 
                 group=country, 
                 color=country))+
  #scale_y_continuous(labels=function(x) format(x, big.mark = ",", scientific = FALSE))+
  scale_y_continuous(labels = scales::percent_format(accuracy = 1))+
  geom_hline(yintercept = mean(data$diffpercent), color="blue",linetype="dashed")+
  geom_line(aes())+
  labs(title= "COVID-2019 | GERMANY | New Confirmed Cases per Day [%]",
       subtitle = paste("Last dataset: ",lastdate,"\nMean Growth per Day: ",(round(mean_growth*100,2))," % (blue)",
                        "\nLast Growth per Day ",(round(last_growth*100,2))," % (red)",sep=""),
       y="New Cases per Day [%]", 
       x = "Date",
       caption="@muellertag \n Data Source: https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data")


plot(number)

#Plot exportieren--------------------------------------------------------------

plot_path <- 'plot-export/number_of_new_cases-percent/'
plot_title <- '_number_of_new_cases-percent.pdf'

ggsave(
  #paste( "plot-export/",Sys.Date(),"-03_mortality.pdf", sep=""),
  paste(plot_path,lastdate,'-savedat-',format(Sys.time(), "%Y-%m-%d_%H-%M"),plot_title,sep=""),
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
  paste(plot_path,'100x50_',lastdate,'-savedat-',format(Sys.time(), "%Y-%m-%d_%H-%M"),plot_title,sep=""),
  plot = last_plot(),
  device = NULL,
  path = NULL,
  scale = 2,
  width = 100, height = 50, units = "mm",
  dpi = 300,
  limitsize = TRUE
)