function [ output_args ] = nuc_dist(a)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global segmentation;
y=[];
d=[];

for i=a %:length(segmentation.tcells1)
for j=1:length(segmentation.tcells1(i).Obj)
if (~isempty(segmentation.tcells1(i).Obj(j).Mean))&&(segmentation.tcells1(i).Obj(j).Mean.n>0)&&(segmentation.tcells1(i).Obj(j).image>100) &&(segmentation.tcells1(i).Obj(j).image<300)
x1=segmentation.tcells1(i).Obj(j).ox;
y1=segmentation.tcells1(i).Obj(j).oy;
frm=segmentation.tcells1(i).Obj(j).image-segmentation.tnucleus(segmentation.tcells1(i).Obj(j).Mean.n).detectionFrame+1;
n=segmentation.tcells1(i).Obj(j).Mean.n;
x2=segmentation.tnucleus(n).Obj(frm).ox;
y2=segmentation.tnucleus(n).Obj(frm).oy;
y=[y , segmentation.tnucleus(n).Obj(frm).fluoMean(2)/segmentation.tcells1(i).Obj(j).fluoMean(2)];
d=[d , sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1))/sqrt(segmentation.tcells1(i).Obj(j).area/pi)];
end
end
end

figure;
scatter(d , y);
[r , p]=corrcoef(d , y);
r
p

end

