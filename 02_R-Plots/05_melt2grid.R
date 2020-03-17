library(ggplot2)
library(scales)
library(reshape2)

# Setting files location as home location
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)

#Reading CSV
DATALOG <- read.csv("../01_ETLOutput-CSV/03_complete-data-pop-days100.CSV")


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

#Leztes Datum der Datensätze in der Variable lastsave speichern
#data$date <- as.POSIXct(data$datetime,format="%Y-%m-%d",tz=Sys.timezone())
data$date2<-as.Date(data$date)
lastdate <- max(data$date2)



#Save the Plot as PDF-File
#filename=sys.date()

#pdf(file =paste( "plot-export/",Sys.Date(),"-05_melt2grid.pdf", sep=""),   # The directory you want to save the file in
#    width = 4, # The width of the plot in inches
#    height = 4,
#    paper = 'a4',
#    ) # The height of the plot in inches


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
  labs(title="COVID-2019 | Wrap Plot", 
                  subtitle=paste("X-Axis in days since 100th confirmed case \nLast dataset:",lastdate), 
                  caption="@muellertag\n
       Data Source: github.com/CSSEGISandData/COVID-19", 
                  x="Days since 100th confirmed case")

#Plot exportieren--------------------------------------------------------------
ggsave(
  #paste( "plot-export/",Sys.Date(),"-05_melt2grid.pdf", sep=""),
  paste('plot-export/',lastdate,'-savedat-',format(Sys.time(), "%Y-%m-%d_%H-%M"),"-05_melt2grid.pdf",sep=""),
  plot = last_plot(),
  device = NULL,
  path = NULL,
  scale = 1,
  width = 210, height = 297, units = "mm",
  dpi = 300,
  limitsize = TRUE
)

