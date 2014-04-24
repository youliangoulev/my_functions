function plotgrowth( sizeini , deltaini , sms)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

framet=3;
%======================================
xax=[];
delta={};
size={};
zd=[];
za=[];
for i=1:length(deltaini)
   if ~isempty(deltaini{i})
       xax=[xax , (i-1)*framet];
       delta={delta{:} , deltaini{i}};
       size={size{:} , sizeini{i}};
       zd=[zd , deltaini{i} ];
       za=[za , sizeini{i}];
   end;
end;
meandelta=[];
errordelta=[];
meansize=[];
errorsize=[];
for i=1:length(delta)
    meandelta=[meandelta , mean(delta{i})];
    meansize=[meansize , mean(size{i})];
    errordelta=[errordelta , std(delta{i})/sqrt(length(delta{i}))];
    errorsize=[errorsize , std(size{i})/sqrt(length(size{i}))];
end;
figure;
plot(xax , smooth(meandelta , sms));
set(gca,'FontSize',20)
xlabel('Time (min)');
ylabel('Mean growth rate per cell (au)');
title('Cell growth rate'); 
figure;
plot(xax , smooth(meansize , sms));
set(gca,'FontSize',20)
xlabel('Time (min)');
ylabel('Mean area per cell (au)');
title('Cell area'); 
figure ;
scatter (za , zd) ;
set(gca,'FontSize',20)
xlabel('Cell area (au)');
ylabel('Cell growth rate (au)');
title('Cell area and growth rate correlation');
stop1=false;
stop2=false;
stop3=false;
for i=1:length(delta)
    if (length(delta{i})>30)&&(~stop1)
        figure;
        stop1=true;
        scatter (size{i} , delta{i}) ;
        set(gca,'FontSize',20)
        xlabel('Cell area (au)');
        ylabel('Cell growth rate (au)');
        title(['Cell area and growth rate correlation at ' , num2str(xax(i)) , 'min']);
        continue;
    end;
    if (length(delta{i})>50)&&(~stop2)
        figure;
        stop2=true;
        scatter (size{i} , delta{i}) ;
        set(gca,'FontSize',20)
        xlabel('Cell area (au)');
        ylabel('Cell growth rate (au)');
        title(['Cell area and growth rate correlation at ' , num2str(xax(i)) , 'min']);
        continue;
    end;
    if (length(delta{i})>70)&&(~stop3)
        figure;
        stop3=true;
        scatter (size{i} , delta{i}) ;
        set(gca,'FontSize',20)
        xlabel('Cell area (au)');
        ylabel('Cell growth rate (au)');
        title(['Cell area and growth rate correlation at ' , num2str(xax(i)) , 'min']);
        continue;
    end;
end;
end

