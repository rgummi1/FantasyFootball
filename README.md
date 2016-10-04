# FantasyFootball

interesting things to be done with ESPN fantasy football leagues

Run 'ESPN PowerRanks' in python. Then 'ffPowerRanks' in Matlab. You will get a file called 'Ranks-week#.csv'. Those are the team ranks. 
Teams are ranked based on a score of (Average Weekly Score)+(Last 3 Weeks Average)-(standard deviation of scores)+300(% of total wins you would have if you played everyone every week)

'ESPN PowerRanks' outputs a file called 'Points####weeks#maxpointsFalse.csv'. 'ffPowerRanks' uses that file to calculate a score for each team, rank them, and output the 'Ranks-week#.csv' fle.

'ESPN PowerRanks' can also be used to extract the max score of each team each week(if they played the right people on the bench weekly), by changing the returnmax input in the code to True.
