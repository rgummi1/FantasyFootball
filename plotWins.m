%plot wins, Add-on to WinsStatsRegression

for i=1:length(teams)
    loc=i:14:length(fin);
    plot(cell2mat(fin(loc,5)))
    hold all;
    legend(teams)
end