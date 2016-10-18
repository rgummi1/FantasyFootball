function [ windist, luckindex ] = ffExtWinDist( team, data )
%ADD-ON to ffPowerRanks
%Calculates probability of a team having a certain number of win given
%randomized schedule. This includes all possible schedules, including ones
%where the same team is played multiple times

[t,weeks]=size(data);
windist=zeros(1,weeks+1);

winperms=zeros(2^(weeks),weeks); %which weeks have a win
for i=0:(2^(weeks)-1)
    temp=de2bi(i);
    winperms(i+1,1:length(temp))=de2bi(temp);
end
loseperms=ones(2^(weeks),weeks)-winperms;

for wins=0:weeks
    weekwinprob=zeros(1,weeks);
    for i=1:weeks
        weekwinprob(i)=sum(data(:,i)<data(team,i))/(t-1);
    end
    weekloseprob=ones(1,weeks)-weekwinprob;
    ProbWinmore=0;
    for i=1:2^(weeks)
        if sum(winperms(i,:))==wins
            ProbWinmore=ProbWinmore+prod((winperms(i,:).*(weekwinprob))+(loseperms(i,:).*(weekloseprob)));
        end    
    end
    windist(1,wins+1)=ProbWinmore;
end

luckindex=zeros(1,weeks+1); %make matrix of luckindex. where for each win, it has a score of (prob winning more-prob winning less/prob having that many wins)
for wins=0:weeks
    luckindex(1,wins+1)=100*(sum(windist(1,wins+1:end))-sum(windist(1,1:wins+1)))/(windist(1,wins+1)+1e-99);
end