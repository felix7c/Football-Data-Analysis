#data from 'http://www.football-data.co.uk/mmz4281/2021/E0.csv'

library(dplyr)
library(ggplot2)
library(reshape2)

#read in csv file from website
epl_21 = read.csv('http://www.football-data.co.uk/mmz4281/2021/E0.csv')

#calculate mean amount of yellow cards given to home team per referee
h_yellows=aggregate(epl_21$HY, by=list(Referee=epl_21$Referee), FUN=mean)

#calculate mean amount of yellow cards given to away team per referee
a_yellows=aggregate(epl_21$AY, by=list(Referee=epl_21$Referee), FUN=mean)

#calculate mean amount of red cards given to home team per referee
h_reds=aggregate(epl_21$HR, by=list(Referee=epl_21$Referee), FUN=mean)

#calculate mean amount of red cards given to away team per referee
a_reds=aggregate(epl_21$AR, by=list(Referee=epl_21$Referee), FUN=mean)


#joining the variables together
referee_data= h_yellows %>%
  inner_join(a_yellows, by="Referee") %>%
    inner_join(h_reds, by="Referee")%>%
      inner_join(a_reds, by="Referee")

#rename columns
referee_data=rename(referee_data,home_yellows=x.x,away_yellows=x.y,home_reds=x.x.x,away_reds=x.y.y)

#create columns for difference in yellow/red cards
referee_data=mutate(referee_data,yel_dif=home_yellows-away_yellows,red_dif=home_reds-away_reds)

#convert data to 'long' format for ease of plotting
referee_data_long <- melt(referee_data,id="Referee",measure = c("yel_dif","red_dif"))

#plotting 
ggplot(referee_data_long,aes(Referee,value,fill=variable)) + geom_col(position = 'dodge2',col='black')+
  scale_fill_manual(values=c("yellow", "red"),labels = c("Yellow Cards", "Red Cards"))+ #custom colours + axis labels 
  labs(title = "Difference in Mean Cards Given Per Game",y="Card Difference (Home Cards - Away Cards)", fill="Type of Card")+
  theme_minimal()+ #add minimalistic theme
  theme(axis.text.x = element_text(angle = 90,vjust=0.5, hjust=1)) #rotate x axis labels and shift their position slightly



