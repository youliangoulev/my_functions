function [ out1 ] = doublestress( a, b , c , d )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global segmentation

y={};
x={};
z={};
l1w=[];
l3w=[];
fmes=[];
fmes1=[];
m=0;
siz=[];
sizee=[];






for i=1:length(segmentation.tcells1)
    
   if segmentation.tcells1(i).N~=0 && length(segmentation.tcells1(i).Obj)>1 && segmentation.tcells1(i).detectionFrame*3-3<a-20 && segmentation.tcells1(i).lastFrame*3-3>c 
       m=m+1;
       alpha=0;
       alphaA=0;
       betaB=0;
       beta=0;
       x{m}=[];
       y{m}=[];
       z{m}=[];
       for j=1:length(segmentation.tcells1(i).Obj)
          x{m}=[x{m} , segmentation.tcells1(i).Obj(j).image*3-3];
          y{m}=[y{m} , segmentation.tcells1(i).Obj(j).fluoMean(2)];
          z{m}=[z{m} , segmentation.tcells1(i).Obj(j).area];   
          
          
          if segmentation.tcells1(i).Obj(j).image*3-3>=b && alpha==0
              alpha=1;
              fmes=[fmes segmentation.tcells1(i).Obj(j).fluoMean(2) ];
          end
          
          if segmentation.tcells1(i).Obj(j).image*3-3>=c && beta==0
              beta=1;
              fmes1=[fmes1 segmentation.tcells1(i).Obj(j).fluoMean(2) ];
          end
          
          if segmentation.tcells1(i).Obj(j).image*3-3>=a && alphaA==0
              alphaA=1;
              siz=[siz segmentation.tcells1(i).Obj(j).area ];
          end
          
          if segmentation.tcells1(i).Obj(j).image*3-3>=d && betaB==0
              betaB=1;
              sizee=[sizee segmentation.tcells1(i).Obj(j).area ];
          end
          
          
       end
       l1w=[l1w max(y{m})];
       l3w=[l3w min(y{m})];
   end

end


figure
col=colormap(jet(256));

for i=1:length(x)
   
ttt=(fmes(i)-min(fmes))/(max(fmes)-min(fmes))    
    ttt=255*ttt+1
    ttt=round(ttt);
    plot(x{i},y{i} , 'color' , col(ttt,:));
    hold on  
    
end

figure;
scatter(fmes ,fmes1);
hold on
lsline; %fluo lvl before stress stress vs. cell area before stress

l(:,1)=fmes;
l(:,2)=fmes1;
[a p]=corrcoef(l)

std(fmes)/mean(fmes)
std(fmes1)/mean(fmes1)


figure;
scatter(siz ,sizee);
hold on
lsline; %fluo lvl before stress stress vs. cell area before stress
l=[];
l(:,1)=siz;
l(:,2)=sizee;
[a p]=corrcoef(l)

std(siz)/mean(siz)
std(sizee)/mean(sizee)

figure;
scatter(siz ,fmes);
hold on
lsline; %fluo lvl before stress stress vs. cell area before stress
l=[];
l(:,1)=siz;
l(:,2)=fmes;
[a p]=corrcoef(l)


figure;
scatter(siz ,fmes1);
hold on
lsline; %fluo lvl before stress stress vs. cell area before stress
l=[];
l(:,1)=siz;
l(:,2)=fmes1;
[a p]=corrcoef(l)

figure;
scatter(sizee ,fmes1);
hold on
lsline; %fluo lvl before stress stress vs. cell area before stress
l=[];
l(:,1)=sizee;
l(:,2)=fmes1;
[a p]=corrcoef(l)
end

