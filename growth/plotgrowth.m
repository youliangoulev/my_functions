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
xt=[];
for i=1:length(deltaini)
   if ~isempty(deltaini{i})
       xax=[xax , (i-1)*framet];
       delta={delta{:} , deltaini{i}};
       size={size{:} , sizeini{i}};
       zd=[zd , deltaini{i} ];
       za=[za , sizeini{i}];
       xt=[xt , zeros(1, length(sizeini{i}))+(i-1)*framet ];%randn(1, length(sizeini{i}))+(i-1)*framet ];
   end;
end;
meandelta=[];
errordelta=[];
meansize=[];
grpersiz=[]; 
errorsize=[];
errorgrpersiz=[];
num=[];
for i=1:length(delta)
    meandelta=[meandelta , mean(delta{i})];
    meansize=[meansize , mean(size{i})];
    errordelta=[errordelta , std(delta{i})/sqrt(length(delta{i}))];
    errorsize=[errorsize , std(size{i})/sqrt(length(size{i}))];
    num=[num , length(size{i})];
    grpersiz=[grpersiz , sum(delta{i})/sum(size{i})];
    errorgrpersiz=[errorgrpersiz , sqrt((length(delta{i})*std(delta{i})*std(delta{i})/sum(size{i})^2)+((sum(delta{i})^2)*length(delta{i})*std(size{i})*std(size{i})/sum(size{i})^4))];
end;
%=====================================================
figure;
errorbar(xax , smooth(meandelta , sms) , errordelta);
hold on;
plot(xax , smooth(meandelta , sms) , 'color' , 'r' , 'LineWidth' , 2);
set(gca,'FontSize',20)
xlabel('Time (min)');
ylabel('Mean growth rate per cell (au)');
title('Cell growth rate'); 
%=====================================================
figure;
errorbar(xax , smooth(meansize , sms) , errorsize);
hold on;
plot(xax , smooth(meansize , sms) , 'color' , 'r' , 'LineWidth' , 2);
set(gca,'FontSize',20)
xlabel('Time (min)');
ylabel('Mean volum per cell (au)');
title('Cell volum');
%=====================================================
figure;
scatter(xt , za , 7 , 'b' , 'Marker' , '+');
set(gca,'FontSize',20)
xlabel('Time (min)');
ylabel('Volum per cell (au)');
title('Cell volum distribution');
%=====================================================
figure;
errorbar(xax , smooth(grpersiz , sms) , errorgrpersiz);
hold on;
plot(xax , smooth(grpersiz , sms) , 'color' , 'r' , 'LineWidth' , 2);
set(gca,'FontSize',20)
xlabel('Time (min)');
ylabel('Mean growth rate per unit of volum (min-1)');
title('Growth rate per volum'); 
%=====================================================
figure;
plot(xax , num , 'LineStyle' , 'none' , 'MarkerSize', 6 , 'MarkerEdgeColor','k' , 'MarkerFaceColor','g' , 'Marker' , 's');
set(gca,'FontSize',20)
xlabel('Time (min)');
ylabel('Number of analysed events');
title('Statistical significance');
%=====================================================
figure ;
scatter (za , zd) ;
set(gca,'FontSize',20)
xlabel('Cell volum (au)');
ylabel('Cell growth rate (au)');
title('Cell area and growth rate correlation');
%=====================================================
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

