function [ out ] = auc( seg,a1,b1,c,d1,e1,f , border1 , border2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

minutesperframe=3;  

% very important set the number of minutes per frame;
% default 3 min/frme !!!

%============================
function plotiii(r , rrr , col)

mini=0;
maxi=0;
lop={};

for ii=1:length(r)
    mini=min(mini,min(r{ii}));
    maxi=max(maxi,max(r{ii}));
end

iii=[mini:minutesperframe:maxi];

for ii=1:length(iii)
    lop{ii}=[];
end

for ii=1:length(r)
    for jj=1:length(r{ii});
        lop{(r{ii}(jj)-mini)/minutesperframe+1}=[lop{(r{ii}(jj)-mini)/minutesperframe+1} , rrr{ii}(jj)];
    end
end

for ii=1:length(lop)
    meanm(ii)=mean(lop{ii});
    stdm(ii)=std(lop{ii});
    eeenm(ii)=stdm(ii)/sqrt(length(lop{ii}));
end    

                                          
errorbar(iii,meanm,eeenm, 'color' , col);

end
%============================
if b1<=a1
    return
end

if e1<=d1
    return
end

if isempty(seg.tcells1)
    return
end

a=round(a1/minutesperframe+1);
b=round(b1/minutesperframe+1);
d=round(d1/minutesperframe+1);
e=round(e1/minutesperframe+1);
bord1=round(border1/minutesperframe+1);
bord2=round(border2/minutesperframe+1);

x1=[];
y1=[];
p1=[];

plx={};
ply={};
plxM={};
plyM={};
plxD={};
plyD={};

matrix=[];
size1=b-a+1;
size2=e-d+1;
maximumy=0;
maximumx=0;
old1=[];
old2=[];
yang1=[];
yang2=[];
area1=[];
area2=[];
area3=[];

for i=1:length(seg.tcells1)
    if seg.tcells1(i).N<=0
        continue
    end
    firstdomain=0; 
    pass=0;
 if seg.tcells1(i).detectionFrame<=a && seg.tcells1(i).lastFrame>=e
    
    startframe=a-seg.tcells1(i).detectionFrame;
    pass=1;
    for j=1:size1
    firstdomain=firstdomain+seg.tcells1(i).Obj(startframe+j).fluoMean(2)*minutesperframe;    
    end
    
    if c<=0
    firstdomain=firstdomain-seg.tcells1(i).Obj(startframe+1).fluoMean(2)*size1*minutesperframe;     
    else
    firstdomain=firstdomain-c*size1*minutesperframe;
    end
    
        area1=[area1 , firstdomain];   
    
    if seg.tcells1(i).detectionFrame<bord1
        old1=[old1, firstdomain];
    else
        if seg.tcells1(i).detectionFrame<bord2
           yang1=[yang1, firstdomain]; 
        end
    end
    
 end


    seconddomain=0;  

 if seg.tcells1(i).detectionFrame<=d && seg.tcells1(i).lastFrame>=e
    
    startframe=d-seg.tcells1(i).detectionFrame;
    
    for j=1:size2
    seconddomain=seconddomain+seg.tcells1(i).Obj(startframe+j).fluoMean(2)*minutesperframe;    
    end
    
    if f<=0
    seconddomain=seconddomain-seg.tcells1(i).Obj(startframe+1).fluoMean(2)*size2*minutesperframe;     
    else
    seconddomain=seconddomain-c*size2*minutesperframe;
    end
    if pass==1
    area2=[area2 , seconddomain];         
    end
    
        if seg.tcells1(i).detectionFrame<bord1
        old2=[old2, seconddomain];
        else
        if seg.tcells1(i).detectionFrame<bord2
           yang2=[yang2, seconddomain]; 
        end
        end
    
    
 end

 

  if seg.tcells1(i).detectionFrame<bord2
     p1=[p1,length(p1)+1]; 
     if seg.tcells1(i).detectionFrame<bord1
     l=[seg.tcells1(i).Obj.fluoMean];
     plyM={plyM{:},l(2:2:length(l))};
     plxM={plxM{:} , (seg.tcells1(i).detectionFrame-1)*minutesperframe:minutesperframe:(seg.tcells1(i).lastFrame-1)*minutesperframe};
x1=[x1,p1(end)];
     else
     l=[seg.tcells1(i).Obj.fluoMean];
     plyD={plyD{:},l(2:2:length(l))};
     plxD={plxD{:} , (seg.tcells1(i).detectionFrame-1)*minutesperframe:minutesperframe:(seg.tcells1(i).lastFrame-1)*minutesperframe};  
     y1=[y1,p1(end)];
     end
     l=[seg.tcells1(i).Obj.fluoMean];
     ply={ply{:},l(2:2:length(l))};
     plx={plx{:} , (seg.tcells1(i).detectionFrame-1)*minutesperframe:minutesperframe:(seg.tcells1(i).lastFrame-1)*minutesperframe};
     maximumx=max(maximumx,max(plx{end}));
     maximumy=max(maximumy,max(ply{end}));
     
  end   
  
  matrix=[matrix;[firstdomain ,  seconddomain   ]];  
end

out=matrix;


% draw graphs

clrs=colormap(HSV(p1(end)));


for i=1:length(plyM)
   
plot(plxM{i} , plyM{i} , 'color' , clrs(x1(i),:),'LineWidth',1.3);
hold on;
end
xlabel('Time (min)');
ylabel('Fluorescence intensity (au)');
title(['Cells born before ' num2str(border1) ' min']);
axis([0 maximumx 0 maximumy*1.2]);
figure;
plotiii(plxM , plyM , 'r');
xlabel('Time (min)');
ylabel('Mean fluorescence intensity (au)');
title(['Mean intensity for cells born before ' num2str(border1) ' min']);gkjfsf fzf   tuorpzj vjeorg e ogkdpzpzjbg .1345
axis([0 maximumx 0 maximumy*1.2]);

figure;
hold on;
for i=1:length(plyD)
   
plot(plxD{i} , plyD{i} , 'color' , clrs(y1(i),:),'LineWidth',1.3);
hold on;
end
xlabel('Time (min)');
ylabel('Fluorescence intensity (au)');
title(['Cells born after ' num2str(border1) ' min and before ' num2str(border2) ' min']);
axis([0 maximumx 0 maximumy*1.2]);
figure;
plotiii(plxD , plyD , 'b');
xlabel('Time (min)');
ylabel('Mean fluorescence intensity (au)');
title(['Cells born after ' num2str(border1) ' min and before ' num2str(border2) ' min']);
axis([0 maximumx 0 maximumy*1.2]);

figure;
hold on;
for i=1:length(ply)
   
plot(plx{i} , ply{i} , 'color' , clrs(p1(i),:),'LineWidth',1.3);
hold on;
end
xlabel('Time (min)');
ylabel('Fluorescence intensity (au)');
title(['All cells born before ' num2str(border2) ' min']);
axis([0 maximumx 0 maximumy*1.2]);
figure;
plotiii(plx , ply , 'g');
xlabel('Time (min)');
ylabel('Mean fluorescence intensity (au)');
title(['Mean intensity for all cells born before ' num2str(border2) ' min']);
axis([0 maximumx 0 maximumy*1.2]);

figure;
plotiii(plxM , plyM , 'r');
hold on;   
plotiii(plxD , plyD , 'b');
xlabel('Time (min)');
ylabel('Mean fluorescence intensity (au)');
title('in red : old cells , in blue : yang cells');
axis([0 maximumx 0 maximumy*1.2]);

mamxi=max([old1 , old2 , yang1, yang2]);
minmi=min([old1 , old2 , yang1, yang2]);
figure;
h1(1:length(old1))=b1;
h2(1:length(old2))=e1;
h3(1:length(yang1))=b1;
h4(1:length(yang2))=e1;
h11(1:length(area1))=b1;
h21(1:length(area2))=e1;

scatter(h1 , old1 , [], [1 0 0]);
xlabel('Time (min)');
ylabel('Area under the curve of each cell (au)');
title(['Signal activation for cells before ' num2str(border1) ' min']);
axis([0 maximumx minmi*1.2 mamxi*1.2]);
hold on
scatter(h2 , old2 , [], [1 0 0]);

figure;
scatter(h3 , yang1 , [], [0 0 1]);
xlabel('Time (min)');
ylabel('Area under the curve of each cell (au)');
title(['Signal activation for cells born after ' num2str(border1) ' min and before ' num2str(border2) ' min']);
axis([0 maximumx minmi*1.2 mamxi*1.2]);
hold on
scatter(h4 , yang2 , [], [0 0 1]);

figure;
scatter(h1 , old1 , [], [1 0 0]);
xlabel('Time (min)');
ylabel('Area under the curve of each cell (au)');
title('Signal activation for all cells');
axis([0 maximumx minmi*1.2 mamxi*1.2]);
hold on
scatter(h2 , old2 , [], [1 0 0]);
hold on
scatter(h3 , yang1 , [], [0 0 1]);
hold on
scatter(h4 , yang2 , [], [0 0 1]);

mqx=max(area1);
mqn=min(area1);
figure;
clars=colormap(jet(length(area1)));
aaa=clars( round(((area1-mqn)/(mqx-mqn))*(length(area1)-1) +  1)  , :);


scatter(h11 , area1 , [], aaa);
xlabel('Time (min)');
ylabel('Area under the curve of each cell (au)');
title('Signal activation for cells present on both intervales');
axis([0 maximumx minmi*1.2 mamxi*1.2]);
hold on
scatter(h21 , area2 , [], aaa);

figure;
scatter(area1 , area2);
lsline;
xlabel(['Cell fluorescence in ' num2str(border1)]);
ylabel(['Cell fluorescence in ' num2str(border2)]);
[rrr , ppp]=corrcoef([area1' , area2']);
title(['Correlation between activation at ' num2str(border1) ' min and '  num2str(border2) ' min']);
vv1=axis;
axis([vv1(1) vv1(2) vv1(3) max(area2)*1.3]);
text(vv1(2)/2 , max(area2)*1.2 , ['correl=' num2str(rrr(2)) '  p=' num2str(ppp(2))],...
     'HorizontalAlignment','center');

figure;
mm1=mean(old1);
mm2=mean(old2);
mm3=mean(yang2);
sd1=std(old1);
sd2=std(old2);
sd3=std(yang2);
ee1=sd1/length(old1);
ee2=sd2/length(old2);
ee3=sd3/length(yang2);

errorbar([1 , 2 , 3] , [mm1 mm2 mm3], [ee1 , ee2 , ee3]  , 'rs' , 'MarkerFaceColor','r', 'MarkerSize', 3);
set(gca,'XTick',[1 , 2 , 3])
set(gca,'XTickLabel',{['Intervale 1 - old cells'],['Intervale 2 - old cells'],['Intervale 2 - yang cells']});
ylabel('Mean area under the curve of the cells (au)');
title('Mean activation for old and yang cells');
vv1=axis;
maxxxi=max([mm1 mm2 mm3]);
axis([vv1(1) vv1(2) vv1(3) maxxxi*1.5]);
text(1,mm1,['    \leftarrow ' num2str(round(mm1))]  ,...
     'HorizontalAlignment','left');
text(2,mm2,['    \leftarrow ' num2str(round(mm2))]  ,...
     'HorizontalAlignment','left');
text(3,mm3,['    \leftarrow ' num2str(round(mm3))]  ,...
     'HorizontalAlignment','left');

[hhh , pval1]=ttest2(old1 , old2);
[hhh , pval2]=ttest2(old2 , yang2);
[hhh , pval3]=ttest2(old1 , yang2);

line([1.1 1.9] , [maxxxi*1.2  maxxxi*1.2] , 'color' , 'k');
line([2.1 2.9] , [maxxxi*1.2  maxxxi*1.2] , 'color' , 'k');
line([1.1 2.9] , [maxxxi*1.35  maxxxi*1.35] , 'color' , 'k');

text(1.5 , maxxxi*1.25 , ['p=' num2str(pval1)],...
     'HorizontalAlignment','center');
text( 2.5 , maxxxi*1.25  , ['p=' num2str(pval2)],...
     'HorizontalAlignment','center');
text( 2 , maxxxi*1.4 , ['p=' num2str(pval3) ],...
     'HorizontalAlignment','center');

end


