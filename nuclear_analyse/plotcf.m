function plotcf( time , a , bornes_before , timelimite , smsp )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

tim={};
w={};

b=[];
for i=1:length(time)
    if time{i}(1)<bornes_before
        b=[b , i];
    end;
end;
ii=0;
for i=b
    ii=ii+1;
    tim{ii}=time{i}(time{i}<=timelimite);
    w{ii}=a{i}(time{i}<=timelimite);
end;


colorses=hsv(ii);
figure;
for i=1:ii
    plot(tim{i} , smooth(w{i} , smsp) , 'color' , colorses(i,:) , 'LineWidth', 1.3);
    hold on
end;

n=ii;

zt=[];
zw=[];

for i=1:n
    zt=[zt , tim{i}];
    zw=[zw , w{i}];
end;

minim=min(zt);
maxim=max(zt);

t(1)=minim;

i=1;

while t(i)<maxim
    i=i+1;
    t(i)=min(zt(zt>t(i-1)));
end;

zwr={};

meanw=[];
stdew=[];

for i=1:length(t)
    
    zwr{i}=zw(zt==t(i));    
    meanw=[meanw , mean(zwr{i})];
    stdew=[stdew , std(zwr{i})/sqrt(length(zwr{i}))];

end;

   figure;
   errorbar(t , smooth(meanw , smsp) , stdew);

end

