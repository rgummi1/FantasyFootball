function [ windist ] = ffSimWinDist(team,data )
%ADD-ON to ffPowerRanks
%Calculates probability of a team having a certain number of win given
%randomized schedule where you can't play the same team twice
[t,weeks]=size(data);
windist=zeros(1,weeks+1);

for runs=1:90000
    sched=[0:team-1 team+1:t+1];
    sched=sched(2:end-1);
    temp=rand(1,length(sched));
    [~,b2]=sort(temp);
    sched=sched(b2);
    wins=0;
    for i=1:weeks
        if(data(team,i)>data(sched(mod(i,length(sched))),i))
            wins=wins+1;
        end        
    end
    windist(wins+1)=windist(wins+1)+1;
end
windist=windist/sum(windist);

end

