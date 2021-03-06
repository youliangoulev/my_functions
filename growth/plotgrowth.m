function plotgrowth( sizeini , deltaini , sms)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


fitting=1;
born1=108;
born2=950;
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
    errorsize=[errorsize , std(size{i})]; %/sqrt(length(size{i}))];
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
% title('Cell growth rate'); 
%=====================================================
if fitting
cut1=round(born1/framet)+1;
cut2=round(born2/framet)+1;
mxax=xax(cut1:cut2);
temdelta=delta(cut1:cut2);
mdeltam=[];
for i=1:length(temdelta)
    temxax{i}=zeros(1, length(temdelta{i}))+mxax(i);
    mdeltam=[mdeltam , mean(temdelta{i})];
end;
tempra=smooth(mdeltam , 5);
x1=1;
 x5=length(mxax);
 [y3 , x3]=min(tempra(2:end-1));
 xvar1=2:x3-1;
 xvar2=x3+1:x5-1;
 x2=[];
 x4=[];
 Q2=[];
 
 
%======
dal=length(xvar1);
h11=waitbar(0 , 'fiting');
%======  
 
 
 for i=xvar1
     for j=xvar2
         x2=[x2 , i];
         x4=[x4 , j];
         zt1=[temxax{x1:i}];
         zw1=[temdelta{x1:i}];
         zt2=[temxax{j:x5}];
         zw2=[temdelta{j:x5}];
         prob1=polyfit(zt1 , zw1 , 1);
         prob2=polyfit(zt2 , zw2 , 1);
        a1=prob1(1);
        b1=prob1(2);
        a4=prob2(1);
        b4=prob2(2);
         a2=(y3-(a1*mxax(i)+b1))/(mxax(x3)-mxax(i));
         b2=y3-a2*mxax(x3);
         a3=((a4*mxax(j)+b4)-y3)/(mxax(j)-mxax(x3));
         b3=y3-a3*mxax(x3);
         Q=0;
         for c=1:i
             Q=Q+sum((temdelta{c}-(a1*mxax(c)+b1)).*(temdelta{c}-(a1*mxax(c)+b1)));
         end;
         for c=i+1:x3
             Q=Q+sum((temdelta{c}-(a2*mxax(c)+b2)).*(temdelta{c}-(a2*mxax(c)+b2)));
         end;
         for c=x3+1:j
             Q=Q+sum((temdelta{c}-(a3*mxax(c)+b3)).*(temdelta{c}-(a3*mxax(c)+b3)));
         end;
         for c=j+1:x5
             Q=Q+sum((temdelta{c}-(a4*mxax(c)+b4)).*(temdelta{c}-(a4*mxax(c)+b4)));
         end;
         Q2=[Q2 , Q];
     end; 
%==========    

    waitbar((i-1)/dal, h11);

%==========
 end;
%==========
close(h11);
drawnow;
%==========
 
 [Q2m , indic]=min(Q2);
 x2god=x2(indic);
 x4god=x4(indic);
 i=x2god;
 j=x4god;
         zt1=[temxax{x1:i}];
         zw1=[temdelta{x1:i}];
         zt2=[temxax{j:x5}];
         zw2=[temdelta{j:x5}];
         prob1=polyfit(zt1 , zw1 , 1);
         prob2=polyfit(zt2 , zw2 , 1);
        a1=prob1(1);
        b1=prob1(2);
        a4=prob2(1);
        b4=prob2(2);
         a2=(y3-(a1*mxax(i)+b1))/(mxax(x3)-mxax(i));
         b2=y3-a2*mxax(x3);
         a3=((a4*mxax(j)+b4)-y3)/(mxax(j)-mxax(x3));
         b3=y3-a3*mxax(x3);
         
         
figure;
errorbar(xax , smooth(meandelta , sms) , errordelta);
set(gca,'FontSize',20)
xlabel('Time (min)');
ylabel('Mean growth rate per cell (au)');
% title('Cell growth rate'); 
if ranksum(temdelta{x2god} , temdelta{x3}) <= 0.05   %
hold on;
plot(mxax(x1:x2god) , a1*mxax(x1:x2god)+b1 , 'color' , 'r' , 'LineWidth',2);
hold on;
plot(mxax(x2god:x3) , a2*mxax(x2god:x3) +b2 , 'color' , 'r', 'LineWidth',2);
hold on;
plot(mxax(x3:x4god) , a3*mxax(x3:x4god)+b3 , 'color' , 'r' , 'LineWidth',2);
hold on;
plot(mxax(x4god:x5) , a4*mxax(x4god:x5)+b4 , 'color' , 'r' , 'LineWidth',2);
hold on;
disp(['time limit 1 : ' , num2str(x2god) , 'frame']);
disp(['time limit 2 : ' , num2str(x4god) , 'frame']);
else
    
    
        prob3=polyfit([temxax{:}] , [temdelta{:}] , 1);
        a3=prob3(1);
        b3=prob3(2);
        hold on;
        plot(mxax(x1:x5) , a3*mxax(x1:x5)+b3 , 'color' , 'r' , 'LineWidth',2);
end; 
end;
%=====================================================
figure;
errorbar(xax , smooth(meansize , sms) , errorsize);
hold on;
plot(xax , smooth(meansize , sms) , 'color' , 'r' , 'LineWidth' , 2);
set(gca,'FontSize',20)
xlabel('Time (min)');
ylabel('Mean volum per cell (au)');
% title('Cell volum');
%=====================================================
figure;
scatter(xt , za , 7 , 'b' , 'Marker' , '+');
set(gca,'FontSize',20)
xlabel('Time (min)');
ylabel('Volum per cell (au)');
% title('Cell volum distribution');
%=====================================================
figure;
errorbar(xax , smooth(grpersiz , sms) , errorgrpersiz);
hold on;
plot(xax , smooth(grpersiz , sms) , 'color' , 'r' , 'LineWidth' , 2);
set(gca,'FontSize',20)
xlabel('Time (min)');
ylabel('Mean growth rate per unit of volum (min-1)');
% title('Growth rate per volum'); 
%=====================================================
figure;
plot(xax , num , 'LineStyle' , 'none' , 'MarkerSize', 6 , 'MarkerEdgeColor','k' , 'MarkerFaceColor','g' , 'Marker' , 's');
set(gca,'FontSize',20)
xlabel('Time (min)');
ylabel('Number of analysed events');
% title('Statistical significance');
%=====================================================
figure ;
scatter (za , zd , 4 ) ;
set(gca,'FontSize',20)
xlabel('Cell volum (au)');
ylabel('Cell growth rate (au)');
% title('Cell area and growth rate correlation');
[ddddd , ppppp]=corrcoef(za ,zd);
disp(['correlation between cell area and growth rate : ' , num2str(ddddd(1,2))]);
disp(['p-value for the correlation between cell area and growth rate : ' , num2str(ppppp(1,2))]);
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
        % title(['Cell area and growth rate correlation at ' , num2str(xax(i)) , 'min']);
        continue;
    end;
    if (length(delta{i})>50)&&(~stop2)
        figure;
        stop2=true;
        scatter (size{i} , delta{i}) ;
        set(gca,'FontSize',20)
        xlabel('Cell area (au)');
        ylabel('Cell growth rate (au)');
        % title(['Cell area and growth rate correlation at ' , num2str(xax(i)) , 'min']);
        continue;
    end;
    if (length(delta{i})>70)&&(~stop3)
        figure;
        stop3=true;
        scatter (size{i} , delta{i}) ;
        set(gca,'FontSize',20)
        xlabel('Cell area (au)');
        ylabel('Cell growth rate (au)');
        % title(['Cell area and growth rate correlation at ' , num2str(xax(i)) , 'min']);
        continue;
    end;
end;
end

