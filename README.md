# Football-Data-Analysis
Analysing football (soccer) data using software such as R and Python.


## Premier League 2021-2021 Data: Cards Given By Referees
Using a CSV file of Premier League Data from http://www.football-data.co.uk , I aggregated the yellow/red card data for each referee (both home games and away games), and joined these variables together into a datframe. From this, I calculated the differences in cards dished out in home games vs. away games for each referee. After melting the data into long format, I plotted these differences using ggplot.


![red_yel_plot1](red_yel_plot1.jpeg)
#### Figure 1: A plot showing the differences in home cards vs. away cards given out for each referee in the 2020-2021 English Premier League Season.

From this, we can see that Peter Bankes gave out almost 1 more yellow card per game on average to the away team, compared to the home team. In contrast, Kevin Friend gave away considerably more yellow cards to the home team than to the away team on average (approximately 0.6 cards per game). The difference between red cards given out is considerably smaller than yellow cards, as far fewer red cards are given out on average compared to yellow cards (looking at the data we extracted shows that some referees gave out no red cards for the entire 2020-2021 season).
