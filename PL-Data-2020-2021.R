#data from 'http://www.football-data.co.uk/mmz4281/2021/E0.csv'

library(dplyr) #for data manipulation etc
library(ggplot2) #for graphs
library(reshape2) #melting data
library(gridExtra) #for plotting multiple graphs in a grid with ggplot

#read in csv file from website
epl_21 = read.csv('http://www.football-data.co.uk/mmz4281/2021/E0.csv')

#spotted an error when working with data - entry of 'A Moss' as referee should be renamed to 'J Moss'
epl_21$Referee[epl_21$Referee == "A Moss"] <- "J Moss"

#REFEREE DATA

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


#GOALS SCORED/CONCEDED DATA

#first, will create a list of colours for plotting each team with their club colour
prem_colours=c("red", "violetred","blue","violetred","blue","darkmagenta","blue","black","dodgerblue4","blue","red","lightskyblue","red",
               "black","red","red","midnightblue","midnightblue","violetred","tan2")

#calculate amount of home goals scored per team
h_goals=aggregate(epl_21$FTHG, by=list(team=epl_21$HomeTeam), FUN=sum)

#calculate amount of away goals scored per team
a_goals=aggregate(epl_21$FTAG, by=list(team=epl_21$AwayTeam), FUN=sum)

#calculate amount of home goals conceded per team
h_concede=aggregate(epl_21$FTAG, by=list(team=epl_21$HomeTeam), FUN=sum)

#calculate amount of away goals conceded per team
a_concede=aggregate(epl_21$FTHG, by=list(team=epl_21$AwayTeam), FUN=sum)


#joining the variables together
h_a_goals_data= h_goals %>%
  inner_join(a_goals, by="team") %>%
  inner_join(h_concede, by="team")%>%
  inner_join(a_concede, by="team")

#rename columns
h_a_goals_data=rename(h_a_goals_data,home_goals=x.x,away_goals=x.y,home_concede=x.x.x,away_concede=x.y.y)

#correlation table between each of the four values
cor_goals=cor(h_a_goals_data[2:5])
cor_goals=round(cor_goals,2)


#plotting home goals scored and away goals scored 
h_a_g<- ggplot(h_a_goals_data,aes(home_goals,away_goals,color=team))+
  geom_point(aes(color=team))+
  geom_text(aes(home_goals,away_goals, label=team,  hjust = 0.4, vjust = 1.2),data=h_a_goals_data,show.legend = FALSE)+
  labs(title = "Scatter Plot of Home Goals and Away Goals Scored For Each EPL Team",x="Home Goals Scored",y="Away Goals Scored")+
  guides(color="none")+ #hides legend
  theme_minimal()+
  scale_color_manual(values=prem_colours) #add team colours
  
#plotting home goals conceded and away goals conceded
h_a_c<- ggplot(h_a_goals_data,aes(home_concede,away_concede,color=team))+
  geom_point(aes(color=team))+
  geom_text(aes(home_concede,away_concede, label=team,  hjust = 0.4, vjust = 1.2),data=h_a_goals_data,show.legend = FALSE)+
  labs(title = "Scatter Plot of Home Goals Conceded and Away Goals Conceded For Each EPL Team",x="Home Goals Conceded",y="Away Goals Conceded")+
  guides(color="none")+ #hides legend
  theme_minimal()+
  scale_color_manual(values=prem_colours) #add team colours

#plotting home goals scored and home goals conceded 
h_h_g_c<- ggplot(h_a_goals_data,aes(home_goals,home_concede,color=team))+
  geom_point(aes(color=team))+
  geom_text(aes(home_goals,home_concede, label=team,  hjust = 0.4, vjust = 1.2),data=h_a_goals_data,show.legend = FALSE)+
  labs(title = "Scatter Plot of Home Goals Scored and Conceded For Each EPL Team",x="Home Goals Scored",y="Home Goals Conceded")+
  guides(color="none")+ #hides legend
  theme_minimal()+
  scale_color_manual(values=prem_colours) #add team colours

#plotting away goals scored and away goals conceded 
a_a_g_c<- ggplot(h_a_goals_data,aes(away_goals,away_concede,color=team))+
  geom_point(aes(color=team))+
  geom_text(aes(away_goals,away_concede, label=team,  hjust = 0.4, vjust = 1.2),data=h_a_goals_data,show.legend = FALSE)+
  labs(title = "Scatter Plot of Away Goals Scored and Conceded For Each EPL Team",x="Away Goals Scored",y="Away Goals Conceded")+
  guides(color="none")+ #hides legend
  theme_minimal()+
  scale_color_manual(values=prem_colours) #add team colours


grid.arrange(h_a_g,h_a_c,h_h_g_c,a_a_g_c) #plot all four graphs on one plot



