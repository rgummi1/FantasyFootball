%MAIN. THIS IS MAIN
clear all; close all; clc

%%
%START INPUTS
week=10;
%END INPUTS
%%
fopen1=strcat('Outputs\Points2016weeks',int2str(week),'maxpointsFalse.csv');
fopen2=strcat('Outputs\Points2016weeks',int2str(week),'maxpointsTrue.csv');
Points=importdata(fopen1);
data=Points.data(:,1:end-1);
[t,weeks]=size(data);
teams=Points.textdata(2:end,1);


PointsSTD=zeros(length(teams),2);
percentmax=zeros(length(teams),1);
TotalWins=zeros(length(teams),weeks+1);

PointsSTD(:,1)=sum(data,2)/weeks; %totpoints
PointsSTD(:,2)=std(data,0,2); %std
    
if exist(fopen2,'file')==2
    Maxpoints=importdata(fopen2);
    MaxPointsdata=sum(Maxpoints.data,2);
    for i=1:length(teams)
        percentmax(i,1)=(PointsSTD(i,1)*weeks)/MaxPointsdata(i);
    end
else
    percentmax=zeros(length(teams),1);
end
clear fopen1;clear fopen2;

for i=1:length(teams)
    for j=1:weeks
        TotalWins(i,1)=TotalWins(i,1)+(sum(data(i,j)>data(:,j)));
        TotalWins(i,j+1)=sum(data(i,j)>data(:,j));
    end
end

ranks=cell(length(teams)+1,11);
temp2=zeros(length(teams),9);
temp2(:,3:4)=PointsSTD; %average points, std
%temp2(:,3)=mean(data,2)./sum(data,2);
%temp2(:,4)=std(data,0,2)/mean(data,2);
%temp2(:,5)=(sum(data(:,(end-2):end),2))/3; %average points in last 3 weeks
j=0;
for i=1:week
   temp2(:,5)=data(:,end+1-i)/i+temp2(:,5);
   j=j+1/i;
end
temp2(:,5)=temp2(:,5)./j;
temp2(:,6)=TotalWins(:,1)/sum(TotalWins(:,1));
temp2(:,7)=temp2(:,6)*(length(teams)/2)*weeks;
temp2(:,8)=Points.data(:,end);
temp2(:,10)=percentmax; %managerial efficiency
%Get the Luck Index
run('C:\Users\Rohit\Documents\GitHub\FantasyFootball\ffWinsProbability.m')
temp2(:,9)=luck;
temp2(:,2)=temp2(:,3)-(mean(temp2(:,3))*temp2(:,4))./temp2(:,3)+temp2(:,5)+temp2(:,6)*300; %CALCULATE POWER HERE

[~,b]=sort(temp2(:,2),'descend');
temp2=temp2(b,:);
temp2(:,1)=1:length(teams);
teams2=teams(b);

%Finishing rank matrix which is going to be written into the excell file
if sum(percentmax)>0
    ranks(1,:)={'Team','Rank','Weighted Score(Avg+3WkAvg-Std+300*%Wins)','Points per Game','STD','Avereage Points in last 3 weeks','Percent of Total Wins(if you played everyone every week)','Expected Wins(not used in score)(based on W-L if you played everyone every week)','True Wins','Luck Index*(not used in score)(Higher the POSITIVE number-the more UNLUCKY you''ve been. The lower the NEGATIVE number-the LUCKier you''ve been','Managerial efficiency(not used in score)(How many points you scored out of your max. 100% you coudln''t have score more by starting anyone on your bench.)'};
else
    ranks(1,:)={'Team','Rank','Weighted Score(Avg+3WkAvg-Std+300*%Wins)','Points per Game','STD','Avereage Points in last 3 weeks','Percent of Total Wins(if you played everyone every week)','Expected Wins(not used in score)(based on W-L if you played everyone every week)','True Wins','Luck Index*(not used in score)(Higher the POSITIVE number-the more UNLUCKY you''ve been. The lower the NEGATIVE number-the LUCKier you''ve been','N/A'};
end
ranks(2:end,1)=teams2;
ranks(2:end,2:end)=num2cell(temp2);

%make the matrixes to estimate win distributions
%estprobmatrix is the estimate from a simulation of all realistic schedules
%probmatrix is the exact probabilities of wins given all possible
%(11^weeks) schedules. this includes schedules where one team plays another
%over and over again.
%cdfprobmatrxi is the reverse of whichever of the above two you set it
%equal to
estprobmatrix=cell(length(teams)+1,weeks+2);%simulated matrix of all realistic schedules
estprobmatrix(2:end,1)=teams;
estprobmatrix(1,2:end)=num2cell(0:weeks);
estprobmatrix(1,1)={'Wins->'};
for i=1:t
    temp=ffSimWinDist(i,data);
    %actual luck matrix
    temp2=Points.data(i,end);
    luck(i)=100*(sum(temp(temp2+2:end))-sum(temp(1:temp2)))/temp(temp2+1);
    estprobmatrix(i+1,2:end)=num2cell(temp);
end
ranks(2:end,10)=num2cell(luck(b));
cdfprobmatrix=estprobmatrix;%exact matrix of all possible schedules(includes schedules where same team is played multiple times
temp=cdfprobmatrix(2:end,:);
cdfprobmatrix(2:end,1)=teams2;
temp=temp(b,:);
for i=1:weeks+1
    cdfprobmatrix(2:end,i+1)=num2cell(sum(cell2mat(temp(:,(i+1):end)),2));
end

clear PointsSTD; clear TotalWins; clear temp2; clear teams2;
clear percentmax; clear MaxPointsdata;

%%
%Writing excell

fid=fopen(strcat('Outputs\Ranks-Week',int2str(weeks),'.csv'),'w');
fprintf(fid,'%s,',ranks{1,1:end-1});
fprintf(fid,'%s\n',ranks{1,end});
for i=1:length(teams)
    fprintf(fid,'%s, %d, %2.1f, %2.1f, %2.1f, %2.1f, %.3f, %2.1f, %d, %2.0f, %.3f\n',ranks{i+1,:});
end
fprintf(fid,'%s\n','');
fprintf(fid,'%s\n','');
fprintf(fid,'%s\n','');
fprintf(fid,'%s\n','');
fprintf(fid,'%s\n','');
fprintf(fid,'%s\n','');
fprintf(fid,'%s\n','');
fprintf(fid,'%s\n','');
temp={'I found this interesting. This is what I used for the luck index. It''s a chart of how likely you are to have a certain number of wins or more given a random schedule','e.g. Sherwin would always have at least 1 win because he was the highest scorer week 1. So no matter what schedule we choose'' Sherwin gets at least one win. Each column is every teams probability of having at least the number of wins of that column if we replayed the season with a randomzied schedule.'};%,'*This might overestimate the good teams unluckiness and bad teams luckiness. But my computer isn''t good enough for more acuracy and idk efficient coding.'};
fprintf(fid,'%s\n',temp{1:end});

for i=1:t+1
    fprintf(fid,'%s,',cdfprobmatrix{i,1});
    for j=2:weeks+1
       fprintf(fid,'%2.3f,',cdfprobmatrix{i,j});
    end
    fprintf(fid,'%2.2f\n',cdfprobmatrix{i,end});
end
fclose(fid);


clear ans; clear i; clear j; clear fid; clear weeks; clear teams;
clear ProbWinmore; clear ProbLosemore; clear winprob;clear luckindex; clear realwins;
clear winperms;clear loseperms;clear weekwinprob;clear weekloseprob;clear wins; 
clear team; clear t; clear temp; clear luck; clear data;

a=cell2mat(cdfprobmatrix(2:end,2:end));
%a=a(b,:);
plot(0:week,a','linewidth',2)
legend(cdfprobmatrix(2:end,1))
axis([0 week 0 1]);
xlabel('wins'); ylabel('probability');
a=cell2mat(ranks(2:end,9));
for i=1:length(a)
a2(i)=(cdfprobmatrix(i+1,a(i)+2));
end
a2=cell2mat(a2);
hold all
scatter(a,a2,100,'r');
clear b; clear a; clear a2; clear i