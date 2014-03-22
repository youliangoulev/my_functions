function [ divt , burstj ,  areaf , areai , lastd , birth , ismeref] = segmcorr2( segmentation , temps , bursj)
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
   if segmentation.tcells1(i).lastFrame>temps+bursj && segmentation.tcells1(i).detectionFrame<=temps-4 && segmentation.tcells1(i).detectionFrame>0
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
  
       
       dim=[];
       for j=1:temps-segmentation.tcells1(i).detectionFrame
             
              dim=[dim , (segmentation.tcells1(i).Obj(j).fluoNuclMean(2)-segmentation.tcells1(i).Obj(j).fluoCytoMean(2))/segmentation.tcells1(i).Obj(j).fluoCytoMean(2)];


       end
       wax=mean(dim)
       
       
       l=0;
       for j=temps-segmentation.tcells1(i).detectionFrame+2:temps-segmentation.tcells1(i).detectionFrame+1+bursj
              l=l+(segmentation.tcells1(i).Obj(j).fluoNuclMean(2)-segmentation.tcells1(i).Obj(j).fluoCytoMean(2))/segmentation.tcells1(i).Obj(j).fluoCytoMean(2)-wax;
       end
       

       
       
%        l=0;
%        for j=temps-segmentation.tcells1(i).detectionFrame+2:temps-segmentation.tcells1(i).detectionFrame+1+bursj
%            
%            if   l<(segmentation.tcells1(i).Obj(j).fluoNuclMean(2)-segmentation.tcells1(i).Obj(j).fluoCytoMean(2))/segmentation.tcells1(i).Obj(j).fluoCytoMean(2)
%               l=(segmentation.tcells1(i).Obj(j).fluoNuclMean(2)-segmentation.tcells1(i).Obj(j).fluoCytoMean(2))/segmentation.tcells1(i).Obj(j).fluoCytoMean(2);
%            end
%        end
       
       
       
       
       k.max=l;
  
       x=[x,k.divt];
       y=[y,k.max];

       z=[z,segmentation.tcells1(i).Obj(end).area];
       f=[f,segmentation.tcells1(i).Obj(temps-segmentation.tcells1(i).detectionFrame+2).area];
       d=[d,segmentation.tcells1(i).detectionFrame];
       
   end
end
divt=x;
birth=d;
burstj=y;
areaf=z;
areai=f;
ismeref=wad;
lastd=b;

end

