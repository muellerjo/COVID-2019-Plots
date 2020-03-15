library(ggplot2)
library(scales)
library(reshape2)

DATALOG <- read.csv("C:/Users/Mueller/Dropbox/Privat-Hobby/IT/GitHubRepos/COVID-2019-Plots/03_complete-data-pop-days100.CSV")

CORONA <- DATALOG[DATALOG$country == "Germany" |
                     DATALOG$country == "Italy"| 
                     DATALOG$country == "Spain"| 
                     DATALOG$country == "United Kingdom"| 
                     DATALOG$country == "US"
                   ,]


data = melt(CORONA,id.vars=c("date","country","days100"),
            #measured.vars=c("Confirmed","Deaths","Recovered","MortalityPercent")
            )

data$valuenum <- as.numeric(data$value)
#data$date <- as.POSIXct(data$datetime,format="%Y-%m-%d",tz=Sys.timezone())


ggplot(subset(data, variable %in% c("Confirmed",
                                    "PercentOfPopulationConfirmed",
                                    "PercentOfPopulationRecovered",
                                    "MortalityPercent")),
       aes(x=days100, y=valuenum,group=country,colour=country))+
  #scale_color_manual(values=c("blue","red"))+
  geom_line(aes())+
  #scale_x_datetime(breaks=date_breaks('1 day'), date_labels = "%a, %d.%m.%Y")+
  facet_wrap( ~ variable, scales="free_y",ncol=1, strip.position = "left",
              labeller = as_labeller(c(
                Confirmed = "# Confirmed",
                PercentOfPopulationConfirmed= "% of population\n Confirmed",
                PercentOfPopulationRecovered= "% of population\n Recovered",
                MortalityPercent="% Mortality"
                )))+
  theme(strip.background = element_blank(),
        axis.text.x = element_text(angle = 90,
                                   hjust = 1,
                                   vjust = 0.5),
        strip.placement = "outside", legend.position="top")+
  ylab(NULL)+
  labs(title="COVID-2019", 
                  subtitle="X-Axis in days since 100th confirmed case", 
                  caption="@muellertag\n
       Data Source: github.com/CSSEGISandData/COVID-19", 
                  x="Days since 100th confirmed case")

