clear all; close all; clc

temp=importdata('HopkinsFF_pointsTotals20164.csv');
data=temp.data;
[~,weeks]=size(data);
teams=temp.textdata(2:end,1);
PointsSTD=zeros(length(teams),2);
TotalWins=zeros(length(teams),weeks+1);
for i=1:length(teams)
    PointsSTD(i,1)=sum(data(i,:))/weeks; %totpoints
    PointsSTD(i,2)=std(data(i,:)); %std
end

for i=1:length(teams)
    for j=1:weeks
        TotalWins(i,1)=TotalWins(i,1)+(sum(data(i,j)>data(:,j)));
        TotalWins(i,j+1)=sum(data(i,j)>data(:,j));
    end
end

temp=cell(length(teams)+1,7);
temp2=zeros(length(teams),6);
temp2(:,3:4)=PointsSTD;
temp2(:,6)=TotalWins(:,1)/sum(TotalWins(:,1));
%temp2(:,6)=sum(TotalWins(:,(end-2):end),2)/(66*3);
temp2(:,5)=(sum(data(:,(end-2):end),2))/weeks;
temp2(:,2)=temp2(:,3)-temp2(:,4)+temp2(:,5)+temp2(:,6)*300; %CALCULATE POWER HERE
[~,b]=sort(temp2(:,2),'descend');
temp2=temp2(b,:);
temp2(:,1)=1:length(teams);
teams=teams(b);
temp(1,:)={'Team','Rank','Score(sum of last 3 columns)','Total Points','STD','Points for in last 3 weeks','Total Win Loss'};
temp(2:end,1)=teams;
temp(2:end,2:end)=num2cell(temp2);

fid=fopen('test.csv','w');
fprintf(fid,'%s,',temp{1,1:end-1});
fprintf(fid,'%s\n',temp{1,end});
for i=1:length(teams)
    fprintf(fid,'%s, %d, %2.1f, %d, %2.1f, %d, %d, %d\n',temp{i+1,:});
end
fclose(fid);