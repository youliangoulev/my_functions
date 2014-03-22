function [ al ] = facsanalyses(d,o)

global i;
global colorses  ;   
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%=================================================================

liko=figure('Name', ['Mean ' o ' ([H2O2])'] );
a=get(liko,'OuterPosition');
set(liko,'OuterPosition',[a(1) a(2 ) a(3)*2 (a(3)*2)/(size(d,1)*0.8)]);


for i=1:size(d,1)
y=[];
x=[];
e=[];
for j=1:size(d,2)
    y=[y, d(i,j).(o).mean];
    x=[x, d(i,j).h2o2];
    e=[e, d(i,j).(o).ster];
end
subplot(1,size(d,1),i), errorbar(x,y,e, 'ks','MarkerFaceColor','g');
xlabel('[H2O2]');
ylabel(o);
title(['Time : ' num2str(d(i,1).time) ' min'], 'FontWeight','Bold','FontName','Arial');
v(:,i)=axis(subplot(1,size(d,1),i));
end

for i=1:size(d,1)
    axis(subplot(1,size(d,1),i), [-0.15 x(end)+0.15 0 max(v(4,:))]); 
end
v=[];
%==================================================================
 
lik=figure('Name', ['Mean ' o ' (Time)'] );
a=get(lik,'OuterPosition');
set(lik,'OuterPosition',[a(1) a(2 ) a(3)*2 (a(3)*2)/(size(d,2)*0.8)]);


for i=1:size(d,2)
y=[];
x=[];
e=[];
for j=1:size(d,1)
    y=[y, d(j,i).(o).mean];
    x=[x, d(j,i).time];
    e=[e, d(j,i).(o).ster];
end
subplot(1,size(d,2),i), errorbar(x,y,e, '-bo','MarkerFaceColor','b', 'LineWidth',1,'MarkerSize',5);
xlabel('Time');
ylabel(o);
title(['[H2O2] : ' num2str(d(1,i).h2o2) ' mM'], 'FontWeight','Bold','FontName','Arial');
v(:,i)=axis(subplot(1,size(d,2),i));
end

for i=1:size(d,2)
    axis(subplot(1,size(d,2),i), [-50 x(end)+50 0 max(v(4,:))]); 
end
v=[];
%==================================================================

lij=figure('Name', [o ' Distribution'] );
a=get(lij,'OuterPosition');
set(lij,'OuterPosition',[a(1) a(2 ) a(3)*2 ((a(3)*2)/(size(d,2)*0.8))*size(d,1)]);

for i=1:size(d,1)
for j=1:size(d,2)
subplot(size(d,1),size(d,2), (i-1)*size(d,2)+j), hist(d(i,j).(o).values, max(d(i,j).(o).values)-min(d(i,j).(o).values));
xlabel(o);
ylabel('Count');
title([num2str(d(i,j).time) ' min' ' / ' num2str(d(i,j).h2o2) ' mM'], 'FontWeight','Bold','FontName','Arial');
vi(:,i,j)=axis(subplot(size(d,1),size(d,2), (i-1)*size(d,2)+j));
m(i,j)=quantile(d(i,j).(o).values, 0.95);
end
end;

for i=1:size(d,1)
for j=1:size(d,2)
    axis(subplot(size(d,1),size(d,2), (i-1)*size(d,2)+j), [0 max(m(:)) vi(3,i,j) vi(4,i,j)]); 
end
end

m=[];
vi=[];

%==================================================================

lijimolp=figure('Name', ['SSC / FSC ' ' Correlation'] );
a=get(lijimolp,'OuterPosition');
set(lijimolp,'OuterPosition',[a(1) a(2 ) a(3)*2 ((a(3)*2)/(size(d,2)*0.8))*size(d,1)]);

for i=1:size(d,1)
for j=1:size(d,2)
subplot(size(d,1),size(d,2), (i-1)*size(d,2)+j),  dscatter(d(i,j).FSC.values,d(i,j).SSC.values, 'marker' , 'p');
xlabel('FSC');
ylabel('SSC');
title([num2str(d(i,j).time) ' min' ' / ' num2str(d(i,j).h2o2) ' mM'], 'FontWeight','Bold','FontName','Arial');
axis(subplot(size(d,1),size(d,2), (i-1)*size(d,2)+j), [0 1000 0 1000]);
end
end;

%==================================================================


lijimo=figure('Name', [o ' / FSC ' ' Correlation'] );
a=get(lijimo,'OuterPosition');
set(lijimo,'OuterPosition',[a(1) a(2 ) a(3)*2 ((a(3)*2)/(size(d,2)*0.8))*size(d,1)]);

for i=1:size(d,1)
for j=1:size(d,2)
subplot(size(d,1),size(d,2), (i-1)*size(d,2)+j),  dscatter(d(i,j).FSC.values,d(i,j).GFP.values, 'marker' , 'p');
xlabel('FSC');
ylabel('GFP');
title([num2str(d(i,j).time) ' min' ' / ' num2str(d(i,j).h2o2) ' mM'], 'FontWeight','Bold','FontName','Arial');
m(i,j)=quantile(d(i,j).(o).values, 0.99);
end
end;

for i=1:size(d,1)
for j=1:size(d,2)
    axis(subplot(size(d,1),size(d,2), (i-1)*size(d,2)+j), [0 1000 0 max(m(:))]); 
end
end

m=[];

%===================================================================
di={};


lijim=figure('Name', [o ' - Cefficient of variation'] );
a=get(lijim,'OuterPosition');
set(lijim,'OuterPosition',[a(1) a(2 ) a(3)*2  a(4)]);
colorses=hsv(size(d,2));

for i=1:size(d,2)
y=[];
x=[];
e=[];
b=[];
miean=[];
stardnvit=[];
eorsm=[];
eorsv=[];
for j=1:size(d,1)
    y=[y, d(j,i).(o).cv];
    x=[x, d(j,i).time];
    miean=[miean, d(j,i).(o).mean];
    stardnvit=[stardnvit, d(j,i).(o).std];
    eorsm=[eorsm, d(j,i).(o).ster];
    [bootstat] = bootstrp(1000,@coefvar,d(j,i).(o).values); 
    e=[e, std(bootstat)];
    [bootstat] = bootstrp(1000,@std,d(j,i).(o).values); 
    eorsv=[eorsv, std(bootstat)];
end
di={di{:},['[H2O2] ' num2str(d(1,i).h2o2) 'mM']};
subplot(1,2,1), errorbar(x,y,e, 'color' , colorses(i,:) , 'LineWidth',1); %'-bo','MarkerFaceColor','b','MarkerSize',5);
hold on
subplot(1,2,2);
hSLines=errorbar(miean,stardnvit,eorsv , '.', 'MarkerSize' , 2, 'color' , colorses(i,:) ); %'-bo','MarkerFaceColor','b','MarkerSize',5);
hold on
subplot(1,2,2);
hSLines=[hSLines ,  herrorbar(miean,stardnvit,eorsm)]; %'-bo','MarkerFaceColor','b','MarkerSize',5);
hold on
hSGroup= hggroup;
set(hSLines,'Parent',hSGroup)
set(get(get(hSGroup,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','on'); 



end
subplot(1,2,1);
xlabel('Time');
ylabel('Coefficient of Variation');
title('CV(Time)', 'FontWeight','Bold','FontName','Arial');
l=axis(subplot(1,2,1));
axis(subplot(1,2,1), [-25 x(end)+25 0  l(4)]);
p=legend(di);
l=[];
subplot(1,2,2);
xlabel(['Mean ' o ]);
ylabel(['Standard Deviation' o ]); 
title('Std / Mean', 'FontWeight','Bold','FontName','Arial');
l=axis(subplot(1,2,2));
axis(subplot(1,2,2), [0 l(2) 0  l(4)]);
p=legend(di);
l=[];




end

