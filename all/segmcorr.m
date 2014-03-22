function [ divt , max , time , areaf , areai , lvli , lastd , birth , ismeref] = segmcorr( segmentation , temps)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

x=[];
y=[];
w=[];
z=[];
f=[];
v=[];
b=[];
d=[];
wad=[];
for i=1:length(segmentation.tcells1)
   if segmentation.tcells1(i).lastFrame>temps && segmentation.tcells1(i).detectionFrame<=temps && segmentation.tcells1(i).detectionFrame>0
       l=0;
       lmp=segmentation.tcells1(i).detectionFrame;
       if ~isempty(segmentation.tcells1(i).budTimes)
           k1y=10;
           for j=1:length(segmentation.tcells1(i).budTimes)
               if segmentation.tcells1(i).budTimes(j)>temps
                   l=l+1;
               else
                   if segmentation.tcells1(i).budTimes(j)<(temps-10)
                       k1y=100;
                   end
                   if segmentation.tcells1(i).budTimes(j)>lmp
                       lmp=segmentation.tcells1(i).budTimes(j);
                   end
               end
           end
            wad=[wad,k1y];
           b=[b,lmp];   
       else
           b=[b,segmentation.tcells1(i).detectionFrame];
           wad=[wad,10];
       end
       k.divt=l/(segmentation.tcells1(i).lastFrame-temps);
       l=segmentation.tcells1(i).Obj(temps-segmentation.tcells1(i).detectionFrame+2).fluoMean(2);
       p=temps-segmentation.tcells1(i).detectionFrame+2;
       for j=temps-segmentation.tcells1(i).detectionFrame+2:length(segmentation.tcells1(i).Obj)
          if segmentation.tcells1(i).Obj(j).fluoMean(2)>l              
              l=segmentation.tcells1(i).Obj(j).fluoMean(2);
              p=j;
          end
       end
       k.max=l;
       k.time=p-(temps-segmentation.tcells1(i).detectionFrame+2); 
       x=[x,k.divt];
       y=[y,k.max];
       w=[w,k.time];
       z=[z,segmentation.tcells1(i).Obj(end).area];
       f=[f,segmentation.tcells1(i).Obj(temps-segmentation.tcells1(i).detectionFrame+2).area];
       v=[v,segmentation.tcells1(i).Obj(temps-segmentation.tcells1(i).detectionFrame+2).fluoMean(2)];
       d=[d,segmentation.tcells1(i).detectionFrame];
       
   end
end
divt=x;
birth=d;
max=y;
time=w;
areaf=z;
areai=f;
lvli=v;
ismeref=wad;
lastd=b;

end

