library(ggpubr)

ggarrange(number
          , percent
          , plt_percent_log2
          , cfr
          ,  
          #labels = c("A", "B", "C"),
          ncol = 2, nrow = 2)