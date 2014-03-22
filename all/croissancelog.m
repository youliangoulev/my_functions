function [h1 , a]=croissancelog
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

time=3;
global segmentation
long=length(segmentation.cells1);
area=zeros(1, length(segmentation.cells1));
h=[0:time:(long-1)*time];

for i=1:length(segmentation.tcells1)
 if segmentation.tcells1(i).N>0
       
  for j=1:length(segmentation.tcells1(i).Obj)
  area(segmentation.tcells1(i).Obj(j).image)=area(segmentation.tcells1(i).Obj(j).image)+segmentation.tcells1(i).Obj(j).area;      
       
  end    
 end
    
    

    
end


h1=h;
a=area;


end

