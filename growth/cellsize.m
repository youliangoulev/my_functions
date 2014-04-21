function [ t , v] = cellsize(bornes_before)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
global segmentation;


vol={};
time={};
ii=0;
for i=1:length(segmentation.tcells1)
       if (length(segmentation.tcells1(i).Obj)>10)&&((segmentation.tcells1(i).birthFrame-1)*3<bornes_before)&&((segmentation.tcells1(i).detectionFrame-1)*3<bornes_before)
        ii=ii+1;
        vol{ii}=[];
        time{ii}=[];
        
        for j=1:length(segmentation.tcells1(i).Obj)
           s=segmentation.tcells1(i).Obj(j).area;
           vol{ii}=[vol{ii} , 4*sqrt(s*s*s/pi)/3];
           time{ii}=[time{ii} , (segmentation.tcells1(i).Obj(j).image-1)*3];
        end;
       end; 
    
end;

t=time;
v=vol;

zi=[];
zt=[];

for i=1:length(v)
    zi=[zi , v{i}];
    zt=[zt , t{i}];
end;

scatter(zt , zi);

end

