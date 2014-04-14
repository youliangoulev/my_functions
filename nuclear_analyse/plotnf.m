function plotnf( time , a , bornes_before , timelimite , smsp)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


%================================

fiting=1;

%================================

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

n=ii;

for i=1:n
    for j=1:length(w{i})
        if (w{i}(j)<=0)&&(j>1)      
            w{i}(j)=w{i}(j-1); 
        end;
    end;
end;



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
 tempra=smooth(meanw , smsp);
 %%%  aut=tempra; si out

   
if fiting==1   
   %%% operation on zt and wt :
 
   x1=1;
 x5=length(t);

 [y3 , x3]=max(tempra(2:end-1));
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
         zt1=zt((zt>=t(x1))&(zt<=t(i)));
         zw1=zw((zt>=t(x1))&(zt<=t(i)));
         zt2=zt((zt>=t(j))&(zt<=t(x5)));
         zw2=zw((zt>=t(j))&(zt<=t(x5)));
         prob1=polyfit(zt1 , zw1 , 1);
         prob2=polyfit(zt2 , zw2 , 1);
        a1=prob1(1);
        b1=prob1(2);
        a4=prob2(1);
        b4=prob2(2);
         a2=(y3-(a1*t(i)+b1))/(t(x3)-t(i));
         b2=y3-a2*t(x3);
         a3=((a4*t(j)+b4)-y3)/(t(j)-t(x3));
         b3=y3-a3*t(x3);
         Q=0;
         for c=1:i
             Q=Q+sum((zwr{c}-(a1*t(c)+b1)).*(zwr{c}-(a1*t(c)+b1)));
         end;
         for c=i+1:x3
             Q=Q+sum((zwr{c}-(a2*t(c)+b2)).*(zwr{c}-(a2*t(c)+b2)));
         end;
         for c=x3+1:j
             Q=Q+sum((zwr{c}-(a3*t(c)+b3)).*(zwr{c}-(a3*t(c)+b3)));
         end;
         for c=j+1:x5
             Q=Q+sum((zwr{c}-(a4*t(c)+b4)).*(zwr{c}-(a4*t(c)+b4)));
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
zt1=zt((zt>=t(x1))&(zt<=t(i)));
         zw1=zw((zt>=t(x1))&(zt<=t(i)));
         zt2=zt((zt>=t(j))&(zt<=t(x5)));
         zw2=zw((zt>=t(j))&(zt<=t(x5)));
         prob1=polyfit(zt1 , zw1 , 1);
         prob2=polyfit(zt2 , zw2 , 1);

        a1=prob1(1);
        b1=prob1(2);
        a4=prob2(1);
        b4=prob2(2);
         a2=(y3-(a1*t(i)+b1))/(t(x3)-t(i));
         b2=y3-a2*t(x3);
         a3=((a4*t(j)+b4)-y3)/(t(j)-t(x3));
         b3=y3-a3*t(x3); 
         



   
fii=figure;
set(fii,'Position',[251 , 451 , 679 , 346]);
errorbar(t , smooth(meanw , smsp) , stdew);
if ranksum(zwr{x2god} , zwr{x3}) <= 0.05
hold on;
plot(t(x1:x2god) , a1*t(x1:x2god)+b1 , 'color' , 'r' , 'LineWidth',2);
hold on;
plot(t(x2god:x3) , a2*t(x2god:x3) +b2 , 'color' , 'r', 'LineWidth',2);
hold on;
plot(t(x3:x4god) , a3*t(x3:x4god)+b3 , 'color' , 'r' , 'LineWidth',2);
hold on;
plot(t(x4god:x5) , a4*t(x4god:x5)+b4 , 'color' , 'r' , 'LineWidth',2);
hold on;
else
    
    
             prob3=polyfit(zt , zw , 1);
        a3=prob3(1);
        b3=prob3(2);
        hold on;
        plot(t(x1:x5) , a3*t(x1:x5)+b3 , 'color' , 'r' , 'LineWidth',2);
end;

set(gca,'XTick',t(x1):100:t(x5));
set(gca,'YTick',0:0.2:2);
set(gca,'XLim',[t(x1) , t(x5)]);
set(gca,'YLim',[0 , 2]);
linelima=get(gca , 'Ylim');

set(gca,'FontSize',20)
xlabel('Time (min)');
ylabel('Yap1 nuclear enrichment');
title('Yap1 activity');
moyenne1=[];
moyenne2=[];
    posit=get(gca , 'Position');


for i=1:length(w)
    if sum((tim{i}>=t(x1))&(tim{i}<=t(x2god)))>0
    moyenne1=[moyenne1 , mean(w{i}((tim{i}>=t(x1))&(tim{i}<=t(x2god))))];
    end;
    if sum((tim{i}>=t(x4god))&(tim{i}<=t(x5)))>0
    moyenne2=[moyenne2 , mean(w{i}((tim{i}>=t(x4god))&(tim{i}<=t(x5))))];
    end;
end;

me1=mean(moyenne1);
me2=mean(moyenne2);

         pii=ranksum(moyenne1 , moyenne2);
if ranksum(zwr{x2god} , zwr{x3}) <= 0.05
stringg = {['Mean1 before stress: ' , num2str(me1)] , ['Mean2 after adaptation: ' , num2str(me2)] , ['Mean1 vs Mean2: p-value = ' , num2str(pii)] , ['Maximum amplitude: ' , num2str(y3-(a1*t(x2god)+b1))] , ['Burst duration: ' , num2str(t(x4god)-t(x2god)) , ' min']};
annotation('line' , [posit(1)+posit(3)*(x2god-1)/x5 , posit(1)+posit(3)*(x2god-1)/x5] , [posit(2) , posit(2)+posit(4)] , 'LineStyle' , '--');
annotation('line' , [posit(1)+posit(3)*(x4god-1)/x5 , posit(1)+posit(3)*(x4god-1)/x5] , [posit(2) , posit(2)+posit(4)] , 'LineStyle' , '--');
%annotation('line' , [posit(1), posit(1)+posit(3)] , [posit(2)+posit(4)*y3/linelima(2) , posit(2)+posit(4)*y3/linelima(2)] , 'LineStyle' , '--');
else
stringg='No significant Yap1 activation';
    
end;
wax=annotation('textbox', [.139 .582 .1 .1], 'String', stringg , 'FontSize' , 14 , 'LineStyle' , 'none' , 'color' , [0.16 , 0.58 , 0.27]);
ggwxa=get(wax , 'Position');
set(wax , 'Position' , [posit(1)+0.015 , posit(2)+posit(4)-ggwxa(4)-0.018 , ggwxa(3) , ggwxa(4)]);


end;



fiiiii=figure;
   set(fiiiii,'Position',[251 , 451 , 679 , 346]);
   errorbar(t , smooth(meanw , smsp) , stdew);
if fiting   
set(gca,'XTick',t(x1):100:t(x5));
set(gca,'YTick',0:0.2:2);
set(gca,'XLim',[t(x1) , t(x5)]);
set(gca,'YLim',[0 , 2]);

set(gca,'FontSize',20)
xlabel('Time (min)');
ylabel('Yap1 nuclear enrichment');
title('Yap1 activity');         
         
end;         
         colorses=hsv(ii);
fi=figure;
set(fi,'Position',[251 , 451 , 679 , 346]);
for i=1:ii
    plot(tim{i} , smooth(w{i} , smsp) , 'color' , colorses(i,:) , 'LineWidth', 1.3);
    hold on
end;

if fiting
set(gca,'XTick',t(x1):100:t(x5));
set(gca,'YTick',0:0.2:2);
set(gca,'XLim',[t(x1) , t(x5)]);
set(gca,'YLim',[0 , 2]);
set(gca,'FontSize',20)
xlabel('Time (min)');
ylabel('Yap1 nuclear enrichment');
title('Yap1 activity');
end;




end

