function [a ,b]=taillenucleus
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
framet=3;
limite=900;
limit=round((limite/3)+1);
global segmentation;

w=[];
qq=[];

nucleus=[];
cellz=[];

for i=1:length(segmentation.tcells1)
    if segmentation.tcells1(i).N>0
        for j=1:length(segmentation.tcells1(i).Obj)
            if (segmentation.tcells1(i).Obj(j).image<=limit)
                cellz=[cellz , segmentation.tcells1(i).Obj(j).area];
                
            end;
        end;
    end;
end;

x=median(cellz);
cellz=[];

for i=1:length(segmentation.tcells1)
    cem=[];
    nam=[];
    if segmentation.tcells1(i).N>0
        for j=1:length(segmentation.tcells1(i).Obj)
            if (segmentation.tcells1(i).Obj(j).image<=limit) &&(segmentation.tcells1(i).Obj(j).Mean.n>0) && (segmentation.tcells1(i).Obj(j).area>x/2)
                xe=segmentation.tcells1(i).Obj(j).image;
                num=segmentation.tcells1(i).Obj(j).Mean.n;
                diff=xe-segmentation.tnucleus(num).detectionFrame+1;
                cem=[cem , segmentation.tcells1(i).Obj(j).area];
                nam=[nam , segmentation.tnucleus(num).Obj(diff).area];
                w=[w , cem];
                qq=[qq , nam];
                
            end;
        end;
        if (~isempty(cem))&&(~isempty(nam))
           cellz=[cellz , mean(cem)];
         nucleus=[nucleus , mean(nam)];
        end;
    end;
  
end;

[r ,p ]=corrcoef(cellz' , nucleus');
p
r

figure;
hist(cellz);
figure;
hist(nucleus);
figure;
scatter(nucleus , cellz);

a=w;
b=qq;



end

