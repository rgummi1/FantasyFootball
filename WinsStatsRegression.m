%wins to stats regression
clear all; close all; clc

temp=importdata('HopkinsFF_pointsTotals.csv');
data=temp.data;
teams=temp.textdata(2:end,1);
[~,weeks]=size(data);
fin=[];
for weeks=3:13
    PointsSTD=zeros(length(teams),2);
    TotalWins=zeros(length(teams),weeks+1);
    for i=1:length(teams)
        PointsSTD(i,1)=sum(data(i,1:weeks)); %totpoints
        PointsSTD(i,2)=std(data(i,1:weeks)); %std
    end
    PointsSTD(:,1)=PointsSTD(:,1)./weeks;

    for i=1:length(teams)
        for j=1:weeks
            TotalWins(i,1)=TotalWins(i,1)+(sum(data(i,j)>data(:,j)));
            TotalWins(i,j+1)=sum(data(i,j)>data(:,j));
        end
    end
    clear i;clear j;
    
    temp=cell(length(teams)+1,5);
    temp2=zeros(length(teams),4);
    temp2(:,2:3)=PointsSTD;
    temp2(:,4)=TotalWins(:,1)/sum(TotalWins(:,1));
    temp2(:,1)=[4,5,9,11,8,1,8,6,6,4,5,8,7,9]; %final wins
    temp2(:,1)=[13,9,1,7,2,14,6,11,3,10,12,5,8,4]; %final ranks
    temp2(:,1)=[13,10,2,1,4,14,6,9,8,12,11,5,7,3]; %final season ranks
    temp(1,:)={'Team','FinalRank','Total Points','STD','Total Win Loss'};
    temp(2:end,1)=teams;
    temp(2:end,2:end)=num2cell(temp2);
    clear PointsSTD; clear TotalWins; clear temp2;
    fin=[fin;temp(2:end,:)];
end