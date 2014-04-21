function [ t , v] = firstgr
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
global segmentation;


vol={};
time={};
ii=0;
for i=1:length(segmentation.tcells1)
    obj=0;
    if segmentation.tcells1(i).birthFrame>0
        str=segmentation.tcells1(i).birthFrame-segmentation.tcells1(i).detectionFrame+1; 
    else    
        str=1;
    end;  
    if isempty(segmentation.tcells1(i).budTimes)
        obj=length(segmentation.tcells1(i).Obj); 
    else  
        obj=segmentation.tcells1(i).budTimes(1)-segmentation.tcells1(i).detectionFrame;
    end;
    if obj-str+1>1
        ii=ii+1;
        vol{ii}=[];
        time{ii}=[];
        
        for j=str:obj
           s=segmentation.tcells1(i).Obj(j).area;
           vol{ii}=[vol{ii} , 4*sqrt(s*s*s/pi)/3];
           time{ii}=[time{ii} , (segmentation.tcells1(i).Obj(j).image-1)*3];
        end
        
    end;    
    end;

t=time;
v=vol;







end

