%wins to stats regression
clear all; close all; clc

temp=importdata('Points2015weeks14maxpointsFalse.csv');
data=temp.data;
teams=temp.textdata(2:end,1);
[~,weeks]=size(data);
fin=[];
for weeks=3:13
    TotalWins=zeros(length(teams),weeks+1);
    for i=1:length(teams)
        for j=1:weeks
            TotalWins(i,1)=TotalWins(i,1)+(sum(data(i,j)>data(:,j)));
            TotalWins(i,j+1)=sum(data(i,j)>data(:,j));
        end
    end
    clear i;clear j;
    
    temp=cell(length(teams)+1,6);
    temp2=zeros(length(teams),5);
    
    %temp2(:,1)=[4,5,9,11,8,1,8,6,6,4,5,8,7,9]; %final wins
    %temp2(:,1)=[13,9,1,7,2,14,6,11,3,10,12,5,8,4]; %final ranks
    %temp2(:,1)=[13,10,2,1,4,14,6,9,8,12,11,5,7,3]; %final season ranks
    temp2(:,1)=data(:,weeks+1)./sum(data(:,weeks+1)); %next weeks score
%     for i=1:length(teams) %gets prob of winning next week
%         temp2(i,1)=sum(data(i,weeks+1)>data(:,weeks+1))/(length(teams)-1);
%     end
    temp2(:,2)=sum(data(:,1:weeks),2)/weeks;
    temp2(:,2)=sum(data(:,1:weeks),2)/(sum(sum(data(:,1:weeks),2)));
    temp2(:,3)=std(data(:,1:weeks),0,2);
    temp2(:,3)=std(data(:,1:weeks),0,2)./((sum(data(:,1:weeks),2))/weeks);
    temp2(:,4)=TotalWins(:,1)./((length(teams)-1)*weeks);
    temp2(:,5)=sum(data(:,(weeks-2):weeks),2)./3;
    temp2(:,5)=sum(data(:,(weeks-2):weeks),2)/sum(sum(data(:,(weeks-2):weeks),2));
    temp(1,:)={'Team','FinalRank','Total Points','STD','Total Win Loss','last 3wks avg'};
    temp(2:end,1)=teams;
    temp(2:end,2:end)=num2cell(temp2);
    fin=[fin;temp(2:end,:)];
    clear TotalWins; clear temp2;
end
clear temp; clear weeks; clear teams;
