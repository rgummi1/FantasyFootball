clear all; close all; clc

%%
%START INPUTS
week=4;
%END INPUTS
%%
fopen1=strcat('Points2016weeks',int2str(week),'maxpointsFalse.csv');
fopen2=strcat('Points2016weeks',int2str(week),'maxpointsTrue.csv');
Points=importdata(fopen1);
data=Points.data;
[~,weeks]=size(data);
teams=Points.textdata(2:end,1);


PointsSTD=zeros(length(teams),2);
percentmax=zeros(length(teams),1);
TotalWins=zeros(length(teams),weeks+1);
for i=1:length(teams)
    PointsSTD(i,1)=sum(data(i,:))/weeks; %totpoints
    PointsSTD(i,2)=std(data(i,:)); %std
end
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

ranks=cell(length(teams)+1,9);
temp2=zeros(length(teams),8);
temp2(:,3:4)=PointsSTD;
temp2(:,5)=(sum(data(:,(end-2):end),2))/3;
temp2(:,6)=TotalWins(:,1)/sum(TotalWins(:,1));
%temp2(:,6)=sum(TotalWins(:,(end-2):end),2)/(66*3);
temp2(:,7)=temp2(:,6)*(length(teams)/2)*weeks;
temp2(:,8)=percentmax;
temp2(:,2)=temp2(:,3)-temp2(:,4)+temp2(:,5)+temp2(:,6)*300; %CALCULATE POWER HERE

[~,b]=sort(temp2(:,2),'descend');
temp2=temp2(b,:);
temp2(:,1)=1:length(teams);
teams=teams(b);

if sum(percentmax)>0
    ranks(1,:)={'Team','Rank','Weighted Score(Avg+3WkAvg-Std+300*%Wins)','Points per Game','STD','Avereage Points in last 3 weeks','Percent of Total Wins(if you played everyone every week)','Expected W-L(not used in score)(based on W-L if you played everyone every week)','Managerial efficiency(not used in score)(How many points you scored out of your max. 100% mean no one on your bench scored more than a starter)'};
else
    ranks(1,:)={'Team','Rank','Weighted Score(Avg+3WkAvg-Std+300*%Wins)','Points per Game','STD','Avereage Points in last 3 weeks','Percent of Total Wins(if you played everyone every week)','Expected W-L(not used in score)(based on W-L if you played everyone every week)','N/A'};
end
ranks(2:end,1)=teams;
ranks(2:end,2:end)=num2cell(temp2);
clear PointsSTD; clear TotalWins; clear temp2; 
clear b; clear data; clear percentmax; clear Maxpointsdata;

fid=fopen(strcat('Ranks-Week',int2str(weeks),'.csv'),'w');
fprintf(fid,'%s,',ranks{1,1:end-1});
fprintf(fid,'%s\n',ranks{1,end});
for i=1:length(teams)
    fprintf(fid,'%s, %d, %2.1f, %2.1f, %2.1f, %2.1f, %.3f, %2.1f, %.3f\n',ranks{i+1,:});
end
fclose(fid);
clear ans; clear i; clear j; clear fid; clear weeks; clear teams;